local Language = require("core.language")
local lazy = require("core.lazy")

---@type table<LazySpec>
local language_plugins = {}

for _, lang in pairs(Language.all()) do
	-- setup language servers
	lang:init()

	-- accumulate language plugins
	if #lang.plugins > 0 then
		table.move(language_plugins, 1, #lang.plugins, #language_plugins + 1, lang.plugins)
	end
end

lazy.bootstrap(language_plugins)
