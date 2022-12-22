from time import time
from io import BytesIO
from ctypes import c_uint32
from base64 import b64decode
from secrets import randbelow
import asyncio
import json

from PIL import Image

from ..model import SongInfo
from ..model import SourceModel
from ..model import LoginConfig


MAX_INT = 2 ** 31


def int_overflow(val: int) -> int:
    if not -MAX_INT <= val <= MAX_INT - 1:
        val = (val + MAX_INT) % (2 * MAX_INT) - MAX_INT
    return val


def unsigned_right_shitf(n, i):
    # 数字小于0，则转为32位无符号uint
    if n < 0:
        n = c_uint32(n).value
    # 正常位移位数是为正数，但是为了兼容js之类的，负数就右移变成左移好了
    if i < 0:
        return -int_overflow(n << abs(i))
    # print(n)
    return int_overflow(n >> i)


def reqid():
    r = None
    o = None
    d = 0

    def get_reqid():
        nonlocal r, o, d
        b = []
        f = r
        v = o
        if f is None or v is None:
            m = [randbelow(256) for _ in range(16)]
            r = f = f or [1 | m[0], m[1], m[2], m[3], m[4], m[5]]
            o = v = v or 16383 & (int_overflow(m[6] << 8) | 7)
        y = int(time() * 1000)
        w = d + 1
        d = w
        x = (10000 * (268435455 & (y := y + 12219292800000)) + w) % 4294967296
        b.append(unsigned_right_shitf(x, 24) & 255)
        b.append(unsigned_right_shitf(x, 16) & 255)
        b.append(unsigned_right_shitf(x, 8) & 255)
        b.append(255 & x)
        _x = int(y / 4294967296 * 10000) & 268435455
        b.append(unsigned_right_shitf(_x, 8) & 255)
        b.append(255 & _x)
        b.append(unsigned_right_shitf(_x, 24) & 15 | 16)
        b.append(unsigned_right_shitf(_x, 16) & 255)
        b.append(unsigned_right_shitf(v, 8) | 128)
        b.append(255 & v)
        b.extend(f)
        result = [f'{hex(i)[2:]:0>2}' for i in b]
        result.insert(10, '-')
        result.insert(8, '-')
        result.insert(6, '-')
        result.insert(4, '-')
        return ''.join(result)
    return get_reqid


class Source(SourceModel):
    """酷我."""

    SEARCH_URL = 'https://www.kuwo.cn/api/www/search/searchMusicBykeyWord'
    SOURCE_URL = 'https://www.kuwo.cn/api/v1/www/music/playUrl'

    def __init__(
        self,
        loop: asyncio.base_events.BaseEventLoop,
        browser: str = None,
    ) -> None:
        super().__init__(loop, path=__file__, browser=browser)
        self.__domain = 'https://www.kuwo.cn/'
        self._headers['Referer'] = self.__domain
        self._headers['Content-Type'] = 'application/json;charset=UTF-8'
        self.__get_reqid = reqid()

    def __parse_data(self, data: list) -> list:
        def parse(item: dict) -> SongInfo:
            name = item['name']
            author = item['artist']
            album = item['album']
            summary = [name, author, album]
            source_id = item['rid']
            return SongInfo(
                summary=summary,
                _id=source_id,
                _from=self,
            )

        return [parse(item) for item in data]

    async def _init_cookies(self) -> None:
        self._cookies['kw_token'] = 'LPZZ7D4HRJO'

    async def _session(self):
        sess = await super()._session()
        cookies = sess.cookie_jar.filter_cookies(self.__domain)
        csrf = cookies.get('kw_token').value
        sess.headers['csrf'] = csrf
        return sess

    async def _get_info(self, name: str) -> list:
        sess = await self._session()
        params = {
            'key': name,
            'rn': 30,
            'httpsStatus': 1,
            'req-id': self.__get_reqid(),
        }
        resp = await sess.get(self.SEARCH_URL, params=params)
        res_dict = await resp.json(content_type=None)
        data = res_dict['data']['list']
        return self.__parse_data(data)

    async def _get_source(self, source_id) -> str:
        sess = await self._session()
        params = {
            'mid': source_id,
            'httpsStatus': 1,
            'type': 'music',
            'req-id': self.__get_reqid(),
        }
        resp = await sess.get(self.SOURCE_URL, params=params)
        res_dict = await resp.json(content_type=None)
        data = res_dict['data']
        return data['url']

    async def __fetch_verify_code(self) -> tuple:
        sess = await self._session()
        verify_url = 'https://www.kuwo.cn/api/common/captcha/getcode'
        params = {
            'reqId': self.__get_reqid(),
            'httpsStatus': 1,
        }
        resp = await sess.get(verify_url, params=params)
        resp_dict = await resp.json(content_type=None)
        if resp_dict['code'] != 200:
            raise RuntimeError(resp_dict['msg'])
        verify_img_str = b64_str = resp_dict['data']['img']
        verify_token = resp_dict['data']['token']
        prefix = 'data:image/jpeg;base64,'
        if b64_str.startswith(prefix):
            b64_str = b64_str[len(prefix):]
        verify_img_data = b64decode(b64_str)
        verify_img = BytesIO(verify_img_data)
        verify_img = Image.open(verify_img)
        return verify_img, verify_img_str, verify_token

    def __login_by_PWD(self) -> None:
        async def fetch_verify_code() -> Image:
            nonlocal verify_img_str, verify_token
            verify_img, verify_img_str, verify_token = \
                await self.__fetch_verify_code()
            return verify_img

        async def login(login_id: str, password: str, verify_code: str):
            assert verify_img_str and verify_token
            await self.save_config(login_id=login_id)
            sess = await self._session()
            login_url = 'https://www.kuwo.cn/api/www/login/loginByKw'
            params = {
                'reqId': self.__get_reqid(),
                'httpsStatus': 1,
            }
            data = {
                'userIp': 'www.kuwo.cn',
                'uname': login_id,
                'password': password,
                'verifyCode': verify_code,
                'img': verify_img_str,
                'verifyCodeToken': verify_token,
            }
            resp = await sess.post(
                login_url,
                params=params,
                data=json.dumps(data),
            )
            resp_dict = await resp.json(content_type=None)
            code = resp_dict.get('code') or resp_dict['status']
            if code != 200:
                raise RuntimeError(
                    resp_dict.get('msg') or resp_dict['message'])
            cookies = resp_dict['data']['cookies']
            sess.cookie_jar.update_cookies(cookies)
            await self.save_config(login_id=login_id, password=password)

        verify_img_str = ''
        verify_token = ''
        return login, fetch_verify_code

    def __login_by_SMS(self) -> tuple:
        async def send_sms(
            cellphone: str,
            verify_code: str,
        ):
            sess = await self._session()
            sms_url = 'https://kuwo.cn/api/sms/mobileLoginCode'
            params = {
                'reqId': self.__get_reqid(),
                'httpsStatus': 1,
            }
            data = {
                'mobile': cellphone,
                'userIp': 'kuwo.cn',
                'verifyCode': verify_code,
                'verifyCodeToken': verify_token,
            }
            resp = await sess.post(
                sms_url,
                params=params,
                data=json.dumps(data),
            )
            resp_dict = await resp.json(content_type=None)
            __import__('pprint').pprint(resp_dict)
            if resp_dict['code'] != 200:
                raise RuntimeError('send sms error')
            nonlocal last_cellphone
            last_cellphone = cellphone
            await self.save_config(cellphone=cellphone)

        async def login(cellphone: str, sms_code: str, verify_code: str):
            if not last_cellphone:
                raise RuntimeError('it seems that you have not sended sms yet')
            elif cellphone != last_cellphone:
                raise RuntimeError('the cellphone is not the same as the last')
            sess = await self._session()
            login_url = 'https://kuwo.cn/api/www/login/loginByMobile'
            params = {
                'reqId': self.__get_reqid(),
                'httpsStatus': 1,
            }
            data = {
                'mobile': cellphone,
                'smsCode': sms_code,
                'tm': str(self._get_time_stamp()),
                'verifyCode': verify_code,
            }
            resp = await sess.post(
                login_url,
                params=params,
                data=json.dumps(data),
            )
            resp_dict = await resp.json(content_type=None)
            __import__('pprint').pprint(resp_dict)
            if resp_dict['code'] != 200:
                raise RuntimeError(resp_dict['msg'])
            cookies = resp_dict['data']['cookies']
            sess.cookie_jar.update_cookies(cookies)

        async def fetch_verify_code():
            nonlocal verify_token
            verify_img, verify_img_str, verify_token = \
                await self.__fetch_verify_code()
            return verify_img

        last_cellphone = ''
        verify_token = ''
        return send_sms, login, fetch_verify_code

    def check_login(self) -> LoginConfig:
        return LoginConfig(
            PWD_callback=self.__login_by_PWD(),
            SMS_callback=self.__login_by_SMS(),
        )
