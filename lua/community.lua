-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local astro_packs = {
	pack = {
		"bash",
		"cue",
		"docker",
		"go",
		"haskell",
		"helm",
		"html-css",
		"json",
		"lua",
		"markdown",
		"nix",
		"ocaml",
		"python-ruff",
		"rust",
		"scala",
		"sql",
		"terraform",
		"typescript-all-in-one",
		"vue",
		"yaml",
	},
	test = {
		"neotest",
	},
	recipes = {
		"telescope-lsp-mappings",
	},
	colorscheme = {
		"kanagawa-nvim",
	},
	lsp = {
		"lsp-signature-nvim",
	},
	search = {
		"nvim-spectre",
	},

	["code-runner"] = {
		"overseer-nvim",
	},
	-- workflow = {
	--   "hardtime-nvim",
	-- },
}
function assemble_packs(packs)
	local importTable = {}
	for packType, packList in pairs(packs) do
		for _, package in ipairs(packList) do
			table.insert(importTable, { import = "astrocommunity." .. packType .. "." .. package })
		end
	end
	return importTable
end

local community = {
	"AstroNvim/astrocommunity",
	assemble_packs(astro_packs),
}

return community
