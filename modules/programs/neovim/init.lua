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

vim.lsp.config('nil_ls', {
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
		"--fallback-style=llvm", -- Options: llvm, google, chromium, mozilla, webkit
	}
})

local servers = {
	'nixd',
	'nil_ls',
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
