return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = false, -- Enable debugging
			-- See Configuration section for rest
			prompts = {
				Explain = "Explain how it works.",
				Review = "Review the following code and provide concise suggestions.",
				Tests = "Briefly explain how the selected code works, then generate unit tests.",
				Refactor = "Refactor the code to improve clarity and readability.",
			},
		},
		cmd = {
			"CopilotChat",
			"CopilotChatDebugInfo",
			"CopilotChatFix",
			"CopilotChatDocs",
			"CopilotChatLoad",
			"CopilotChatOpen",
			"CopilotChatSave",
			"CopilotChatStop",
			"CopilotChatClose",
			"CopilotChatReset",
			"CopilotChatTests",
			"CopilotChatCommit",
			"CopilotChatReview",
			"CopilotChatToggle",
			"CopilotChatExplain",
			"CopilotChatOptimize",
			"CopilotChatRefactor",
			"CopilotChatCommitStaged",
			"CopilotChatFixDiagnostic",
		},
		-- See Commands section for default commands if you want to lazy load on them
		keys = {
			{ "<leader>acb", ":CopilotChatBuffer<cr>",      desc = "CopilotChat - Buffer" },
			{ "<leader>ace", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>act", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
			{
				"<leader>acT",
				"<cmd>CopilotChatVsplitToggle<cr>",
				desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
			},
			{
				"<leader>acv",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>acc",
				":CopilotChatInPlace<cr>",
				mode = { "n", "x" },
				desc = "CopilotChat - Run in-place code",
			},
			{
				"<leader>acf",
				"<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
				desc = "CopilotChat - Fix diagnostic",
			},
		},
	},
}
