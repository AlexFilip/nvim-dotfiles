
vim.keymap.set("n", "<M-s>", function()
    local layout = vim.fn.winlayout()

    -- Any layout of multiple splits will be turned into a single buffer view
    -- single buffer view will turn into 2 side-by-side buffers
    if layout[1] ~= 'leaf' then
        vim.cmd.wincmd("o")
    else
        -- TODO: If window is thinner than it is wide, make it use horizontal splits
        vim.cmd.vnew()
    end
end, { desc = "Toggle a vertical split" })

vim.keymap.set("n", "<M-k>", function()
    vim.cmd.wincmd("k")
end, { desc = "Move one pane up" })

vim.keymap.set("n", "<M-j>", function()
    vim.cmd.wincmd("j")
end, { desc = "Move one pane down" })

vim.keymap.set("n", "<M-h>", function()
    vim.cmd.wincmd("h")
end, { desc = "Move one pane left" })

vim.keymap.set("n", "<M-l>", function()
    vim.cmd.wincmd("l")
end, { desc = "Move one pane right" })
