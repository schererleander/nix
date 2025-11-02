{
  config,
  username,
  lib,
  pkgs,
  ...
}:

{
  options.nx.programs.vscode.enable = lib.mkEnableOption "Enable vscode and setup";
  config = lib.mkIf config.nx.programs.vscode.enable {
    home-manager.users.${username} = {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          enableUpdateCheck = true;
          enableExtensionUpdateCheck = true;

          userSettings = {
            "update.mode" = "none";
            "workbench.colorTheme" = "Minimal";
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

          extensions = (
            with pkgs.vscode-extensions;
            [
              ms-vscode.cmake-tools
              ms-azuretools.vscode-docker
              github.copilot
              ms-python.python
              golang.go
              rust-lang.rust-analyzer
              vscjava.vscode-maven
              sumneko.lua
              #fwcd.kotlin
              bradlc.vscode-tailwindcss
              adpyke.codesnap
              esbenp.prettier-vscode
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "minimalist-dark";
                publisher = "nichabosh";
                version = "1.0.0";
                sha256 = "sha256-lw+Scfada6DycLdRT2Cz+Fd12JucglIrw3uRd2ZhabQ=";
              }
            ]
          );
        };
      };
    };
  };
}