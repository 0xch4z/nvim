local editor = {}

local util = require("plugins.util")
local load = util.load

-- Language/grammar syntax highlighting
editor["nvim-treesitter/nvim-treesitter"] = {
    lazy = true,
    event = { "BufReadPost" },
    dependencies = {
        { "abecodes/tabout.nvim" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "mfussenegger/nvim-treehopper" },
        { "andymass/vim-matchup" },
        {
            "windwp/nvim-ts-autotag",
            config = load("plugins.configs.editor.autotag"),
        },
        {
            "NvChad/nvim-colorizer.lua",
            config = load("plugins.configs.editor.colorizer"),
        },
        {
            "abecodes/tabout.nvim",
            config = load("plugins.configs.editor.tabout"),
        },
    },
    config = load("plugins.configs.editor.nvim-treesitter"),
}

-- Accelerates j/k keystrokes
editor["rainbowhxch/accelerated-jk.nvim"] = {
    lazy = true,
    event = "VeryLazy",
    config = load("plugins.configs.editor.accelerated-jk"),
}

-- Autocloses parenthesis, brackets and braces
editor["altermo/ultimate-autopair.nvim"] = {
    lazy = true,
    event = "InsertEnter",
    config = load("plugins.configs.editor.ultimate-autopair"),
}

-- Utility for quickly commenting/uncommenting code
editor["tpope/vim-commentary"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
}

-- Makes trailing whitespace shows up red
editor["ntpeters/vim-better-whitespace"] = {
    lazy = true,
    event = "InsertEnter",
}

-- Editorconfig respects editorconfig files
editor["gpanders/editorconfig.nvim"] = {}

-- File + symbol breadcrumbs
editor["Bekaboo/dropbar.nvim"] = {
    dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    },
    config = load("plugins.configs.editor.dropbar")
};

return editor
