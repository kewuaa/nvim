from pathlib import Path
import re
import os
import asyncio

import pynvim
# from aiohttp import ClientSession
from requests import Session


@pynvim.plugin
class Translator:

    PATH = Path(__file__).parent

    def __init__(self, nvim: pynvim.api.nvim.Nvim) -> None:
        self.__nvim = nvim
        loop: asyncio.windows_events.ProactorEventLoop = nvim.loop
        self.__loop = loop
        # self.__sess = loop.create_task(self.__init_sess())
        self.__init_sess()
        self.__init_api()
        self._js_path = self.PATH / 'sign.js'

    # async def _session(self) -> ClientSession:
    #     return await self.__sess

    # async def __init_sess(self) -> ClientSession:
    #     session = ClientSession(base_url=self.BASE_URL)
    #     self.__loop.create_task(self.__init_api())
    #     return session

    # async def __init_api(self) -> None:
    #     sess = await self._session()
    #     await sess.get(self.BASE_URL)
    #     resp = await sess.get(self.BASE_URL)
    #     page = await resp.text()
    #     info = re.search(r"window\['common'\].*(\{[\s\S]+\});", page)
    #     self.__info = info.group(1)

    def __init_sess(self) -> None:
        sess = Session()
        header = {
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebK'
            'it/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36 Edg/'
            '108.0.1462.54',
            'Host': 'fanyi.baidu.com',
            'Origin': 'https://fanyi.baidu.com',
            'Referer': 'https://fanyi.baidu.com/',
        }
        sess.headers.update(header)
        self.__sess = sess

    def __log(self, msg: str) -> None:
        msg = str(msg) + '\n'
        self.__nvim.out_write(msg)

    def __init_api(self) -> None:
        sess = self.__sess
        url = 'https://fanyi.baidu.com/'
        sess.get(url)
        resp = sess.get(url)
        page = resp.text
        info = re.search(r"window\['common'\].*(\{[\s\S]+\});", page)
        if info is None:
            raise RuntimeError()
        info = self.__info = info.group(1)
        self.__token = re.search(r"token:[\s\S]'([\d\w]+)'", info)
        if self.__token is not None:
            self.__token = self.__token.group(1)

    def lang_detece(self, query: str) -> str:
        sess = self.__sess
        url = 'https://fanyi.baidu.com/langdetect'
        parameters = {
            'query': query,
        }
        resp = sess.get(url, params=parameters)
        result = resp.json()
        if result['error'] != 0:
            raise RuntimeError(result['msg'])
        language = result['lan']
        return language

    def _translate(self, query: str, _from: str, dest: str) -> None:
        sess = self.__sess
        url = 'https://fanyi.baidu.com/v2transapi'
        parameters = {
            'from': _from,
            'to': dest,
        }
        sign = os.popen(f'node {str(self._js_path)} "{query}"').read()
        data = {
            'from': _from,
            'to': dest,
            'query': query,
            'transtype': 'realtime',
            'simple_means_flag': '3',
            'sign': sign.strip(),
            'token': self.__token,
            'domain': 'common',
        }
        resp = sess.post(url, params=parameters, data=data)
        result = resp.json()
        if result.get('error') is not None:
            raise RuntimeError(result['errmsg'])
        if 'dict_result' in result:
            result = result['dict_result']['simple_means']['word_means']
            result = '\n'.join(result)
        else:
            result = result['trans_result']['data'][0]['dst']
        self.__log(result)

    @pynvim.command('PyTrans', nargs='*', range='')
    def translate(self, args, range) -> None:
        if args:
            query = ' '.join(args)
        else:
            return
        _from = self.lang_detece(query)
        dest = 'zh'
        self.__nvim.async_call(
            self._translate,
            query=query,
            _from=_from,
            dest=dest,
        )
