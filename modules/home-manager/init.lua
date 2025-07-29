vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

local map = vim.keymap.set
map('n', '<leader>o', '<CMD>update<BAR>source %<CR>', { desc = 'Save & reload init.lua' })
map('n', '<leader>w', '<CMD>write<CR>')
map('n', '<leader>q', '<CMD>quit<CR>')

map({ 'n', 'v', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
map({ 'n', 'v', 'x' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })

vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
--	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "nix" },
	highlight = { enable = true },
})

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
  },
  underline = true,
  severity_sort = true,
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.o.completeopt = "menu,menuone,noselect"

require("gitsigns").setup()

require("lspconfig").nixd.setup({
	settings = {
		nixd = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

require("lspconfig").lua_ls.setup({
	settings = {
		lua_ls = {
			formatting = {
				command = { "luaformatter" },
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "pyright" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)


require("mini.pick").setup()

vim.cmd("colorscheme gruvbox")

local hl = vim.api.nvim_set_hl
hl(0, 'Normal',      { bg = 'none' })
hl(0, 'NormalFloat', { bg = 'none' })
hl(0, 'NormalNC',    { bg = 'none' })
hl(0, 'StatusLine',  { bg = 'none' })
hl(0, 'SignColumn',  { bg = 'none' })

-- LSP diagnostics
hl(0, "DiagnosticError",      { bg = "none" })
hl(0, "DiagnosticSignError",  { bg = "none" })
hl(0, "DiagnosticSignHint",   { bg = "none" })
hl(0, "DiagnosticSignInfo",   { bg = "none" })
hl(0, "DiagnosticSignWarn",   { bg = "none" })
