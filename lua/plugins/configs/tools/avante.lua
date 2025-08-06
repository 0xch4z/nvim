local avante = require("avante")

if os.getenv("NVIM_DISABLE_AI") ~= "true" then
    avante.setup({
        provider = os.getenv("AVANTE_PROVIDER") or "copilot",
    })
end
