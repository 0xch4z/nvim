return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/nvim-nio",
		"fredrikaverpil/neotest-golang",
		"rouge8/neotest-rust",
	},
	ft = { "go", "rust" },
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run()
			end,
			desc = "test: nearest",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "test: file",
		},
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-golang")({
					go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
				}),
				require("neotest-rust"),
			},
			discovery = {
				enable = true,
			},
			log_level = vim.log.levels.WARN,
		})
	end,
} --[[@as LazyPluginSpec]]
