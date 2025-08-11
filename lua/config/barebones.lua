-- Set leader keys
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]

-- UI
vim.o.lazyredraw = true -- faster scrolling
vim.o.termguicolors = true -- enable 24-bit colors
vim.o.history = 10000 -- keep last 10k commands run
vim.o.synmaxcol = 240 -- don't syntax highlight 240+ char lines
vim.o.number = true -- numbered lines
vim.o.signcolumn = "yes" -- always draw the signcolumn

-- Text defaults
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.smartindent = true -- auto-indent new lines
vim.o.shiftwidth = 4 -- number of cols to make up 1 tab
vim.o.tabstop = 4 -- 1 tab == 4 spaces

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)

vim.diagnostic.config({
	only_current_line = true,
	float = true,
}--[[@as vim.diagnostic.Opts]])

-- debloat unnecessary plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}
for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
