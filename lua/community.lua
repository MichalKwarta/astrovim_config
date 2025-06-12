-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@param tab table table with astropacks grouped by type
---@param path string? path to the current element with default valuel of ""
---@param result table? table to store the result
-- @return table
function assemble_packs(tab, path, result)
	result = result or {}
	path = path or "astrocommunity"
	for k, v in pairs(tab) do
		if type(v) == "table" then
			assemble_packs(v, path .. "." .. k, result)
		else
			result[#result + 1] = { import = path .. "." .. v }
		end
	end
	return result
end

local astro_packs = {
	["bars-and-lines"] = {
		"vim-illuminate",
	},
	colorscheme = {
		"kanagawa-nvim",
	},
	completion = {
		"avante-nvim",
	},
	["code-runner"] = {
		"overseer-nvim",
	},
	diagnostics = {
		"lsp_lines-nvim",
		"trouble-nvim",
	},
	["file-explorer"] = {
		"oil-nvim",
	},
	game = {
		"leetcode-nvim",
	},
	lsp = {
		"lsp-signature-nvim",
	},
	media = {
		"codesnap-nvim",
	},
	["neovim-lua-development"] = {
		"helpview-nvim",
	},
	pack = {
		"bash",
		"cue",
		"docker",
		"go",
		-- "haskell", - needs additonal workarounds to install haskell stuff on nix
		"helm",
		"html-css",
		"json",
		"lua",
		"markdown",
		"mdx",
		"nix",
		-- "ocaml"
		"python-ruff",
		"rust",
		"scala",
		"sql",
		"terraform",
		"typescript-all-in-one",
		"vue",
		"yaml",
	},
	recipes = {
		"telescope-lsp-mappings",
	},
	search = {
		"nvim-spectre",
	},
	test = {
		"neotest",
	},
	utility = {
		"live-server-nvim",
	},
	workflow = {
		--   "hardtime-nvim",
	},
}

local community = {
	"AstroNvim/astrocommunity",
	assemble_packs(astro_packs),
}

return community
