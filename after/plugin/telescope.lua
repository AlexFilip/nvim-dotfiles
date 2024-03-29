local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Search for files" })
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Git search" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Search buffers" })
vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = "Search file contents" })

