
-- NOTE: Untested
vim.keymap.set("n", "<leader>gd", function() vim.cmd 'vert Gdiffsplit!' end, { desc = "Solve merge conflict or git diff" })
vim.keymap.set("n", "<leader>gh", function() vim.cmd 'diffget //2' end, { desc = "Select left in conflict resolution" })
vim.keymap.set("n", "<leader>gl", function() vim.cmd 'diffget //3' end, { desc = "Select right in conflict resolution" })

