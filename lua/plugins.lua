local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

    -- Useful editor plugins
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "mbbill/undotree",

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
