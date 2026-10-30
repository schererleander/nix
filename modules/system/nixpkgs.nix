{ inputs, ... }:
let
  nixpkgs = {
    overlays = with inputs.self.overlays; [
      claude-code
      codex
    ];
    config = {
      allowUnfree = true;
    };
  };
in
{
  flake.modules.nixos.nixpkgs = { inherit nixpkgs; };
  flake.modules.darwin.nixpkgs = { inherit nixpkgs; };

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs (nixpkgs // { inherit system; });
      formatter = pkgs.nixfmt;
    };
}
