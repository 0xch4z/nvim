---@type LazyPluginSpec
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			go = { "golangcilint" },
			lua = { "luacheck" },
			python = { "ruff" },
		}

		local group = vim.api.nvim_create_augroup("LintOnSave", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = group,
			callback = function()
				if lint.linters_by_ft[vim.bo.filetype] ~= nil then
					lint.try_lint()
				end
			end,
		})
	end,
}
