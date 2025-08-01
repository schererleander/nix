{ config, lib, ... }:

{
  options.gh.enable = lib.mkEnableOption "Setup gh";
  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
    };
  };
}
