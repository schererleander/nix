{
  description = "Nix configuration";
  
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  
    nvf.url = "github:notashelf/nvf";

    nixcord.url = "github:kaylorben/nixcord";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { nixpkgs, nur, nix-darwin, home-manager, ... } @ inputs: let
    linux-system = "x86_64-linux";
    darwin-system = "aarch64-darwin";
    username = "schererleander";
    email = "leander@schererleander.de";
    desktop = "nixos";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = linux-system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nixos/configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
          home-manager.users.leander = import ./hosts/nixos/home.nix;

          home-manager.sharedModules = [
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.nixcord.homeModules.nixcord
            inputs.nvf.homeManagerModules.nvf
          ];
        }
      ];
    };
    darwinConfigurations."MacBook-Air" = nix-darwin.lib.darwinSystem {
      system = darwin-system;
      specialArgs = { inherit inputs username; };
      modules = [
        ./hosts/darwin/configuration.nix

        inputs.mac-app-util.darwinModules.default

        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.${username} = import ./hosts/darwin/home.nix;

          home-manager.sharedModules = [
            inputs.spicetify-nix.homeManagerModules.spicetify
            inputs.nixcord.homeModules.nixcord
            inputs.nvf.homeManagerModules.nvf
          ];
        }
      ];
    };
  };
}
