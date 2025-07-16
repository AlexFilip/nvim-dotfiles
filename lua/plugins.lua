local util = require("util")

local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

    -- Useful editor plugins
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "mbbill/undotree",

    -- Git support
    "tpope/vim-fugitive",

    -- Theming
    "shaunsingh/nord.nvim",
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    },
}

vim.cmd [[packadd packer.nvim]]
-- if vim.fn.exists(':Termdebug') == 0 then
--   vim.cmd [[packadd termdebug]]
-- end

local exports = require("packer").startup(function(use)
    for _, plugin in ipairs(plugins) do
        use(plugin)
    end
end)

-- Telescope
local telescope_builtin = require('telescope.builtin')
util.keymap("n", '<leader>ff', telescope_builtin.find_files, { desc = "Search for files" })
util.keymap("n", '<leader>fg', telescope_builtin.git_files, { desc = "Git search" })
util.keymap("n", '<leader>fb', telescope_builtin.buffers, { desc = "Search buffers" })
util.keymap("n", '<leader>fs', telescope_builtin.live_grep, { desc = "Search file contents" })

-- Undotree
util.keymap("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })

-- Fugitive
util.keymap("n", "<leader>gs", vim.cmd.Git, { desc = "Open git view" })

-- Colorscheme
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

--- Status line
-- Count how many instances of a search term are found
local function searchCount()
    local search = vim.fn.searchcount({ maxcount = 0 }) -- maxcount = 0 makes the number not be capped at 99
    local searchCurrent = search.current
    local searchTotal = search.total
    local result = ""
    if searchCurrent > 0 then
        -- result = "/" .. vim.fn.getreg("/") .. " [" .. searchCurrent .. "/" .. searchTotal .. "]"
        result = "[" .. searchCurrent .. "/" .. searchTotal .. "]"
    end
    return result
end

local winbar_config = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
        {
            'filename',
            file_status = true,     -- display monified, readonly, etc.
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- Relative path
            shorting_target = 40,   -- How many spaces to leave in window for other components
        }
    },
    ---
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        -- refresh = {
        --     -- statusline = 1000,
        --     -- tabline = 1000,
        --     winbar  = 1000,
        -- }
    },

    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                'tabs',
                max_length = vim.o.columns, -- Maximum width of tabs component.
                -- Note:
                -- It can also be a function that returns
                -- the value of `max_length` dynamically.
                mode = 2,

                -- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
                use_mode_colors = false,

                tabs_color = {
                    -- Same values as the general color option can be used here.
                    active = 'lualine_a_normal',     -- Color for active tab.
                    inactive = 'lualine_b_inactive', -- Color for inactive tab.
                },
            },
        },

        lualine_x = {{ searchCount }, 'encoding', { 'fileformat', icons_enabled = false }, 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },

    always_show_tabline = false,
    tabline = nil,

    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },

    winbar = winbar_config,
    inactive_winbar = winbar_config,
    extensions = {}
}

-- vim.o.laststatus = 0
vim.o.showtabline = 0

return exports
