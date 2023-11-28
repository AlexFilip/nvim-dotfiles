local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

    -- Useful plugins
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "mbbill/undotree",

    -- TODO: setup git-worktree, harpoon and dadbod
    "tpope/vim-dadbod",

    -- Prime
    'ThePrimeagen/git-worktree.nvim',
    {
        'ThePrimeagen/harpoon',
        requires = {
            'nvim-lua/plenary.nvim',
        }
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
