
local util = require("util")

local function makeOperatorPrefix(name, prefix)
    local result = {
        name = name,
        -- prefix = prefix,
        on = function(operator)
            return prefix .. operator
        end
    }
    return result
end

local         leader = makeOperatorPrefix("Leader",    "<leader>")
local carriageReturn = makeOperatorPrefix("Return",    "<CR>")
local         delete = makeOperatorPrefix("Delete",    "<Del>")
local      backspace = makeOperatorPrefix("Backspace", "<BS>")

local function makeRegister(name, prefix)
    local result = {
        name = name,
        -- prefix = prefix,
        on = function(operator)
            return "\"" .. prefix .. operator
        end
    }

    return result
end

local systemRegister = makeRegister("system", "+")
local nullRegister   = makeRegister("null", "_")

-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
util.nnoremap(leader.on("ef"), vim.cmd.Ex, { desc = "Open directory current file is in" })

-- Consistency is key
util.nnoremap("Y", "y$", { desc = "Copy to end of line" })

-- leader and carriage-return + command
local function operatorToRegister(modes, prefix, register, ops)
    for k, operator in pairs(ops) do
        local keyBinding = k

        if type(k) == "number" then
            keyBinding = operator
        end

        local extraArg = { desc = operator .. " operator on " .. register.name .. " register" }
        for _, mode in ipairs(modes) do
            util.keymap(mode, prefix.on(keyBinding), register.on(operator), extraArg)
        end
    end
end

local operators = { "d", "c", "p", "P", "y", Y = "y$" }
operatorToRegister({ "n", "v" }, carriageReturn, nullRegister, operators) -- Use null register
operatorToRegister({ "n", "v" }, leader,       systemRegister, operators) -- Use system register
util.vnoremap(carriageReturn.on("p"), nullRegister.on("dP"), { desc = "Replace text without cutting" }) -- special case

local clipboard_copy = util.copy_command("")
util.nnoremap(leader.on("cp"), function()
    local absolute_path = vim.fn.getcwd():gsub("[\n\r]", "")
    clipboard_copy(absolute_path)
    print("Copied current path (" .. absolute_path .. ") to clipboard")
end, { desc = "Copy current path to clipboard" })

util.nnoremap(leader.on("nn"), function()
    vim.o.number = not vim.o.number
end, { desc = "Toggle line numbers" })

util.nnoremap(leader.on("nr"), function()
    vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative numbers" })

util.nnoremap(leader.on("s"), ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search word under cursor" })
util.nnoremap(leader.on("df"), function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = "Toggle diff" })

util.tnoremap("<C-w>",  "<C-\\><C-n><C-w>", { desc = "Win commands in terminal" })
util.tnoremap("<C-w>[", "<C-\\><C-n>",      { desc = "Change to normal mode in terminal" })
util.tnoremap("<C-w><C-[>", "<C-\\><C-n>",  { desc = "Change to normal mode in terminal" })

-- Do not respond to these keys
for _, mode in ipairs({ "n", "v", "o" }) do
    for _, key in ipairs({ "<CR>", "<Del>", "<BS>", "<Space>", "Q" }) do
        util.keymap(mode, key, "", { desc = "Don't respond to " .. key })
    end
end

util.nnoremap(carriageReturn.on("j"), "o<Esc>", { desc = "Make new line below" })
util.nnoremap(carriageReturn.on("k"), "O<Esc>", { desc = "Make new line above" })

util.cnoremap("<C-f>", "<Right>", { desc = "Forward" })
util.cnoremap("<C-b>", "<Left>", { desc = "Back" })
util.cnoremap("<C-a>", "<C-b>", { desc = "Beginning" })
util.cnoremap("<C-d>", "<Del>", { desc = "Delete" })

util.cnoremap("<C-W>", "\\<\\><Left><Left>", { desc = "Search for word" })

-- Move selected lines up and down
util.vnoremap("<C-J>", ":m '>+1<CR>gv=gv", { desc = "Move lines down and match indent" })
util.vnoremap("<C-K>", ":m '<-2<CR>gv=gv", { desc = "Move lines up and match indent" })
-- util.vnoremap <C-J> :m '>+1<CR>gv=gv
-- util.vnoremap <C-K> :m '<-2<CR>gv=gv

-- Horizontal scrolling. Only useful when wrap is turned off.
util.nnoremap("<C-J>", "zl", { desc = "Scroll right" })
util.nnoremap("<C-H>", "zh", { desc = "Scroll left" })

-- Make current file executable
util.nnoremap(leader.on("ex"), function()
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

for _, mode in ipairs({"n", "v", "o"}) do
    for _, s in ipairs({ "0", "^" }) do
        util.keymap(mode, s, GotoBeginningOfLine, { desc = "Go to beginning of line" })
    end
    util.keymap(mode, "-", "$", { desc = "Go to end of line" })
end

