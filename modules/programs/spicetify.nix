{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  options.nx.programs.spicetify.enable = lib.mkEnableOption "Enable Spicetify integration";
  config = lib.mkIf config.nx.programs.spicetify.enable {
    home-manager.users.${username} = { ... }: {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];
      nixpkgs.config.allowUnfree = true;
      programs.spicetify = {
        enable = true;
        enabledSnippets = with spicePkgs.snippets; [
          pointer
          sonicDancing
          modernScrollbar
          nyanCatProgressBar
          declutterNowPlayingBar
        ];

        enabledExtensions = with spicePkgs.extensions; [
          keyboardShortcut
        ];

        theme = spicePkgs.themes.sleek;
        colorScheme = "Coral";
      };
    };
  };
}
