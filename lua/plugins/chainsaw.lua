---@type LazyPluginSpec
return {
	"0xch4z/chainsaw.nvim",
	lazy = false,
	dependencies = { "folke/snacks.nvim" },
	---@type chainsaw.Config
	opts = {
		notify = function(msg, level)
			Snacks.notify(msg, { level = level })
		end,
	},
}
