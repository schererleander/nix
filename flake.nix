{
  description = "Nix configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
    nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
      system = linux-system;
      specialArgs = { inherit inputs; };
      modules = [
        .hosts/vps/configuration

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
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
