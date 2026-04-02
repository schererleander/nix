{
  flake.modules.homeManager.sioyek =
    { ... }:
    {
      programs.sioyek = {
        enable = true;
        config = {
          # dark monochrome background
          "background_color" = "0.0 0.0 0.0";
          "dark_mode_background_color" = "0.0 0.0 0.0";
          "custom_background_color" = "0.0 0.0 0.0";
          "custom_text_color" = "0.9 0.9 0.9";

          # ui chrome
          "ui_background_color" = "0.05 0.05 0.05";
          "ui_selected_background_color" = "0.15 0.15 0.15";
          "ui_text_color" = "0.85 0.85 0.85";
          "ui_selected_text_color" = "1.0 1.0 1.0";
          "status_bar_color" = "0.0 0.0 0.0";
          "status_bar_text_color" = "0.75 0.75 0.75";
          "page_separator_color" = "0.1 0.1 0.1";

          # highlights / search
          "text_highlight_color" = "0.6 0.6 0.6";
          "search_highlight_color" = "0.5 0.5 0.5";
          "visual_mark_color" = "0.9 0.9 0.9 0.15";
          "link_highlight_color" = "0.55 0.55 0.55";
          "synctex_highlight_color" = "0.45 0.45 0.45";
        };
        bindings = {
          "move_up" = "k";
          "move_down" = "j";
          "move_left" = "h";
          "move_right" = "l";
          "screen_down" = [
            "d"
            "<c-d>"
          ];
          "screen_up" = [
            "u"
            "<c-u>"
          ];
        };
      };
    };
}
