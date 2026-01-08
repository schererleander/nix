{
  config,
  lib,
  ...
}:

{
  options.nx.programs.kitty.enable = lib.mkEnableOption "Enable kitty";
  config = lib.mkIf config.nx.programs.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      font = {
        name = "monospace";
        size = 11;
      };
      settings = {
        cursor_shape = "underline";
        cursor_blink_interval = "-1";
        cursor_stop_blinking_after = "15.0";

        background_opacity = "0.3";

        enable_audio_bell = false;
        bell_on_tab = false;

        window_border_width = "0";
        window_margin_width = "4";
        window_padding_width = "5";
      };
    };
  };
}
