local Language = require("core.language")

Language.new("bash")
	:filetypes("sh", "bash")
	:server("bashls", {
		cmd = { "bash-language-server", "start" },
	})
	:spaces(4)
	:register()
