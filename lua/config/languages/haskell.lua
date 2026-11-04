local Language = require("core.language")

Language.new("haskell")
	:filetypes("haskell", "lhaskell")
	:server("hls", {
		cmd = { "haskell-language-server-wrapper", "--lsp" },
		root_markers = { "hie.yaml", "cabal.project", "stack.yaml", "package.yaml", ".git" },
		settings = {
			haskell = {
				formattingProvider = "fourmolu",
			},
		},
	})
	:spaces(4)
	:width(120)
	:preserve_indent()
	:register()
