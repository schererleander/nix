{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    nixcord.url = "github:kaylorben/nixcord";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... } @ inputs: let
    linux-system = "x86_64-linux";
    darwin-system = "aarch64-darwin";
    username = "schererleander";
    email = "leander@schererleander.de";
    desktop = "nixos";
    pkgs = import nixpkgs {
      overlays = [ (import ./overlays/minbrowser.nix) ];
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linux-system;
        specialArgs = { inherit inputs; };
	pkgs = pkgs;
        modules = [
          ./hosts/nixos/configuration.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.leander = import ./hosts/nixos/home.nix;

            home-manager.sharedModules = [
              inputs.nixcord.homeModules.nixcord
            ];
          }
        ];
      };
    darwinConfigurations."MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = darwin-system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./hosts/darwin/configuration.nix

          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${username} = import ./hosts/darwin/home.nix;
          }
        ];
      };
  };
}

