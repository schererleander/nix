{ config, lib, pkgs, ... }:

let
  cfg = config.neovim;
in {
  options.neovim.enable = lib.mkEnableOption "Enable and setup neovim";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        lua-language-server
      ];

      plugins = with pkgs.vimPlugins; [
        lazy-nvim
        nvim-lspconfig
        friendly-snippets
        telescope-nvim

        (nvim-treesitter.withPlugins (plugins: with plugins; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-json
          tree-sitter-lua
          tree-sitter-python
          tree-sitter-nix
          tree-sitter-vim
          tree-sitter-vimdoc
          tree-sitter-yaml
          tree-sitter-markdown
          tree-sitter-markdown_inline
        ]))
      ];
    };

    xdg.configFile."nvim/lua".source = ./lua;

    home.sessionVariables = rec {
      EDITOR = "nvim";
      GIT_EDITOR = EDITOR;
    };
  };
}