local SYMBOL_KIND_INCLUDE = {
	["Class"] = true,
	["Constant"] = true,
	["Constructor"] = true,
	["Enum"] = true,
	["EnumMember"] = true,
	["Event"] = true,
	["Field"] = true,
	["Function"] = true,
	["Interface"] = true,
	["Key"] = true,
	["Method"] = true,
	["Module"] = true,
	["Namespace"] = true,
	["Object"] = true,
	["Package"] = false,
	["Property"] = true,
	["Struct"] = true,
	["Trait"] = true,
	["TypeParameter"] = true,
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

local function make_symbol_item(icon, hl, name, suffix, opts)
	opts = opts or {}
	local prefix = opts.indent or ""
	return {
		text = prefix .. icon .. " " .. name .. "  " .. suffix,
		icon = icon,
		icon_hl = hl,
		indent = opts.indent,
		suffix_len = #suffix,
		deprecated = opts.deprecated or false,
		buf = opts.buf,
		path = opts.path,
		lnum = opts.lnum,
		col = opts.col,
		end_lnum = opts.end_lnum,
		end_col = opts.end_col,
	}
end

local function make_symbol_show(ns)
	return function(buf_id, pick_items, query)
		local pick = require("mini.pick")
		pick.default_show(buf_id, pick_items, query)

		vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

		for i, item in ipairs(pick_items) do
			local icon_start = #(item.indent or "")

			if item.icon_hl then
				vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, icon_start, {
					end_col = icon_start + #item.icon,
					hl_group = item.icon_hl,
					hl_mode = "combine",
					priority = 200,
				})
			end

			local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1] or ""
			local suffix_start = #line - item.suffix_len
			vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, suffix_start, {
				end_col = #line,
				hl_group = "Comment",
				hl_mode = "combine",
				priority = 200,
			})

			if item.deprecated then
				local name_start = icon_start + #item.icon + 1
				vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, name_start, {
					end_col = suffix_start - 2,
					hl_group = "DiagnosticDeprecated",
					hl_mode = "combine",
					priority = 201,
				})
			end
		end
	end
end

local function build_doc_symbol_items(result, opts)
	opts = opts or {}
	local icons = require("mini.icons")
	local items = {}

	for _, sym in ipairs(flatten(result, {})) do
		local loc = sym.selectionRange
		local kind = vim.lsp.protocol.SymbolKind[sym.kind]

		if SYMBOL_KIND_INCLUDE[kind] then
			local icon, hl = icons.get("lsp", string.lower(kind))
			local depth = #sym.scope
			local indent = string.rep("  ", depth)
			local detail = sym.detail and vim.trim(sym.detail) or ""
			local is_deprecated = sym.deprecated or (sym.tags and vim.tbl_contains(sym.tags, 1))

			local parts = {}
			if detail ~= "" then
				table.insert(parts, detail)
			end
			table.insert(parts, kind)
			local suffix = table.concat(parts, " · ")
			if opts.rel_path then
				suffix = suffix .. "  " .. opts.rel_path .. ":" .. (loc.start.line + 1)
			end

			table.insert(
				items,
				make_symbol_item(icon, hl, sym.name, suffix, {
					indent = indent,
					deprecated = is_deprecated,
					buf = opts.buf,
					path = opts.path,
					lnum = loc.start.line + 1,
					col = loc.start.character + 1,
					end_lnum = loc["end"].line + 1,
					end_col = loc["end"].character + 1,
				})
			)
		end
	end

	return items
end

local saved_pickers = {}

local function save_picker(key, extra)
	local pick = require("mini.pick")
	if not pick.is_picker_active() then
		return
	end

	local opts = pick.get_picker_opts() or {}
	local matches = pick.get_picker_matches() or {}
	local source = opts.source or {}

	saved_pickers[key] = vim.tbl_extend("force", {
		items = pick.get_picker_items(),
		name = source.name or key,
		show = source.show,
		current = matches.current_ind,
	}, extra or {})

	vim.notify("Saved " .. (source.name or key), vim.log.levels.INFO)
end

local function restore_picker(key)
	local pick = require("mini.pick")
	local saved = saved_pickers[key]
	if not saved then
		vim.notify("No saved search for " .. key, vim.log.levels.WARN)
		return
	end

	local saved_current = saved.current
	local saved_show = saved.show
	local did_restore_index = false

	pick.start({
		source = {
			items = saved.items,
			name = saved.name .. " (saved)",
			show = function(buf_id, items, query)
				if saved_show then
					saved_show(buf_id, items, query)
				else
					pick.default_show(buf_id, items, query)
				end

				if not did_restore_index and saved_current then
					did_restore_index = true
					vim.schedule(function()
						if pick.is_picker_active() then
							pick.set_picker_match_inds({ saved_current }, "current")
						end
					end)
				end
			end,
		},
	})
end

local function picker_items_to_entries(items)
	local entries = {}
	for _, item in ipairs(items) do
		if type(item) == "string" then
			-- NB: mini.pick grep uses null-byte separators
			local parts = vim.split(item, "\0")
			if #parts >= 4 then
				table.insert(entries, {
					filename = parts[1],
					lnum = tonumber(parts[2]),
					col = tonumber(parts[3]),
					text = parts[4],
				})
			elseif #parts >= 2 then
				table.insert(entries, {
					filename = parts[1],
					lnum = tonumber(parts[2]) or 1,
					text = parts[#parts],
				})
			else
				-- plain file path
				local clean = item:gsub("%z", "")
				table.insert(entries, { filename = clean, lnum = 1, text = clean })
			end
		elseif type(item) == "table" then
			table.insert(entries, {
				filename = item.path,
				bufnr = item.buf,
				lnum = item.lnum or 1,
				col = item.col,
				end_lnum = item.end_lnum,
				end_col = item.end_col,
				text = item.text or item.path or "",
			})
		end
	end
	return entries
end

local function send_to_list(loclist)
	local pick = require("mini.pick")
	local matches = pick.get_picker_matches() or {}

	local items = (#matches.marked > 0) and matches.marked or matches.all
	if not items or #items == 0 then
		return
	end

	local entries = picker_items_to_entries(items)
	if #entries == 0 then
		return
	end

	local state = pick.get_picker_state() or {}
	local target_win = (state.windows or {}).target

	pick.stop()
	vim.schedule(function()
		local win = (target_win and vim.api.nvim_win_is_valid(target_win)) and target_win or 0

		local existing_winid
		if loclist then
			existing_winid = vim.fn.getloclist(win, { winid = 0 }).winid
		else
			existing_winid = vim.fn.getqflist({ winid = 0 }).winid
		end

		local action = (existing_winid ~= 0) and "a" or " "
		local props = { items = entries }
		if action == " " then
			props.title = "Pick results"
		end

		if loclist then
			vim.fn.setloclist(win, {}, action, props)
		else
			vim.fn.setqflist({}, action, props)
		end

		require("quicker").open(loclist and { loclist = true } or nil)
	end)
end

local function picker_mappings(key, extra)
	return {
		send_to_qf = {
			char = "<C-q>",
			func = function()
				send_to_list(false)
			end,
		},
		send_to_loclist = {
			char = "<C-l>",
			func = function()
				send_to_list(true)
			end,
		},
		save = {
			char = "<C-s>",
			func = function()
				save_picker(key, extra)
			end,
		},
		restore = {
			char = "<C-r>",
			func = function()
				restore_picker(key)
			end,
		},
	}
end

return {
	"echasnovski/mini.nvim",
	dependencies = { "stevearc/quicker.nvim" },
	config = function()
		require("mini.pairs").setup()
		require("mini.comment").setup()
		require("mini.surround").setup()
		require("mini.icons").setup()
		require("mini.pick").setup()
	end,
	keys = function()
		local pick = require("mini.pick")

		local keys = {
			{
				"<leader>ff",
				function()
					pick.builtin.files({}, { mappings = picker_mappings("files") })
				end,
			},

			{
				"<leader>fg",
				function()
					pick.builtin.grep_live({}, { mappings = picker_mappings("grep") })
				end,
			},

			{
				"<leader>fs",
				function()
					local buf = vim.api.nvim_get_current_buf()
					local win = vim.api.nvim_get_current_win()

					if #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentSymbol" }) == 0 then
						vim.notify("LSP not ready — no clients support documentSymbol", vim.log.levels.WARN)
						return
					end

					local pars = vim.lsp.util.make_position_params(win, "utf-8")
					local cursor_line = vim.api.nvim_win_get_cursor(win)[1]

					vim.lsp.buf_request(buf, "textDocument/documentSymbol", pars, function(err, result)
						if err then
							vim.notify("documentSymbol: " .. (err.message or tostring(err)), vim.log.levels.WARN)
							return
						end
						if not result or #result == 0 then
							vim.notify("No symbols found", vim.log.levels.INFO)
							return
						end

						local items = build_doc_symbol_items(result, { buf = buf })

						table.sort(items, function(a, b)
							return a.lnum < b.lnum
						end)

						local ns = vim.api.nvim_create_namespace("MiniPickSymbols")
						local show = make_symbol_show(ns)

						-- find symbol closest to cursor
						local closest_idx = 1
						local closest_dist = math.huge
						for i, item in ipairs(items) do
							local dist = math.abs(item.lnum - cursor_line)
							if dist < closest_dist then
								closest_dist = dist
								closest_idx = i
							end
						end

						local did_initial_scroll = false

						pick.start({
							source = {
								items = items,
								name = "Document symbols",
								show = function(buf_id, pick_items, query)
									show(buf_id, pick_items, query)

									if not did_initial_scroll then
										did_initial_scroll = true
										vim.schedule(function()
											if pick.is_picker_active() then
												pick.set_picker_match_inds({ closest_idx }, "current")
											end
										end)
									end
								end,
								preview = function(buf_id, item)
									pick.default_preview(buf_id, item)
								end,
							},
							mappings = picker_mappings("symbols", { show = show }),
						})
					end)
				end,
			},

			-- workspace symbols
			{
				"<leader>fw",
				function()
					local doc_clients = vim.lsp.get_clients({ method = "textDocument/documentSymbol" })
					if #doc_clients == 0 then
						vim.notify("LSP not ready — no clients support documentSymbol", vim.log.levels.WARN)
						return
					end

					-- scope to the root of whatever project the current file belongs to
					local bufname = vim.api.nvim_buf_get_name(0)
					local root = vim.fs.root(bufname, {
						".git",
						"go.mod",
						"go.sum",
						"Cargo.toml",
						"package.json",
						"pyproject.toml",
						"setup.py",
						"Makefile",
						"CMakeLists.txt",
						".hg",
					}) or vim.fn.fnamemodify(bufname, ":h")

					-- find source files under root
					local client = doc_clients[1]

					-- use git ls-files when possible, fall back to vim.fs.find
					local files = {}
					local git_root = vim.fs.root(bufname, { ".git" })
					if git_root and root:sub(1, #git_root) == git_root then
						local result = vim.system({ "git", "ls-files", "--full-name", root }, { cwd = git_root }):wait()
						if result.code == 0 then
							for line in result.stdout:gmatch("[^\n]+") do
								local fullpath = git_root .. "/" .. line
								if fullpath:sub(1, #root) == root then
									table.insert(files, fullpath)
								end
							end
						end
					end

					if #files == 0 then
						files = vim.fs.find(function()
							return true
						end, {
							path = root,
							type = "file",
							limit = math.huge,
						})
					end

					-- filter to files the LSP can handle
					local source_files = {}
					for _, f in ipairs(files) do
						local ft = vim.filetype.match({ filename = f })
						if ft and vim.tbl_contains(client.config.filetypes or {}, ft) then
							table.insert(source_files, f)
						end
					end

					if #source_files == 0 then
						vim.notify("No source files found in " .. root, vim.log.levels.INFO)
						return
					end

					local pending = #source_files
					local all_items = {}

					local function on_file_done()
						pending = pending - 1
						if pending > 0 then
							return
						end

						if #all_items == 0 then
							vim.notify("No symbols found", vim.log.levels.INFO)
							return
						end

						table.sort(all_items, function(a, b)
							if a.path ~= b.path then
								return (a.path or "") < (b.path or "")
							end
							return a.lnum < b.lnum
						end)

						local ns = vim.api.nvim_create_namespace("MiniPickWorkspaceSymbols")

						pick.start({
							source = {
								items = all_items,
								name = "Workspace symbols",
								show = make_symbol_show(ns),
								preview = function(buf_id, item)
									pick.default_preview(buf_id, item)
								end,
							},
						})
					end

					for _, filename in ipairs(source_files) do
						local uri = vim.uri_from_fname(filename)
						local rel_path = vim.fn.fnamemodify(filename, ":.")

						client:request(
							"textDocument/documentSymbol",
							{ textDocument = { uri = uri } },
							function(err, result)
								if not err and result then
									local file_items = build_doc_symbol_items(result, {
										path = filename,
										rel_path = rel_path,
									})
									vim.list_extend(all_items, file_items)
								end
								on_file_done()
							end
						)
					end
				end,
			},
		}

		return keys
	end,
} --[[@as LazyPluginSpec]]
