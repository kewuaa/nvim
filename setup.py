from pathlib import Path
import os

cwd = Path(__file__).parent
alacritty = f"""
import:
 - {cwd / "alacritty.yml"}
"""
clink = f"""
$include {cwd / "clink_inputrc"}
"""


def setup() -> None:
    # setup alacritty
    alacritty_path = Path(os.environ["appdata"]) / "alacritty"
    if not alacritty_path.exists():
        alacritty_path.mkdir()
    with open(alacritty_path / "alacritty.yml", "w") as f:
        f.write(alacritty)

    # setup clink
    clink_path = Path(os.environ["home"]) / ".inputrc"
    with open(clink_path, "w") as f:
        f.write(clink)


if __name__ == "__main__":
    setup()
