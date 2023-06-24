-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd termdebug]]

return require("packer").startup(function(use)
    -- Let Packer manage itself
    use("wbthomason/packer.nvim")

    -- Useful plugins
    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    use("mbbill/undotree")

    -- Theming
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use("catppuccin/nvim")

    use({
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    })

    -- Languages via treesitter
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use("nvim-orgmode/orgmode")

    -- Git support
    use("tpope/vim-fugitive")

    -- GnuPG support (buggy, doesn't work with GPG_TTY, have to use qt, gnome or gtk)
    use("jamessan/vim-gnupg")
end)
