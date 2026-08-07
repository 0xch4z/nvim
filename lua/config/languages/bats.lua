local Language = require("core.language")

Language.new("bats")
	:filetypes("bats")
	:server("bashls", {
		cmd = { "bash-language-server", "start" },
		settings = {
			bashIde = {
				shellcheckPath = "",
			},
		},
	})
	:spaces(2)
	:register()
