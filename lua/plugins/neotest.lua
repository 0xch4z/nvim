return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/nvim-nio",
		"fredrikaverpil/neotest-golang",
		"rouge8/neotest-rust",
		"BodneyC/neotest-bats",
		"nvim-neotest/neotest-python",
	},
	ft = { "go", "rust", "bats", "python" },
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
		{
			"<leader>ts",
			function()
				require("neotest").run.stop()
			end,
			desc = "test: stop",
		},
		{
			"<leader>to",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "test: toggle output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "test: toggle outline",
		},
	},
	config = function()
		local neotest = require("neotest")
		local function project_python(root)
			local python = vim.fs.joinpath(root, ".venv", "bin", "python")
			if vim.fn.executable(python) == 1 then
				return python
			end

			return "python3"
		end

		neotest.setup({
			adapters = {
				require("neotest-golang")({
					go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
				}),
				require("neotest-rust"),
				require("neotest-bats").setup({}),
				require("neotest-python")({
					python = project_python,
					runner = "pytest",
					pytest_discover_instances = true,
				}),
			},
			discovery = {
				enable = true,
			},
			log_level = vim.log.levels.WARN,
		})
	end,
} --[[@as LazyPluginSpec]]
