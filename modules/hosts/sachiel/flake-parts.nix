{ inputs, ... }:
{
  flake.nixosConfigurations.sachiel = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      nixpkgs
      sachiel
      nebula-lighthouse
      openssh
      nginx
      acme
      nextcloud
      git-server
      cgit
    ];
  };
}
