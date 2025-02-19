local util = require("util")
local config = require('config_files')

-- Count how many instances of a search term are found
function searchCount()
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
            file_status = true,        -- display monified, readonly, etc.
            newfile_status = false,    -- Display new file status (new file means no write after created)
            path = 1,                  -- Relative path
            shorting_target = 40,      -- How many spaces to leave in window for other components
        }
    },
    ---
    lualine_x = {
        {
            'path',
            icons_enabled = false,
            cond = function()
                local filetype = vim.bo.filetype
                return filetype == "json" or filetype == "yaml"
            end,
            fmt = function(toDisplay, context)
                return config.getPath()
            end,
            on_click = function(numClicks, button, modifiers)
                local register
                if modifiers:find("c", 1, true) ~= nil then
                    register = "+"
                    -- else if modifiers:find("a", 1, true) ~= nil then -- alt
                    -- else if modifiers:find("m", 1, true) ~= nil then -- meta
                    -- else if modifiers:find("s", 1, true) ~= nil then -- shift
                else -- no other modifiers
                    register = [["]]
                end
                config.yankToRegister(register)
            end,
        }
    },
    lualine_y = {},
    lualine_z = {},
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
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

                -- fmt = function(name, context)
                    --     -- Show + if buffer is modified in tab
                    --     local buflist = vim.fn.tabpagebuflist(context.tabnr)
                    --     local winnr = vim.fn.tabpagewinnr(context.tabnr)
                    --     local bufnr = buflist[winnr]
                    --     local mod = vim.fn.getbufvar(bufnr, '&mod')
                    --     return name .. (mod == 1 and ' +' or '')
                    -- end
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
