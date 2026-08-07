local Language = require("core.language")

local function project_python(root_dir)
	if not root_dir then
		return nil
	end

	local python = vim.fs.joinpath(root_dir, ".venv", "bin", "python")
	if vim.fn.executable(python) == 1 then
		return python
	end

	return nil
end

Language.new("python")
	:server("pyright", {
		cmd = { "pyright-langserver", "--stdio" },
		root_markers = {
			"pyrightconfig.json",
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		},
		before_init = function(_, config)
			local python = project_python(config.root_dir)
			if python then
				config.settings.python.pythonPath = python
			end
		end,
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
				},
			},
		},
	})
	:formatters("ruff_format")
	:spaces(4)
	:register()
