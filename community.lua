-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local astro_packs = {
  "rust",
  "typescript",
  "lua",
  "go",
  "cue",
  "docker",
  "nix",
  "helm",
  "markdown",
  "yaml",
  "json",
  "html-css",
  "scala",
  "terraform",
}

astro_packs.assemble = function()
  local packs = {}
  for _, pack in ipairs(astro_packs) do
    table.insert(packs, { import = "astrocommunity.pack." .. pack })
  end
  return packs
end

local community = {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.kanagawa-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.project.nvim-spectre" },
}
table.insert(community, astro_packs.assemble())

return community
