---@type LazyPluginSpec
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	---@type tokyonight.Config
	opts = {
		style = "moon",
		light_style = "day",
		transparent = true,
		terminal_colors = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		day_brightness = 0.3,
		dim_inactive = false,
		lualine_bold = true,

		on_colors = function(_) end,

		---@param highlights tokyonight.Highlights
		---@param colors ColorScheme
		on_highlights = function(highlights, colors)
			--See: https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups/base.lua
			highlights.LineNr = { fg = "#9999c1" }
			highlights.CursorLineNr = { fg = "#008b8b" }
			highlights.StatusLine = { fg = "#ffffe4", bg = "#008b8b", blend = 80 }
			highlights.WinBar = { bg = colors.none }
			highlights.Normal = { bg = colors.none, fg = "#ffffe4" }
			highlights.NormalNC = { bg = colors.none }
			highlights.Float = { bg = colors.bg_dark1 }
		end,
		cache = true,
		plugins = { all = false },
	},
	init = function()
		vim.cmd([[colorscheme tokyonight-moon]])
		vim.cmd([[hi Normal guibg=None ctermbg=None]])

		vim.cmd([[hi clear SignColumn]])
		vim.cmd([[hi SignColumn guifg=hotpink]])
	end,
}
