local log = require("core.logger").new("lang")

local registry = {}

local BUFFER_OPTS = {
    "expandtab",
    "tabstop",
    "shiftwidth",
    "softtabstop",
    "textwidth",
    "autoindent",
    "smartindent",
    "cindent"
}

local WINDOW_OPTS = {
	"colorcolumn",
    "linebreak",
    "wrap"
}

-- Language represents a language's editor configuration.
local Language = {}
Language.__index = Language

-- new creates a new Language instance.
function Language:new_with_defaults(name)
    local instance = {
        name = name,
        config = {
            editor = {
                expandtab = true,
                tabstop = 4,
                shiftwidth = 4,
                softtabstop = -1,
                textwidth = 80,
                colorcolumn = 80,
                wrap = true,
                linebreak = true,
                autoindent = true,
                smartindent = true,
            }
        },
        keymaps = {},
        autocmds = {},
    }

    setmetatable(instance, Language)
    return instance
end

-- spaces sets the number of spaces to indent.
function Language:spaces(n)
    self.config.editor.expandtab = true
    self.config.editor.tabstop = n
    self.config.editor.shiftwidth = n
    self.config.editor.softtabstop = -1
    return self
end

-- tabs sets the width of tabs to indent.
function Language:tabs(n)
    n = n or 4
    self.config.editor.expandtab = false
    self.config.editor.tabstop = n
    self.config.editor.shiftwidth = n
    self.config.editor.softtabstop = 0
    return self
end

-- width sets text width
function Language:width(n)
    self.config.editor.textwidth = n
	self.config.editor.colorcolumn = tostring(n)
    return self
end

-- no_wrap disables line wrapping
function Language:no_wrap()
    self.config.editor.wrap = false
    self.config.editor.linebreak = false
    return self
end

-- hard_wrap breaks a line after the n-th character
function Language:hard_wrap(n)
	self:width(n or 80)
    self.config.editor.wrap = true
    self.config.editor.linebreak = true
    return self
end

-- preserve_indent auto indents on new lines
function Language:preserve_indent()
    self.config.editor.autoindent = true
    self.config.editor.smartindent = true
    return self
end

-- no_auto_indent does not auto indent on new lines
function Language:no_auto_indent()
    self.config.editor.autoindent = false
    self.config.editor.smartindent = false
    self.config.editor.cindent = false
    return self
end

-- debug sets the debug cmd
function Language:debug(cmd, desc)
    return self:keymap('<leader>d', cmd, desc or 'Debug')
end

-- run sets the run cmd
function Language:run(cmd, desc)
    return self:keymap('<leader>r', cmd, desc or 'Run')
end

-- test sets the test cmd
function Language:test(cmd, desc)
    return self:keymap('<leader>t', cmd, desc or 'Test')
end

-- build sets the build cmd
function Language:build(cmd, desc)
    return self:keymap('<leader>b', cmd, desc or 'Build')
end

-- format sets the format cmd
function Language:format(cmd, desc)
    return self:keymap('<leader>f', cmd, desc or 'Format')
end

-- repl sets the repl cmd
function Language:repl(cmd, desc)
    return self:keymap('<leader>i', cmd, desc or 'REPL')
end

-- keymap sets the custom keymaps for the language
function Language:keymap(lhs, rhs, desc, mode)
    table.insert(self.keymaps, {
        mode = mode or 'n',
        lhs = lhs,
        rhs = rhs,
        desc = desc,
    })
    return self
end

-- autocmd registers an autocmd for this language
function Language:autocmd(event, callback, desc)
    table.insert(self.autocmds, {
        event = event,
        callback = callback,
        desc = desc,
    })
    return self
end

-- on_save registers an on_save autocmd
function Language:on_save(callback, desc)
    return self:autocmd('BufWritePre', callback, desc or 'On save')
end

-- on_enter registers an on_enter autocmd
function Language:on_enter(callback, desc)
    return self:autocmd('BufEnter', callback, desc or 'On buffer enter')
end

-- register registers this language configuration
function Language:register()
    registry[self.name] = self
    self:_apply_configuration()
    return self
end

-- _apply_configuration applied the language's editor settings and keybinds
-- to the given open buffer.
function Language:_apply_configuration()
    local augroup = vim.api.nvim_create_augroup('lang::' .. self.name, { clear = true })

    -- add root autocmd for filetype
    vim.api.nvim_create_autocmd('FileType', {
        pattern = self.name,
        group = augroup,
        callback = function(event)
            local buf = event.buf

			log:trace("adjusting editor settings for %s (buffer:)", self.name)

            -- if editorconfig is present in the root directory, we'll use that
            -- instead of the language's default editor settings.
            local editorconfig_root = vim.fs.find('.editorconfig', {
                upward = true,
                path = vim.fn.expand('%:p:h'), -- current file dir
                type = 'file'
            })[1]

            if not editorconfig_root then
                -- not editorconfig found, use language default editor settings
                for _, option in ipairs(BUFFER_OPTS) do
                    local value = self.config.editor[option]
                    if type(value) ~= nil then
                        vim.api.nvim_set_option_value(option, value, { buf = buf })
                    end
                end

                -- NB: wrap, linebreak, etc. cannot be scoped to a buffer
                for _, option in ipairs(WINDOW_OPTS) do
                    local value = self.config.editor[option]
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

-- register creates and registers the language
function Language.new(name)
    return Language:new_with_defaults(name)
end

-- get returns a registered language by name
function Language.get(name)
    return registry[name]
end

-- all returns all registered languages.
function Language.all()
    return registry
end

return Language
