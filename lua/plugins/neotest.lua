local prefix = "<Leader>n"

---@type LazySpec
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-go",
    "nvim-neotest/nvim-nio",
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>Td"] = false,
            ["<Leader>T"] = false,
            ["<Leader>Tt"] = false,
            ["<Leader>Tf"] = false,
            ["<Leader>T<CR>"] = false,
            ["<Leader>To"] = false,
            ["<Leader>Tp"] = false,
            ["<Leader>TO"] = false,

            [prefix] = { desc = "󰗇 neotest" },
            [prefix .. "r"] = { function() require("neotest").run.run() end, desc = "Run nearest" },
            [prefix .. "d"] = { function() require("neotest").run.run { strategy = "dap" } end, desc = "Debug test" },
            [prefix .. "f"] = {
              function() require("neotest").run.run(vim.fn.expand "%") end,
              desc = "Run all tests in file",
            },
            [prefix .. "p"] = {
              function() require("neotest").run.run(vim.fn.getcwd()) end,
              desc = "Run all tests in project",
            },
            [prefix .. "w"] = {
              function() require("neotest").watch.toggle(vim.fn.expand "%") end,
              desc = "Watch project",
            },
            [prefix .. "s"] = { function() require("neotest").summary.toggle() end, desc = "Test Summary" },
            [prefix .. "o"] = { function() require("neotest").output.open() end, desc = "Output hover" },
            [prefix .. "O"] = { function() require("neotest").output_panel.toggle() end, desc = "Output window" },
            ["]" .. prefix] = { function() require("neotest").jump.next() end, desc = "Next test" },
            ["[" .. prefix] = { function() require("neotest").jump.prev() end, desc = "previous test" },
          },
        },
      },
    },
  },
  opts = {
    adapters = {
      ["neotest-python"] = {
        args = { "--log-level", "DEBUG" },
        runner = "pytest",
      },
      ["neotest-plenary"] = {
        args = { "-m", "plenary" },
      },
      ["neotest-go"] = {
        args = { "-v" },
        runner = "go test",
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
}
