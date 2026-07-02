{ inputs, ... }:
{
  flake.modules.nixos.nixpkgs =
    { ... }:
    {
      nixpkgs.overlays = [
        inputs.self.overlays.rpcs3
      ];
      nixpkgs.config.allowUnfree = true;
    };
}
