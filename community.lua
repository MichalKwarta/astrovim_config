-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

local astro_packs = {
  pack = {
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
    "python-ruff",
    "yaml",
    "vue",
  },
  test = {
    "neotest",
  },
  colorscheme = {
    "kanagawa-nvim",
  },
  lsp = {
    "lsp-signature-nvim",
  },
  project = {
    "nvim-spectre",
  },
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
