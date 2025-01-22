LilToggleState = {}

local prefix = vim.g.lil_toggle_prefix or [[\]]
local modes = vim.g.lil_toggle_modes or { 'n', 'v', 'x' }

local function notify(value, log_level)
	vim.notify('[lil-toggle] ' .. value, log_level or vim.log.levels.INFO, { title = 'lil-toggle' })
end

local function notify_set(opt, value)
	notify('set ' .. opt .. ' to ' .. tostring(value))
end

local function try_toggleable(obj, opt)
	if obj and type(obj.enable) == 'function' and type(obj.is_enabled) == 'function' then
		obj.enable(not obj.is_enabled())
		notify_set(opt, obj.is_enabled())
		return true
	end
end

local function toggle_quickfix()
	local is_open = vim.tbl_contains(vim.tbl_map(function(w) return w.quickfix == 1 end, vim.fn.getwininfo()), true)
	if is_open then
		vim.cmd('cclose')
		notify('quickfix closed')
		return
	end

	if vim.tbl_isempty(vim.fn.getqflist()) then
		notify('quickfix is empty')
		return
	end

	vim.cmd('copen')
	notify('quickfix opened')
end

local function toggle(opt)
	if opt == 'quickfix' then
		toggle_quickfix()
		return
	end

	local ok, val = pcall(function() return vim.o[opt] end)
	if not ok then
		goto try_toggleable
	end

	if type(val) == 'boolean' then
		vim.o[opt] = not val
		notify_set(opt, vim.o[opt])
		return
	end

	if type(val) == 'number' then
		if val == 0 then
			vim.o[opt] = LilToggleState[opt] or 1
		else
			LilToggleState[opt] = val
			vim.o[opt] = 0
		end
		notify_set(opt, vim.o[opt])
		return
	end

	if type(val) == 'string' then
		if val == 'light' or val == 'dark' then
			vim.o[opt] = val == 'light' and 'dark' or 'light'
			notify_set(opt, vim.o[opt])
			return
		end
	end

	::try_toggleable::

	if try_toggleable(vim[opt], opt) or try_toggleable(vim.lsp[opt], opt) then
		return
	end

	local has_cmds, cmds = pcall(vim.api.nvim_get_autocmds, { group = opt })
	if has_cmds and type(cmds) == 'table' then
		LilToggleState[opt] = cmds
		pcall(vim.api.nvim_del_augroup_by_name, opt)
		notify(opt .. ' disabled')
		return
	end

	vim.api.nvim_create_augroup(opt, { clear = true })
	cmds = LilToggleState[opt]
	if type(cmds) == 'table' then
		for _, cmd in pairs(cmds) do
			local opts = { desc = cmd.desc or '', group = cmd.group_name or opt }
			if cmd.pattern then
				opts.pattern = cmd.pattern
			elseif cmd.buffer then
				opts.buffer = cmd.buffer
			end
			if cmd.callback then
				opts.callback = cmd.callback
			elseif cmd.command then
				opts.command = cmd.command
			end
			vim.api.nvim_create_autocmd(cmd.event, opts)
		end
		notify(opt .. 'enabled')
	end
end

function LilToggle(lhs, rhs)
	vim.keymap.set(modes, prefix .. lhs, type(rhs) == 'function' and rhs or function() toggle(rhs) end)
end

vim.api.nvim_create_user_command('LilToggle', function(opts)
	toggle(opts.args)
end, { nargs = '+', desc = 'Toggle things' })
