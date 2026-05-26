return {
	"Bekaboo/dropbar.nvim",
	lazy = false,
	config = function()
		local dropbar = require("dropbar")
		local sources = require("dropbar.sources")
		local utils = require("dropbar.utils")

		dropbar.setup({
			sources = function(buf, _)
				if vim.bo[buf].ft == "markdown" then
					return {
						sources.markdown,
					}
				end
				if vim.bo[buf].buftype == "terminal" then
					return {
						sources.terminal,
					}
				end
				return {
					utils.source.fallback({
						sources.lsp,
						sources.treesitter,
					}),
				}
			end,
		})
	end,
	keys = {
		{
			"<leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick breadcrumb",
		},
	},
} --[[@as LazyPluginSpec]]
