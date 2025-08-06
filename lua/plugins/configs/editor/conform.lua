require("conform").setup({
    -- TODO: eventually this will be computed from Language structs
    formatters_by_ft = {
        go = { "gofmt" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
