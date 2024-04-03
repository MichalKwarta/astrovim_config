return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "__pycache__",
            ".pytest_cache",
            ".mypy_cache",
            -- '.venv',
            ".vscode",
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    },
  },
}
