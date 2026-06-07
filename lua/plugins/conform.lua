return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			c = { "clang-format", lsp_format = "fallback" },
			cpp = { "clang-format", lsp_format = "fallback" },
			go = { "gofmt", lsp_format = "fallback" },
			lua = { "stylua", lsp_format = "fallback" },
			nix = { "nixfmt", lsp_format = "fallback" },
			rust = { "rustfmt", lsp_format = "fallback" },
			terraform = { "terraform_fmt", lsp_format = "fallback" },
		},
		format_after_save = {
			async = true,
			timeout_ms = 500,
		},
	},
}--[[@as LazyPluginSpec]]
