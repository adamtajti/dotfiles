-- Tree-sitter is an incremental syntax tree builder plugin
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = function()
		require("nvim-treesitter.configs").setup({
			indent = {
				enable = true,
				disable = { "yaml" },
			},
			-- A list of parser names, or "all"
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"cmake",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"gitignore",
				"gitcommit",
				"go",
				"gomod",
				"html",
				"http",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"latex",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"ninja",
				"nix",
				"norg",
				"org",
				"php",
				"proto",
				"python",
				"query",
				"regex",
				"ruby",
				"sql",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"terraform",
				"scss",
				"ini",
				"angular",
				"awk",
				"comment",
				"disassembly",
				"doxygen",
				"erlang",
				"glsl",
				"gosum",
				"gowork",
				"graphql",
				"haskell",
				"hlsl",
				"hyprlang",
				"java",
				"luadoc",
				"muttrc",
				"requirements",
				"tsv",
				"xml",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,
			-- List of parsers to ignore installing (for "all")
			ignore_install = {},
			autopairs = {
				enable = true,
			},
			highlight = {
				-- `false` will disable the whole extension
				enable = true,
				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = function(lang, bufnr)
					if lang == "cpp" then
						return vim.api.nvim_buf_line_count(bufnr) > 50000
					elseif lang == "json" then
						return vim.api.nvim_buf_line_count(bufnr) > 50000
					elseif lang == "make" then
						return vim.api.nvim_buf_line_count(bufnr) > 10000
					end

					return false
				end,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = true,
			},
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			textsubjects = {
				enable = true,
				prev_selection = ",",
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = "textsubjects-container-inner",
				},
			},
			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = false, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
					goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
				},
				lsp_interop = {
					enable = false,
					peek_definition_code = {
						["gD"] = "@function.outer",
					},
				},
			},
		})

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.markdown.filetype_to_parsername = "octo"

		vim.o.foldmethod = "expr"
		vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		vim.o.foldenable = true
	end,
}
