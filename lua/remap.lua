
-- local util = require("util")

local exports = {}

local function keymap(mode, keybinding, mapping, extra)
    -- print(mode .. "noremapping " .. keybinding .. " to " .. util.stringify(mapping))
    vim.keymap.set(mode, keybinding, mapping, extra)
end

exports.keymap = keymap

-- Create functions for all of the noremaps
for _, mode in ipairs({"n", "v", "c", "i", "t"}) do
    local fnName = mode .. "noremap"
    local mappingFunction = function(keybinding, mapping, extra)
        keymap(mode, keybinding, mapping, extra)
    end

    _G[fnName] = mappingFunction
    exports[fnName] = mappingFunction
end

local function operatorToRegister(modes, prefix, register, ops)
    for k, operator in pairs(ops) do
        local keyBinding = k

        if type(k) == "number" then
            keyBinding = operator
        end

        local extraArg = { desc = operator .. " operator on " .. register.name .. " register" }
        for _, mode in ipairs(modes) do
            keymap(mode, prefix.on(keyBinding), register.on(operator), extraArg)
        end
    end
end

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
local nullRegister = makeRegister("null", "_")

-- Leader mappings
vim.g.mapleader = " "

-- Open vim explore
nnoremap(leader.on("ef"), vim.cmd.Ex, { desc = "Open directory current file is in" })

-- Consistency is key
nnoremap("Y", "y$", { desc = "Copy to end of line" })

local operators = { "d", "c", "p", "P", "y", Y = "y$" }
operatorToRegister({ "n", "v" }, carriageReturn, nullRegister, operators) -- Use null register
operatorToRegister({ "n", "v" }, leader,       systemRegister, operators) -- Use system register
vnoremap(carriageReturn.on("p"), nullRegister.on("dP"), { desc = "Replace text without cutting" }) -- special case

--
inoremap("<Up>",   "<C-p>", { desc = "Previous in completion list" });
inoremap("<Down>", "<C-n>", { desc = "Next in completion list" });

nnoremap(leader.on("cp"), function()
    local absolute_path = vim.fn.getcwd():gsub("[\n\r]", "")

    -- TODO: Make this use a copy function supplied by clipboard.lua
    --   This should become clipboard.copy(clipboard.system, absolute_path)
    vim.fn.systemlist("echo '" .. absolute_path .. "' | wl-copy", {""}, 1) -- "1" keeps empty lines
    print("Copied current path (" .. absolute_path .. ") to clipboard")

end, { desc = "Copy current path to clipboard" })

nnoremap(leader.on("nn"), function()
    vim.o.number = not vim.o.number
end, { desc = "Toggle line numbers" })

nnoremap(leader.on("nr"), function()
    vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative numbers" })

nnoremap(leader.on("s"), ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search word under cursor" })
nnoremap(leader.on("df"), function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = "Toggle diff" })

tnoremap("<C-w>",  "<C-\\><C-n><C-w>", { desc = "Win commands in terminal" })
tnoremap("<C-w>[", "<C-\\><C-n>",      { desc = "Change to normal mode in terminal" })
tnoremap("<C-w><C-[>", "<C-\\><C-n>",  { desc = "Change to normal mode in terminal" })

local function doNotRespond(modes, keys)
    for _, mode in ipairs(modes) do
        for _, key in ipairs(keys) do
            keymap(mode, key, "", { desc = "Don't respond to " .. key })
        end
    end
end

doNotRespond({ "n", "v", "o" }, { "<CR>", "<Del>", "<BS>", "<Space>", "Q" })

nnoremap(carriageReturn.on("j"), "o<Esc>", { desc = "Make new line below" })
nnoremap(carriageReturn.on("k"), "O<Esc>", { desc = "Make new line above" })

cnoremap("<C-f>", "<Right>", { desc = "Forward" })
cnoremap("<C-b>", "<Left>", { desc = "Back" })
cnoremap("<C-a>", "<C-b>", { desc = "Beginning" })
cnoremap("<C-d>", "<Del>", { desc = "Delete" })

cnoremap("<C-W>", "\\<\\><Left><Left>", { desc = "Search for word" })

-- Move selected lines up and down
vnoremap("<C-J>", ":m '>+1<CR>gv=gv", { desc = "Move lines down and match indent" })
vnoremap("<C-K>", ":m '<-2<CR>gv=gv", { desc = "Move lines up and match indent" })
-- vnoremap <C-J> :m '>+1<CR>gv=gv
-- vnoremap <C-K> :m '<-2<CR>gv=gv

-- Horizontal scrolling. Only useful when wrap is turned off.
nnoremap("<C-J>", "zl", { desc = "Scroll right" })
nnoremap("<C-H>", "zh", { desc = "Scroll left" })

-- Make current file executable
nnoremap(leader.on("ex"), function()
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
            keymap(mode, s, GotoBeginningOfLine, { desc = "Go to beginning of line" })
        end
        keymap(mode, "-", "$", { desc = "Go to end of line" })
    end
end

mapLineMotions({"n", "v", "o"})

return exports

