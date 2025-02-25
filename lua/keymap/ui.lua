local map = require("keymap.map")
local cmd = map.cmd
local key = map.key

local mappings = {
    -- TODO: search on current line <leader>\\, get line number, run :/%LINE

    -- Window navigation
    ["n|<leader>wH"] = cmd("<c-w>H"):noremap():desc("window: move left"),
    ["n|<leader>wJ"] = cmd("<c-w>J"):noremap():desc("window: move up"),
    ["n|<leader>wK"] = cmd("<c-w>K"):noremap():desc("window: move down"),
    ["n|<leader>wL"] = cmd("<c-w>L"):noremap():desc("window: move right"),
    ["n|<leader>wh"] = cmd("<c-w>h"):noremap():desc("window: go left"),
    ["n|<leader>wj"] = cmd("<c-w>j"):noremap():desc("window: go up"),
    ["n|<leader>wk"] = cmd("<c-w>k"):noremap():desc("window: go down"),
    ["n|<leader>wl"] = cmd("<c-w>l"):noremap():desc("window: go right"),
    -- Window operations
    ["n|<leader>vs"] = cmd("vsplit"):noremap():desc("window: vsplit"),
    ["n|<leader>hs"] = cmd("split"):noremap():desc("window: hsplit"),
    -- Buffer lifecycle/navigation
    ["n|<leader>bd"] = cmd("bd"):noremap():desc("buffer: delete"),
    ["n|<leader>bD"] = cmd(":let curr = bufnr('%') | execute 'bufdo if bufnr() != ' . curr . ' | bdelete | endif'")
        :noremap()
        :desc("buffer: delete all but current"),
    ["n|<leader>q"] = cmd("q"):noremap():desc("buffer: quit"),
    ["n|<leader>wq"] = cmd("wq"):noremap():desc("buffer: save & quit"),
    ["n|<leader>qa"] = cmd("qa"):noremap():desc("buffer: quit all"),
    ["n|<leader>k"] = cmd("q!"):noremap():desc("buffer: kill"),
    ["n|<leader>ka"] = cmd("xa!"):noremap():desc("buffer: kill all"),
    ["n|8"] = cmd("bprevious"):noremap():desc("buffer: prev"),
    ["n|9"] = cmd("bnext"):noremap():desc("buffer: prev"),
    -- Paging
    ["n|<C-d>"] = key("<C-d>zz"):desc("page: down"),
    ["n|<C-u>"] = key("<C-u>zz"):desc("page: up"),
    ["n|G"] = cmd("Gzz"):noremap():desc("page: end"),

    --["n|<leader>bc"] = cmd("BufferClose"):noremap():desc("buffer: close"),
    -- Misc
    ["n|<leader>nh"] = cmd("noh"):noremap():desc("search: clear highlight"),
    ["n|<leader>fml"] = cmd("CellularAutomaton make_it_rain"):noremap():desc("fml"),
}

map.register_keys(mappings)
