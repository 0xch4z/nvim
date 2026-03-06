---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	opts = {},
	config = function()
		local ts_path = vim.env.LOCAL_NVIM_TREESITTER_PATH
		if ts_path then
			vim.opt.rtp:prepend(ts_path)
		end
		vim.opt.foldenable = false
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end,
	keys = {},
}
