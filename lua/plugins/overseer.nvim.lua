return {
	"stevearc/overseer.nvim",
	cmd = {
		"OverseerOpen",
		"OverseerClose",
		"OverseerToggle",
		"OverseerSaveBundle",
		"OverseerLoadBundle",
		"OverseerDeleteBundle",
		"OverseerRunCmd",
		"OverseerRun",
		"OverseerInfo",
		"OverseerBuild",
		"OverseerQuickAction",
		"OverseerTaskAction ",
		"OverseerClearCache",
	},
	---@param opts overseer.Config
	opts = function(_, opts)
		local astrocore = require("astrocore")
		if astrocore.is_available("toggleterm.nvim") then
			opts.strategy = { "toggleterm", direction = "vertical" }
		end
		opts.task_list = {
			bindings = {
				["<C-l>"] = false,
				["<C-h>"] = false,
				["<C-k>"] = false,
				["<C-j>"] = false,
				q = "<Cmd>close<CR>",
				K = "IncreaseDetail",
				J = "DecreaseDetail",
				["<C-p>"] = "ScrollOutputUp",
				["<C-n>"] = "ScrollOutputDown",
			},
		}
	end,
	dependencies = {
		{ "AstroNvim/astroui", opts = { icons = { Overseer = "" } } },
		{
			"AstroNvim/astrocore",
			opts = function(_, opts)
				local maps = opts.mappings
				local prefix = "<leader>m"
				maps.n[prefix] = { desc = require("astroui").get_icon("Overseer", 1, true) .. "Overseer" }

				maps.n[prefix .. "t"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer" }
				maps.n[prefix .. "c"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Run Command" }
				maps.n[prefix .. "r"] = { "<Cmd>OverseerRun<CR>", desc = "Run Task" }
				maps.n[prefix .. "R"] = {
					function()
						local overseer = require("overseer")
						local tasks = overseer.list_tasks({ recent_first = true })
						if vim.tbl_isempty(tasks) then
							vim.notify("No tasks found", vim.log.levels.WARN)
						else
							overseer.run_action(tasks[1], "restart")
						end
					end,
					desc = "Rerun Last Action",
				}
				maps.n[prefix .. "q"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
				maps.n[prefix .. "a"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Action" }
				maps.n[prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Overseer Info" }
			end,
		},
	},
}
