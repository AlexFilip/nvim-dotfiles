local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

    -- Useful editor plugins
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "mbbill/undotree",

    -- TODO: setup git-worktree, harpoon and dadbod
    -- Database management
    "tpope/vim-dadbod",

    -- Prime
    'ThePrimeagen/git-worktree.nvim',
    {
        'ThePrimeagen/harpoon',
        requires = {
            'nvim-lua/plenary.nvim',
        }
    },

    -- Project management
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- Manual mode doesn't automatically change your root directory, so you have
                -- the option to manually do so using `:ProjectRoot` command.
                -- manual_mode = false,

                -- Methods of detecting the root directory. **"lsp"** uses the native neovim
                -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
                -- order matters: if one is not detected, the other is used as fallback. You
                -- can also delete or rearangne the detection methods.
                -- detection_methods = { "lsp", "pattern" },

                -- All the patterns used to detect root dir, when **"pattern"** is in
                -- detection_methods
                patterns = {
                    -- defaults
                    ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",
                    -- custom
                    "compile",
                    "tmux.conf",
                    "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml",
                },

                -- Table of lsp clients to ignore by name
                -- eg: { "efm", ... }
                -- ignore_lsp = {},

                -- Don't calculate root dir on specific directories
                -- Ex: { "~/.cargo/*", ... }
                -- exclude_dirs = {},

                -- Show hidden files in telescope
                -- show_hidden = false,

                -- When set to false, you will get a message when project.nvim changes your
                -- directory.
                -- silent_chdir = true,

                -- What scope to change the directory, valid options are
                -- * global (default)
                -- * tab
                -- * win
                -- scope_chdir = 'global',

                -- Path where project.nvim will store the project history for use in
                -- telescope
                -- datapath = vim.fn.stdpath("data"),
            }
        end
    },

    -- Explore config files
    'phelipetls/jsonpath.nvim',
    {
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim" -- optional
        }
    },

    -- Theming
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    "catppuccin/nvim",

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    },

    -- LSP support
    {
        "williamboman/mason.nvim",
        run = ":MasonUpdate" -- :MasonUpdate updates registry contents
    },

    "williamboman/mason-lspconfig.nvim",

    -- Languages via treesitter
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
    {
        'nvim-treesitter/playground',
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    },
    {
        "nvim-orgmode/orgmode",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    },

    "simrat39/rust-tools.nvim",

    -- Git support
    "tpope/vim-fugitive",

    -- GnuPG support buggy, doesn't work with GPG_TTY, have to use qt, gnome or gtk
    "jamessan/vim-gnupg",

    -- Cmp
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",

    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Debugger
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
}

vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd termdebug]]

local x = require("packer").startup(function(use)

    for _, plugin in ipairs(plugins) do
        use(plugin)
    end
end)

return x
