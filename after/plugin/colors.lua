
local function SetColor(color)
    color = color or "edge"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal",       { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat",  { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "CursorLineNR", { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "CursorLine",   { ctermbg = "none", bg = "none" })
    vim.api.nvim_set_hl(0, "NonText",      { ctermbg = "none", bg = "none", fg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer",  { ctermbg = "none", bg = "none" })
end

SetColor()
