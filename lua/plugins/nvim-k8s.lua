return {
  "hsalem7/nvim-k8s",
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>k"] = { function() require("nvim-k8s.K8s"):toggle() end, desc = "⎈ K9s" },
        },

        t = {
          ["<Leader>k"] = { function() require("nvim-k8s.K8s"):toggle() end, desc = "⎈ K9s" },
        },
      },
    },
  },
}
