{
  config,
  lib,
  ...
}:

{
  options.dunst.enable = lib.mkEnableOption "Enable dunst notification";
  config = lib.mkIf config.dunst.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          transparency = 10;
          font = "monospace 10";
        };
      };
    };
  };
}
