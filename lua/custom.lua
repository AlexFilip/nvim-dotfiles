local exports = {}
local util = require('util')

local homeDirectory = os.getenv('HOME')
exports.homeDirectory = homeDirectory

local undo_dir = homeDirectory .. '/.local/nvim-undos'
if not vim.fn.isdirectory(undo_dir) then
    vim.fn.mkdir(undo_dir)
end

local newFormatoptions = vim.o.formatoptions .. 'n'
local newCinkeys       = vim.o.cinkeys:gsub(',0#', '')

util.setValuesInObject(vim.opt, {
    title = true,
    titlestring = "Neovim %F%m",
})

util.setValuesInObject(vim.o, {
    -- Persistent Undo
    undofile   = true,     -- Save undos after file closes
    undolevels = 1000,     -- How many undos
    undoreload = 10000,    -- number of lines to save for undo
    undodir    = undo_dir, -- where to save undo histories

    -- Miscellaneous
    splitright = true,          -- Vertical split goes right, not left
    showcmd    = true,          -- Show the current command in operator pending mode
    cursorline = true,          -- Make the cursor line a visible color
    showmode   = false,         -- Don't show -- INSERT --
    mouse      = 'a',           -- Allow mouse input
    sidescroll = 1,             -- Number of columns to scroll left and right
    backspace  = 'indent',      -- allow backspacing only over automatic indenting (:help 'backspace')
    wildmenu   = true,          -- Display a menu of all completions for commands when pressing tab
    number     = false,         -- Do not show line numbers
    signcolumn = 'yes',         -- always show the sidebar with signs for diagnostics

    -- Leading tabs (trailing spaces coming soon)
    list      = true,              -- Show hidden characters
    listchars = 'tab:>-<,trail:/', -- Add tabs and spaces to list of hidden chars

    -- listchars = 'tab:>-<,leadmultispace:---|' -- Add tabs and spaces to list of hidden chars
    -- <- there is a tab here, which should be visible, and trailing spaces here -> --     

    -- Don't wrap long lines
    wrap        = false,
    linebreak   = true,
    breakindent = true,

    breakindentopt = 'shift:0,min:20',
    formatoptions  = newFormatoptions,
    virtualedit    = 'block',  -- Visual block mode is not limited to the character locations

    fixendofline = false, -- Don't insert an end of line at the end of the file
    eol          = false, -- Give it a mean look so it understands

    -- Folding
    -- foldenable = true
    foldmethod = 'indent',
    foldlevel  = 99, -- Don't open a file fully folded
    -- zc to close fold, zo to open, zM to close all folds, zR to open all

    -- Indenting
    tabstop     = 4,
    shiftwidth  = 0,
    softtabstop = -1,
    expandtab   = true,
    cindent     = true,
    cinoptions  = 'l1,=4,:4,(0,{0,+2,w1,W4,t0,j1,J1',
    shortmess   = 'fFcCtToOsSiIlnxW',
    cinkeys     = newCinkeys,
    viminfo     = '',
    display     = 'lastline',
    swapfile    = false,
    hlsearch    = true,
    incsearch   = true,
    -- colorcolumn = '80',
    -- scrolloff   = 5,
    updatetime  = 50,

    -- Docs: http://vimhelp.appspot.com/eval.txt.html
    fillchars = 'stlnc:|,vert:|,fold:.,diff:.',
})

util.setValuesInObject(vim.g, {
    netrw_liststyle = 0,
    netrw_banner    = 0,
    netrw_keepdir   = 1,
})

---

local function makeOperatorPrefix(name, prefix)
    local result = {
        name = name,
        -- prefix = prefix,
        on = function(operator)
            return prefix .. operator
        end
    }
    return result
end

local         leader = makeOperatorPrefix('Leader',    '<leader>')
local    localLeader = makeOperatorPrefix('Leader',    '<localleader>')

local carriageReturn = makeOperatorPrefix('Return',    '<CR>')
local         delete = makeOperatorPrefix('Delete',    '<Del>')
local      backspace = makeOperatorPrefix('Backspace', '<BS>')

local function makeRegister(name, prefix)
    local result = {
        name = name,
        -- prefix = prefix,
        on = function(operator)
            return '"' .. prefix .. operator
        end
    }

    return result
end

local systemRegister = makeRegister('system', '+')
local nullRegister   = makeRegister('null', '_')

local autoGroup = vim.api.nvim_create_augroup('AutoGroup', { clear = true })
local function makeCommand(event, pattern, action)
    local opts = {
        pattern = pattern,
        group   = autoGroup,
    }
    local action_type = type(action)
    if action_type == 'function' then
        opts.callback = action
    elseif action_type == 'string' then
        opts.command = action
    else
        -- vim.cmd.echoerr('action in autoCmd was set to value of unsupported type ' .. action_type)
        return
    end
    return vim.api.nvim_create_autocmd(event, opts)
end

function exports.syntax(flag)
    vim.cmd.syntax(flag and 'on' or 'off')
end

-- Find highlight group under cursor
util.keymap('n', '<C-g><C-h>', function()
    local result = vim.treesitter.get_captures_at_cursor(0)
    print(vim.inspect(result))
end, { noremap = true, silent = false })

-- Open vim explore
util.keymap('n', leader.on('ef'), vim.cmd.Ex, { desc = 'Open directory current file is in' })

-- Consistency is key
util.keymap('n', 'Y', 'y$', { desc = 'Copy to end of line' })

-- leader and carriage-return + command
local function operatorToRegister(modes, prefix, register, ops)
    for k, operator in pairs(ops) do
        local keyBinding = k

        if type(k) == 'number' then
            keyBinding = operator
        end

        local extraArg = { desc = operator .. ' operator on ' .. register.name .. ' register' }
        util.keymap(modes, prefix.on(keyBinding), register.on(operator), extraArg)
    end
end

local operators = { 'd', 'c', 'p', 'P', 'y', Y = 'y$' }
operatorToRegister({ 'n', 'v' }, carriageReturn, nullRegister, operators) -- Use null register
operatorToRegister({ 'n', 'v' }, leader,       systemRegister, operators) -- Use system register
util.keymap('v', carriageReturn.on('p'), nullRegister.on('dP'), { desc = 'Replace text without cutting' }) -- special case

local clipboard_copy = util.copy_command('')
util.keymap('n', leader.on('cp'), function()
    local absolute_path = vim.fn.getcwd():gsub('[\n\r]', '')
    clipboard_copy(absolute_path)
    print('Copied current path (' .. absolute_path .. ') to clipboard')
end, { desc = 'Copy current path to clipboard' })

util.keymap('n', leader.on('nn'), function()
    vim.o.number = not vim.o.number
end, { desc = 'Toggle line numbers' })

util.keymap('n', leader.on('nr'), function()
    vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'Toggle relative numbers' })

util.keymap('n', leader.on('s'), ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Search word under cursor' })
util.keymap('n', leader.on('df'), function()
    if vim.o.diff then
        vim.cmd.diffoff()
    else
        vim.cmd.diffthis()
    end
end, { desc = 'Toggle diff' })

util.keymap('t', '<C-w>',  '<C-\\><C-n><C-w>', { desc = 'Win commands in terminal' })
util.keymap('t', '<C-w>[', '<C-\\><C-n>',      { desc = 'Change to normal mode in terminal' })
util.keymap('t', '<C-w><C-[>', '<C-\\><C-n>',  { desc = 'Change to normal mode in terminal' })

-- Do not respond to these keys
util.keymap({ 'n', 'v', 'o' }, { '<CR>', '<Del>', '<BS>', '<Space>', 'Q' }, '', { desc = 'No-op' })

util.keymap('n', carriageReturn.on('j'), 'o<Esc>', { desc = 'Make new line below' })
util.keymap('n', carriageReturn.on('k'), 'O<Esc>', { desc = 'Make new line above' })

util.keymap('c', '<C-f>', '<Right>', { desc = 'Forward' })
util.keymap('c', '<C-b>', '<Left>', { desc = 'Back' })
util.keymap('c', '<C-a>', '<C-b>', { desc = 'Beginning' })
util.keymap('c', '<C-d>', '<Del>', { desc = 'Delete' })

util.keymap('c', '<C-W>', '\\<\\><Left><Left>', { desc = 'Search for word' })

-- Move selected lines up and down
util.keymap('v', '<C-J>', ':m \'>+1<CR>gv=gv', { desc = 'Move lines down and match indent' })
util.keymap('v', '<C-K>', ':m \'<-2<CR>gv=gv', { desc = 'Move lines up and match indent' })
-- vnoremap <C-J> :m '>+1<CR>gv=gv
-- vnoremap <C-K> :m '<-2<CR>gv=gv

-- Horizontal scrolling. Only useful when wrap is turned off.
util.keymap('n', '<C-J>', 'zl', { desc = 'Scroll right' })
util.keymap('n', '<C-H>', 'zh', { desc = 'Scroll left' })

-- Make current file executable
util.keymap('n', leader.on('ex'), function()
    local filename = vim.fn.expand('%')
    local is_executable = vim.fn.executable('./' .. filename)

    local sign = '+'
    if is_executable ~= 0 then
        sign = '-'
    end

    local command = { 'chmod', sign .. 'x', filename }
    vim.fn.system(command)
end, { desc = 'Toggle executable flag on current file' })

local function GotoBeginningOfLine()
    local command = '0'
    if vim.fn.indent('.') + 1 ~= vim.fn.col('.') then
        command = '^'
    end
    vim.cmd { cmd = 'normal', args = {command}, bang = true }
end

util.keymap({'n', 'v', 'o'}, { '0', '^' }, GotoBeginningOfLine, { desc = 'Go to beginning of line' })
util.keymap({'n', 'v', 'o'}, '-', '$', { desc = 'Go to end of line' })

-- Open in new tab
makeCommand('FileType', { 'help', 'man' }, function()
    vim.cmd.wincmd('T')
end)

-- Wrap lines
makeCommand('FileType', { 'txt', 'markdown', 'md', 'notes', 'org', 'tex', 'plaintex' }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- NOTE: Cannot pass { buf = bufnr } to any of these because the options are window-local
    vim.api.nvim_set_option_value('wrap', true, {})
    vim.api.nvim_set_option_value('linebreak', true, {})
    vim.api.nvim_set_option_value('list', false, {})
    util.keymap('n', 'j', 'gj', { buffer = bufnr, desc = 'Go down one visual line' })
    util.keymap('n', 'k', 'gk', { buffer = bufnr, desc = 'Go up one visual line' })
end)

-- Python
makeCommand('FileType', { 'py' }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value('tabstop', 4, { buf = bufnr })
end)

-- EncryptedFile
makeCommand('User', 'GnuPG', function()
    vim.o.undofile = false
    local filename = vim.fn.expand('%')
    filename = string.sub(filename, 1, #filename - #'.gpg')
    vim.o.filetype = vim.filetype.match { filename = filename }
end)

-- JSONComments
makeCommand('FileType', 'json', function()
    vim.cmd.syntax([[match Comment +\/\/.\+$+]])
end)

-- TabOnlyFiles
makeCommand({ 'BufNewFile', 'BufRead' }, { 'Makefile', 'makefile', 'Caddyfile', '*.go' }, function()
    vim.o.expandtab = false
end)

-- makeCommand({ 'FileType' }, { 'clojure', 'lisp', 'scheme' }, function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     -- Newline in lisp/clojure/scheme
--     util.keymap({ 'n', 'v', 'o' }, '(', '[(', { buffer = bufnr, desc = 'Skip to (' })
--     util.keymap({ 'n', 'v', 'o' }, ')', '])', { buffer = bufnr, desc = 'Skip to )' })
-- end)

-- Navigation
util.keymap('n', '<leader>mt', function() vim.cmd.tabnew() end, { desc = 'Create new tab' })

function MoveTab(multiplier)
    local amount = (vim.v.count ~= 0) and vim.v.count or 1
    local cur_tab = vim.fn.tabpagenr()
    local n_tabs  = vim.fn.tabpagenr('$')
    local new_place = cur_tab + multiplier * amount

    if new_place <= 0 then
        amount = cur_tab - 1
    elseif new_place > n_tabs then
        amount = n_tabs - cur_tab
    end

    amount = multiplier * amount
    if amount ~= 0 then
        amount = (multiplier > 0 and '+' or '') .. amount
        vim.cmd.tabmove(amount)
    end
end

util.keymap('n', '<leader>{', function() MoveTab(-1) end, { desc = 'Move current tab to the left' })
util.keymap('n', '<leader>}', function() MoveTab( 1) end, { desc = 'Move current tab to the right' })

-- Splits
util.keymap('n', '<leader>mv', function() vim.cmd 'vnew' end, { desc = 'Create new vertical split' })

util.keymap('n', '<M-s>', function()
    local layout = vim.fn.winlayout()
    -- Any layout of multiple splits will be turned into a single buffer view
    -- single buffer view will turn into 2 side-by-side buffers
    if layout[1] ~= 'leaf' then
        vim.cmd.wincmd('o')
    else
        -- TODO: If window is thinner than it is wide, make it use horizontal splits
        vim.cmd.vnew()
    end
end, { desc = 'Toggle a vertical split' })

util.keymap('n', '<M-k>', function() vim.cmd.wincmd('k') end, { desc = 'Move one pane up' })
util.keymap('n', '<M-j>', function() vim.cmd.wincmd('j') end, { desc = 'Move one pane down' })
util.keymap('n', '<M-h>', function() vim.cmd.wincmd('h') end, { desc = 'Move one pane left' })
util.keymap('n', '<M-l>', function() vim.cmd.wincmd('l') end, { desc = 'Move one pane right' })

-- Commands
local function createCommand(customCommands, opts, handler)
    for _, cmd in ipairs(customCommands) do
        vim.api.nvim_create_user_command(cmd, function(tbl)
            tbl.args = vim.api.nvim_parse_cmd('a ' .. tbl.args, {}).args
            handler(tbl)
        end, opts)
    end
end

local function QWE_fn(str)
    return function(tbl)
        vim.cmd { cmd = str, bang = tbl.bang, args = tbl.args }
    end
end

createCommand({ 'Q' }, { bang = true }, QWE_fn('q'))
createCommand({ 'W' }, { bang = true, nargs = '?', complete = 'file' }, QWE_fn('w'))
createCommand({ 'E' }, { bang = true, nargs = '?', complete = 'file' }, QWE_fn('e'))

createCommand({ 'Qa', 'QA' }, { bang = true }, QWE_fn('qa'))
createCommand({ 'Wq', 'WQ' }, { bang = true, nargs = '?', complete = 'file' }, QWE_fn('wq'))

createCommand({ 'RmColor' }, {}, function(tbl)
    local lastSearch = vim.fn.getreg('/', 1)
    vim.cmd [[ %s/[[0-9;]*[mK]//g ]]
    vim.fn.setreg('/', lastSearch)
end)

--[[
    Usage:
        1. cd to directory you want to use
            :cd directory
        2. Read add files from current directory
            :r !ls
        3. Edit file list. Do NOT:
            - Reorder names
            - Remove names
        4. Call the RenameFiles command
            :RenameFiles
        5. Run commands from buffer in your favorite shell
            :w !zsh
]]

createCommand({ 'RenameFiles' }, {}, function()
    local lines = vim.fn.filter(vim.fn.getline(1, '$'), function(index, value)
        return value:len() > 0
    end)
    local file_list = vim.fn.split(vim.fn.system('ls'), '\n')
    if #lines ~= #file_list then
        vim.cmd(
            'echoerr \"Number of lines in buffer (' .. #lines ..
            ') does not match number of files in current directory (' .. #file_list .. ')\"')
        return
    end
    vim.fn.deletebufline(vim.fn.bufnr(), 1, '$')
    local commands = vim.fn.map(vim.fn.range(#file_list), function(index, value)
        -- NOTE: Not an exhaustive list of characters that need to be escaped in bash
        local sub_pattern = '([\"\'\\$!`&])'
        local replacement = '\\%1'
        local old_file_name = file_list[index + 1]:gsub(sub_pattern, replacement)
        local new_file_name = lines[index + 1]:gsub(sub_pattern, replacement)
        return 'mv \"' .. old_file_name .. ' \"' .. new_file_name .. '\"'
    end)
    vim.fn.append(0, commands)
end)

return exports