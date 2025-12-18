---@type LazySpec
return {
  {
    "kawre/leetcode.nvim",
    opts = {
      lang = "python3",
      injector = {
        ["python3"] = {
          imports = function(_) return { "from typing import Optional, List, Dict, Any" } end,
        },
      },
    },
  },
}
