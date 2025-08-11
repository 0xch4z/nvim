local Language = require("core.language")

Language.new("nix")
	:server("nixd", {
		cmd = { "nixd" },
	})
	:spaces(2)
	:width(120)
	:preserve_indent()
	:register()
