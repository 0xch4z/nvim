---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		notifier = { enabled = true },
		picker = { enabled = true },
	},
	keys = {
		{
			"fF",
			function()
				require("snacks").picker.files()
			end,
			desc = "find: files",
		},
		{
			"fg",
			function()
				require("snacks").picker.grep()
			end,
			desc = "find: grep",
		},
		{
			"fw",
			mode = { "n", "x" },
			function()
				require("snacks").picker.grep_word()
			end,
			desc = "find: word under cursor",
		},
		{
			"fb",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "find: buffers",
		},
		{
			"fs",
			function()
				require("snacks").picker.lsp_symbols()
			end,
			desc = "find: document symbols",
		},
		{
			"fS",
			function()
				require("snacks").picker.lsp_workspace_symbols()
			end,
			desc = "find: workspace symbols",
		},
		{
			"fd",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "find: diagnostics",
		},
		{
			"fh",
			function()
				require("snacks").picker.help()
			end,
			desc = "find: help",
		},
		{
			"fr",
			function()
				require("snacks").picker.resume()
			end,
			desc = "find: resume",
		},
	},
}
