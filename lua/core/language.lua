local lsp = require("core.lsp")

---@class LanguageEditorConfig
---@field expandtab? boolean
---@field tabstop? integer
---@field shiftwidth? integer
---@field softtabstop? integer
---@field textwidth? integer
---@field colorcolumn? string
---@field wrap? boolean
---@field linebreak? boolean
---@field autoindent? boolean
---@field smartindent? boolean
---@field cindent? boolean

---@class Language
---@field name string name of the language
---@field autocmds table<string> TODO
---@field editor LanguageEditorConfig editor config overrides for the language
---@field filetypes table<string> filetypes associated with the language
---@field plugins table<LazyPluginSpec> language specific plugins to load
---@field keymaps table<string> TODO
---@field servers table<string, ServerConfig> language server configurations
---@field lazy_servers table<string, fun():ServerConfig> language server configured on ft
local Language = {}
Language.__index = Language

---@type table<string, Language>
local registry = {}

local BUFFER_OPTS = {
	"expandtab",
	"tabstop",
	"shiftwidth",
	"softtabstop",
	"textwidth",
	"autoindent",
	"smartindent",
	"cindent",
}

local WINDOW_OPTS = {
	"colorcolumn",
	"linebreak",
	"wrap",
}

---@param name string Name of the language
---@return Language
function Language.new(name)
	local lang =
		---@type Language
		{
			name = name,

			autocmds = {},

			editor = {},

			-- default to the name of the language as a filetype.
			-- can be overriden with :filetypes(...)
			filetypes = { name },

			keymaps = {},

			plugins = {},
			servers = {},
			lazy_servers = {},
		}

	setmetatable(lang, Language)
	return lang
end

---@class ServerConfig : vim.lsp.ClientConfig

---@param ... string filetypes to associate with this language
---@return Language
function Language:filetypes(...)
	self.filetypes = arg
	return self
end

---@param name string name of the lsp configuration
---@param config ServerConfig|fun():ServerConfig lsp configuration
---@return Language
function Language:server(name, config)
	if type(config) == "function" then
		self.lazy_servers[name] = config
	else
		self.servers[name] = config
	end

	return self
end

---@param n integer number of specs to indent
function Language:spaces(n)
	self.editor.expandtab = true
	self.editor.tabstop = n
	self.editor.shiftwidth = n
	self.editor.softtabstop = -1
	return self
end

---@param n integer number of spaces to represent a tab
function Language:tabs(n)
	n = n or 4
	self.editor.expandtab = false
	self.editor.tabstop = n
	self.editor.shiftwidth = n
	self.editor.softtabstop = 0
	return self
end

function Language:preserve_indent()
	self.editor.autoindent = true
	self.editor.smartindent = true
	return self
end

function Language:no_auto_indent()
	self.editor.autoindent = false
	self.editor.smartindent = false
	self.editor.cindent = false
	return self
end

---@param n integer number of columns for language
function Language:width(n)
	self.editor.textwidth = n
	self.editor.colorcolumn = tostring(n)
	return self
end

---@param n integer number of lines to wrap at
function Language:hard_wrap(n)
	self:width(n or 80)
	self.editor.wrap = true
	self.editor.linebreak = true
	return self
end

---@param name string
---@param config ServerConfig
function Language:_setup_server(name, config)
	-- wrap cmd as a table
	if type(config.cmd) == "string" then
		config.cmd = { config.cmd }
	end

	-- default lsp config filetypes to all defined for the language
	if config.filetypes == nil then
		config.filetypes = self.filetypes
	end

	-- .git is probably a sane default top-level root marker
	if config.root_markers == nil then
		config.root_markers = { ".git" }
	end

	if config.capabilities == nil then
		config.capabilities = lsp.default_capabilities({})
	end

	vim.lsp.config[name] = config
	vim.lsp.enable(name)
end

function Language:_setup_servers()
	for server, config in pairs(self.servers) do
		self:_setup_server(server, config)
		self.servers[server] = nil
	end
end

function Language:_setup_lazy_servers()
	for server, config_fn in pairs(self.lazy_servers) do
		self:_setup_server(server, config_fn())
		self.lazy_servers[server] = nil

		vim.notify("configured lazy lsp " .. server, vim.log.levels.INFO)
	end
end

function Language:_setup_augroup()
	local augroup = vim.api.nvim_create_augroup("lang::" .. self.name, { clear = true })

	-- add root autocmd for filetype
	vim.api.nvim_create_autocmd("FileType", {
		pattern = self.filetypes,
		group = augroup,
		callback = function(event)
			local buf = event.buf

			-- Is there an editorconfig in the root of this workspace?
			local editorconfig_root = vim.fs.find(".editorconfig", {
				upward = true,
				path = vim.fn.expand("%:p:h"), -- current file dir
				type = "file",
			})[1]

			-- if editorconfig is present in the root directory, we'll use that
			-- instead of the language's default editor settings. Otherwise we
			-- apply to buffer/window.
			if not editorconfig_root then
				-- not editorconfig found, use language default editor settings
				for _, option in ipairs(BUFFER_OPTS) do
					local value = self.editor[option]
					if type(value) ~= nil then
						vim.api.nvim_set_option_value(option, value, { buf = buf })
					end
				end

				-- NB: wrap, linebreak, etc. cannot be scoped to a buffer
				for _, option in ipairs(WINDOW_OPTS) do
					local value = self.editor[option]
					if type(value) ~= nil then
						vim.api.nvim_set_option_value(option, value, {})
					end
				end
			end

			-- apply language-specific keymaps
			for _, keymap in ipairs(self.keymaps) do
				vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, {
					buffer = buf,
					desc = keymap.desc,
					silent = true,
				})
			end

			self:_setup_lazy_servers()
		end,
	})

	-- register any additional language autocmds
	for _, autocmd in ipairs(self.autocmds) do
		vim.api.nvim_create_autocmd(autocmd.event, {
			pattern = self.name,
			group = augroup,
			callback = autocmd.callback,
			desc = autocmd.desc,
		})
	end
end

---@param spec LazyPluginSpec
function Language:plugin(spec)
	if spec.ft == nil then
		spec.ft = self.filetypes
	end

	table.insert(self.plugins, spec)
end

function Language:init()
	self:_setup_servers()
	self:_setup_augroup()
end

function Language:register()
	registry[self.name] = self
end

--@return table<string, Language>
function Language.all()
	return registry
end

return Language
