---@type LazyPluginSpec
return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		local linters_by_ft = {
			go = { "golangcilint" },
			lua = { "luacheck" },
		}

		local group = vim.api.nvim_create_augroup("LintOnSave", { clear = true })
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = group,
			callback = function()
				if linters_by_ft[vim.bo.filetype] ~= nil then
					require("lint").try_lint()
				end
			end,
		})
	end,
}
