from pathlib import Path

try:
    import tomllib as toml
except ImportError:
    import rtoml as toml


def pyread_toml(file: str) -> dict:
    file = Path(file)
    if not file.exists():
        raise RuntimeError(f'{file} not exists')
    with open(file, 'rb') as f:
        content = toml.load(f)
    return content
