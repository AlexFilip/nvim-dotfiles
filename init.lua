-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Leader and localleader mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Conjure config
vim.g['conjure#mapping#prefix'] = '<localleader>'

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        -- { import = "plugins" },

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
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },

        -- Utilities
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = { { 'nvim-lua/plenary.nvim' } }
        },

        -- Lisp
        {
            'guns/vim-sexp',
            lazy = true,
            ft = { 'clojure', 'lisp', 'scheme' },
        },

        {
            'tpope/vim-sexp-mappings-for-regular-people',
            lazy = true,
            ft = { 'clojure', 'lisp', 'scheme' },
        },

        {
            'Olical/conjure',
            lazy = true,
            ft = { 'clojure' },
        },

    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "nord.nvim" } },

    -- automatically check for plugin updates
    checker = { enabled = true },
})

require('plugins')

-- Files in the lua subdirectory should stay OS independent
local settings = require('custom')
local util = require('util')

-- Everything here is either OS dependent or used to set 
vim.cmd [[ filetype plugin indent on ]]

local function AddToPath(PATH_separator, ...)
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
    AddToPath(";", "C:\\tools", "C:\\Program Files\\Git\\bin")
else
    if vim.fn.executable("/bin/zsh") ~= 0 then
        vim.o.shell="/bin/zsh" -- Shell to launch in terminal
    end

    AddToPath(":", "/usr/local/sbin", settings.homeDirectory .. "/bin", "/usr/local/bin")
    if vim.fn.has("mac") ~= 0 then
        AddToPath("/opt/homebrew/bin", "/sbin", "/usr/sbin")
    end
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
        name = "wl-clipboard",
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

-- Load extra config from local file. **Keep this at the end**
local local_vimrc_path = table.concat({ settings.homeDirectory, '.local', 'neovimrc.lua' }, path_separator)
local user_vimrc = (loadfile(local_vimrc_path) or function() return {} end)() or {}

if user_vimrc.file_end and type(user_vimrc.file_end) == 'function' then
    user_vimrc.file_end()
end

