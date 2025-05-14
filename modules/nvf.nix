{ config, lib, pkgs, ... }:

{
  options.nvf.enable = lib.mkEnableOption "Setup nvf";
  config = lib.mkIf config.nvf.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme.enable = true;
          theme.name = "gruvbox";
          theme.transparent = true;
          theme.style = "dark";

          options = {
            clipboard = "unnamedplus";
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

          autopairs.nvim-autopairs.enable = true;

          git.enable = true;

          lsp = {
            enable = true;
            formatOnSave = true;
            lspkind.enable = true;
            lspSignature.enable = true;
          };

          diagnostics = {
            enable = true;
            config = {
              signs = {
                text = {
                  "vim.diagnostic.severity.ERROR" = " ";
                  "vim.diagnostic.severity.WARN" = " ";
                  "vim.diagnostic.severity.HINT" = " ";
                  "vim.diagnostic.severity.INFO" = " ";
                };
              };
              underline = true;
              virtual_lines = true;
              virtual_text = {
                format = lib.generators.mkLuaInline ''
                  function(diagnostic)
                    return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                  end
                  '';
              };
            };
            nvim-lint.enable = true;
          };

          languages = {
            enableTreesitter = true;
            
            nix.enable = true;
            markdown.enable  = true;

            clang.enable = true;
            css.enable = true;
            html.enable = true;
            java.enable = true;
            ts.enable = true;
            go.enable = true;
            lua.enable = true;
            python.enable = true;
            typst.enable = true;
            # fails on darwin
            #tailwind.enable = true;
          };

          formatter.conform-nvim.enable = true;

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
              event = ["VimEnter"];
              command = "highlight StatusLine guibg=none | highlight StatusLineNC guibg=none";
            }
          ];

          statusline.lualine.enable = true;
        };
      };
    };
  };
}
