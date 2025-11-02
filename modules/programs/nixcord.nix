{
  config,
  lib,
  inputs,
  username,
  ...
}:

{
  options.nx.programs.nixcord.enable = lib.mkEnableOption "Enable nixcord and setup";
  config = lib.mkIf config.nx.programs.nixcord.enable {
    home-manager.users.${username} = { ... }: {
        imports = [ inputs.nixcord.homeModules.nixcord ];

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
  };
}
