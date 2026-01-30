return {
	"yetone/avante.nvim",
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false,

	---@type avante.Config
	---@diagnostic disable-next-line: missing-fields
	opts = {
		provider = "codex",
		auto_suggestions_provider = nil,

		behaviour = {
			auto_suggestions = false,
			auto_focus_sidebar = true,
			auto_apply_diff_after_generation = false,
			auto_approve_tool_permissions = true,
			jump_result_buffer_on_finish = false,
			auto_set_keymaps = true,
			auto_set_highlight_group = true,
			acp_follow_agent_locations = true,
			enable_token_counting = true,
			minimize_diff = true,
			auto_add_current_file = true,
		},

		acp_providers = {
			codex = {
				command = "npx",
				args = { "-y", "-g", "@zed-industries/codex-acp" },
				env = vim.tbl_extend("force", vim.env, {
					NODE_NO_WARNINGS = "1",
					OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
				}),
			},
		},

		providers = {},
		mode = "agentic",
		tokenizer = "tiktoken",

		selection = {
			enabled = true,
			hint_display = "delayed",
		},

		repo_map = {
			ignore_patterns = { "%.git", "node_modules", "__pycache__", "%.worktree" },
		},

		rules = {
			project_dir = nil, -- auto-detect project root
			global_dir = nil,
		},

		history = {
			max_tokens = 4096,
			carried_entry_count = nil,
		},

		prompt_logger = {
			enabled = true,
			log_dir = vim.fn.stdpath("cache"),
			max_entries = 100,
		},
	},

	keys = {
		{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante: ask", mode = { "n", "t" } },
		{ "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante: chat", mode = { "n", "t" } },
		{ "<leader>aC", "<cmd>AvanteChatNew<cr>", desc = "Avante: new chat", mode = { "n", "t" } },
		{ "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "Avante: history", mode = { "n", "t" } },
		{ "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Avante: focus", mode = { "n", "t" } },
		{ "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante: refresh", mode = { "n", "t" } },
		{ "<leader>am", "<cmd>AvanteModels<cr>", desc = "Avante: models", mode = { "n", "t" } },
		{ "<leader>aR", "<cmd>AvanteShowRepoMap<cr>", desc = "Avante: repo map", mode = { "n", "t" } },
		{ "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Avante: edit", mode = { "n", "v" } },
		{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: toggle", mode = { "n", "t" } },
		{ "<leader>aS", "<cmd>AvanteStop<cr>", desc = "Avante: stop", mode = { "n", "t" } },
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-mini/mini.pick",
		"ibhagwan/fzf-lua",
		"nvim-telescope/telescope.nvim",
		"stevearc/dressing.nvim",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "Avante" },
			opts = { file_types = { "markdown", "Avante" } },
		},
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
		},
	},
}--[[@as LazyPluginSpec]]
