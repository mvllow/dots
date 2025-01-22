vim.filetype.add({
	extension = {
		mustache = 'html',
		njk = 'html',
		svg = 'html',
		webc = 'html',
	},
	pattern = {
		['.*component.html'] = 'htmlangular'
	}
})
