
local groups = {}

local M = {}
function M:makeGroup(name)
    local result = groups[name]
    if not result then
        result = {
            group = vim.api.nvim_create_augroup(name, { clear = true }),
            autoCmd = function(self, event, pattern, action)
                local opts = {
                    pattern = pattern,
                    group   = self.group,
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
        }

        groups[name] = result
    end

    return result
end

local HelpFileGroup = M:makeGroup("HelpFile")
HelpFileGroup:autoCmd("FileType", "help", function() 
    vim.cmd.wincmd("T")
end)

local ManGroup = M:makeGroup("Man")
ManGroup:autoCmd("FileType", "man", function() 
    vim.cmd.wincmd("T")
end)

local WrapLinesGroup = M:makeGroup("WrapLines")
WrapLinesGroup:autoCmd("FileType", { "txt", "org", "tex", "plaintex", "mkd" }, function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value('wrap', true, { buf = bufnr })
    vim.api.nvim_set_option_value('linebreak', true, { buf = bufnr })
    vim.api.nvim_set_option_value('list', false, { buf = bufnr })
end)

-- local WrapLinesGroup = vim.api.nvim_create_augroup("WrapLines", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "txt", "org", "tex" },
--     group = WrapLinesGroup,
--     callback = function()
--         local bufnr = vim.api.nvim_get_current_buf()
--         local buffer_options = vim.bo[bufnr]
-- 
--         buffer_options.wrap      = true
--         buffer_options.linebreak = true
--         buffer_options.list      = false
--     end
-- })

local TerraformGroup = M:makeGroup("Terraform")
TerraformGroup:autoCmd("BufWritePost",  "*.tf", function() 
    -- In lua anything that is not `false`, including 0, is true
    if vim.fn.executable("terraform") ~= 0 then
        io.popen("terraform fmt " .. vim.fn.expand("%"))
    end
end)


local EncryptedFileGroup  = M:makeGroup("EncryptedFile")
EncryptedFileGroup:autoCmd({ "BufNewFile", "BufRead" }, "*.gpg", function() 
    -- print("Hello")
    -- TODO: Get file name and split it up by dots. If it is something like abc.org.gpg. Make it have the same filetype as if abc.org was opened
end)

EncryptedFileGroup:autoCmd({ "BufNewFile", "BufRead" }, "*.gpg", function()
end)

-- augroup encrypted_file
--   au!
--   autocmd BufNewFile,BufRead *.org.gpg set ft=org | set formatoptions-=cro
--   autocmd User GnuPG setlocal noundofile
-- augroup END

-- augroup CommentHighlighting
--     autocmd!
--     autocmd FileType json syntax match Comment +\/\/.\+$+
-- augroup END

-- augroup TabOnlyFiles
--     autocmd!
--     autocmd BufNewFile,BufRead Makefile,makefile setlocal noexpandtab
-- augroup END

-- augroup EnterAndLeave
--     " Enable and disable cursor line in other buffers
--     " | call RedrawTabLine()
-- 
--     autocmd!
--     autocmd     WinEnter * set   cursorline
--     autocmd     WinLeave * set nocursorline
--     autocmd  InsertEnter * set nocursorline
--     autocmd  InsertLeave * set   cursorline
-- 
--     " autocmd CmdlineEnter *                    call RedrawTabLine()
--     " autocmd CmdlineLeave *                    call RedrawTabLine()
-- 
--     " autocmd CmdlineEnter / call OverrideModeName("Search") | call RedrawTabLine()
--     " autocmd CmdlineLeave / call OverrideModeName(0) | call RedrawTabLine()
-- 
--     " autocmd CmdlineEnter ? call OverrideModeName("Reverse Search") | call RedrawTabLine()
--     " autocmd CmdlineLeave ? call OverrideModeName(0) | call RedrawTabLine()
-- 
--     " I created these but they don't work as intended yet
--     " autocmd  VisualEnter *                    call RedrawTabLine()
--     " autocmd  VisualLeave *                    call RedrawTabLine()
-- augroup END

-- augroup NeovimTerm
--     autocmd!
--     " autocmd TermOpen  * let g:term_statuses[b:terminal_job_id] = 1
--     " autocmd TermClose * let g:term_statuses[b:terminal_job_id] = 0
-- augroup END

-- augroup FileHeaders
--     autocmd!
--     autocmd BufNewFile *.c,*.cpp,*.h,*.hpp call CreateSourceHeader()
-- augroup END

return M
