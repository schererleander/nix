{
  flake.modules.homeManager.vscode =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) optionals;
    in
    {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
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

          extensions =
            with pkgs.vscode-extensions;
            [
              github.copilot
              adpyke.codesnap
              esbenp.prettier-vscode
            ]
            ++ (optionals false [ ms-vscode.cmake-tools ])
            ++ (optionals false [ ms-azuretools.vscode-docker ])
            ++ (optionals false [ ms-python.python ])
            ++ (optionals false [ golang.go ])
            ++ (optionals false [ rust-lang.rust-analyzer ])
            ++ (optionals false [ vscjava.vscode-maven ])
            ++ (optionals false [ sumneko.lua ])
            ++ (optionals false [ bradlc.vscode-tailwindcss ])
            ++ (optionals true (
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
