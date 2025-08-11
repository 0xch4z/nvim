local SYMBOL_KIND_INCLUDE = {
	["Class"] = true,
	["Constructor"] = true,
	["Enum"] = true,
	["EnumMember"] = true,
	["Field"] = true,
	["Function"] = true,
	["Interface"] = true,
	["Method"] = true,
	["Module"] = true,
	["Namespace"] = true,
	["Package"] = false,
	["Property"] = true,
	["Struct"] = true,
	["Trait"] = true,
}

local function flatten(symbols, scope)
	local items = {}

	for _, symbol in ipairs(symbols) do
		symbol.scope = scope

		table.insert(items, symbol)

		if symbol.children then
			local new_scope = vim.deepcopy(scope)

			table.insert(new_scope, symbol.name)

			for _, item in ipairs(flatten(symbol.children, new_scope)) do
				table.insert(items, item)
			end
		end
	end

	return items
end

return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		require("mini.surround").setup()
		require("mini.icons").setup()
		require("mini.pick").setup()
	end,
	keys = function()
		local pick = require("mini.pick")

		return {
			{
				"fg",
				"<cmd>Pick grep_live<cr>",
			},
			{
				"fs",
				function()
					local buf = vim.api.nvim_get_current_buf()
					local win = vim.api.nvim_get_current_win()
					local pars = vim.lsp.util.make_position_params(win, "utf-8")

					vim.lsp.buf_request(buf, "textDocument/documentSymbol", pars, function(err, result)
						if err or not result then
							return
						end

						local items = {}

						for _, sym in ipairs(flatten(result, {})) do
							local loc = sym.selectionRange
							local kind = vim.lsp.protocol.SymbolKind[sym.kind]

							if SYMBOL_KIND_INCLUDE[kind] then
								table.insert(items, {
									parent = { text = table.concat(sym.scope, " / ") },
									text = "[" .. kind .. "] " .. sym.name,
									kind = kind,
									buf = buf,
									lnum = loc.start.line + 1,
									col = loc.start.character + 1,
									end_lnum = loc["end"].line + 1,
									end_col = loc["end"].character + 1,
								})
							end
						end

						table.sort(items, function(a, b)
							return a.text < b.text
						end)

						pick.start({
							source = {
								items = items,
								name = "Document symbols",
							},
						})
					end)
				end,
			},
		}
	end,
} --[[@as LazyPluginSpec]]
