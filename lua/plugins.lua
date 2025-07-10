local plugins = {
    -- Let Packer manage itself
    "wbthomason/packer.nvim",

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
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    },
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
