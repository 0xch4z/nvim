local lang_configs = {
    javascript = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    typescript = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    javascriptreact = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    typescriptreact = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    html = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    css = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    scss = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    json = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    yaml = { expandtab = true, tabstop = 2, shiftwidth = 2 },

    terraform = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    hcl = { expandtab = true, tabstop = 2, shiftwidth = 2 },

    lua = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    vim = { expandtab = true, tabstop = 2, shiftwidth = 2 },

    python = { expandtab = true, tabstop = 4, shiftwidth = 4 },
    rust = { expandtab = true, tabstop = 4, shiftwidth = 4 },
    go = { expandtab = false, tabstop = 4, shiftwidth = 4 },

    c = { expandtab = true, tabstop = 4, shiftwidth = 4 },
    cpp = { expandtab = true, tabstop = 4, shiftwidth = 4 },

    -- Markup
    markdown = { expandtab = true, tabstop = 2, shiftwidth = 2 },
    xml = { expandtab = true, tabstop = 2, shiftwidth = 2 },
}

local function set_lang_defaults()
    local ft = vim.bo.filetype
    local config = lang_configs[ft]

    if config then
        -- Only set if EditorConfig hasn't already set these values
        -- Check if we're in a project with .editorconfig by looking for the root
        local editorconfig_root = vim.fs.find('.editorconfig', {
            upward = true,
            path = vim.fn.expand('%:p:h'),
            type = 'file'
        })[1]

        -- If no .editorconfig found, apply our defaults
        if not editorconfig_root then
            for option, value in pairs(config) do
                vim.bo[option] = value
            end
        end
    end
end

local augroup = vim.api.nvim_create_augroup("LanguageDefaults", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "*",
    callback = set_lang_defaults,
});
