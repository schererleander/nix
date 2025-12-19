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

vim.pack.add({
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/echasnovski/mini.starter" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-cmdline" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/onsails/lspkind-nvim" }
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "nix" },
	highlight = { enable = true },
})

local builtin = require('telescope.builtin')
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

local servers = {
	nixd = {
		settings = {
			nixd = {
				formatting = {
					command = { "nixfmt" },
				},
			},
		},
	},
	lua_ls = {
		settings = {
			lua_ls = {
				formatting = {
					command = { "luaformatter" },
				},
			},
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
	},
	pyright = {},
	tailwindcss = {},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					unusedwrite = true,
				},
				staticcheck = true,
			},
		},
	},
	rust_analyzer = {},
}

local server_names = {}
for server, config in pairs(servers) do
	config.capabilities = capabilities
	vim.lsp.config(server, config)
	table.insert(server_names, server)
end

vim.lsp.enable(server_names)

vim.diagnostic.config({
	virtual_text = { source = "if_many" },
	underline = true,
	severity_sort = true,
})


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
