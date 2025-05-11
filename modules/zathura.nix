{ config, lib, pkgs, ... }:

{
  options.zathura.enable = lib.mkEnableOption "Enable zathura and setup";
  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        recolor-lightcolor = "rgba(0, 0, 0, 0)";
        recolor-darkcolor = "rgba(255, 255, 255, 1)";
        recolor = true;
        adjust-open = "width";
        guioptions = "none";
        zoom-center = true;
        page-padding = 0;
        pages-per-row = 1;
        scroll-page-aware = true;
      };
      
      mappings = {
        i = "recolor";
        j = "navigate previous";
        k = "navigate next";
      };
    };
  };
}