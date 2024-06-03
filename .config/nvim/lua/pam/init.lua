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

---@param source string
local function get_package_name(source)
	return source:match(".*/(.*)")
end

---@param spec PackageSpec
local function validate_package_spec(spec)
	if type(spec) ~= "table" or not spec.source or type(spec.source) ~= "string" then
		notify(
			"Invalid package spec. Ensure it is a table with a proper source. For example, { source = 'mvllow/modes.nvim' }",
			vim.log.levels.ERROR
		)
		return false
	end

	if spec.dependencies then
		for _, dependency in ipairs(spec.dependencies) do
			if not validate_package_spec(dependency) then
				return false
			end
		end
	end

	return true
end

---@param spec PackageSpec
---@param install_path string
local function build_clone_cmd(spec, install_path)
	local clone_cmd = { "git", "clone", "--depth=1", "--filter=blob:none", "--single-branch" }
	local repo_path = spec.source:find("^http") and spec.source or "https://github.com/" .. spec.source .. ".git"
	table.insert(clone_cmd, repo_path)
	table.insert(clone_cmd, install_path)
	if spec.branch then
		table.insert(clone_cmd, "--branch=" .. spec.branch)
	end
	return clone_cmd
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

	vim.fn.system(build_clone_cmd(spec, install_path))
	notify(string.format("Installed %s", package_name))

	-- Handle dependencies
	if spec.dependencies then
		for _, dependency in ipairs(spec.dependencies) do
			handle_package(dependency)
		end
	end

	return true
end

---@param packages PackageSpec[]
function Pam.install(packages)
	local installed_any = false

	notify("Installing packages...")
	for _, package in ipairs(packages) do
		if handle_package(package) then
			installed_any = true
		end
	end

	if not installed_any then
		notify("Packages are already installed")
	end
end

---@param packages PackageSpec[]
function Pam.upgrade(packages)
	local upgraded_any = false

	notify("Upgrading packages...")
	for _, package in ipairs(packages) do
		local package_name = get_package_name(package.source)
		local path = Pam.config.install_path .. "/" .. package_name
		if vim.uv.fs_stat(path) then
			local result = vim.fn.system({ "git", "-C", path, "pull" })
			if not result:find("Already up to date.") then
				notify(string.format("Upgraded %s (%s)", package_name, package.source))
				upgraded_any = true
			end
		end
	end

	if not upgraded_any then
		notify("Packages are already up to date")
	end
end

---@param packages PackageSpec[]
function Pam.clean(packages)
	local directories = vim.fn.readdir(Pam.config.install_path)
	local managed_packages = {}

	local function add_managed_package(spec)
		managed_packages[get_package_name(spec.source)] = true
		if spec.dependencies then
			for _, dependency in ipairs(spec.dependencies) do
				add_managed_package(dependency)
			end
		end
	end

	for _, package in ipairs(packages) do
		add_managed_package(package)
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

	if vim.fn.input(confirm_msg):lower() == "y" then
		notify("Removing unused packages...")
		for _, dir in ipairs(to_remove) do
			vim.fn.delete(Pam.config.install_path .. "/" .. dir, "rf")
			notify("Removed " .. dir)
		end
	else
		notify("Clean cancelled")
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
		return { "install", "clean", "upgrade" }
	end,
})

return Pam
