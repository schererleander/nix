{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nixcord.url = "github:schererleander/nixcord";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      linux-system = "x86_64-linux";
      darwin-system = "aarch64-darwin";
      username = "schererleander";
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
      lib = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations = {
        desktop = lib.mkSystem {
          host = "desktop";
          username = username;
          system = linux-system;
          overlays = overlays;
        };
        vps = lib.mkSystem {
          host = "vps";
          username = "administrator";
          system = linux-system;
        };
      };
      darwinConfigurations.macbook = lib.mkSystem {
        host = "macbook";
        username = username;
        system = darwin-system;
        overlays = overlays;
        sharedModules = [
          inputs.nixcord.homeModules.nixcord
        ];
      };
    };
}
