{
  config,
  username,
  lib,
  pkgs,
  ...
}:

{
  options.nx.programs.neovim.enable = lib.mkEnableOption "Setup neovim";
  config = lib.mkIf config.nx.programs.neovim.enable {
    home-manager.users.${username} = {
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
  };
}