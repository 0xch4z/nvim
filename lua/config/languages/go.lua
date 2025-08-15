local Language = require("core.language")

Language.new("go")
	:server("gopls", {
		cmd = { "gopls" },
	})
	:tabs(4)
	:width(120)
	:preserve_indent()
	:register()
