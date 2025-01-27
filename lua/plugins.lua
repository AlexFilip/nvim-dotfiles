local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

    -- Useful editor plugins
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "mbbill/undotree",

    -- TODO: setup git-worktree and harpoon

    -- 'ThePrimeagen/git-worktree.nvim',
    -- {
    --     'ThePrimeagen/harpoon',
    --     requires = {
    --         'nvim-lua/plenary.nvim',
    --     }
    -- },

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

    -- Languages via treesitter
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
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

    -- "mrcjkb/rustaceanvim",
    "jubnzv/virtual-types.nvim", -- display types in virtual text on same line

    -- Git support
    "tpope/vim-fugitive",
    -- {
    --     "NeogitOrg/neogit",
    --     requires = {
    --         "nvim-lua/plenary.nvim",         -- required
    --         "sindrets/diffview.nvim",        -- optional - Diff integration

    --         -- Only one of these is needed, not both.
    --         "nvim-telescope/telescope.nvim", -- optional
    --         -- "ibhagwan/fzf-lua",              -- optional
    --     }
    -- },

    -- Cmp
    "neovim/nvim-lspconfig",

    "hrsh7th/nvim-cmp",       -- Completion engine
    "hrsh7th/cmp-nvim-lsp",   -- Language server protocol
    "hrsh7th/cmp-buffer",     -- Source for buffer words
    "hrsh7th/cmp-path",       -- Source for filesystem paths
    "hrsh7th/cmp-cmdline",    -- Source for command line

    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Debugger
    {
        "mfussenegger/nvim-dap",
        requires = {
            "nvim-neotest/nvim-nio"
        }
    },
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
}

vim.cmd [[packadd packer.nvim]]
-- if vim.fn.exists(':Termdebug') == 0 then
--   vim.cmd [[packadd termdebug]]
-- end

local x = require("packer").startup(function(use)

    for _, plugin in ipairs(plugins) do
        use(plugin)
    end
end)

return x
