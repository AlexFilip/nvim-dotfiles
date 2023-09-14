
-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "Open directory current file is in" })

-- Consistency is key
vim.keymap.set("n", "Y", "y$", { desc = "Copy to end of line" })

local function operatorToRegister(modes, front, register, ops)
    for _, op in ipairs(ops) do
        local key = ""
        local value = ""

        if type(op) == "table" then
            key = front .. op[1]
            value = register .. op[2]
        else
            key = front .. op
            value = register .. op
        end

        -- TODO: Include description as last argument { desc = "..." }
        for _, mode in ipairs(modes) do
            vim.keymap.set(mode, key, value)
        end
    end
end

local operators = { "d", "c", "p", "P", "y", { "Y", "y$" } }
operatorToRegister({ "n", "v" }, "<CR>", "\"_", operators) -- Use null register
operatorToRegister({ "n", "v" }, "<leader>", "\"+", operators) -- Use system register
vim.keymap.set("v", "<leader>p", "\"_dP", { desc = "Replace text without cutting" }) -- special case

--
vim.keymap.set("i", "<Up>",   "<C-p>", { desc = "Previous in completion list" });
vim.keymap.set("i", "<Down>", "<C-n>", { desc = "Next in completion list" });

vim.keymap.set("n", "<leader>n", function()
    vim.o.relativenumber = not vim.o.relativenumber
    vim.o.number = not vim.o.number
end, { desc = "Toggle line and relative numbers" })

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>df", function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = "Toggle diff" })

vim.keymap.set("t", "<C-w>",  "<C-\\><C-n><C-w>", { desc = "Win commands in terminal" })
vim.keymap.set("t", "<C-w>[", "<C-\\><C-n>", { desc = "Change to normal mode in terminal" })
vim.keymap.set("t", "<C-w><C-[>", "<C-\\><C-n>", { desc = "Change to normal mode in terminal" })

local function doNotRespond(modes, keys)
    for _, mode in ipairs(modes) do
        for _, key in ipairs(keys) do
            vim.keymap.set(mode, key, "", { desc = "Don't respond to " .. key })
        end
    end
end

doNotRespond({ "n", "v", "o" }, { "<CR>", "<Del>", "<Space>", "Q" })

vim.keymap.set("n", "<CR>j", "o<Esc>", { desc = "Make new line below" })
vim.keymap.set("n", "<CR>k", "O<Esc>", { desc = "Make new line above" })

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

local function GotoBeginningOfLine()
    local command = "0"
    if vim.fn.indent(".") + 1 ~= vim.fn.col(".") then
        command = "^"
    end
    vim.cmd { cmd = "normal", args = {command}, bang = true }
end

local function mapLineMotions(modes)
    for _, mode in ipairs(modes) do
        for _, s in ipairs({ "0", "^" }) do
            vim.keymap.set(mode, s, GotoBeginningOfLine, { desc = "Go to beginning of line" })
        end
        vim.keymap.set(mode, "-", "$", { desc = "Go to end of line" })
    end
end

mapLineMotions({"n", "v", "o"})

