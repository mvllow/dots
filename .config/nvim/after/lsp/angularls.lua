local suffixes = {
	controller = '.component.ts',
	view = '.component.html',
	css = '.component.css',
	story = '.component.stories.ts',
	test = '.component.spec.ts',
}

local related_types = {
	['component'] = {
		source = '.component.ts',
		spec = '.component.spec.ts',
	},
	['directive'] = {
		source = '.directive.ts',
		spec = '.directive.spec.ts',
	},
	['pipe'] = {
		source = '.pipe.ts',
		spec = '.pipe.spec.ts',
	},
	['service'] = {
		source = '.service.ts',
		spec = '.service.spec.ts',
	},
}

local function find_base_and_kind(filename)
	for kind, pair in pairs(related_types) do
		if filename:find(pair.source) then
			return filename:gsub(pair.source, ''), kind, 'source'
		elseif filename:find(pair.spec) then
			return filename:gsub(pair.spec, ''), kind, 'spec'
		end
	end
	return nil
end

local function related_file()
	local filepath = vim.api.nvim_buf_get_name(0)
	local dir = vim.fn.fnamemodify(filepath, ':h') .. '/'
	local filename = vim.fn.fnamemodify(filepath, ':t')

	local base, kind, file_type = find_base_and_kind(filename)
	if not base or not kind then
		vim.notify('Not a recognized Angular/Nx file', vim.log.levels.WARN)
		return
	end

	local target_suffix
	if file_type == 'source' then
		target_suffix = related_types[kind].spec
	elseif file_type == 'spec' then
		target_suffix = related_types[kind].source
	else
		vim.notify('Unknown file type', vim.log.levels.ERROR)
		return
	end

	local target_file = dir .. base .. target_suffix
	if vim.fn.filereadable(target_file) == 1 then
		vim.cmd('edit ' .. target_file)
	else
		vim.notify('Related file not found: ' .. target_file, vim.log.levels.WARN)
	end
end

local function switch_to(suffix_key)
	local filepath = vim.api.nvim_buf_get_name(0)
	local dir = vim.fn.fnamemodify(filepath, ':h') .. '/'
	local filename = vim.fn.fnamemodify(filepath, ':t')

	local base
	for _, suffix in pairs(suffixes) do
		if filename:find(suffix) then
			base = filename:gsub(suffix, '')
			break
		end
	end

	if not base then
		vim.notify('Not an Angular component file', vim.log.levels.WARN)
		return
	end

	local target_file = dir .. base .. suffixes[suffix_key]
	if vim.fn.filereadable(target_file) == 1 then
		vim.cmd('edit ' .. target_file)
	else
		vim.notify('File not found: ' .. target_file, vim.log.levels.WARN)
	end
end

local function alternate_file()
	local filepath = vim.api.nvim_buf_get_name(0)
	local dir = vim.fn.fnamemodify(filepath, ':h') .. '/'
	local filename = vim.fn.fnamemodify(filepath, ':t')

	local base
	local suffix
	for _, s in pairs(suffixes) do
		if filename:find(s) then
			base = filename:gsub(s, '')
			suffix = s
			break
		end
	end

	if not base then
		vim.notify('Not an Angular component file', vim.log.levels.WARN)
		return
	end

	local target_suffix
	if suffix == suffixes.controller then
		target_suffix = suffixes.view
	elseif suffix == suffixes.view then
		target_suffix = suffixes.controller
	else
		vim.notify('No alternate file for this type', vim.log.levels.WARN)
		return
	end

	local target_file = dir .. base .. target_suffix
	if vim.fn.filereadable(target_file) == 1 then
		vim.cmd('edit ' .. target_file)
	else
		vim.notify('Alternate file not found: ' .. target_file, vim.log.levels.WARN)
	end
end

return {
	on_attach = function()
		local clients = vim.lsp.get_clients({ name = 'angularls' })
		if not clients or #clients == 0 then
			vim.notify('Angular LSP not active', vim.log.levels.ERROR)
			return
		end


		for key, _ in pairs(suffixes) do
			vim.api.nvim_create_user_command('E' .. key, function()
				switch_to(key)
			end, {})
		end

		vim.api.nvim_create_user_command('A', alternate_file, {})
		vim.api.nvim_create_user_command('R', related_file, {})
	end
}
