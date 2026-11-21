export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export HYTALE_LAUNCHER_NO_SELF_UPDATE=1

# The updater renames staged files into the install tree, so its
# temporary directory must be on the same filesystem as the game.
export TMPDIR="$XDG_DATA_HOME/Hytale/.tmp"
install -d -m700 "$TMPDIR"

# Upstream checks this distribution marker even for native installs;
# without it, it incorrectly reports an outdated Flatpak package.
install -Dm644 @launcher@/share/hytale-launcher/bundled-hash \
  "$XDG_DATA_HOME/Hytale/.bundled_hash"
