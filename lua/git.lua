
local util = require('util')

-- NOTE: Untested
util.nnoremap("<leader>gd", function() vim.cmd 'vert Gdiffsplit!' end, { desc = "Solve merge conflict or git diff" })
util.nnoremap("<leader>gh", function() vim.cmd 'diffget //2' end, { desc = "Select left in conflict resolution" })
util.nnoremap("<leader>gl", function() vim.cmd 'diffget //3' end, { desc = "Select right in conflict resolution" })

util.nnoremap("<leader>gp", function() vim.cmd 'Git push' end, { desc = "git push" })
util.nnoremap("<leader>gfp", function() vim.cmd 'Git push --force-with-lease' end, { desc = "git force push" })

