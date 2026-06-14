local Language = require("core.language")

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = function()
		---@type conform.setupOpts
		return {
			formatters_by_ft = Language.formatters_by_ft(),
			format_after_save = {
				async = true,
				timeout_ms = 500,
			},
		}
	end,
}--[[@as LazyPluginSpec]]
