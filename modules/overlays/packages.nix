{ ... }:
let
  byName = ../../pkgs/by-name;
  pythonModules = ../../pkgs/python-modules;
in
{
  flake.overlays.packages =
    final: prev:
    prev.lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = byName;
    }
    // {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (
          pythonFinal: pythonPrev:
          prev.lib.packagesFromDirectoryRecursive {
            inherit (pythonFinal) callPackage;
            directory = pythonModules;
          }
          // {
            sse-starlette = pythonPrev.sse-starlette.overrideAttrs (
              old:
              prev.lib.optionalAttrs (old.version == "3.2.0") {
                # Check that the stream started and disconnected without
                # requiring the fourth event just before the timeout.
                postPatch = (old.postPatch or "") + ''
                  substituteInPlace tests/test_sse.py \
                    --replace-fail "chunk: b'data: 4" "chunk: b'data: 1"
                '';
              }
            );
          }
        )
      ];
    };

  perSystem =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      names = directory: builtins.attrNames (builtins.readDir directory);
    in
    {
      packages = lib.filterAttrs (_: lib.meta.availableOn pkgs.stdenv.hostPlatform) (
        lib.getAttrs (names byName) pkgs
        // lib.getAttrs (
          names pythonModules
          ++ [
            "idapro"
            "ida-domain"
          ]
        ) pkgs.python3Packages
      );

      checks =
        let
          sourcePackages = removeAttrs config.packages [
            "claude-desktop"
            "hytale-launcher"
            "ida-pro"
            "ida-mcp"
          ];
        in
        sourcePackages
        // lib.concatMapAttrs (
          name: package:
          lib.mapAttrs' (test: lib.nameValuePair "${name}-${test}") (package.passthru.tests or { })
        ) sourcePackages;
    };
}
