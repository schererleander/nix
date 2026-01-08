{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    mkIf
    optionals
    ;
  cfg = config.nx.editors.zed-editor;
in
{
  options.nx.editors.zed-editor = {
    enable = mkOption {
      description = "Enable and setup zed editor";
      type = types.bool;
      default = false;
    };

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
      };
    };
  };
}
