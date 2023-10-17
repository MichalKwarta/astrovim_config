return {
  n = {
    ["<leader>m"] = { desc = "󱖫 " .. "Neotest" },
    ["<leader>s"] = { desc = "Spectre" },
    ["<leader>ff"] = { function() require("telescope.builtin").find_files { hidden = true } end, desc = "Find files" },
  },
}
