local exports = {}
local util = require('util')

local homeDirectory = os.getenv('HOME')
exports.homeDirectory = homeDirectory

local undo_dir = homeDirectory .. "/.local/nvim-undos"
if not vim.fn.isdirectory(undo_dir) then
    vim.fn.mkdir(undo_dir)
end

local newFormatoptions = vim.o.formatoptions .. "n"
local newCinkeys       = vim.o.cinkeys:gsub(",0#", "")

util.setValuesInObject(vim.o, {
    -- Persistent Undo
    undofile   = true,     -- Save undos after file closes
    undolevels = 1000,     -- How many undos
    undoreload = 10000,    -- number of lines to save for undo
    undodir    = undo_dir, -- where to save undo histories

    -- Miscellaneous
    splitright = true,          -- Vertical split goes right, not left
    showcmd    = true,          -- Show the current command in operator pending mode
    cursorline = true,          -- Make the cursor line a visible color
    showmode   = false,         -- Don't show -- INSERT --
    mouse      = "a",           -- Allow mouse input
    sidescroll = 1,             -- Number of columns to scroll left and right
    backspace  = "indent",      -- allow backspacing only over automatic indenting (:help 'backspace')
    wildmenu   = true,          -- Display a menu of all completions for commands when pressing tab
    number     = false,         -- Do not show line numbers
    signcolumn = "yes",         -- always show the sidebar with signs for diagnostics

    -- Leading tabs (trailing spaces coming soon)
    list      = true,              -- Show hidden characters
    listchars = "tab:>-<,trail:/", -- Add tabs and spaces to list of hidden chars

    -- listchars = "tab:>-<,leadmultispace:---|" -- Add tabs and spaces to list of hidden chars
    -- <- there is a tab here, which should be visible, and trailing spaces here -> --     

    -- Don't wrap long lines
    wrap        = false,
    linebreak   = true,
    breakindent = true,

    breakindentopt = "shift:0,min:20",
    formatoptions  = newFormatoptions,
    virtualedit    = "block",  -- Visual block mode is not limited to the character locations

    fixendofline = false, -- Don't insert an end of line at the end of the file
    eol          = false, -- Give it a mean look so it understands

    -- Folding
    -- foldenable = true
    foldmethod = "indent",
    foldlevel  = 99, -- Don't open a file fully folded
    -- zc to close fold, zo to open, zM to close all folds, zR to open all

    -- Indenting
    tabstop     = 4,
    shiftwidth  = 0,
    softtabstop = -1,
    expandtab   = true,
    cindent     = true,
    cinoptions  = "l1,=4,:4,(0,{0,+2,w1,W4,t0,j1,J1",
    shortmess   = "fFcCtToOsSiIlnxW",
    cinkeys     = newCinkeys,

    viminfo     = "",
    display     = "lastline",
    swapfile    = false,
    hlsearch    = true,
    incsearch   = true,
    -- colorcolumn = '80',
    -- scrolloff   = 5,
    updatetime  = 50,

    -- Docs: http://vimhelp.appspot.com/eval.txt.html
    fillchars="stlnc:|,vert:|,fold:.,diff:.",
})

util.setValuesInObject(vim.g, {
    netrw_liststyle = 0,
    netrw_banner    = 0,
    netrw_keepdir   = 1,
})

function exports.syntax(flag)
    vim.cmd.syntax(flag and "on" or "off")
end

return exports