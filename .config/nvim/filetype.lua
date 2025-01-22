vim.filetype.add({
	extension = {
		mustache = "html",
		njk = "html"
	},
	pattern = {
		[".*component.*.html"] = "htmlangular"
	}
})
