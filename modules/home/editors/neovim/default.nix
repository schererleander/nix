{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf optionals;
  cfg = config.nx.editors.neovim;
in
{
  options.nx.editors.neovim = {
    enable = mkEnableOption "Neovim editor";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      defaultEditor = true;
      enable = true;
      package = pkgs.neovim-unwrapped;
      extraPackages =
        with pkgs;
        [
          tree-sitter
          git
          ripgrep
          fd
          gcc
        ]
        ++ (optionals true [ pkgs.gopls ])
        ++ (optionals true [
          pkgs.nil
          pkgs.nixfmt
        ])
        ++ (optionals true [ pkgs.lua-language-server ])
        ++ (optionals true [ pkgs.texlab ])
        ++ (optionals true [ pkgs.tinymist ]);

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