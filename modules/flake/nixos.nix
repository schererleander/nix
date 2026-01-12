{
  inputs,
  config,
  self,
  ...
}:

let
  inherit (inputs.nixpkgs) lib;
  import-tree = inputs.import-tree.withLib lib;

  # Use import-tree.leafs to get list of NixOS module paths
  nixosModuleFiles = import-tree.leafs (self + /modules/nixos);

  # Common NixOS modules for all hosts
  commonNixosModules = nixosModuleFiles ++ [
    {
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    }
  ];

  # Home-manager modules for hosts that use it
  homeManagerModules = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.sharedModules = [ config.flake.homeModules.default ];
    }
  ];
in
{
  flake.nixosConfigurations = {
    adam = lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        host = "adam";
      };
      modules =
        commonNixosModules
        ++ homeManagerModules
        ++ [
          (self + /hosts/adam/configuration.nix)
        ];
    };

    sachiel = lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        host = "sachiel";
      };
      modules = commonNixosModules ++ [
        (self + /hosts/sachiel/configuration.nix)
      ];
    };
  };
}
