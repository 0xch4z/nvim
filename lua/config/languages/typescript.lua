local Language = require("core.language")

Language.new("typescript")
	:filetypes("typescript", "typescriptreact", "javascript", "javascriptreact")
	:server("ts_ls", {
		cmd = { "typescript-language-server", "--stdio" },
		-- The server has no bundled tsserver; it resolves `typescript` from the
		-- nearest node_modules, so root on the package rather than the repo.
		root_markers = {
			"tsconfig.json",
			"jsconfig.json",
			"package.json",
			".git",
		},
		init_options = {
			hostInfo = "neovim",
		},
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "literals",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
				},
			},
		},
	})
	:spaces(2)
	:width(100)
	:preserve_indent()
	:register()
