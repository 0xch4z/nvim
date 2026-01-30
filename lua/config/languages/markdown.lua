local Language = require("core.language")

Language.new("markdown")
	:filetypes("markdown", "md", "mdx")
	:server("marksman", {
		cmd = { "marksman" },
	})
	:spaces(2)
	:hard_wrap(80)
	:register()
