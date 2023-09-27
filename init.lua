local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local maps = require("astronvim.utils").empty_map_table()
maps.n["<leader>m"] = {
    desc = "󱖫 " .. "Neotest"
}

return {
    mappings = maps,
    lsp = {
        formatting = {
            format_on_save = {
                enabled = true, -- enable format on save
                ignore_filetypes = { -- disable format on save for specified filetypes
                "markdown", "python"}
            }
        }
    },
    plugins = {{
        "easymotion/vim-easymotion",
        config = function()
            require("easymotion").set_default_keymaps()
        end
    }, {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75
                }

            })
        end

    }, {
        "wakatime/vim-wakatime",
        lazy = false

    }, {"rebelot/kanagawa.nvim"}, {"AlexvZyl/nordic.nvim"}, {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require'lsp_signature'.setup(opts)
        end
    }, {
        "nvim-neotest/neotest",
        dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "antoinemadec/FixCursorHold.nvim",
                        "nvim-neotest/neotest-python", "nvim-neotest/neotest-plenary"},
        opts = {
            -- Can be a list of adapters like what neotest expects,
            -- or a list of adapter names,
            -- or a table of adapter names, mapped to adapter configs.
            -- The adapter will then be automatically loaded with the config.
            adapters = {
                ["neotest-python"] = {
                    args = {"--log-level", "DEBUG"},
                    runner = "pytest"

                },
                ["neotest-plenary"] = {
                    args = {"-m", "plenary"}
                }

            },

            status = {
                virtual_text = true
            },
            output = {
                open_on_run = true
            }
        },
        config = function(_, opts)
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+",
                            "")
                        return message
                    end
                }
            }, neotest_ns)

            if opts.adapters then
                local adapters = {}
                for name, config in pairs(opts.adapters or {}) do
                    if type(name) == "number" then
                        if type(config) == "string" then
                            config = require(config)
                        end
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
        keys = {{
            "<leader>mt",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run File"
        }, {
            "<leader>mT",
            function()
                require("neotest").run.run(vim.loop.cwd())
            end,
            desc = "Run All Test Files"
        }, {

            "<leader>mw",
            function()
                require("neotest").watch.toggle(vim.fn.expand("%"))
            end,
            desc = "Watch current file"
        }, {
            "<leader>mr",
            function()
                require("neotest").run.run()
            end,
            desc = "Run Nearest"
        },
{
            "<leader>ml",
            function()
                require("neotest").run.run_last()
            end,
            desc = "Rerun last test"
        },

                {
            "<leader>ms",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle Summary"
        }, {
            "<leader>mo",
            function()
                require("neotest").output.open({
                    enter = true,
                    auto_close = true
                })
            end,
            desc = "Show Output"
        }, {
            "<leader>mO",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle Output Panel"
        }, {
            "<leader>mS",
            function()
                require("neotest").run.stop()
            end,
            desc = "Stop"
        }}
    }},
    colorscheme = "kanagawa-dragon"

}
