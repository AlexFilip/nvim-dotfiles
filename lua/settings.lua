
local exports = {}

local homeDirectory = os.getenv('HOME')
exports.homeDirectory = homeDirectory

local undo_dir = homeDirectory .. "/.local/nvim-undos"
-- Persistent Undo
vim.o.undofile   = true     -- Save undos after file closes
vim.o.undolevels = 1000     -- How many undos
vim.o.undoreload = 10000    -- number of lines to save for undo
vim.o.undodir    = undo_dir -- where to save undo histories
if not vim.fn.isdirectory(undo_dir) then
    vim.fn.mkdir(undo_dir)
end

-- Miscellaneous
vim.o.splitright = true          -- Vertical split goes right, not left
vim.o.showcmd    = true          -- Show the current command in operator pending mode
vim.o.cursorline = true          -- Make the cursor line a visible color
vim.o.showmode   = false         -- Don't show -- INSERT --
vim.o.mouse      = "a"           -- Allow mouse input
vim.o.sidescroll = 1             -- Number of columns to scroll left and right
vim.o.backspace  = "indent"      -- allow backspacing only over automatic indenting (:help 'backspace')
vim.o.wildmenu   = true          -- Display a menu of all completions for commands when pressing tab
-- vim.o.clipboard   = "unnamedplus" -- Use system clipboard

-- Leading tabs (trailing spaces coming soon)
vim.o.list      = true              -- Show hidden characters
vim.o.listchars = "tab:>-<,trail:/" -- Add tabs and spaces to list of hidden chars

-- vim.o.listchars = "tab:>-<,leadmultispace:---|" -- Add tabs and spaces to list of hidden chars
	 -- <- there is a tab here, which should be visible, and trailing spaces here -> --     

-- Don't wrap long lines
vim.o.wrap        = false
vim.o.linebreak   = true
vim.o.breakindent = true

vim.o.breakindentopt = "shift:0,min:20"
vim.o.formatoptions  = vim.o.formatoptions .. "n"
vim.o.virtualedit    = "block"  -- Visual block mode is not limited to the character locations

vim.o.fixendofline = false -- Don't insert an end of line at the end of the file
vim.o.eol          = false -- Give it a mean look so it understands

-- Folding
-- vim.o.foldenable = true
vim.o.foldmethod = "indent"
vim.o.foldlevel  = 99 -- Don't open a file fully folded
-- zc to close fold, zo to open, zM to close all folds, zR to open all

-- Indenting
vim.o.tabstop     = 4
vim.o.shiftwidth  = 0
vim.o.softtabstop = -1
vim.o.expandtab   = true
vim.o.cindent     = true
vim.o.cinoptions  = "l1,=4,:4,(0,{0,+2,w1,W4,t0,j1,J1"
vim.o.shortmess   = "filnxtToOIs"

-- set viminfo+=n~/.local/nviminfo -- Out of sight, out of mind
vim.o.viminfo     = ""
vim.o.display     = "lastline" -- For writing prose
vim.o.swapfile    = false
vim.o.hlsearch    = false
vim.o.incsearch   = true
vim.o.colorcolumn = 80
vim.o.scrolloff   = 5
vim.o.updatetime  = 50

return exports