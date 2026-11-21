{ inputs, ... }:
{
  flake.overlays.unstable =
    final: prev:
    let
      inherit (prev) lib;

      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        inherit (prev) config;
        overlays = lib.optionals prev.stdenv.hostPlatform.isDarwin [
          (_: uPrev: {
            pythonPackagesExtensions = uPrev.pythonPackagesExtensions ++ [
              (pyFinal: pyPrev: {
                anki-mac-helper = pyPrev.anki-mac-helper.overrideAttrs (old: {
                  nativeBuildInputs = lib.remove pyFinal.pyprojectVersionPatchHook old.nativeBuildInputs;
                });
              })
            ];
          })
        ];
      };

      fromUnstable = callPackage: path: callPackage "${inputs.nixpkgs-unstable}/pkgs/${path}" { };
    in
    {
      inherit (unstable)
        chatgpt
        claude-code
        codex
        jpexs
        ;

      # tk-wayland needs Tcl 9.1, and LOOT 0.29 needs libloot 0.29.
      tcl-9_1 = fromUnstable final.callPackage "development/interpreters/tcl/9.1.nix";
      libloot = fromUnstable final.callPackage "by-name/li/libloot/package.nix";
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyFinal: _: {
          idapro = fromUnstable pyFinal.callPackage "development/python-modules/idapro";
          ida-domain = fromUnstable pyFinal.callPackage "development/python-modules/ida-domain";
        })
      ];
    }
    // lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      inherit (unstable) wootility;
    }
    // lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      inherit (unstable) anki;
    };
}
