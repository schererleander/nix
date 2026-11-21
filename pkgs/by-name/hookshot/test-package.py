"""Exercise installed launchers, native helpers, and per-game root lifetimes."""

import importlib.util
from pathlib import Path
import subprocess
import sys
import tempfile
from unittest.mock import patch

package = Path(sys.argv[1])
shell = sys.argv[2]
tools = package / "share/hookshot"


def check_launchers(directory):
    config = directory / "builder.ini"
    for nested in (True, False):
        game = directory / ("nested game" if nested else "legacy game")
        executable = game / "bin/hookshot" if nested else game / "hookshot"
        executable.parent.mkdir(parents=True)
        (game / "image.bin").touch()
        executable.write_text(
            f"#!{shell}\n"
            'test "$HOOKSHOT_NO_UPDATE_CHECK" = 1 || exit 2\n'
            'test "${HOOKSHOT_TEST-unset}" = unset || exit 3\n'
            'test "${PYTHONPATH-unset}" = unset || exit 4\n'
            'test "$RX_VK_FSR_DIR" = /custom/fsr || exit 5\n'
            'printf "game started\\n"\n'
        )
        executable.chmod(0o755)
        env = {
            "PATH": "",
            "HOOKSHOT_LAUNCH_CONFIG": str(config),
            "HOOKSHOT_TEST": "must be removed",
            "PYTHONPATH": "/must/be/removed",
            "RX_VK_FSR_DIR": "/custom/fsr",
        }
        config.write_text(f"out={game}\n")
        for arguments in ([], [str(game)]):
            result = subprocess.run(
                [str(package / "bin/hookshot-play"), *arguments],
                env=env,
                check=True,
                text=True,
                capture_output=True,
            )
            assert result.stdout == "game started\n", result
        (game / "image.bin").unlink()
        result = subprocess.run(
            [str(package / "bin/hookshot-play"), str(game)],
            env=env,
            text=True,
            capture_output=True,
        )
        assert result.returncode == 1 and "no built game" in result.stderr, result


def check_roots(directory):
    spec = importlib.util.spec_from_file_location(
        "nix_runtime", tools / "nx2/nix_runtime.py"
    )
    runtime = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runtime)
    game = directory / "retained game"
    game.mkdir()
    roots = game / ".hookshot-nix"
    roots.mkdir()
    old_runtime = runtime.RUNTIME.with_name("0" * 32 + "-hookshot-old")
    old_root = roots / ("runtime-" + old_runtime.name)
    old_root.symlink_to(old_runtime)
    unrelated = roots / "runtime-unrelated-hookshot-link"
    unrelated.symlink_to("/unrelated")
    note = roots / "runtime-user-hookshot-note"
    note.write_text("leave this file alone")

    with patch.object(
        runtime.subprocess,
        "run",
        side_effect=subprocess.CalledProcessError(1, "nix-store"),
    ):
        try:
            runtime.retain_runtime(game)
        except subprocess.CalledProcessError:
            pass
        else:
            raise AssertionError("a failed registration must stop the build")
    assert old_root.is_symlink(), "a failed update released the previous runtime"

    def register(command, **kwargs):
        assert command[0] == runtime.NIX_STORE
        assert command[1:3] == ["--realise", str(runtime.RUNTIME)]
        assert command[-1] == "--indirect" and kwargs["check"]
        root = Path(command[command.index("--add-root") + 1])
        assert root.parent == roots
        root.symlink_to(runtime.RUNTIME)

    with patch.object(runtime.subprocess, "run", side_effect=register):
        runtime.retain_runtime(game)
    assert old_root.is_symlink(), "retain the old runtime until the swap succeeds"
    runtime.prune_runtimes(game)
    assert not old_root.is_symlink()
    assert (roots / ("runtime-" + runtime.RUNTIME.name)).is_symlink()
    assert unrelated.is_symlink() and note.read_text() == "leave this file alone"

    linked_game = directory / "linked game"
    linked_game.mkdir()
    (linked_game / ".hookshot-nix").symlink_to(roots, target_is_directory=True)
    try:
        runtime.retain_runtime(linked_game)
    except ValueError:
        pass
    else:
        raise AssertionError("do not manage roots through an unexpected directory symlink")


with tempfile.TemporaryDirectory(prefix="hookshot-package-") as temporary:
    directory = Path(temporary)
    check_launchers(directory)
    check_roots(directory)

subprocess.run(
    [str(package / "bin/hookshot-cli"), "--help"],
    env={"PATH": ""},
    check=True,
    stdout=subprocess.DEVNULL,
)
# Load the installed ELF helpers after normal fixup, without the build environment.
sys.path.insert(0, str(tools / "nx2"))
import zbic

zbic.lib()
sys.path.insert(0, str(tools / "third_party/a64-kit/lift"))
import a64emit

a64emit.lib()
print("PASS: launchers, legacy layout, clean environment, roots and native helpers")
