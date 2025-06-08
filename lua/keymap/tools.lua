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
    ["n|<leader>de"] = cmd("Trouble diagnostics toggle"):noremap():desc("diag: show diagnostics"),
    ["n|<leader>dE"] = cmd("Trouble diagnostics toggle filter.buf=0")
        :noremap()
        :desc("diag: show diagnostics for buffer"),
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
    ["n|<leader>tt"] = cmd("lua require'neotest'.run.run()"):noremap():desc("test: run nearest"),
    ["n|<leader>tl"] = cmd("lua require'neotest'.run.run_last()"):noremap():desc("test: run last"),
    ["n|<leader>tj"] = cmd("lua require'neotest'.jump.prev()"):noremap():desc("test: jump-to last"),
    ["n|<leader>tf"] = cmd("lua require'neotest'.run.run(vim.fn.expand(\"%\"))"):noremap():desc("test: run file"),
    ["n|<leader>td"] = cmd("lua require'neotest'.run.run({strategy = \"dap\"})"):noremap():desc("test: rerun"),
    ["n|<leader>tO"] = cmd("lua require'neotest'.output_panel.toggle()"):noremap():desc("test: output"),
    ["n|<leader>to"] = cmd("lua require'neotest'.output.open()"):noremap():desc("test: output"),
    -- Note taking
    ["n|<leader>mm"] = cmd("MindOpenMain"):noremap():desc("mind: open main"),
    ["n|<leader>mp"] = cmd("MindOpenProject"):noremap():desc("mind: open project"),
    -- Misc
    ["n|<leader>mv"] = cmd("Glow"):noremap():desc("markdown: preview"),
    ["n|<leader>hh"] = cmd("lua require'harpoon.ui'.toggle_quick_menu()"):desc("harpoon: ui"),
    ["n|<leader>hm"] = cmd("lua require'harpoon.mark'.add_file()"):desc("harpoon: add"),
    ["n|<leader>hn"] = cmd("lua require'harpoon.ui'.nav_prev()"):noremap():desc("harpoon: nav prev"),
    ["n|<leader>hp"] = cmd("lua require'harpoon.ui'.nav_next()"):noremap():desc("harpoon: nav next"),
    ["n|;;"] = cmd("HopChar1"):noremap():desc("goto: character"),
    ["n|,,"] = cmd("HopChar1"):noremap():desc("goto: character"),
    ["n|,."] = cmd("HopWord"):noremap():desc("goto: character"),
    ["n|,p"] = cmd("HopChar1CurrentLine"):noremap():desc("goto: character in current line"),
    ["n|,l"] = cmd("HopLine"):noremap():desc("goto: line"),
    ["n|;w"] = cmd("HopWord"):noremap():desc("goto: word"),

}

-- bruh

map.register_keys(mappings)
