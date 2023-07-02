local ui = {}

local util = require("plugins.util")
local load = util.load

ui["embark-theme/vim"] = {
    config = load("plugins.configs.ui.embark"),
}

ui["mhinz/vim-startify"] = {
    config = load("plugins.configs.ui.vim-startify"),
}

ui["lewis6991/gitsigns.nvim"] = {
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = load("plugins.configs.ui.gitsigns"),
}

return ui
