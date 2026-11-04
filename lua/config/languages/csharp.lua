local Language = require("core.language")

local function nearest(start, ext)
	local match = vim.fs.find(function(name)
		return name:sub(-#ext) == ext
	end, { upward = true, path = start, type = "file" })[1]

	return match and vim.fs.dirname(match) or nil
end

---@param bufnr integer
---@param on_dir fun(dir: string?)
local function find_root(bufnr, on_dir)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return
	end

	local start = vim.fs.dirname(name)
	on_dir(nearest(start, ".sln") or nearest(start, ".csproj") or vim.fs.root(bufnr, { ".git" }))
end

Language.new("csharp")
	:filetypes("cs")
	:server("roslyn", {
		cmd = {
			"Microsoft.CodeAnalysis.LanguageServer",
			"--stdio",
			"--autoLoadProjects",
			"--logLevel=Information",
		},
		root_dir = find_root,
	})
	:spaces(4)
	:width(120)
	:preserve_indent()
	:register()
