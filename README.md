# Neovim config
Most of the configuration is taken from my [original vim config](https://github.com/AlexFilip/dotvim) like persistent undo and automatic reloading of the vimrc when it's modified.
I also added other plugins like fzf and ripgrep.
There are still some kinks I need to work out, especially with the terminal and compile command.

## Installation:
Save this directory as `~/.config/nvim/`
```
git clone https://github.com/AlexFilip/nvim-dotfiles ~/.config/nvim
```

or symlink it from your preferred location

```
PREFERRED_LOCATION="your/preferred/location"
git clone https://github.com/AlexFilip/nvim-dotfiles $PREFERRED_LOCATION
ln -sf ~/.config/nvim $PREFERRED_LOCATION
```

## Local vimrc
This config also checks for a file named `~/.local/vimrc` and executes it if it exists. That file is executed after many of the options are set but before plugins are loaded. You can create the following functions in your local vimrc and they will be executed at the specified times.
- `LocalVimRCPlugins()` run after all plugins have been specified. Here you can specify other plugins using [vim-plug](https://github.com/junegunn/vim-plug) syntax.
- `LocalVimRCEnd()` run at the end of the script so you can override any variable or option

