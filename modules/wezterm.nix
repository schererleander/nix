{ config, lib, pkgs, ... }:

{
  options.wezterm.enable = lib.mkEnableOption "Enable wezterm and setup";
  config = lib.mkIf config.wezterm.enable {
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "SpaceMono" "IBMPlexMono" "Terminus" ]; })
    ];

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
      local wezterm = require 'wezterm'

      local config = wezterm.config_builder()

      config.font = wezterm.font "SpaceMono Nerd Font Mono"
      config.font_size = 10
      config.use_fancy_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.window_background_opacity = 0.9
      config.exit_behavior = 'Close'
      config.exit_behavior_messaging = 'None'

      return config
      '';
    };
  };
}