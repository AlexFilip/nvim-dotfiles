local util = require('util')

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

-- Load the colorscheme
require('nord').set()

local function SetTransparentBackground(color, theme)
    vim.o.background = theme or "dark"
    vim.cmd.colorscheme(color or "nord")
end

SetTransparentBackground("nord", "dark")
