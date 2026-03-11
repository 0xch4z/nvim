---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		notifier = { enabled = true },
	},
}
