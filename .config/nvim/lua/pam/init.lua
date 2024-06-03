local Pam = {}
Pam.packages = {}
Pam.config = {
	install_path = vim.fn.stdpath("data") .. "/site/pack/pam/start",
}

function Pam.manage(packages, config)
	Pam.packages = packages or {}
	Pam.config = vim.tbl_extend("force", Pam.config, config or {})
end

---@param msg string
---@param level? integer
local function notify(msg, level)
	level = level or vim.log.levels.INFO
	vim.notify("(pam) " .. msg, level)
end

local function get_package_name(url)
	return url:match(".*/(.*)")
end

---@param spec PackageSpec
local function validate_package_spec(spec)
	if type(spec) ~= "table" then
		notify(
			"Invalid package spec. Ensure it is a table with a proper source. For example, { source = 'mvllow/modes.nvim' }",
			vim.log.levels.ERROR
		)
		return false
	end
	if not spec.source or type(spec.source) ~= "string" then
		notify(
			"Invalid package spec. Ensure a proper source exists and is a string. For example, { source = 'mvllow/modes.nvim' }",
			vim.log.levels.ERROR
		)
		return false
	end
	if spec.dependencies then
		if type(spec.dependencies) ~= "table" then
			notify(
				"Invalid package spec.Ensure dependencies is a list of packages. For example, { dependencies = { { source = 'nvim-lua/plenary.nvim' } } }",
				vim.log.levels.ERROR
			)
			return false
		end
		for _, dependency in ipairs(spec.dependencies) do
			if not validate_package_spec(dependency) then
				return false
			end
		end
	end

	return true
end

---@param spec PackageSpec
local function handle_package(spec)
	if not validate_package_spec(spec) then
		return false
	end

	local package_path = spec.source:gsub("^~", vim.fn.expand("$HOME"))
	local package_name = get_package_name(package_path)
	local install_path = Pam.config.install_path .. "/" .. package_name

	-- Package already exists
	if vim.uv.fs_stat(install_path) then
		return false
	end

	local clone_cmd = { "git", "clone", "--depth=1", "--filter=blob:none", "--single-branch" }
	if spec.source:find("^http") then
		table.insert(clone_cmd, package_path)
	else
		table.insert(clone_cmd, "https://github.com/" .. package_path .. ".git")
	end
	table.insert(clone_cmd, install_path)
	if spec.branch ~= nil then
		table.insert(clone_cmd, "--branch=" .. spec.branch)
	end

	vim.fn.system(clone_cmd)
	notify(string.format("Installed %s", package_name))

	-- Handle dependencies
	if spec.dependencies then
		for _, dependency in ipairs(spec.dependencies) do
			handle_package(dependency)
		end
	end

	return true
end

function Pam.install(packages)
	local installed_any = false

	notify("Installing packages...")
	for _, package in ipairs(packages) do
		if handle_package(package) then
			installed_any = true
		end
	end

	if not installed_any then
		notify("All packages are already installed")
	end
end

function Pam.upgrade(packages)
	local upgraded_any = false

	notify("Upgrading packages...")
	for _, package in ipairs(packages) do
		local package_name = get_package_name(package)
		local path = Pam.config.install_path .. "/" .. package_name
		if vim.uv.fs_stat(path) then
			local result = vim.fn.system({ "git", "-C", path, "pull" })
			if not result:find("Already up to date.") then
				notify(string.format("Upgraded %s (%s)", package_name, package))
				upgraded_any = true
			end
		end
	end

	if not upgraded_any then
		notify("All packages are already up to date")
	end
end

function Pam.clean(packages)
	local directories = vim.fn.readdir(Pam.config.install_path)
	local managed_packages = {}
	for _, package in ipairs(packages) do
		local package_name = get_package_name(package)
		managed_packages[package_name] = true
	end

	local to_remove = {}
	for _, dir in ipairs(directories) do
		if not managed_packages[dir] then
			table.insert(to_remove, dir)
		end
	end

	if #to_remove == 0 then
		notify("No packages to remove")
		return
	end

	local confirm_msg = "Remove the following directories?\n" .. table.concat(to_remove, "\n") .. "\n[y/N]: "
	local confirm = vim.fn.input(confirm_msg)

	if confirm:lower() == "y" then
		notify("\nRemoving unused packages...")
		for _, dir in ipairs(to_remove) do
			vim.fn.delete(Pam.config.install_path .. "/" .. dir, "rf")
			notify("Removed " .. dir)
		end
	else
		notify("\nClean cancelled")
	end
end

vim.api.nvim_create_user_command("Pam", function(opts)
	local subcommand = opts.fargs[1]
	if subcommand == "install" then
		Pam.install(Pam.packages)
	elseif subcommand == "upgrade" or subcommand == "update" then
		Pam.upgrade(Pam.packages)
	elseif subcommand == "clean" then
		Pam.clean(Pam.packages)
	else
		print("Invalid subcommand: " .. subcommand)
	end
end, {
	nargs = "+",
	complete = function()
		return { "install", "clean", "update" }
	end,
})

return Pam
