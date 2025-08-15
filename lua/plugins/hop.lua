return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		keys = "etovxqpdygfblzhckisuran",
	},
	keys = {
		{
			",,",
			mode = { "n", "x", "o" },
			"<cmd>HopChar1<cr>",
			desc = "jump: character",
		},
		{
			",l",
			mode = { "n", "x", "o" },
			"<cmd>HopChar1CurrentLine<cr>",
			desc = "jump: character in-line",
		},
		{
			";;",
			mode = { "n", "x", "o" },
			"<cmd>HopWord<cr>",
			desc = "jump: word",
		},
		{
			";l",
			mode = { "n", "x", "o" },
			"<cmd>HopWordCurrentLine<cr>",
			desc = "jump: word in-line",
		},
	},
}--[[@as LazyPluginSpec]]
