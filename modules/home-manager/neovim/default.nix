{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.neovim.enable = lib.mkEnableOption "Setup neovim";
  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim;
      extraConfig = ''
        luafile ${./init.lua}
      '';
    };
    home.packages = with pkgs; [
			ripgrep

			# github pilot
			nodejs

      # language servers
      lua-language-server
      nixd
      pyright
			gopls
      java-language-server
      typescript-language-server
			rust-analyzer
			tailwindcss-language-server

      # formatter
      nixfmt-rfc-style
      luaformatter
    ];
  };
}
