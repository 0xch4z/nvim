return
{
  "nvim-neotest/neotest",
  event = "InsertEnter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "fredrikaverpil/neotest-golang"
  },
  keys = {
    {
      "tt",
      function()
        require("neotest").run()
      end,
      desc = "test: closest",
    }
  },
  config = function ()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-golang")({
          go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
        })
      },
      discovery = {
        enable = true,
      },
      log_level = vim.log.levels.DEBUG,
    })
  end
} --[[@as LazyPluginSpec]]
