--- lil-helpers.lua
--- https://github.com/mvllow/lilvim

--- Shared utility functions.

local M = {}
local packer = nil
local installed_plugins = {}

M.use = function(package)
	if packer == nil then
		local install_path = vim.fn.stdpath('data')
			.. '/site/pack/packer/start/packer.nvim'
		if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
			vim.fn.execute(
				'!git clone --depth 1 https://github.com/wbthomason/packer.nvim '
					.. install_path
			)
		end

		packer = require('packer')

		-- Initialise shared plugins
		if packer ~= nil then
			packer.init()
			packer.use('wbthomason/packer.nvim')
		end
	end

	-- Get package name from string or table
	-- Eg. use('some/package') or use({'some/package', ...})
	local package_name = ''
	if type(package) == 'string' then
		package_name = package
	else
		package_name = package[1]
	end

	-- Prevent package duplication
	if not vim.tbl_contains(installed_plugins, package_name) then
		if packer ~= nil then
			packer.use(package)
		end
	end
	table.insert(installed_plugins, package_name)
end

return M
