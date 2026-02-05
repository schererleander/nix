{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      programs.neovim = {
        defaultEditor = true;
        enable = true;
        package = pkgs.neovim-unwrapped;
        extraPackages = with pkgs; [
          tree-sitter
          git
          ripgrep
          fd
          gcc
          gopls
          nil
          nixfmt
          lua-language-server
          texlab
          tinymist
        ];

        plugins = with pkgs.vimPlugins; [
          gruvbox-nvim
          mini-starter
          gitsigns-nvim
          nvim-autopairs
          telescope-nvim
          fidget-nvim
          plenary-nvim
          nvim-treesitter.withAllGrammars
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          luasnip
          cmp_luasnip
          lspkind-nvim
        ];

        extraConfig = ''
          luafile ${./init.lua}
        '';
      };
    };
}
