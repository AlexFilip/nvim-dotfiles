local util = require('util')

-- Nord config
util.setValuesInObject(vim.g, {
    nord_contrast = false,
    nord_borders = true,
    nord_disable_background = false,
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

    -- vim.api.nvim_set_hl(0, "Normal",       { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalNC",     { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat",  { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "CursorLineNR", { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "CursorLine",   { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NonText",      { ctermbg = "none", bg = "none", fg = "none" })
    -- vim.api.nvim_set_hl(0, "EndOfBuffer",  { ctermbg = "none", bg = "none" })
end

SetTransparentBackground("nord", "dark")

util.setValuesInObject(vim.o, {
    showtabline = 0,
    laststatus  = 3,
    winbar      = "%f %m %{%v:lua.require('config_files').getPath()%}",
})
