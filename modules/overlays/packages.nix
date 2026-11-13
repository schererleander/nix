{
  flake.overlays.packages =
    final: prev:
    let
      inherit (prev) lib;
      system = prev.stdenv.hostPlatform.system;
    in
    {
      ffdecmcp = final.callPackage ../../pkgs/ffdecmcp.nix { };
    }
    // lib.optionalAttrs (system == "x86_64-linux") {
      bodyslide = final.callPackage ../../pkgs/bodyslide.nix { };
      hytale-launcher = final.callPackage ../../pkgs/hytale-launcher.nix { };
      ida-pro = final.callPackage ../../pkgs/ida-pro.nix { };
      ida-pro-mcp = final.callPackage ../../pkgs/ida-pro-mcp.nix { };
      loot = final.callPackage ../../pkgs/loot.nix { };
      open-goal-launcher = final.callPackage ../../pkgs/open-goal-launcher.nix { };
    }
    // lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      renderdoc-with-python = final.callPackage ../../pkgs/renderdoc-with-python.nix { };
      renderdoc-mcp = final.callPackage ../../pkgs/renderdoc-mcp.nix { };
    }
    // lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      claude-desktop = final.callPackage ../../pkgs/claude-desktop.nix { };
    };

  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    {
      packages = {
        inherit (pkgs) codex ffdecmcp;
      }
      // lib.optionalAttrs (system == "x86_64-linux") {
        inherit (pkgs)
          bodyslide
          hytale-launcher
          ida-pro
          ida-pro-mcp
          loot
          open-goal-launcher
          ;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit (pkgs) renderdoc-with-python renderdoc-mcp;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        inherit (pkgs) claude-desktop;
      };
    };
}
