{ inputs, ... }:
{
  flake.overlays.unstable =
    _final: prev:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        overlays = prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [
          (_uFinal: uPrev: {
            python3 = uPrev.python3.override {
              packageOverrides = pyFinal: pyPrev: {
                # The bundled version already matches; the hook rejects a no-op.
                anki-mac-helper = pyPrev.anki-mac-helper.overrideAttrs (old: {
                  nativeBuildInputs = builtins.filter (
                    p: p != pyFinal.pyprojectVersionPatchHook
                  ) old.nativeBuildInputs;
                });
              };
            };
          })
        ];
      };
    in
    {
      inherit (unstable) chatgpt claude-code codex;
    }
    // prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      inherit (unstable) wootility;
    }
    // prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      # Use one package set for Anki, PyQt6 and QtWebEngine's qtbase.
      inherit (unstable) anki;
    };
}
