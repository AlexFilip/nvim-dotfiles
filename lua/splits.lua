
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
end)

vim.keymap.set("n", "<M-k>", function()
    vim.cmd.wincmd("k")
end)

vim.keymap.set("n", "<M-j>", function()
    vim.cmd.wincmd("j")
end)

vim.keymap.set("n", "<M-h>", function()
    vim.cmd.wincmd("h")
end)

vim.keymap.set("n", "<M-l>", function()
    vim.cmd.wincmd("l")
end)
