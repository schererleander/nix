{ inputs, ... }:
{
  flake.modules.nixos.nixpkgs =
    { ... }:
    {
      nixpkgs.overlays = [ inputs.self.overlays.codex ];
      nixpkgs.config.allowUnfree = true;
    };
}
