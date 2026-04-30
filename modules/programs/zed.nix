{
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "c"
        "go"
        "lua"
        "rust"
        "python"
        "typescript"
        "typst"
        "latex"
      ];
      userSettings = {
        telemetry = {
          metrics = false;
        };
        title_bar = {
          show_onboarding_banner = false;
          show_sign_in = false;
          show_user_menu = false;
        };
        toolbar.quick_actions = false;
        outline_panel = {
          default_width = 300;
          indent_guides.show = "never";
        };
        file_finder.modal_max_width = "large";
      };
    };
  };
}
