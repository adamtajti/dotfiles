local H = {}

-- Toggles QuickFix window (Bookmars, References frequently use this functionality)
H.ToggleQuickFix = function()
	if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
		vim.cmd([[copen]])
	else
		vim.cmd([[cclose]])
	end
end

return H
