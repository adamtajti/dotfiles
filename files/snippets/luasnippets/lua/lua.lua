return {
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
}
