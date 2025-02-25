local ui = {}

local util = require("plugins.util")
local load = util.load

ui["embark-theme/vim"] = {
    config = load("plugins.configs.ui.embark"),
}

-- ui["mhinz/vim-startify"] = {
--     config = load("plugins.configs.ui.vim-startify"),
-- }

ui["lewis6991/gitsigns.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = load("plugins.configs.ui.gitsigns"),
}

ui["https://git.sr.ht/~whynothugo/lsp_lines.nvim"] = {
    config = load("plugins.configs.ui.lsp-lines")
}

ui["j-hui/fidget.nvim"] = {
    config = load("plugins.configs.ui.fidget")
}

ui["eandrju/cellular-automaton.nvim"] = {}

return ui
