{ config, lib, pkgs, ... }:

let
  cfg = config.vscode;
in {
  options.vscode.enable = lib.mkEnableOption "Enable vscode and setup"
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
      mutableExtensionsDir = false;
      extensions = (with pkgs.vscode-extensions; [
        vscode-extensions.ms-vscode.cmake-tools
	vscode-extensions.ms-azuretools.vscode-docker
	vscode-extensions.ms-vscode.git
	vscode-extensions.ms-vscode.gitlens
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "minimalist-dark";
	  publisher = "nichabosh";
	  version = "1.0.0";
	  sha256 = "06vx8jphw9g188n9bq8jargn9hkydw79xahg0dv72qzjvdbyb37g";
	}
      ];
    };
  };
];

        
