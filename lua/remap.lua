
-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex)

-- Consistency is key
vim.keymap.set("n", "Y", "y$")

-- Copy input null buffer
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>c", "\"_c")
vim.keymap.set("n", "<leader>x", "\"_x")

vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+y$")

vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>n", function()
    vim.o.relativenumber = not vim.o.relativenumber
    vim.o.number = not vim.o.number
end)

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>di", function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end)

vim.keymap.set("t", "<C-w>",  "<C-\\><C-n><C-w>")
vim.keymap.set("t", "<C-w>[", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w><C-[>", "<C-\\><C-n>")

vim.keymap.set("n", "<CR>j", "o<Esc>")
vim.keymap.set("n", "<CR>k", "O<Esc>")

vim.keymap.set("n", "<CR>",    "")
vim.keymap.set("n", "<Del>",   "")
vim.keymap.set("n", "<Space>", "")

vim.keymap.set("v", "<CR>",    "")
vim.keymap.set("v", "<Del>",   "")
vim.keymap.set("v", "<Space>", "")

vim.keymap.set("o", "<CR>",    "")
vim.keymap.set("o", "<Del>",   "")
vim.keymap.set("o", "<Space>", "")

vim.keymap.set("n", "Q", "")

vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-a>", "<C-b>")
vim.keymap.set("c", "<C-d>", "<Del>")

vim.keymap.set("c", "<C-W>", "\\<\\><Left><Left>")

-- Move selected lines up and down
vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv")

-- Horizontal scrolling. Only useful when wrap is turned off.
vim.keymap.set("n", "<C-J>", "zl")
vim.keymap.set("n", "<C-H>", "zh")

-- Make current file executable
vim.keymap.set("n", "<leader>ex", function()
    local filename = vim.fn.expand("%")
    local sign = "+"
    local is_executable = vim.fn.executable("./" .. filename)

    if is_executable ~= 0 then
        sign = "-" 
    end

    local command = { "chmod", sign .. "x", filename }
    vim.fn.system(command)
end)

function GotoBeginningOfLine()
    local command = "0"
    if vim.fn.indent(".") + 1 ~= vim.fn.col(".") then
        command = "^"
    end
    vim.cmd { cmd = "normal", args = {command}, bang = true }
end

vim.keymap.set("n", "0", GotoBeginningOfLine)
vim.keymap.set("n", "^", GotoBeginningOfLine)
vim.keymap.set("n", "-", "$")

vim.keymap.set("v", "0", GotoBeginningOfLine)
vim.keymap.set("v", "^", GotoBeginningOfLine)
vim.keymap.set("v", "-", "$")

vim.keymap.set("o", "0", GotoBeginningOfLine)
vim.keymap.set("o", "^", GotoBeginningOfLine)
vim.keymap.set("o", "-", "$")

