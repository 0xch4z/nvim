return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			go = { "gofmt" },
			lua = { "stylua" },
			nix = { "nixfmt" },
			terraform = { "terraform_fmt" },
		},
		format_after_save = {
			async = true,
			timeout_ms = 500,
		},
	},
}--[[@as LazyPluginSpec]]
