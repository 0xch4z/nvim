local cmd = vim.cmd

cmd("colorscheme embark")
cmd("hi Normal guibg=None ctermbg=None")

-- Sign Column
cmd("hi clear SignColumn")
cmd("hi SignColumn guifg=hotpink")

-- Status Line
cmd("hi clear StatusLine")
cmd("hi StatusLine guibg=darkcyan")

-- LineNr
cmd("hi clear LineNr")
cmd("hi LineNr guifg=lightgrey")
