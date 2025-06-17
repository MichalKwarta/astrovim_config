return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local builtins = require("null-ls").builtins
      opts.sources = {
        builtins.code_actions.statix,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        nix = { "statix" },
      },
    },
  },
}
