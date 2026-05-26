return {
	"stevearc/quicker.nvim",
	event = "FileType qf",
	keys = {
		{
			"<leader>q",
			function()
				if require("quicker").is_open() then
					local qf_win = vim.fn.getqflist({ winid = 0 }).winid
					if qf_win ~= 0 and vim.api.nvim_get_current_win() ~= qf_win then
						vim.api.nvim_set_current_win(qf_win)
						return
					end
				end
				require("quicker").toggle()
			end,
			desc = "Toggle/focus quickfix",
		},
		{
			"<leader>l",
			function()
				require("quicker").toggle({ loclist = true })
			end,
			desc = "Toggle loclist",
		},
	},
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {
		keys = {
			{
				">",
				function()
					require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
				end,
				desc = "Expand quickfix context",
			},
			{
				"<",
				function()
					require("quicker").collapse()
				end,
				desc = "Collapse quickfix context",
			},
		},
	},
} --[[@as LazyPluginSpec]]
