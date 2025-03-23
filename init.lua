
require('plugins')

local settings = require('settings')
require('remap')
require('groups')
require('git')
require('commands')
require('navigation')
require('status_line')
local util = require('util')


vim.cmd [[ filetype plugin indent on ]]

local PATH_separator = ""
local function AddToPath(...)
    local arg = {...}
    local exist_in_path = {}
    local new_path = {}
    local i = 1

    while i <= #vim.env.PATH do
        local sep_loc = string.find(vim.env.PATH, PATH_separator, i) or #vim.env.PATH+1
        local sub_path = string.sub(vim.env.PATH, i, sep_loc-1)

        if not exist_in_path[sub_path] then
            new_path[#new_path + 1] = sub_path
            exist_in_path[sub_path] = true
        end

        i = sep_loc + 1
    end

    local new_components = {}
    for i,path in ipairs(arg) do
        if not exist_in_path[path] and path ~= '' then
            new_components[#new_components + 1] = path
        end
    end

    for i=1,#new_path do
        new_components[#new_components + 1] = new_path[i]
    end

    vim.env.PATH = table.concat(new_components, PATH_separator)
    return vim.env.PATH
end

if vim.fn.has("win32") ~= 0 then
    PATH_separator = ";"
    AddToPath("C:\\tools", "C:\\Program Files\\Git\\bin")
else
    if vim.fn.executable("/bin/zsh") ~= 0 then
        vim.o.shell="/bin/zsh" -- Shell to launch in terminal
    end

    PATH_separator = ":"
    AddToPath("/usr/local/sbin", settings.homeDirectory .. "/bin", "/usr/local/bin")
    if vim.fn.has("mac") ~= 0 then
        AddToPath("/opt/homebrew/bin", "/sbin", "/usr/sbin")
    end
end

if vim.loop.os_uname().sysname == "Darwin" then
    settings.syntax(false) -- disable syntax for mac, since it doesn't handle nord syntax well
end

local dot_vim_path = vim.fn.fnamemodify(vim.env.MYVIMRC, ":p:h")
local path_separator = '/'
if vim.fn.has('win32') ~= 0 then
    path_separator = '\\'
end

vim.env.PINENTRY_USER_DATA="qt"
vim.env.GPG_TTY=''
vim.g.GPGDefaultRecipients = {}

-- Clipboard
if vim.fn.executable("wl-copy") then
    vim.g.clipboard = {
        name = "wl-clipboard (wsl)",
        copy = {
            ["+"] = util.copy_command(""),
            ["*"] = util.copy_command("--primary")
        },
        paste = {
            ["+"] = util.paste_command(""),
            ["*"] = util.paste_command("--primary"),
        },
        cache_enabled = true
    }
else
    print("wl-clipboard not found, clipboard integration won't work")
end
-- Shortcuts
--   Undotree
util.nnoremap("<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })

--   Fugitive
util.nnoremap("<leader>gs", vim.cmd.Git, { desc = "Open git view" })

--   Telescope
local telescope_builtin = require('telescope.builtin')
util.nnoremap('<leader>ff', telescope_builtin.find_files, { desc = "Search for files" })
util.nnoremap('<leader>fg', telescope_builtin.git_files, { desc = "Git search" })
util.nnoremap('<leader>fb', telescope_builtin.buffers, { desc = "Search buffers" })
util.nnoremap('<leader>fs', telescope_builtin.live_grep, { desc = "Search file contents" })


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


-- Load extra config from local file. **Keep this at the end**
local local_vimrc_path = table.concat({ settings.homeDirectory, '.local', 'neovimrc.lua' }, path_separator)
local user_vimrc = (loadfile(local_vimrc_path) or function() return {} end)() or {}

if user_vimrc.file_end and type(user_vimrc.file_end) == 'function' then
    user_vimrc.file_end()
end

