require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function ()
      require("gruvbox").setup({})
      vim.cmd("colorscheme gruvbox")
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim"
    },
    config = function()
      local signs = {
        Error = " ",
        Warn  = " ",
        Hint  = " ",
        Info  = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
      end

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "..."
          }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'buffer' },
        })
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = { "c", "lua", "vim", "python", "java", "javascript", "typescript", "css", "html" },
        highlight = { enable = true, use_languagetree = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    config = function()
      require("nvim-tree").setup({
        view = { width = 20, side = "left" },
        disable_netrw = true,
        hijack_cursor = true,
        update_cwd = true,
        hijack_directories = { auto_open = true },
        renderer = {
          root_folder_label = false,
          indent_markers = {
            enable = true,
            icons = { corner = "└ ", edge = "│ ", none = "  " },
          },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-s>", ":silent Telescope current_buffer_fuzzy_find<CR>", desc = "Open Telescope" },
    },
    config = function()
      require("telescope").setup({
        defaults = { mapping = {} },
        pickers = {},
        extensions = {},
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "echasnovski/mini.nvim",
    version = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("mini.starter").setup({
        header = table.concat({
          "  ／l、     ",
          "（ﾟ､ ｡ ７    ",
          " l  ~ ヽ    ",
          " じしf_,)ノ ",
        }, "\n"),
        footer = "",
        content_hooks = {
          require("mini.starter").gen_hook.adding_bullet("» "),
          require("mini.starter").gen_hook.aligning("center", "center"),
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  {
    "tamton-aquib/staline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("staline").setup {
        sections = {
          left = { 'file_name', 'branch' },
          mid = { 'lsp' },
          right = { 'line_column' },
        },
        special_table = {
          NvimTree = { 'NvimTree', ' ' },
          packer = { 'Packer', ' ' },
          starter = { '', '' },
          lazy = { '', '' },
          mason = { '', '' },
        },
        lsp_symbols = {
          Error = " ",
          Info  = " ",
          Warn  = " ",
          Hint  = "",
        },
        defaults = {
          true_colors = true,
          line_column = ' ☰ %l/%L %c',
          branch_symbol = " ",
          exclude_fts = { 'NvimTree' },
        },
      }
      vim.cmd('highlight Statusline guibg=none')
      vim.cmd('highlight StatuslineNC guibg=none')
    end,
  },
})
