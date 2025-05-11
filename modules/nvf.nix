{ config, lib, pkgs, ... }:

let
  cfg = config.nvf;
in {
  options.nvf.enable = lib.mkEnableOption "Setup nvf";

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme.enable = true;
          theme.name = "gruvbox";
          theme.transparent = true;
          theme.style = "dark";

          options = {
            tabstop = 2;
            shiftwidth = 2;
            expandtab = true;
            autoindent = true;
            mouse = "a";
          };

          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          mini = {
            starter = {
              enable = true;
              setupOpts = {
                header = "  ／l、     \n" +
                         "（ﾟ､ ｡ ７  \n" +
                         " l  ~ ヽ    \n" +
                         " じしf_,)ノ \n";
                footer = " ";
              };
            };
          };

          autopairs.nvim-autopairs = {
            enable = true;
          };

          git.enable = true;

          lsp = {
            enable = true;

            formatOnSave = true;
            lspkind.enable = true;
          };

          languages = {
            enableTreesitter = true;

            nix.enable = true;
          };

          visuals = {
            nvim-web-devicons.enable = true;
          };

          snippets.luasnip.enable = true;

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          ui = {
            borders.enable = false;
          };

          autocmds = [
            {
              enable = true;
              event = ["VimEnter"];
              command = "highlight Statusline guibg=none | highlight StatuslineNC guibg=none";
              desc = "Transparent statusline";
            }
          ];

          statusline.lualine.enable = true;
        };
      };
    };
  };
}
