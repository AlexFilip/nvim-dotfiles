-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd termdebug]]

return require("packer").startup(function(use)
    -- Let Packer manage itself
    use("wbthomason/packer.nvim")

    -- Theming
    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    -- use("vim-airline/vim-airline")
    -- use("vim-airline/vim-airline-themes")
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use("junegunn/goyo.vim")
    use("mbbill/undotree")

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

    -- Themes
    use("rose-pine/neovim")
    use("morhetz/gruvbox")
    use("catppuccin/nvim")

    use("sainnhe/edge")
    use("folke/tokyonight.nvim")
    use("preservim/vim-colors-pencil")

    -- Language Server
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        requires = {
            -- LSP Support
            -- Required
            {"neovim/nvim-lspconfig"},

            -- Optional
            {
                "williamboman/mason.nvim",
                run = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            {"williamboman/mason-lspconfig.nvim"}, -- Optional

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},     -- Required
            {"hrsh7th/cmp-nvim-lsp"}, -- Required
            {"L3MON4D3/LuaSnip"},     -- Required
        }

    })

    -- Snippets
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp"
    })

    -- TODO:
    --  Get debuggers working

    -- use("mfussenegger/nvim-dap")
    -- -- use("leoluz/nvim-dap-go")
    -- use("rcarriga/nvim-dap-ui")
    -- use("theHamsta/nvim-dap-virtual-text")
    -- use("nvim-telescope/telescope-dap.nvim")

end)
