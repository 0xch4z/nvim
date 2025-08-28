local Language = require("core.language")

Language.new("rust")
	:server("rust_analyzer", {
		cmd = { "rust-analyzer" },
	})
	:tabs(4)
	:width(120)
	:preserve_indent()
	:register()
