return {
	s(
		"p-snippet",
		t({
			"s(",
			"  'p-',",
			"  t({",
			"    '',",
			"  })",
			"),",
		})
	),
	s(
		"p-iterate-table-dictionary",
		t({
			"for i, entry in pairs(entries) do",
			"end",
		})
	),
	s(
		"p-iterate-table-array",
		t({
			"for i, entry in ipairs(entries) do",
			"end",
		})
	),
	s(
		"p-nvim-isdirectory",
		t({
			"vim.fn.isdirectory(dir) ~= 0",
		})
	),
	s("p-nvim-nui-popup-example", {
		t({ '			local Popup = require("nui.popup")', "" }),
		t({ '			local event = require("nui.utils.autocmd").event', "" }),
		t({ "			local popup = Popup({", "" }),
		t({ "				enter = true,", "" }),
		t({ "				focusable = true,", "" }),
		t({ "				border = {", "" }),
		t({ '					style = "rounded",', "" }),
		t({ "				},", "" }),
		t({ '				position = "50%",', "" }),
		t({ "				size = {", "" }),
		t({ '					width = "80%",', "" }),
		t({ '					height = "60%",', "" }),
		t({ "				},", "" }),
		t({ "			})", "" }),
		t({ "			-- mount/open the component", "" }),
		t({ "			popup:mount()", "" }),
		t({ "			-- unmount component when cursor leaves buffer", "" }),
		t({ "			popup:on(event.BufLeave, function()", "" }),
		t({ "				popup:unmount()", "" }),
		t({ "			end)", "" }),
		t({ "			local snippet_content_for_nui = utils.ensure_string_array(snippet)", "" }),
		t({ "			vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, snippet_content_for_nui)", "" }),
	}),
}
