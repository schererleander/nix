{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    site.url = "github:schererleander/site";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixcord.url = "github:kaylorben/nixcord";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs =
    { ... }@inputs:
    let
      linux-system = "x86_64-linux";
      darwin-system = "aarch64-darwin";
      username = "schererleander";
      overlays = [ ];
      lib = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations = {
        adam = lib.mkSystem {
          host = "adam";
          username = "schererleander";
          system = linux-system;
          overlays = overlays;
        };
        sachiel = lib.mkSystem {
          host = "sachiel";
          username = "administrator";
          system = linux-system;
          useHomeManager = false;
        };
      };
      darwinConfigurations.lilith = lib.mkSystem {
        host = "lilith";
        username = username;
        system = darwin-system;
        overlays = overlays;
      };
    };
}
