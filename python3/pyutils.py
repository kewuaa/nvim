from pathlib import Path

try:
    import tomllib
    def read_toml(file: str) -> dict:
        with open(file, 'rb') as f:
            conten = tomllib.load(f)
        return conten
except ImportError:
    import rtoml
    def read_toml(file: str) -> dict:
        with open(file) as f:
            content = rtoml.load(f)
        return content


def pyread_toml(file: str) -> dict:
    file = Path(file)
    if not file.exists():
        raise RuntimeError(f'{file} not exists')
    return read_toml(file)
