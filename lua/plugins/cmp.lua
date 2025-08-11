return
os.getenv("NVIM_CMP") == "1" and
{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
    "hrsh7th/cmp-buffer",       -- Buffer completion source
    "hrsh7th/cmp-path",         -- Path completion source
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",         -- Snippet engine
    "saadparwaiz1/cmp_luasnip", -- Snippet completion source
    "onsails/lspkind.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    lspkind.init({})

    local opts =
    ---@type cmp.ConfigSchema
    {
      confirmation = {
        default_behavior = 'insert',
        get_commit_characters = function (_)
          return { '(', '.', ':' }
        end
      },
      experimental = {
        ghost_text = true
      },
      view = {
        docs = { auto_open = true },
        entries = "native"
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
            local cmp_entry = lspkind.cmp_format({
                  mode = "symbol",
                  maxwidth = 50,
                  menu = {
                    buffer = "[buf]",
                    nvim_lsp = "[LSP]",
                    path = "[path]",
                    luasnip = "[snip]",
                 },
              })(entry, item)
              cmp_entry.kind = " " .. cmp_entry.kind .. " "
              return cmp_entry
          end,
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    }

    cmp.setup(opts)
  end,
} --[[@as LazyPluginSpec]] or {}
