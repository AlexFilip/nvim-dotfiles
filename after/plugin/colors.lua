
require("catppuccin").setup({
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "frappe",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "light",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

local function SetTransparentBackground(color, theme)
    color = color or "catppuccin"
    vim.o.background = theme or 'dark'
    vim.cmd.colorscheme(color)

    -- vim.api.nvim_set_hl(0, "Normal",       { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalNC",     { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat",  { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "CursorLineNR", { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "CursorLine",   { ctermbg = "none", bg = "none" })
    -- vim.api.nvim_set_hl(0, "NonText",      { ctermbg = "none", bg = "none", fg = "none" })
    -- vim.api.nvim_set_hl(0, "EndOfBuffer",  { ctermbg = "none", bg = "none" })
end

SetTransparentBackground("catppuccin", "dark")
