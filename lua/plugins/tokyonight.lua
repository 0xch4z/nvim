return
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent"
    }
  },
  config = function ()
    vim.cmd[[colorscheme tokyonight-moon]]
    vim.cmd[[hi Normal guibg=None ctermbg=None]]

    vim.cmd[[hi clear SignColumn]]
    vim.cmd[[hi SignColumn guifg=hotpink]]

    vim.cmd[[hi clear LineNr]]
    vim.cmd[[hi LineNr guifg=lightgrey]]
  end
} --[[@as LazyPluginSpec]]
