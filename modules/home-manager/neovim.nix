{ config, lib, pkgs, ... }:

{
  options.neovim.enable = lib.mkEnableOption "Setup neovim";
  config = lib.mkIf config.neovim.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.oxocarbon.enable = true;
      plugins = {
        treesitter.enable = true;
	lsp = {
	  enable = true;
	  servers.lua_ls.enable = true;
	};
      };
    };
  };
}
