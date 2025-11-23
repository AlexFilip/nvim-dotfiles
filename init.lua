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
ensure('folke/lazy.nvim', 'lazy.nvim')

--- Status line
-- Count how many instances of a search term are found
local function searchCount()
    local search = vim.fn.searchcount({ maxcount = 0 }) -- maxcount = 0 makes the number not be capped at 99
    local searchCurrent = search.current
    local searchTotal = search.total
    local result = ''
    if searchCurrent > 0 then
        -- result = '/' .. vim.fn.getreg('/') .. ' [' .. searchCurrent .. '/' .. searchTotal .. ']'
        result = '[' .. searchCurrent .. '/' .. searchTotal .. ']'
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

-- vim.o.laststatus = 0

-- Leader and localleader mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup({
    spec = {
        -- { import = 'plugins' },

        -- Useful editor plugins
        {
            "kylechui/nvim-surround",
            version = "^3.0.0",
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup({})
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
                -- TODO: Adapt these to the new plugin
                -- { '<leader>gd', function() vim.cmd 'vert Gdiffsplit!' end, desc = 'Solve merge conflict or git diff' }
                -- { '<leader>gh', function() vim.cmd 'diffget //2' end, desc = 'Select left in conflict resolution' }
                -- { '<leader>gl', function() vim.cmd 'diffget //3' end, desc = 'Select right in conflict resolution' }
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                "sindrets/diffview.nvim",
                "ibhagwan/fzf-lua",
            },
        },

        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = {
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
                    -- refresh = { statusline = 1000, tabline = 1000, winbar  = 1000, }
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
        },

        {
            'hrsh7th/nvim-cmp',
            config = function()
                local cmp = require('cmp')

                cmp.setup({
                    snippet = {
                        -- REQUIRED - you must specify a snippet engine
                        expand = function(args)
                            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

                            -- For `mini.snippets` users:
                            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                            -- insert({ body = args.body }) -- Insert at cursor
                            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                            -- require("cmp.config").set_onetime({ sources = {} })
                        end,
                    },
                    window = {
                        -- completion = cmp.config.window.bordered(),
                        -- documentation = cmp.config.window.bordered(),
                    },
                    mapping = cmp.mapping.preset.insert({
                        -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-e>'] = cmp.mapping.abort(),
                        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    }),
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp' },
                        { name = 'vsnip' },
                    }, {
                        { name = 'buffer' },
                    })
                })

                cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' }
                    }
                })

                -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = 'path' }
                    }, {
                        { name = 'cmdline' }
                    }),
                    matching = { disallow_symbol_nonprefix_matching = false }
                })

            end,

            dependencies = {
                'neovim/nvim-lspconfig',
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-vsnip',
                'hrsh7th/vim-vsnip',
            },
        },

        {
            "mason-org/mason.nvim",
            opts = {},
        },

        {
            "nvim-treesitter/nvim-treesitter",
            branch = 'master',
            lazy = false,
            build = ":TSUpdate",
            keys = {
                -- In your init.lua or similar configuration file
                { "<leader>er", vim.diagnostic.open_float, desc = "Show diagnostic message" },
                { "<leader>ner", vim.diagnostic.goto_next, desc = "Next diagnostic" },
                { "<leader>per", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
                { '<leader>gd', vim.lsp.buf.definition, desc = 'LSP Go to Definition' },
                { '<leader>K', vim.lsp.buf.hover, desc = "Hover documentation" }
            },
            opts = {
                ensure_installed = {
                    "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
                },
                sync_install = false,
                auto_install = true,
                ignore_install = {},

                ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = false
                },
            },
        },

        -- Theming
        {
            'shaunsingh/nord.nvim',
            priority = 1000,
            lazy = false,
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

    install = {
        colorscheme = { 'nord.nvim' }
    },

    checker = {
        enabled = true,
        notify = false
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = false, -- get a notification when changes are found
    },

})

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local function addCapabilitiesToLSP(name, options)
    vim.lsp.config(name, options or {
        capabilities = cmp_capabilities
    })

    vim.lsp.enable(name)
end

addCapabilitiesToLSP('clangd',  {
    capabilities = cmp_capabilities,
    init_options = {
        fallbackFlags = {'--std=c++23'}
    },
})
addCapabilitiesToLSP('json-lsp')
addCapabilitiesToLSP('html-lsp')
addCapabilitiesToLSP('python-lsp-server')
addCapabilitiesToLSP('clojure-lsp')
addCapabilitiesToLSP('terraform-ls')


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

