local Language = require("core.language")

Language.new("go")
	:server("gopls", {
		cmd = { "gopls" },
	})
	:formatters("gofmt")
	:tabs(4)
	:width(120)
	:preserve_indent()
	:register()
