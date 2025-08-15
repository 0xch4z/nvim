local Language = require("core.language")

Language.new("terraform")
	:server("terraformls", --[[@type vim.lsp.ClientConfig]] {
		cmd = { "terraform-ls" },
		root_markers = { ".terraform", ".git" },
	})
	:spaces(2)
	:register()
