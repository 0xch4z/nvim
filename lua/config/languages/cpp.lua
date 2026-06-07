local Language = require("core.language")

Language.new("cpp")
	:filetypes("c", "cpp", "objc", "objcpp", "cuda")
	:server("clangd", {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders=1",
		},
		root_markers = {
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			".git",
		},
	})
	:spaces(4)
	:width(120)
	:preserve_indent()
	:register()
