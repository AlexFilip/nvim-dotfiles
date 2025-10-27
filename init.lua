local util = require('util')

-- Lazy documentation: https://lazy.folke.io/
-- Tangerine (use fennel (a lisp) instead of lua): https://github.com/udayvir-singh/tangerine.nvim
-- Vim kickstart (ideas for a vim init): https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
local package_path = vim.fn.stdpath('data') .. '/lazy'
function ensure(repo, package, dir)
    local install_path = string.format('%s/%s', package_path, package)
    if not (vim.uv or vim.loop).fs_stat(install_path) then
        local out = vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            '--single-branch',
            'https://github.com/' .. repo .. '.git',
            install_path,
        })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { 'Failed to clone ' .. package .. ':\n', 'ErrorMsg' },
                { out, 'WarningMsg' },
                { '\nPress any key to exit...' },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(install_path)
end

-- ensure('Olical/aniseed', 'aniseed')
-- vim.g['aniseed#env'] = {module = 'init', compile = true}
-- require('aniseed.env').init()

ensure('folke/lazy.nvim', 'lazy.nvim')

-- Leader and localleader mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup({
    spec = {
        -- import your plugins
        { import = 'plugins' },

        -- Useful editor plugins
        {
            "kylechui/nvim-surround",
            version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
        },
        {
            'mbbill/undotree',
            keys = {
                { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle undo tree' },
            },
        },

        -- Git support
        {
            "NeogitOrg/neogit",
            keys = {
                { '<leader>gs', vim.cmd.Neogit, desc = 'Open git view' },
            },
            dependencies = {
                "nvim-lua/plenary.nvim",         -- required
                "sindrets/diffview.nvim",        -- optional - Diff integration

                -- Only one of these is needed.
                "nvim-telescope/telescope.nvim", -- optional
                "ibhagwan/fzf-lua",              -- optional
                "nvim-mini/mini.pick",           -- optional
                "folke/snacks.nvim",             -- optional
            },
        },
        -- Theming
        {
            'shaunsingh/nord.nvim',
            init = function(plugin)
                vim.o.background = 'dark'
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
            end,
            config = function()
                vim.cmd.colorscheme('nord')
                -- Modifications to nord theme
                local named_colors = require('nord.named_colors')
                vim.cmd.highlight('Comment',        'guifg=' .. named_colors.green, 'gui=NONE')
                vim.cmd.highlight('SpecialComment', 'guifg=' .. named_colors.green, 'gui=NONE')
                vim.cmd.highlight('Character',      'guifg=' .. named_colors.red,   'gui=NONE')
                vim.cmd.highlight('SpecialChar',    'guifg=' .. named_colors.red,   'gui=NONE')
                vim.cmd.highlight('String',         'guifg=' .. named_colors.red,   'gui=NONE')
                vim.cmd.highlight('Visual',         'guibg=' .. named_colors.blue,  'gui=NONE')
                vim.cmd.highlight('VisualNOS',      'guibg=' .. named_colors.blue,  'gui=NONE')
            end,
            lazy = false,
            priority = 1000,
        },

        -- Utilities
        {
            'nvim-telescope/telescope.nvim',
            lazy = true,
            branch = '0.1.x',
            dependencies = {
                { 'nvim-lua/plenary.nvim' },
                { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" }
            },
            keys = {
                { '<leader>ff', function(...) require('telescope.builtin').find_files(...) end, desc = 'Search for files' },
                { '<leader>fg', function(...) require('telescope.builtin').git_files(...) end,  desc = 'Git search' },
                { '<leader>fb', function(...) require('telescope.builtin').buffers(...) end,    desc = 'Search buffers' },
                { '<leader>fs', function(...) require('telescope.builtin').live_grep(...) end,  desc = 'Search file contents' },
                { '<leader>fm', function(...) require('telescope.builtin').marks(...) end,      desc = 'Search file contents' },
                { '<leader>fr', function(...) require('telescope.builtin').registers(...) end,  desc = 'Search file contents' },
            },
        },

        -- Lisp
        {
            'guns/vim-sexp',
            lazy = true,
            ft = { 'clojure', 'lisp', 'scheme' },
        },

        {
            'Olical/conjure',
            init = function(plugin)
                vim.g['conjure#mapping#prefix'] = '<localleader>'
            end,
            lazy = true,
            ft = { 'clojure', 'fennel' },
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = {
        colorscheme = { 'nord.nvim' }
    },

    -- automatically check for plugin updates
    checker = {
        enabled = true,
        notify = false
    },
})


-- Since lualine doesn't have an option for hiding the tab bar entirely
vim.o.showtabline = 0

-- Files in the lua subdirectory should stay OS independent
local settings = require('custom')

-- Everything here is either OS dependent or used to set 
vim.cmd [[ filetype plugin indent on ]]

local function AddToPath(PATH_separator, ...)
    local arg = {...}
    local exist_in_path = {}
    local new_path = {}
    local i = 1

    for path in string.gmatch(vim.env.PATH, '[^' .. PATH_separator .. ']+') do
        if not exist_in_path[path] then
            new_path[#new_path + 1] = path
            exist_in_path[path] = true
        end
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
end

if vim.fn.has('win32') ~= 0 then
    AddToPath(';', 'C:\\tools', 'C:\\Program Files\\Git\\bin')
else
    if vim.fn.executable('/bin/bash') ~= 0 then
        vim.o.shell='/bin/bash' -- Shell to launch in terminal
    end
    AddToPath(':', '/usr/local/sbin', settings.homeDirectory .. '/bin', '/usr/local/bin')
    if vim.fn.has('mac') ~= 0 then
        AddToPath(':', '/opt/homebrew/bin', '/sbin', '/usr/sbin')
    end
end

local dot_vim_path = vim.fn.fnamemodify(vim.env.MYVIMRC, ':p:h')
local path_separator = '/'
if vim.fn.has('win32') ~= 0 then
    path_separator = '\\'
end

-- Clipboard
if vim.fn.executable('wl-copy') then
    vim.g.clipboard = {
        name = 'wl-clipboard',
        copy = {
            ['+'] = util.copy_command(''),
            ['*'] = util.copy_command('--primary')
        },
        paste = {
            ['+'] = util.paste_command(''),
            ['*'] = util.paste_command('--primary'),
        },
        cache_enabled = true
    }
else
    print('wl-clipboard not found, clipboard integration won\'t work')
end

-- Load extra config from local file. **Keep this at the end**
local local_vimrc_path = table.concat({ settings.homeDirectory, '.local', 'neovimrc.lua' }, path_separator)
local user_vimrc = (loadfile(local_vimrc_path) or function() return {} end)() or {}

if user_vimrc.file_end and type(user_vimrc.file_end) == 'function' then
    user_vimrc.file_end()
end

