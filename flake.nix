{
  description = "Nix configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = { nixpkgs, nur, nix-darwin, home-manager, ... } @ inputs: let
    linux-system = "x86_64-linux";
    darwin-system = "aarch64-darwin";
    username = "schererleander";
    lib = import ./lib { inherit inputs; };
  in {
    darwinConfigurations.macbook = lib.mkSystem {
      host = "macbook";
      username = username;
      system = darwin-system;
    };
  };
}
