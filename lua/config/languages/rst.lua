local Language = require("core.language")

Language.new("rst")
	:filetypes("rst", "restructuredtext")
	:server("esbonio", {
		cmd = { "esbonio" },
	})
	:spaces(2)
	:hard_wrap(80)
	:register()
