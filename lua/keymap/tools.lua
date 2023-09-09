local map = require("keymap.map")
local cmd = map.cmd

local mappings = {
    -- Config
    ["n|<leader>vrc"] = cmd("tabedit ~/.config/nvim/lua/"):noremap():desc("config: edit"),
    ["n|<leader>src"] = cmd("luafile ~/.config/nvim/init.lua"):noremap():desc("config: reload"),
    -- File + Buffer operations
    ["n|<leader>fo"] = cmd("lua require'lir.float'.toggle()"):noremap():desc(),
    ["n|<leader>ff"] = cmd("Telescope find_files"):noremap():desc("file: find"),
    ["n|<leader>fg"] = cmd("Telescope live_grep"):noremap():desc("file: live grep"),
    ["n|<leader>bf"] = cmd("Telescope buffers"):noremap():desc("buffer: find"),
    -- Diagnostics
    ["n|<leader>de"] = cmd("TroubleToggle"):noremap():desc("diag: errors"),
    ["n|<leader>ds"] = cmd("SymbolsOutline"):noremap():desc("diag: symbol outline"),
    ["n|<leader>vb"] = cmd("Gitsigns blame_line"):noremap():desc("git: blame line"),
    ["n|<leader>vd"] = cmd("Gitsigns toggle_deleted"):noremap():desc("git: show deleted"),
    -- Debugging
    ["n|<leader>du"] = cmd("lua require'dapui'.toggle()"):desc("debug: toggle ui"),
    ["n|<leader>dz"] = cmd("lua require'dapui'.open({reset = true})"):desc("debug: reset ui"),
    ["n|<leader>dr"] = cmd("DapToggleRepl"):desc("debug: toggle repl"),
    ["n|<leader>db"] = cmd("DapToggleBreakpoint"):desc("debug: toggle breakpoint"),
    ["n|<leader>dc"] = cmd("DapContinue"):desc("debug: continue"),
    ["n|<leader>do"] = cmd("DapStepOut"):desc("debug: step out"),
    ["n|<leader>di"] = cmd("DapStepInto"):desc("debug: step into"),
    ["n|<leader>dl"] = cmd("DapShowLog"):desc("debug: show logs"),
    -- Testing
    ["n|<leader>ts"] = cmd("TestSuite"):noremap():desc("test: run suite"),
    ["n|<leader>tf"] = cmd("TestFile"):noremap():desc("test: run file"),
    ["n|<leader>tt"] = cmd("TestNearest"):noremap():desc("test: run nearest"),
    ["n|<leader>tr"] = cmd("TestLast"):noremap():desc("test: rerun"),
    -- Note taking
    ["n|<leader>mm"] = cmd("MindOpenMain"):noremap():desc("mind: open main"),
    ["n|<leader>mp"] = cmd("MindOpenProject"):noremap():desc("mind: open project"),
    -- Misc
    ["n|<leader>mv"] = cmd("Glow"):noremap():desc("markdown: preview")
}

map.register_keys(mappings)
