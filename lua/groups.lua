local util = require('util')

local autoGroup = vim.api.nvim_create_augroup("AutoGroup", { clear = true })
local function makeCommand(event, pattern, action)
    local opts = {
        pattern = pattern,
        group   = autoGroup,
    }
    local action_type = type(action)
    if action_type == "function" then
        opts.callback = action
    elseif action_type == "string" then
        opts.command = action
    else
        -- vim.cmd.echoerr('action in autoCmd was set to value of unsupported type ' .. action_type)
        return
    end
    return vim.api.nvim_create_autocmd(event, opts)
end

-- OpenInNewTab
makeCommand("FileType", { "help", "man" }, function()
    vim.cmd.wincmd("T")
end)

-- WrapLines
makeCommand("FileType", { "txt", "markdown", "md", "notes", "org", "tex", "plaintex" }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- NOTE: Cannot pass { buf = bufnr } to any of these because the options are window-local
    vim.api.nvim_set_option_value('wrap', true, {})
    vim.api.nvim_set_option_value('linebreak', true, {})
    vim.api.nvim_set_option_value('list', false, {})
    util.nnoremap("j", "gj", { buffer = bufnr, desc = "Go down one visual line" })
    util.nnoremap("k", "gk", { buffer = bufnr, desc = "Go up one visual line" })
end)

-- Python
makeCommand("FileType", { "py" }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value('tabstop', 4, { buf = bufnr })
end)

-- EncryptedFile
makeCommand("User", "GnuPG", function()
    vim.o.undofile = false
    local filename = vim.fn.expand("%")
    filename = string.sub(filename, 1, #filename - #".gpg")
    vim.o.filetype = vim.filetype.match { filename = filename }
end)

-- JSONComments
makeCommand("FileType", "json", function()
    vim.cmd.syntax([[match Comment +\/\/.\+$+]])
end)

-- TabOnlyFiles
makeCommand({ "BufNewFile", "BufRead" }, { "Makefile", "makefile", "Caddyfile", "*.go" }, function()
    vim.o.expandtab = false
end)

makeCommand({ "BufRead" }, { "*.clj", "*.lisp", "*.cl", "*.scm" }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Newline in lisp/clojure/scheme
    util.nnoremap("(", "[(", { buffer = bufnr, desc = "Skip to (" })
    util.nnoremap(")", "])", { buffer = bufnr, desc = "Skip to )" })

    util.vnoremap("(", "[(", { buffer = bufnr, desc = "Skip to (" })
    util.vnoremap(")", "])", { buffer = bufnr, desc = "Skip to )" })

    util.onoremap("(", "[(", { buffer = bufnr, desc = "Skip to (" })
    util.onoremap(")", "])", { buffer = bufnr, desc = "Skip to )" })
end)
