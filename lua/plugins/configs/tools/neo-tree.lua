local neotree = require("neo-tree")

neotree.setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_config = {
        name = {
            use_git_status_colors = true,
        },
    },
})
