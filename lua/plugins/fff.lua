return
{
  "dmtrKovalenko/fff.nvim",
  build = "nix run .#release",

  opts =
  {
  },
  keys = {
    {
      "ff",
      function()
        require("fff").find_files()
      end,
      desc = "Open file picker",
    },
  },
} --[[@as LazyPluginSpec]]
