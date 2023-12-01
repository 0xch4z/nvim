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
    tag = "0.1.0",
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
    },
}

tools["kevinhwang91/nvim-bqf"] = {
    lazy = true,
    ft = "qf",
    config = load("plugins.configs.tools.bqf"),
}

tools["tamago324/lir.nvim"] = {
    config = load("plugins.configs.tools.lir"),
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
    config = load("plugins.configs.tools.persisted")
}

tools["ThePrimeagen/harpoon"] = {
    config = load("plugins.configs.tools.harpoon"),
}

tools["jinh0/eyeliner.nvim"] = {
    config = load("plugins.configs.tools.eyeliner")
}

return tools
