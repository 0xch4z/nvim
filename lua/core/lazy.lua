local M = {}

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function merge_tables_unique(base, additions)
  local result = vim.deepcopy(base or {})
  local seen = {}

  for _, item in ipairs(result) do
    seen[item] = true
  end

  for _, item in ipairs(additions) do
    if not seen[item] then
      table.insert(result, item)
    end
  end

  return result
end

local function lazy_install()
  if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazy_path,
    })
  end
end

local function generate_luarc()
  local config = require("lazy.core.config")
  local config_path = vim.fn.stdpath("config")
  local template_path = config_path .. "/.luarc.tmpl.json"
  local output_path = config_path .. "/.luarc.json"

  local base_config = {}
  local base_config_file = io.open(template_path, "r")

  -- parse base luarc
  if base_config_file then
    local content = base_config_file:read("*all")
    base_config_file:close()

    local ok, parsed = pcall(vim.fn.json_decode, content)
    if ok then
      base_config = parsed
    else
      vim.notify("failed to parse .luarc.tmpl.json: " .. parsed, vim.log.levels.ERROR)
      return
    end
  else
    vim.notify("template file .luarc.tmpl.json not found", vim.log.levels.ERROR)
    return
  end

  local plugin_library_paths = {}

  -- collect plugins paths for lsp
  for _, plugin in pairs(config.plugins) do
    if plugin._.installed then
      local lua_dir = plugin.dir .. "/lua"
      if vim.fn.isdirectory(lua_dir) == 1 then
        table.insert(plugin_library_paths, lua_dir)
      end

      table.insert(plugin_library_paths, plugin.dir)
    end
  end

  -- merge plugins into template
  local merged_config = vim.deepcopy(base_config)

  merged_config.workspace = merged_config.workspace or {}
  merged_config.workspace.library = merge_tables_unique(
    merged_config.workspace.library,
    plugin_library_paths
  )

  -- write generated config
  local output_file = io.open(output_path, "w")
  if output_file then
    output_file:write(vim.fn.json_encode(merged_config))
    output_file:close()

    vim.notify(string.format("added %d plugin paths to .luarc.json", #plugin_library_paths), vim.log.levels.TRACE)
  else
    vim.notify("could not write to .luarc.json", vim.log.levels.ERROR)
  end
end

---@param extra_specs table<LazySpec>
function M.bootstrap(extra_specs)
  lazy_install()

  vim.opt.rtp:prepend(lazy_path)

  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyInstall", "LazyUpdate", "LazySync", "LazyClean" },
    callback = function()
      -- wait 2s for plugins to be initialized
      vim.defer_fn(generate_luarc, 2000)
    end,
  })

  require("lazy").setup({
    spec = {
      { import = "plugins" },
      unpack(extra_specs),
    },
    change_detection = {
      enabled = true,
      notify = false,
    }
  }--[[@as LazyConfig]])
end

return M
