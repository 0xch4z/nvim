---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function(plugin)
		vim.opt.rtp:prepend(plugin.dir .. "/runtime")

		local ts_path = vim.env.LOCAL_NVIM_TREESITTER_PATH
		if ts_path then
			vim.opt.rtp:prepend(ts_path)
		end
		vim.opt.foldenable = false
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
	keys = {},
}
