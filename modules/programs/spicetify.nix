{
  flake.modules.homeManager.spicetify =
    {
      pkgs,
      inputs,
      ...
    }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.spicetify
      ];

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
}
