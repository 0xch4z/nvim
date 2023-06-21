local util = require("core.util")

local g, o, wo, bo, api = vim.g, vim.o, vim.wo, vim.bo, vim.api
local buffer = { o, bo }
local window = { o, wo }

-- TODO: maybe use updatetime (ms to wait for event trigger)

-- General
util.opt("swapfile", false)
util.opt("completeopt", "menu,menuone,noselect")

-- UI
util.opt("colorcolumn", "80") -- show line length market at pos 80
util.opt("lazyredraw", true) -- faster scrolling
util.opt("showmatch", true) -- highlight matching parenthesis
util.opt("termguicolors", true) -- enabled 24-bit RGB colors
util.opt("history", 100) -- keep last 100 lines of buffer in memory
util.opt("synmaxcol", 240) -- don't process syntax of 240+ char line
util.opt("signcolumn", "yes") -- allow signs alongside line numbers
util.opt("number", true) -- number lines
util.opt("clipboard", "unnamed") -- copy/paste with system pasteboard

-- Text
util.opt("expandtab", true) -- use spaces instead of tabs
util.opt("shiftwidth", 4) -- shift 4 spaces when tab
util.opt("tabstop", 4) -- default to 1 tab == 4 spaces
util.opt("smartindent", true) -- auto indent new lines

local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end
