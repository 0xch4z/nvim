local Language = require("core.language")

Language.new("makefile")
	:filetypes("make")
	:server("autotools_language_server", {
		cmd = { "autotools-language-server" },
		root_markers = { "Makefile", "makefile", "GNUmakefile", "configure.ac" },
	})
	:tabs(4)
	:register()
