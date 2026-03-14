{ inputs, ... }:
{
  flake.nixosConfigurations."sachiel" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.self.modules.nixos.sachiel
      inputs.self.modules.nixos.openssh
      inputs.self.modules.nixos.nginx
      inputs.self.modules.nixos.nextcloud
      inputs.self.modules.nixos.site
      inputs.self.modules.nixos.git
      inputs.self.modules.nixos.cgit
    ];
  };
}
