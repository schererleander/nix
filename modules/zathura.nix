{ config, lib, pkgs, ... }:

let
  cfg = config.zathura;
in {
  options.zathura.enable = lib.mkEnableOption "Enable zathura and setup";
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        adjust-open = "width";
        zoom-center = true;
        page-padding = 0;
        pages-per-row = 1;
        scroll-page-aware = true;
      };
      mappings = {
        j = "navigate previous";
        k = "navigate next";
      };
    };
  };
}

