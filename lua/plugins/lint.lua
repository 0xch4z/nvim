---@type LazyPluginSpec
return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		local linters_by_ft = {
			go = { "golangcilint" },
			lua = { "luacheck" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				if linters_by_ft[vim.bo.filetype] ~= nil then
					require("lint").try_lint()
				end
			end,
		})
	end,
}
