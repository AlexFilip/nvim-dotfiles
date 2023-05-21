-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd termdebug]]

return require("packer").startup(function(use) -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    -- use("vim-airline/vim-airline")
    -- use("vim-airline/vim-airline-themes")
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    --use("SirVer/ultisnips")
    use("mbbill/undotree")

    use ({
        "VonHeikemen/fine-cmdline.nvim",
        requires = {
            { "MunifTanjim/nui.nvim" }
        }
    })

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

    -- GnuPG support (buggy, doesn't work with GPG_TTY, have to use qt)
    use("jamessan/vim-gnupg")

    -- Themes
    use("rose-pine/neovim")
    use("morhetz/gruvbox")
    use("catppuccin/nvim")
    use("sainnhe/edge")
    use("folke/tokyonight.nvim")
    use("preservim/vim-colors-pencil")
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}
end)
