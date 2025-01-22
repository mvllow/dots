local prefix = "_" -- must be alphanumeric or an underscore

local map = {
	["&check;"] = "✓",
	["&copy;"] = "©",
	["&crarr;"] = "↵",
	["&darr;"] = "↓",
	["&euro;"] = "€",
	["&harr;"] = "↔",
	["&hellip;"] = "…",
	["&laquo;"] = "«",
	["&larr;"] = "←",
	["&mdash;"] = "—",
	["&middot;"] = "·",
	["&minus;"] = "−",
	["&ndash;"] = "–",
	["&nearr;"] = "↗",
	["&nwarr;"] = "↖",
	["&quot;"] = "\"",
	["&raquo;"] = "»",
	["&rarr;"] = "→",
	["&searr;"] = "↘",
	["&swarr;"] = "↙",
	["&times;"] = "×",
	["&uarr;"] = "↑",
	["&varr;"] = "↕",
}

for from, to in pairs(map) do
	vim.keymap.set("ia", prefix .. from, function()
		return to
	end, { expr = true })
end
