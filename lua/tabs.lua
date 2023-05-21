
-- TODO: Add tab management and drawing functions here
-- Shortcuts
vim.keymap.set("n", "<leader>cv", function() vim.cmd 'vnew' end)
vim.keymap.set("n", "<leader>ct", function() vim.cmd 'tabnew' end)
-- vim.keymap.set("n", "<leader>tv",  vim.cmd 'vnew | wincmd H')

vim.keymap.set("n", "<C-p>", "gt")
vim.keymap.set("n", "<C-n>", "gT")

