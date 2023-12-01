require("neotest").setup({
    adapters = {
        require("neotest-plenary"),
        require("neotest-elixir")({
            args = { "--trace" }
        }),
        require("neotest-go")({
            experimental = {
                test_table = true,
            }
        })
    }
})
