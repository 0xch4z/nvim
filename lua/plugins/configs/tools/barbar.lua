local barbar = require("barbar")

barbar.setup({
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        tabpages = true,
    },
})
