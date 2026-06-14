local Language = require("core.language")

Language.new("terraform")
	:server("terraformls", {
		cmd = { "terraform-ls", "serve" },
		root_markers = { ".terraform", ".git" },
	})
	:formatters("terraform_fmt")
	:spaces(2)
	:register()
