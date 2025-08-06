local tools = {}
local util = require("plugins.util")
local load = util.load

tools["folke/which-key.nvim"] = {
    lazy = true,
    event = "VeryLazy",
}

tools["LeonHeidelbach/trailblazer.nvim"] = {
    lazy = true,
    config = load("plugins.configs.tools.trailblazer"),
    event = "VeryLazy",
}

tools["nvim-telescope/telescope.nvim"] = {
    tag = "0.1.8",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        {
            "nvim-telescope/telescope-frecency.nvim",
            dependencies = {
                { "kkharji/sqlite.lua" },
            },
        },
        { "debugloop/telescope-undo.nvim" },
        { "nvim-lua/popup.nvim" },
    },
    config = load("plugins.configs.tools.telescope"),
}

tools["folke/trouble.nvim"] = {
    lazy = true,
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    config = load("plugins.configs.tools.trouble"),
}

tools["ibhagwan/smartyank.nvim"] = {
    lazy = true,
    event = "BufReadPost",
}

tools["nvim-neotest/neotest"] = {
    config = load("plugins.configs.tools.neotest"),
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-go",
        "jfpedroza/neotest-elixir",
        "nvim-neotest/neotest-plenary",
        "nvim-neotest/nvim-nio",
    },
}

tools["tamago324/lir.nvim"] = {
    config = load("plugins.configs.tools.lir"),
}

tools["kevinhwang91/nvim-bqf"] = {
    lazy = true,
    ft = "qf",
    config = load("plugins.configs.tools.bqf"),
}

tools["phaazon/mind.nvim"] = {
    config = load("plugins.configs.tools.mind"),
}

tools["ellisonleao/glow.nvim"] = {
    config = load("plugins.configs.tools.glow"),
    cmd = { "Glow" },
}

tools["mrjones2014/smart-splits.nvim"] = {
    config = load("plugins.configs.tools.smart-splits"),
}

tools["williamboman/mason.nvim"] = {
    config = load("plugins.configs.tools.mason"),
}

tools["mfussenegger/nvim-dap"] = {
    config = load("plugins.configs.tools.nvim-dap"),
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "nvim-telescope/telescope-dap.nvim",
        "jbyuki/one-small-step-for-vimkind",
    },
}
tools["rcarriga/nvim-dap-ui"] = {
    event = "VeryLazy",
    config = function()
        require("dapui").setup()
    end,
}

tools["romgrk/barbar.nvim"] = {
    config = load("plugins.configs.tools.barbar"),
}

tools["olimorris/persisted.nvim"] = {
    config = load("plugins.configs.tools.persisted"),
}

tools["ThePrimeagen/harpoon"] = {
    config = load("plugins.configs.tools.harpoon"),
}

tools["jinh0/eyeliner.nvim"] = {
    config = load("plugins.configs.tools.eyeliner"),
}

tools["rmagatti/auto-session"] = {
    lazy = false,
    dependencies = {
        -- "nvim-telescope/telescope.nvim" -- maybe?
    },
    config = load("plugins.configs.tools.auto-session"),
}

tools["smoka7/hop.nvim"] = {
    tag = "v2.7.2",
    config = load("plugins.configs.tools.hop")
}

tools["zbirenbaum/copilot.lua"] = {
    cmd = "Copilot",
    event = "InsertEnter",
    config = load("plugins.configs.tools.copilot")
}

tools["yetone/avante.nvim"] = {
    tag = "v0.0.25",
    build = "make",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",         -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "stevearc/dressing.nvim",        -- for input provider dressing
        "folke/snacks.nvim",             -- for input provider snacks
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    config = load("plugins.configs.tools.avante")
}

return tools
