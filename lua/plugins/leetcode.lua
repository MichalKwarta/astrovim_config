---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "kawre/leetcode.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      lang = "python3",
    },
  },
}
