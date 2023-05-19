-- This file can be loaded by calling `lua require("plugins")` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use) -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "tpope/vim-surround"
    use "tpope/vim-repeat"
    use "vim-airline/vim-airline"
    use "vim-airline/vim-airline-themes"
    use "SirVer/ultisnips"
    use "mbbill/undotree"

    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Languages
    use "vim-scripts/awk.vim"
    use "rust-lang/rust.vim"
    use "fatih/vim-go"
    use "keith/swift.vim"
    use "hashivim/vim-terraform"

    -- Git support
    use "tpope/vim-fugitive"

    -- GnuPG support (buggy, doesn't work with GPG_TTY, have to use qt)
    use "jamessan/vim-gnupg"
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use "nvim-orgmode/orgmode"

    -- Themes
    use "morhetz/gruvbox"
    use "catppuccin/nvim"
    use "sainnhe/edge"
    use "folke/tokyonight.nvim"
    use "preservim/vim-colors-pencil"
end)
