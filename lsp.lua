local lspconfig = require "lspconfig"

return {
  formatting = {
    format_on_save = {
      enabled = true, -- enable format on save
      ignore_filetypes = { -- disable format on save for specified filetypes
      },
    },
  },
}
