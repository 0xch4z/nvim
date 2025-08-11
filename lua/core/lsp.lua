local M = {}

local function if_nil(val, default)
  if val == nil then return default end
  return val
end

---@param override table
function M.default_capabilities(override)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  override = override or {}

  capabilities.textDocument.completion = {
    dynamicRegistration = if_nil(override.dynamicRegistration, false),
    completionItem = {
      snippetSupport = if_nil(override.snippetSupport, true),
      commitCharactersSupport = if_nil(override.commitCharactersSupport, true),
      deprecatedSupport = if_nil(override.deprecatedSupport, true),
      preselectSupport = if_nil(override.preselectSupport, true),
      tagSupport = if_nil(override.tagSupport, {
        valueSet = { 1 }
      }),
      insertReplaceSupport = if_nil(override.insertReplaceSupport, true),
      resolveSupport = if_nil(override.resolveSupport, {
        properties = {
          "documentation",
          "additionalTextEdits",
          "insertTextFormat",
          "insertTextMode",
          "command",
        },
      }),
      insertTextModeSupport = if_nil(override.insertTextModeSupport, {
        valueSet = { 1, 2 }
      }),
      labelDetailsSupport = if_nil(override.labelDetailsSupport, true),
    },
    contextSupport = if_nil(override.snippetSupport, true),
    insertTextMode = if_nil(override.insertTextMode, 1),
    completionList = if_nil(override.completionList, {
      itemDefaults = {
        'commitCharacters',
        'editRange',
        'insertTextFormat',
        'insertTextMode',
        'data',
      }
    })
  }
end

return M
