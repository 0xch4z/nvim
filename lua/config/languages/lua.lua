local Language = require("core.language")

Language.new("lua")
  :server("luals", {
    cmd = { "lua-language-server" }
  })
  :spaces(2)
  :register()
