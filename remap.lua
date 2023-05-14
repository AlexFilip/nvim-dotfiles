
-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "Y", "y$")

-- Copy input null buffer
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>c", "\"_c")
vim.keymap.set("n", "<leader>p", "\"_p")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")

vim.keymap.set("n", "<leader>di", function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end)
