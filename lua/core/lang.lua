-- Global registry for all languages.
local registry = {}

-- Language represents a language's editor configuration.
local Language = {}
Language.__index = Language

-- Create a new language configuration
function Language:new(name)
    local instance = {
        name = name,
        config = {
            -- Editor defaults
            expandtab = true,
            tabstop = 4,
            shiftwidth = 4,
            softtabstop = -1,
            textwidth = 0,
            wrap = true,
            linebreak = true,
            autoindent = true,
            smartindent = true,
        },
        keymaps = {},
        autocmds = {},
    }

    setmetatable(instance, Language)
    return instance
end

-- spaces sets the number of spaces to indent.
function Language:spaces(n)
    self.config.expandtab = true
    self.config.tabstop = n
    self.config.shiftwidth = n
    self.config.softtabstop = -1
    return self
end

-- tabs sets the width of tabs to indent.
function Language:tabs(n)
    n = n or 4
    self.config.expandtab = false
    self.config.tabstop = n
    self.config.shiftwidth = n
    self.config.softtabstop = 0
    return self
end

-- width sets text width
function Language:width(n)
    self.config.textwidth = n
    return self
end

-- no_wrap disables line wrapping
function Language:no_wrap()
    self.config.wrap = false
    self.config.linebreak = false
    return self
end

-- hard_wrap breaks a line after the n-th character
function Language:hard_wrap(n)
    self.config.textwidth = n or 80
    self.config.wrap = true
    self.config.linebreak = true
    return self
end

-- preserve_indent auto indents on new lines
function Language:preserve_indent()
    self.config.autoindent = true
    self.config.smartindent = true
    return self
end

-- no_auto_indent does not auto indent on new lines
function Language:no_auto_indent()
    self.config.autoindent = false
    self.config.smartindent = false
    self.config.cindent = false
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

-- adds an autocmd for this language
function Language:autocmd(event, callback, desc)
    table.insert(self.autocmds, {
        event = event,
        callback = callback,
        desc = desc,
    })
    return self
end

function Language:on_save(callback, desc)
    return self:autocmd('BufWritePre', callback, desc or 'On save')
end

function Language:on_enter(callback, desc)
    return self:autocmd('BufEnter', callback, desc or 'On buffer enter')
end

-- Register this language configuration
function Language:register()
    registry[self.name] = self
    self:_apply_configuration()
    return self
end

-- Internal: Apply the configuration to Neovim
function Language:_apply_configuration()
    local augroup = vim.api.nvim_create_augroup('Language_' .. self.name, { clear = true })

    -- Apply editor settings on FileType
    vim.api.nvim_create_autocmd('FileType', {
        pattern = self.name,
        group = augroup,
        callback = function(event)
            local buf = event.buf

            -- Check if EditorConfig is present
            local editorconfig_root = vim.fs.find('.editorconfig', {
                upward = true,
                path = vim.fn.expand('%:p:h'),
                type = 'file'
            })[1]

            -- Only apply if no .editorconfig found
            if not editorconfig_root then
                for option, value in pairs(self.config) do
                    if type(value) ~= 'table' then
                        vim.api.nvim_set_option_value(option, value, { buf = buf })
                    end
                end
            end

            -- Apply keymaps (always, regardless of editorconfig)
            for _, keymap in ipairs(self.keymaps) do
                vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, {
                    buffer = buf,
                    desc = keymap.desc,
                    silent = true,
                })
            end
        end,
    })

    -- Apply custom autocmds
    for _, autocmd in ipairs(self.autocmds) do
        vim.api.nvim_create_autocmd(autocmd.event, {
            pattern = self.name,
            group = augroup,
            callback = autocmd.callback,
            desc = autocmd.desc,
        })
    end
end

-- Static method: Create and immediately register a language
function Language.register(name)
    return Language:new(name)
end

-- Static method: Get registered language
function Language.get(name)
    return registry[name]
end

-- Static method: Get all registered languages
function Language.all()
    return registry
end

-- Module exports
return Language
