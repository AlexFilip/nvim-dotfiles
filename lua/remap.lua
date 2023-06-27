
-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Open directory current file is in" })

-- Consistency is key
vim.keymap.set("n", "Y", "y$", { desc = "Copy to end of line" })

-- Copy input null buffer
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete to null buffer" })
vim.keymap.set("n", "<leader>c", "\"_c", { desc = "Change without cutting" })
vim.keymap.set("n", "<leader>x", "\"_x", { desc = "Delete without cutting" })

vim.keymap.set("n", "<leader>p", "\"+p", { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>P", "\"+P", { desc = "Paste before from system clipboard" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+y$", { desc = "Copy to end of line with system clipboard" })

vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete to system clipboard" })
vim.keymap.set("v", "<leader>p", "\"_dP", { desc = "Replace text without cutting" })
vim.keymap.set("v", "<leader>c", "\"_c", { desc = "Change without cutting" })

vim.keymap.set("i", "<Up>", "<C-p>", { desc = "Previous in completion list" });
vim.keymap.set("i", "<Down>", "<C-n>", { desc = "Next in completion list" });

vim.keymap.set("n", "<leader>n", function()
    vim.o.relativenumber = not vim.o.relativenumber
    vim.o.number = not vim.o.number
end, { desc = "Toggle line and relative numbers" })

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>di", function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = "Toggle diff" })

vim.keymap.set("t", "<C-w>",  "<C-\\><C-n><C-w>", { desc = "Win commands in terminal" })
vim.keymap.set("t", "<C-w>[", "<C-\\><C-n>", { desc = "Change to normal mode in terminal" })
vim.keymap.set("t", "<C-w><C-[>", "<C-\\><C-n>", { desc = "Change to normal mode in terminal" })

vim.keymap.set("n", "<CR>j", "o<Esc>", { desc = "Make new line below" })
vim.keymap.set("n", "<CR>k", "O<Esc>", { desc = "Make new line above" })

vim.keymap.set("n", "<CR>",    "", { desc = "Don't respond to <CR>" })
vim.keymap.set("n", "<Del>",   "", { desc = "Don't respond to <Del>" })
vim.keymap.set("n", "<Space>", "", { desc = "Don't respond to <Space>" })

vim.keymap.set("v", "<CR>",    "", { desc = "Don't respond to <CR>" })
vim.keymap.set("v", "<Del>",   "", { desc = "Don't respond to <Del>" })
vim.keymap.set("v", "<Space>", "", { desc = "Don't respond to <Space>" })

vim.keymap.set("o", "<CR>",    "", { desc = "Don't respond to <CR>" })
vim.keymap.set("o", "<Del>",   "", { desc = "Don't respond to <Del>" })
vim.keymap.set("o", "<Space>", "", { desc = "Don't respond to <Space>" })

vim.keymap.set("n", "Q", "", { desc = "Don't respond to Q" })

vim.keymap.set("c", "<C-f>", "<Right>", { desc = "Forward" })
vim.keymap.set("c", "<C-b>", "<Left>", { desc = "Back" })
vim.keymap.set("c", "<C-a>", "<C-b>", { desc = "Beginning" })
vim.keymap.set("c", "<C-d>", "<Del>", { desc = "Delete" })

vim.keymap.set("c", "<C-W>", "\\<\\><Left><Left>", { desc = "Search for word" })

-- Move selected lines up and down
vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv", { desc = "Move lines down and match indent" })
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv", { desc = "Move lines up and match indent" })

-- Horizontal scrolling. Only useful when wrap is turned off.
vim.keymap.set("n", "<C-J>", "zl", { desc = "Scroll right" })
vim.keymap.set("n", "<C-H>", "zh", { desc = "Scroll left" })

-- Make current file executable
vim.keymap.set("n", "<leader>ex", function()
    local filename = vim.fn.expand("%")
    local is_executable = vim.fn.executable("./" .. filename)

    local sign = "+"
    if is_executable ~= 0 then
        sign = "-"
    end

    local command = { "chmod", sign .. "x", filename }
    vim.fn.system(command)
end, { desc = "Toggle executable flag on current file" })

function GotoBeginningOfLine()
    local command = "0"
    if vim.fn.indent(".") + 1 ~= vim.fn.col(".") then
        command = "^"
    end
    vim.cmd { cmd = "normal", args = {command}, bang = true }
end

vim.keymap.set("n", "0", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("n", "^", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("n", "-", "$", { desc = "Go to end of line" })

vim.keymap.set("v", "0", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("v", "^", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("v", "-", "$", { desc = "Go to end of line" })

vim.keymap.set("o", "0", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("o", "^", GotoBeginningOfLine, { desc = "Go to beginning of line" })
vim.keymap.set("o", "-", "$", { desc = "Go to end of line" })

