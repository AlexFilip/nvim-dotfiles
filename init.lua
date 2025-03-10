
require('plugins')

local settings = require('settings')
require('remap')
require('clipboard')
require('groups')
require('git')
require('tabs')
require('commands')
require('splits')
require('default_files')
local config_file_functions = require('config_files')

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

local local_vimrc_path = table.concat({ settings.homeDirectory, '.local', 'neovimrc.lua' }, path_separator)
local user_vimrc = (loadfile(local_vimrc_path) or function() return {} end)() or {}

if user_vimrc.file_end and type(user_vimrc.file_end) == 'function' then
    user_vimrc.file_end()
end

