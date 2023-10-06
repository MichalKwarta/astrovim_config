local utils = require "astronvim.utils"

local null_ls_tools = {

  "black",

  "stylua",

  -- shell
  "shellharden",
  "beautysh",

  --ts/js

  "prettier",
  "prettierd",

  -- bazel
  "buildifier",

  --robot
  "robotframework-lsp",

  --cue
  "cueimports",
}
local lsp_tools = {
  -- python
  "pyright",
  "ruff_lsp",

  -- rust
  "rust_analyzer",

  -- lua
  "lua_ls",

  -- ts/js
  "tsserver",

  -- shell
  "bashls",

  -- nix
  "rnix",

  -- go
  "gopls",

  -- cue
  "dagger",

  -- haskell
  "hls",

  --docker
  "docker_compose_language_service",
  "dockerls",

  -- helm
  "helm_ls",

  -- html/css
  "html",
  "cssls",
  "emmet_ls",

  --markdown
  "marksman",

  --terraform
  "terraformls",

  -- toml
  "taplo",
}

return {
  {
    "easymotion/vim-easymotion",
    config = function() require("easymotion").set_default_keymaps() end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
        },
      }
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  { "rebelot/kanagawa.nvim" },
  { "AlexvZyl/nordic.nvim" },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require("lsp_signature").setup(opts) end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
    },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {
        ["neotest-python"] = {
          args = { "--log-level", "DEBUG" },
          runner = "pytest",
        },
        ["neotest-plenary"] = {
          args = { "-m", "plenary" },
        },
      },

      status = {
        virtual_text = true,
      },
      output = {
        open_on_run = true,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then config = require(config) end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    keys = {
      {
        "<leader>mt",
        function() require("neotest").run.run(vim.fn.expand "%") end,
        desc = "Run File",
      },
      {
        "<leader>mT",
        function() require("neotest").run.run(vim.loop.cwd()) end,
        desc = "Run All Test Files",
      },
      {

        "<leader>mw",
        function() require("neotest").watch.toggle(vim.fn.expand "%") end,
        desc = "Watch current file",
      },
      {
        "<leader>mr",
        function() require("neotest").run.run() end,
        desc = "Run Nearest",
      },
      {
        "<leader>ml",
        function() require("neotest").run.run_last() end,
        desc = "Rerun last test",
      },

      {
        "<leader>ms",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Summary",
      },
      {
        "<leader>mo",
        function()
          require("neotest").output.open {
            enter = true,
            auto_close = true,
          }
        end,
        desc = "Show Output",
      },
      {
        "<leader>mO",
        function() require("neotest").output_panel.toggle() end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>mS",
        function() require("neotest").run.stop() end,
        desc = "Stop",
      },
    },
  },
  { "folke/neodev.nvim", opts = {} },

  {
    "williamboman/mason-lspconfig",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = lsp_tools,
      }
      require("lspconfig").pyright.setup {
        on_attach = function(client, bufnr)
          require("lsp").common_on_attach(client, bufnr)
          require("lsp").formatting_sync(client, bufnr)
        end,

        settings = {
          pyright = {
            disableOrganizeImports = false,
            openFilesOnly = true,
            -- disableLanguageServices = true,
          },

          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
            },
          },
        },
      }
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      name = { ".venv" },
    },
    keys = { { "<leader>lv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, null_ls_tools) end,
  },
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
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
      vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "grey" })
    end,
  },
  {},
  {
    "nvim-pack/nvim-spectre",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    keys = {
      {
        "<leader>ss",
        function() require("spectre").toggle() end,
        desc = "Toggle Spectre",
      },

      {
        "<leader>sw",
        function() require("spectre").open_visual { select_word = true } end,
        desc = "Search current word",
      },

      {
        "<leader>sp",
        function() require("spectre").open_file_search { select_word = true } end,
        desc = "Search on current file",
      },
    },
  },
}
