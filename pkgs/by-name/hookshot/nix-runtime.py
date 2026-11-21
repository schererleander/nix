"""Retain the package closure for a game built outside the Nix store."""

from pathlib import Path
import subprocess
import sys

RUNTIME = Path("@hookshotOut@")
NIX_STORE = "@nixStore@"


def runtime_directory(folder):
    directory = Path(folder).resolve() / ".hookshot-nix"
    if directory.is_symlink():
        raise ValueError(f"Runtime root directory must not be a symlink: {directory}")
    directory.mkdir(exist_ok=True)
    return directory


def retain_runtime(folder):
    directory = runtime_directory(folder)
    root = directory / ("runtime-" + RUNTIME.name)
    # Nix registers an indirect root pointing at this symlink. Deleting the game
    # removes the symlink, so a subsequent GC can collect its package closure.
    subprocess.run(
        [NIX_STORE, "--realise", str(RUNTIME), "--add-root", str(root), "--indirect"],
        check=True,
        stdout=subprocess.DEVNULL,
    )


def prune_runtimes(folder):
    directory = runtime_directory(folder)
    current = directory / ("runtime-" + RUNTIME.name)
    # Called only after the new executables and runtimes have been installed.
    # Leave ordinary files and unrelated links alone.
    for root in directory.glob("runtime-*-hookshot-*"):
        if root != current and root.is_symlink():
            target = Path(root.readlink())
            if (
                target.parent == RUNTIME.parent
                and target.name == root.name.removeprefix("runtime-")
            ):
                root.unlink()


if __name__ == "__main__":
    retain_runtime(sys.argv[1])
