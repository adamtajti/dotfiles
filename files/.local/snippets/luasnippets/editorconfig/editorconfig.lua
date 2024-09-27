return {
	s("p-editorconfig-basic-template", {
		t({ "root = true", "" }),
		t({ "[*]", "" }),
		t({ "end_of_line = lf", "" }),
		t({ "insert_final_newline = true", "" }),
		t({ "indent_style = space", "" }),
		t({ "indent_size = 2", "" }),
	}),
}
