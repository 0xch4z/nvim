return {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"esmuellert/codediff.nvim",
		"folke/snacks.nvim",
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
	},

	---@type NeogitConfig
	opts = {
		kind = "floating",
		popup = {
			kind = "floating",
		},
	},
} --[[@as LazyPluginSpec]]
