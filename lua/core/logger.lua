local LOG_LEVELS = {
	TRACE = 1,
	DEBUG = 2,
	INFO = 3,
	WARN = 4,
	ERROR = 5
}

local ENV_LOG_LEVEL = os.getenv("NVIM_LOG_LEVEL") or "INFO"
local LOG_LEVEL = LOG_LEVELS[ENV_LOG_LEVEL] or LOG_LEVELS.INFO

local Logger = {}
Logger.__index = Logger

function Logger.new(namespace)
    return Logger:init(namespace)
end

function Logger:init(namespace)
	local instance = {
		namespace = namespace,
		console_level = "ERROR",
	}

	setmetatable(instance, self)
	return instance
end

function Logger:set_console_level(level)
	self.console_level = LOG_LEVELS[level] or LOG_LEVELS.INFO
	return self
end

function Logger:trace(message, ...) self:log("TRACE", message, ...) end
function Logger:debug(message, ...) self:log("DEBUG", message, ...) end
function Logger:info(message, ...)  self:log("INFO", message, ...) end
function Logger:warn(message, ...)  self:log("WARN", message, ...) end
function Logger:error(message, ...) self:log("ERROR", message, ...) end

function Logger:log(level, msg, ...)
	local leveln = LOG_LEVELS[level]

	if LOG_LEVEL > leveln then
		-- log level too high
		return
	end

	-- get namespace from options
    local ns = self.namespace or "default"

	local formatted_msg = string.format(msg, (... or {}))
	local timestamp = os.date("%H:%M:%S")
	local entry = string.format("[%s] [%s] %s: %s\n", timestamp, level, ns, formatted_msg)

	-- log to console?
	-- if LOG_LEVELS[self.console_level] <= leveln then
	-- 	self:_consolelog(entry)
	-- end

	self:_stdlog(level, entry, ns)
end

function Logger:_consolelog(entry)
	vim.cmd(string.format("echo '%s'", entry))
end

function Logger:_stdlog(level, entry, ns)
	vim.notify(entry, level, { title = ns })
end

return Logger
