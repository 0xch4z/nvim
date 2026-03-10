-- Custom filetype detection rules
vim.filetype.add({
	pattern = {
		-- GitHub Actions workflows under .github/workflows
		[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
	},
})
