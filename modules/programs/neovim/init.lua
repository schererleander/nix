vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

local map = vim.keymap.set
map('n', '<leader>o', '<CMD>update<BAR>source %<CR>', { desc = 'Save & reload init.lua' })
map('n', '<leader>lf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer via LSP' })
map('n', '<leader>w', '<CMD>write<CR>')
map('n', '<leader>q', '<CMD>quit<CR>')

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

require("gitsigns").setup()
require("nvim-autopairs").setup()
require("fidget").setup()

vim.cmd("colorscheme gruvbox")

local hl = vim.api.nvim_set_hl
hl(0, 'Normal', { bg = 'none' })
hl(0, 'NormalFloat', { bg = 'none' })
hl(0, 'NormalNC', { bg = 'none' })
hl(0, 'StatusLine', { bg = 'none' })
hl(0, 'SignColumn', { bg = 'none' })
hl(0, "DiagnosticError", { bg = "none" })
hl(0, "DiagnosticSignError", { bg = "none" })
hl(0, "DiagnosticSignHint", { bg = "none" })
hl(0, "DiagnosticSignInfo", { bg = "none" })
hl(0, "DiagnosticSignWarn", { bg = "none" })

hl(0, "Pmenu", { bg = "none" })
hl(0, "PmenuSel", { bg = "none" })
hl(0, "FloatBorder", { bg = "none" })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Treesitter', { clear = true }),
  callback = function(event)
    -- Filetypes without an installed parser keep their normal syntax rules.
    if pcall(vim.treesitter.start, event.buf) then
      vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('nvim-treesitter-textobjects').setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local ts_select = require('nvim-treesitter-textobjects.select')
for key, query in pairs({
  af = '@function.outer',
  ['if'] = '@function.inner',
  ac = '@class.outer',
  ic = '@class.inner',
}) do
  map({ 'x', 'o' }, key, function()
    ts_select.select_textobject(query, 'textobjects')
  end, { desc = 'Select ' .. query })
end

local ts_move = require('nvim-treesitter-textobjects.move')
for method, keys in pairs({
  goto_next_start = { ['äm'] = '@function.outer', ['äc'] = '@class.outer' },
  goto_next_end = { ['äM'] = '@function.outer', ['äC'] = '@class.outer' },
  goto_previous_start = { ['öm'] = '@function.outer', ['öc'] = '@class.outer' },
  goto_previous_end = { ['öM'] = '@function.outer', ['öC'] = '@class.outer' },
}) do
  for key, query in pairs(keys) do
    map({ 'n', 'x', 'o' }, key, function()
      ts_move[method](query, 'textobjects')
    end, { desc = method .. ' ' .. query })
  end
end

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

local cmp = require("cmp")
local ls = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'require' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--fallback-style=llvm",
  }
})

local servers = {
  'nixd',
  'lua_ls',
  'gopls',
  'clangd',
  'pyright',
  'tailwindcss',
  'rust_analyzer',
  'ts_ls'
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

vim.diagnostic.config({
  virtual_text = { source = "if_many" },
  underline = true,
  severity_sort = true,
})
