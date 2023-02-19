from pathlib import Path

try:
    import rtoml as toml
except ImportError:
    import tomli as toml


def pyread_toml(file: str) -> dict:
    file = Path(file)
    if not file.exists():
        raise RuntimeError(f'{file} not exists')
    with open(file) as f:
        content = toml.load(f)
    return content
