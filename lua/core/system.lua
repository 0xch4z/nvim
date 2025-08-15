local M = {}

local os_name = nil
local hostname = os.getenv("HOSTNAME")
local userhost = os.getenv("NIX_USERHOST")

local is_nix = nil
local nix_platform = os.getenv("NIX_VARIANT")

---Check if file exists
---@param path string
---@return boolean
function M.file_exists(path)
	local fh = io.open(path, "r")
	if fh then
		fh:close()
		return true
	end

	return false
end

---Run command and return it's output
---@param cmd string
---@return string
function M.cmdout(cmd)
	local fh = io.popen(cmd)
	if not fh then
		return ""
	end

	local output = fh:read("*a")
	fh:close()

	return output:gsub("%s+$", "")
end

---Get system's OS name
---@return string
function M.get_os_name()
	if os_name then
		return os_name
	end

	os_name = string.lower(M.cmdout("uname -s"))

	return os_name
end

---@return string
function M.get_hostname()
	if hostname then
		return hostname
	end

	hostname = M.cmdout("/bin/hostname")
	return hostname
end

---Returns $OS@$HOSTNAME
---@return string?
function M.get_userhost()
	if userhost then
		return userhost
	end

	userhost = os.getenv("USER") .. "@" .. M.get_hostname()

	return userhost
end

---Get the system's nix "platform" or nil
---@return string?
function M.get_nix_platform()
	if nix_platform then
		return nix_platform
	end

	if is_nix == false then
		return nil
	end

	if string.lower(M.cmdout("uname -s")) == "darwin" then
		-- this is macos
		return "darwin"
	end

	is_nix = false

	return nil
end

---Check whether the system is nix.
---@return boolean
function M.get_is_nix()
	return is_nix == true or not not M.get_nix_platform()
end

return M
