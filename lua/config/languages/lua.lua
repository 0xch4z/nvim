local Language = require("core.language")

Language.new("lua")
	:server("luals", {
		cmd = { "lua-language-server" },
		cmd_env = {
			VIMRUNTIME = vim.env.VIMRUNTIME,
		},
	})
	:tabs(4)
	:register()
