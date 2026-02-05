-- General settings
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"

local map = vim.keymap.set
map('n', '<leader>o', '<CMD>update<BAR>source %<CR>', { desc = 'Save & reload init.lua' })
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

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if status_ok then
	configs.setup({
		highlight = { enable = true },
		indent = { enable = true },
	})
end

local builtin = require('telescope.builtin')
local map = vim.keymap.set
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
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
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
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

-- Add parentheses after selecting function or method
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, noremap = true, silent = true }
		vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
	end,
})

-- Format on save for all languages with LSP support
vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('FormatOnSave', {}),
	callback = function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.supports_method('textDocument/formatting') then
				vim.lsp.buf.format({ async = false })
				return
			end
		end
	end,
})

-- Native LSP setup (Neovim v0.11+)
vim.lsp.config('nixd', {
	cmd = { 'nixd' },
	capabilities = capabilities,
	settings = {
		nixd = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})

vim.lsp.config('nil_ls', {
	cmd = { 'nil' },
	capabilities = capabilities,
	settings = {
		['nil'] = {
			nix = {
				flake = {
					autoArchive = true,
				},
			},
		},
	},
})

vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim', 'require' },
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

vim.lsp.config('pyright', {
	cmd = { 'pyright-langserver', '--stdio' },
	capabilities = capabilities,
})

vim.lsp.config('tailwindcss', {
	cmd = { 'tailwindcss-language-server', '--stdio' },
	capabilities = capabilities,
})

vim.lsp.config('gopls', {
	cmd = { 'gopls' },
	capabilities = capabilities,
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

vim.lsp.config('rust_analyzer', {
	cmd = { 'rust-analyzer' },
	capabilities = capabilities,
})

vim.lsp.config('ts_ls', {
	cmd = { 'typescript-language-server', '--stdio' },
	capabilities = capabilities,
})

-- Enable all configured servers
vim.lsp.enable('nixd')
vim.lsp.enable('nil_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('gopls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('ts_ls')

vim.diagnostic.config({
	virtual_text = { source = "if_many" },
	underline = true,
	severity_sort = true,
})
