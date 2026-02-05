{
  flake.modules.homeManager.nixcord =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        config = {
          themeLinks = [
            "https://refact0r.github.io/system24/theme/system24.theme.css"
          ];
          frameless = true;
          plugins = {
            alwaysAnimate.enable = false;
            imageLink.enable = true;
            imageZoom.enable = true;
            translate.enable = true;
          };
        };
      };
    };
}
