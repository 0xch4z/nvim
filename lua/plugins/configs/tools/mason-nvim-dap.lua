require("mason-nvim-dap").setup {
    ensure_installed = { "python", "delve" },
    handlers = {
        function(config)
            require("mason-nvim-dap").default_setup(config)
        end,
        python = function(config)
            require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
        delve = function(config)
            require("mason-nvim-dap").default_setup(config)
        end,
    },
}
