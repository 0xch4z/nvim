local Language = require("core.language")

Language.new("terraform")
	:server("terraformls", {
		cmd = { "terraform-ls", "serve" },
		root_markers = { ".terraform", ".git" },
	})
	:spaces(2)
	:register()
