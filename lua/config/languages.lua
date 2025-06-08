local Language = require("core.lang")
local logger = require("core.logger").new("lua")

Language.new("lua")
    :spaces(4)
    :width(100)
    :register()

Language.new("go")
    :tabs(4)
    :preserve_indent()
    :width(100)
    :register()

Language.new("sh")
    :tabs(5)
    :preserve_indent()
    :width(100)
    :register()

