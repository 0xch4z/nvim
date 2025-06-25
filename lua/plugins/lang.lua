local lang = {}
local util = require("plugins.util")
local load = util.load

lang["saecki/crates.nvim"] = {
    event = { "InsertEnter Cargo.toml" },
    config = load("plugins.configs.lang.crates"),
}

lang["someone-stole-my-name/yaml-companion.nvim"] = {
    config = load("plugins.configs.lang.yaml-companion"),
    dependencies = {
        { "neovim/nvim-lspconfig" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
    },
}

lang["jglasovic/venv-lsp.nvim"] = {
    config = load("plugins.configs.lang.venv-lsp")
}

return lang
