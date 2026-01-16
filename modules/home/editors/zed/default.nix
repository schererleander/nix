{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    optionals
    ;
  cfg = config.nx.editors.zed-editor;
in
{
  options.nx.editors.zed-editor = {
    enable = mkEnableOption "zed editor";

    langs = {
      nix = mkOption {
        description = "enable nix integration";
        type = types.bool;
        default = true;
      };
      python = mkOption {
        description = "enable python integration";
        type = types.bool;
        default = false;
      };
      rust = mkOption {
        description = "enable rust integration";
        type = types.bool;
        default = false;
      };
      go = mkOption {
        description = "enable go integration";
        type = types.bool;
        default = false;
      };
      lua = mkOption {
        description = "enable lua integration";
        type = types.bool;
        default = false;
      };
      docker = mkOption {
        description = "enable docker integration";
        type = types.bool;
        default = false;
      };
      java = mkOption {
        description = "enable java integration";
        type = types.bool;
        default = false;
      };
      cmake = mkOption {
        description = "enable cmake integration";
        type = types.bool;
        default = false;
      };
      toml = mkOption {
        description = "enable toml integration";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions =
        [ ]
        ++ (optionals cfg.langs.nix [ "nix" ])
        ++ (optionals cfg.langs.python [ "python" ])
        ++ (optionals cfg.langs.rust [ "rust" ])
        ++ (optionals cfg.langs.go [ "go" ])
        ++ (optionals cfg.langs.lua [ "lua" ])
        ++ (optionals cfg.langs.docker [ "dockerfile" ])
        ++ (optionals cfg.langs.java [ "java" ])
        ++ (optionals cfg.langs.cmake [ "cmake" ])
        ++ (optionals cfg.langs.toml [ "toml" ]);
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
