-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local astro_packs = {
  "bash",
  "cue",
  "docker",
  "go",
  "helm",
  "html-css",
  "json",
  "lua",
  "markdown",
  "nix",
  "rust",
  "scala",
  "terraform",
  "typescript",
  "yaml",
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
  astro_packs.assemble(),
}

return community
