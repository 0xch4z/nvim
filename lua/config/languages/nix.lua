local system = require("core.system")
local Language = require("core.language")

Language.new("nix")
	:server("nixd", function()
		---@type ServerConfig
		return {
			cmd = { "nixd" },
			--See https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
			settings = {
				nixpkgs = {
					nixpkgs = "import <nixpkgs> { }",
				},
				options = system.get_is_nix() and {
					[system.get_nix_platform()] = {
						expr = '(builtins.getFlake ("git+file://" + toString ./.)).'
							.. system.get_nix_platform()
							.. 'Configurations."'
							.. system.get_hostname()
							.. '".options',
					},
					home_manager = {
						expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."'
							.. system.get_userhost()
							.. '".options',
					},
				} or {},
			},
		}
	end)
	:spaces(2)
	:width(120)
	:preserve_indent()
	:register()
