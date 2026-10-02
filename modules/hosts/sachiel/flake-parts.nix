{ inputs, ... }:
{
  flake.nixosConfigurations.sachiel = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      nixpkgs
      sachiel
      openssh
      nginx
      acme
      nextcloud
      mail
      git
      cgit
    ];
  };
}
