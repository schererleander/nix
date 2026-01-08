{
  config,
  username,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    mkIf
    optionals
    ;
  cfg = config.nx.editors.neovim;
in
{
  options.nx.editors.neovim = {
    enable = mkOption {
      description = "Neovim editor";
      type = types.bool;
      default = true;
    };

    langs = {
      python = mkOption {
        description = "enable the python integration";
        type = types.bool;
        default = false;
      };
      go = mkOption {
        description = "enable go integration";
        type = types.bool;
        default = false;
      };
      ts = mkOption {
        description = "enable the js/ts integration";
        type = types.bool;
        default = false;
      };
      nix = mkOption {
        description = "enable the nix integration";
        type = types.bool;
        default = true;
      };
      lua = mkOption {
        description = "enable the lua integration";
        type = types.bool;
        default = true;
      };
      latex = mkOption {
        description = "enable latex integration";
        type = types.bool;
        default = false;
      };
    };
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
        ++ (optionals cfg.langs.ts [ pkgs.nodePackages.typescript-language-server ])
        ++ (optionals cfg.langs.python [ ])
        ++ (optionals cfg.langs.go [ pkgs.gopls ])
        ++ (optionals cfg.langs.nix [
          pkgs.nil
          pkgs.nixfmt
        ])
        ++ (optionals cfg.langs.lua [ pkgs.lua-language-server ])
        ++ (optionals cfg.langs.latex [ pkgs.texlab ]);

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
