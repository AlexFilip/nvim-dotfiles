local util = require('util')
local named_colors = require('nord.named_colors')

-- Nord config
util.setValuesInObject(vim.g, {
    nord_contrast = false,
    nord_borders = true,
    nord_disable_background = true,
    nord_cursorline_transparent = true,
    nord_enable_sidebar_background = false,
    nord_italic = true,
    nord_uniform_diff_background = true,
    nord_bold = true,
})

-- Load the theme
vim.o.background = "dark"
require('nord').set()

vim.o.background = theme or "dark"
vim.cmd.colorscheme(color or "nord")

-- Modifications to theme
-- Vim syntax
vim.cmd.highlight("Comment",        "guifg=" .. named_colors.green, "gui=NONE")
vim.cmd.highlight("SpecialComment", "guifg=" .. named_colors.green, "gui=NONE")
vim.cmd.highlight("Character",      "guifg=" .. named_colors.red,   "gui=NONE")
vim.cmd.highlight("SpecialChar",    "guifg=" .. named_colors.red,   "gui=NONE")
vim.cmd.highlight("String",         "guifg=" .. named_colors.red,   "gui=NONE")

-- Treesitter
vim.cmd.highlight("@comment",   "guifg=" .. named_colors.green, "gui=NONE")
vim.cmd.highlight("TSComment",  "guifg=" .. named_colors.green, "gui=NONE")
vim.cmd.highlight("@character", "guifg=" .. named_colors.red,   "gui=NONE")
vim.cmd.highlight("@string",    "guifg=" .. named_colors.red,   "gui=NONE")
