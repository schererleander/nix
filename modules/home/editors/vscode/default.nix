{
  config,
  lib,
  pkgs,
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
  cfg = config.nx.editors.vscode;
in
{
  options.nx.editors.vscode = {
    enable = mkEnableOption "vscode editor";

    useVSCodium = mkOption {
      description = "Use vscodium instead of vscode";
      type = types.bool;
      default = false;
    };

    theme = mkOption {
      description = "Theme to use for vscode";
      type = types.enum [
        "minimal"
        "dark"
        "light"
      ];
      default = "minimal";
    };

    langs = {
      cmake = mkOption {
        description = "enable cmake integration";
        type = types.bool;
        default = false;
      };
      docker = mkOption {
        description = "enable docker integration";
        type = types.bool;
        default = false;
      };
      python = mkOption {
        description = "enable python integration";
        type = types.bool;
        default = false;
      };
      go = mkOption {
        description = "enable go integration";
        type = types.bool;
        default = false;
      };
      rust = mkOption {
        description = "enable rust integration";
        type = types.bool;
        default = false;
      };
      java = mkOption {
        description = "enable java integration";
        type = types.bool;
        default = false;
      };
      lua = mkOption {
        description = "enable lua integration";
        type = types.bool;
        default = false;
      };
      tailwindcss = mkOption {
        description = "enable tailwindcss integration";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = if cfg.useVSCodium then pkgs.vscodium else pkgs.vscode;
      mutableExtensionsDir = false;
      profiles.default = {
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;

        userSettings = {
          "update.mode" = "none";
          "workbench.colorTheme" =
            if cfg.theme == "minimal" then
              "Minimal"
            else if cfg.theme == "dark" then
              "Default Dark Modern"
            else
              "Default Light Modern";
          "editor.fontFamily" = "monospace";
          "editor.tabSize" = 2;
          "editor.minimap.enabled" = false;
          "terminal.integrated.cursorStyle" = "underline";
          "terminal.integrated.cursorStyleInactive" = "underline";
          "terminal.integrated.fontFamily" = "monospace";
          "terminal.integrated.fontSize" = 13;
          "git.autofetch" = true;
          "window.controlsStyle" = "custom";
        };

        extensions =
          with pkgs.vscode-extensions;
          [
            github.copilot
            adpyke.codesnap
            esbenp.prettier-vscode
          ]
          ++ (optionals cfg.langs.cmake [ ms-vscode.cmake-tools ])
          ++ (optionals cfg.langs.docker [ ms-azuretools.vscode-docker ])
          ++ (optionals cfg.langs.python [ ms-python.python ])
          ++ (optionals cfg.langs.go [ golang.go ])
          ++ (optionals cfg.langs.rust [ rust-lang.rust-analyzer ])
          ++ (optionals cfg.langs.java [ vscjava.vscode-maven ])
          ++ (optionals cfg.langs.lua [ sumneko.lua ])
          ++ (optionals cfg.langs.tailwindcss [ bradlc.vscode-tailwindcss ])
          ++ (optionals (cfg.theme == "minimal") (
            pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "minimalist-dark";
                publisher = "nichabosh";
                version = "1.0.0";
                sha256 = "sha256-lw+Scfada6DycLdRT2Cz+Fd12JucglIrw3uRd2ZhabQ=";
              }
            ]
          ));
      };
    };
  };
}
