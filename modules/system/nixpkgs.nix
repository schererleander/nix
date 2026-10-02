{ inputs, ... }:
let
  nixpkgs = {
    overlays = with inputs.self.overlays; [
      codex
    ];
    config = {
      allowUnfree = true;
      gitConfig.http.version = "HTTP/1.1";
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
