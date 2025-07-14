
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
util.keymap("n", leader.on("ef"), vim.cmd.Ex, { desc = "Open directory current file is in" })

-- Consistency is key
util.keymap("n", "Y", "y$", { desc = "Copy to end of line" })

-- leader and carriage-return + command
local function operatorToRegister(modes, prefix, register, ops)
    for k, operator in pairs(ops) do
        local keyBinding = k

        if type(k) == "number" then
            keyBinding = operator
        end

        local extraArg = { desc = operator .. " operator on " .. register.name .. " register" }
        util.keymap(modes, prefix.on(keyBinding), register.on(operator), extraArg)
    end
end

local operators = { "d", "c", "p", "P", "y", Y = "y$" }
operatorToRegister({ "n", "v" }, carriageReturn, nullRegister, operators) -- Use null register
operatorToRegister({ "n", "v" }, leader,       systemRegister, operators) -- Use system register
util.keymap("v", carriageReturn.on("p"), nullRegister.on("dP"), { desc = "Replace text without cutting" }) -- special case

local clipboard_copy = util.copy_command("")
util.keymap("n", leader.on("cp"), function()
    local absolute_path = vim.fn.getcwd():gsub("[\n\r]", "")
    clipboard_copy(absolute_path)
    print("Copied current path (" .. absolute_path .. ") to clipboard")
end, { desc = "Copy current path to clipboard" })

util.keymap("n", leader.on("nn"), function()
    vim.o.number = not vim.o.number
end, { desc = "Toggle line numbers" })

util.keymap("n", leader.on("nr"), function()
    vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative numbers" })

util.keymap("n", leader.on("s"), ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search word under cursor" })
util.keymap("n", leader.on("df"), function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = "Toggle diff" })

util.keymap("t", "<C-w>",  "<C-\\><C-n><C-w>", { desc = "Win commands in terminal" })
util.keymap("t", "<C-w>[", "<C-\\><C-n>",      { desc = "Change to normal mode in terminal" })
util.keymap("t", "<C-w><C-[>", "<C-\\><C-n>",  { desc = "Change to normal mode in terminal" })

-- Do not respond to these keys
util.keymap({ "n", "v", "o" }, { "<CR>", "<Del>", "<BS>", "<Space>", "Q" }, "", { desc = "No-op" })

util.keymap("n", carriageReturn.on("j"), "o<Esc>", { desc = "Make new line below" })
util.keymap("n", carriageReturn.on("k"), "O<Esc>", { desc = "Make new line above" })

util.keymap("c", "<C-f>", "<Right>", { desc = "Forward" })
util.keymap("c", "<C-b>", "<Left>", { desc = "Back" })
util.keymap("c", "<C-a>", "<C-b>", { desc = "Beginning" })
util.keymap("c", "<C-d>", "<Del>", { desc = "Delete" })

util.keymap("c", "<C-W>", "\\<\\><Left><Left>", { desc = "Search for word" })

-- Move selected lines up and down
util.keymap("v", "<C-J>", ":m '>+1<CR>gv=gv", { desc = "Move lines down and match indent" })
util.keymap("v", "<C-K>", ":m '<-2<CR>gv=gv", { desc = "Move lines up and match indent" })
-- vnoremap <C-J> :m '>+1<CR>gv=gv
-- vnoremap <C-K> :m '<-2<CR>gv=gv

-- Horizontal scrolling. Only useful when wrap is turned off.
util.keymap("n", "<C-J>", "zl", { desc = "Scroll right" })
util.keymap("n", "<C-H>", "zh", { desc = "Scroll left" })

-- Make current file executable
util.keymap("n", leader.on("ex"), function()
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

util.keymap({"n", "v", "o"}, { "0", "^" }, GotoBeginningOfLine, { desc = "Go to beginning of line" })
util.keymap({"n", "v", "o"}, "-", "$", { desc = "Go to end of line" })
