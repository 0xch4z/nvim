return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	cmd = "Yazi",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			"fo",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
	},
	---@type YaziConfig
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
	},
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		--
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1

		-- open Yazi on startup if no file was specified
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.argc() == 0 then
					vim.cmd("Yazi")
				end
			end,
		})
	end,
} --[[@as LazyPluginSpec]]
