{
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      userSettings = {
        telemetry = {
          metrics = false;
        };
        title_bar = {
          show_onboarding_banner = false;
          show_project_items = false;
          show_branch_name = false;
          show_user_menu = false;
        };
        tab_bar.show = false;
        toolbar.quick_actions = false;
        status_bar."experimental.show" = false;
        project_panel = {
          dock = "right";
          default_width = 400;
          hide_root = true;
          auto_fold_dirs = false;
          starts_open = false;
          git_status = false;
          sticky_scroll = false;
          scrollbar.show = "never";
          indent_guides.show = "never";
        };
        outline_panel = {
          default_width = 300;
          indent_guides.show = "never";
        };
        file_finder.modal_max_width = "large";
      };
    };
  };
}
