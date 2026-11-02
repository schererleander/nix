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
        ];

        plugins = with pkgs.vimPlugins; [
          gruvbox-nvim
          mini-starter
          gitsigns-nvim
          nvim-autopairs
          telescope-nvim
          fidget-nvim
          plenary-nvim
          (nvim-treesitter.withPlugins (
            parsers: with parsers; [
              bash
              c
              cpp
              css
              go
              html
              javascript
              json
              latex
              lua
              markdown
              markdown_inline
              nix
              python
              regex
              rust
              toml
              tsx
              typescript
              typst
              vim
              vimdoc
              yaml
            ]
          ))
          nvim-treesitter-textobjects
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
