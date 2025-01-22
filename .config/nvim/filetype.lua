vim.filetype.add({
	extension = {
		mustache = "html",
		njk = "html",
		svg = "html",
	},
	pattern = {
		[".*component.*.html"] = "htmlangular"
	}
})
