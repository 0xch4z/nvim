local Language = require("core.language")

Language.new("lua")
    :server("luals", {
        cmd = { "lua-language-server" },
    })
    :tabs(4)
    :register()
