local system = require("core.system")
local Language = require("core.language")

local function nixd_options(root)
	local platform = system.get_nix_platform()
	if not platform or not root or not system.file_exists(root .. "/flake.nix") then
		return {}
	end

	local flake = '(builtins.getFlake "git+file://' .. root .. '")'

	return {
		[platform] = {
			expr = flake .. "." .. platform .. 'Configurations."' .. system.get_hostname() .. '".options',
		},
		home_manager = {
			expr = flake .. '.homeConfigurations."' .. system.get_userhost() .. '".options',
		},
	}
end

Language.new("nix")
	:server("nixd", function()
		---@type ServerConfig
		return {
			cmd = { "nixd" },
			root_markers = { "flake.nix", ".git" },
			--See https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
			settings = {
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					options = {},
				},
			},
			-- nixd parses `expr` with its own cwd as the base path, so a relative
			-- `./.` is wherever nvim was launched from, not the flake. Pin it.
			before_init = function(_, config)
				config.settings.nixd.options = nixd_options(config.root_dir)
			end,
		}
	end)
	:formatters("nixfmt")
	:spaces(2)
	:width(120)
	:preserve_indent()
	:register()
