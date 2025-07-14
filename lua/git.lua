
local util = require('util')

util.keymap("n", "<leader>gd", function() vim.cmd 'vert Gdiffsplit!' end, { desc = "Solve merge conflict or git diff" })
util.keymap("n", "<leader>gh", function() vim.cmd 'diffget //2' end, { desc = "Select left in conflict resolution" })
util.keymap("n", "<leader>gl", function() vim.cmd 'diffget //3' end, { desc = "Select right in conflict resolution" })

util.keymap("n", "<leader>gp", function() vim.cmd 'Git push' end, { desc = "git push" })
util.keymap("n", "<leader>gfp", function() vim.cmd 'Git push --force-with-lease' end, { desc = "git force push" })

