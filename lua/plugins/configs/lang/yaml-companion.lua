local yaml_comp = require("yaml-companion")
local teleacope = require("telescope")

local config = yaml_comp.setup({
    builtin_matchers = {
        kubernetes = { enabled = true },
        cloud_init = { enabled = true }
    },
    schemas = {
        {
            name = "Kubernetes 1.22.4",
            uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
        },
    },
    -- Pass any additional options that will be merged in the final LSP config
    lspconfig = {
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
                validate = true,
                format = { enable = true },
                hover = true,
                schemaStore = {
                    enable = true,
                    url = "https://www.schemastore.org/api/json/catalog.json",
                },
                schemaDownload = { enable = true },
                schemas = {},
                trace = { server = "debug" },
            },
        },
    },
})

teleacope.load_extension("yaml_schema")

return config
