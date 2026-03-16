{
  flake.modules.homeManager.sioyek =
    { ... }:
    {
      programs.sioyek = {
        enable = true;
        config = {
          "background_color" = "1.0 1.0 1.0";
          "text_highlight_color" = "1.0 0.0 0.0";
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
