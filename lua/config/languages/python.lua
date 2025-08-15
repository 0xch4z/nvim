local Language = require("core.language")

Language.new("python")
	:server("pyright", {
		cmd = { "pyright-langserver", "--stdio" },
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
	})
	:tabs(4)
	:register()
