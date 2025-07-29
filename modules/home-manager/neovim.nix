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
      # language servers
      lua-language-server
      nixd
      pyright
      java-language-server
      typescript-language-server

      # formatter
      nixfmt-rfc-style
      luaformatter
    ];
  };
}
