local completion = {}

local util = require("plugins.util")
local load = util.load

completion["neovim/nvim-lspconfig"] = {
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
        { "ray-x/lsp_signature.nvim" },
        {
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            config = load("plugins.configs.completion.null-ls"),
        },
    },
    config = load("plugins.configs.completion.nvim-lspconfig"),
}

completion["hrsh7th/nvim-cmp"] = {
    lazy = true,
    event = "InsertEnter",
    dependencies = {
        { "L3MON4D3/LuaSnip" },
        { "saadparwaiz1/cmp_luasnip" },
        { "rafamadriz/friendly-snippets" },
        { "onsails/lspkind.nvim" },
        { "hrsh7th/cmp-nvim-lsp" }, -- Comp. for LSP
        { "hrsh7th/cmp-buffer" }, -- Comp. for text in buffer
        { "hrsh7th/cmp-path" },
        { "f3fora/cmp-spell" },
        { "onsails/lspkind.nvim" },
        { "ray-x/cmp-treesitter" },
    },
    config = load("plugins.configs.completion.nvim-cmp"),
}

return completion
