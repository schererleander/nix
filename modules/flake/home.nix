{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs) lib;
  import-tree = inputs.import-tree.withLib lib;

  homeModuleFiles = import-tree.leafs (self + /modules/home);
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules = {
    default = {
      imports = homeModuleFiles ++ [
        inputs.sops-nix.homeManagerModules.sops
        inputs.nixcord.homeModules.nixcord
        inputs.spicetify-nix.homeManagerModules.spicetify
      ];
    };
  };
}
