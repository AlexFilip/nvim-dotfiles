
require('remap')
require('groups')
require('git')
require('tabs')
require('settings')

vim.cmd('source ~/.config/nvim/init-old.vim')

require('orgmode').setup_ts_grammar()
