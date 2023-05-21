
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

local OpenInNewTab = M:makeGroup("OpenInNewTab")
OpenInNewTab:autoCmd("FileType", { "help", "man" }, function() 
    vim.cmd.wincmd("T")
end)

local WrapLinesGroup = M:makeGroup("WrapLines")
WrapLinesGroup:autoCmd("FileType", { "txt", "markdown", "md", "notes", "org", "tex", "plaintex" }, function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value('wrap', true, { buf = bufnr })
    vim.api.nvim_set_option_value('linebreak', true, { buf = bufnr })
    vim.api.nvim_set_option_value('list', false, { buf = bufnr })
end)

local PythonGroup = M:makeGroup("Python")
WrapLinesGroup:autoCmd("FileType", { "py" }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value('tabstop', 4, { buf = bufnr })
end)


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
    local filename = vim.fn.expand("%")
end)
EncryptedFileGroup:autoCmd("User", "GnuPG", function() 
    vim.o.undofile = false
end)

-- augroup encrypted_file
--   au!
--   autocmd BufNewFile,BufRead *.org.gpg set ft=org | set formatoptions-=cro
--   autocmd User GnuPG setlocal noundofile
-- augroup END

local JSONComments = M:makeGroup("JSONComments")
JSONComments:autoCmd("FileType", "json", function()
    vim.cmd.syntax([[match Comment +\/\/.\+$+]])
end)

local TabOnlyFiles = M:makeGroup("TabOnlyFiles")
TabOnlyFiles:autoCmd({ "BufNewFile", "BufRead" }, { "Makefile", "makefile" }, function()
    vim.o.expandtab = false
end)

local EnterAndLeave = M:makeGroup("EnterAndLeave")
EnterAndLeave:autoCmd("WinEnter",    "*", function() vim.o.cursorline = true  end)
EnterAndLeave:autoCmd("WinLeave",    "*", function() vim.o.cursorline = false end)
EnterAndLeave:autoCmd("InsertEnter", "*", function() vim.o.cursorline = false end)
EnterAndLeave:autoCmd("InsertLeave", "*", function() vim.o.cursorline = true  end)

-- TODO: I may be able to do this differently so that I don't have to use
-- a terminal but I also need to make sure that the buffer is deleted when
-- it's closed. Maybe I should reuse existing ones and allow the number of
-- buffers to be adjustable.
local NeovimTerm = M:makeGroup("NeovimTerm")
NeovimTerm:autoCmd("TermOpen", "*", function() 
    -- TODO:
    -- let g:term_statuses[b:terminal_job_id] = 1
end)
NeovimTerm:autoCmd("TermClose", "*", function() 
    -- TODO:
    -- let g:term_statuses[b:terminal_job_id] = 0
end)

local FileHeadersGroup = M:makeGroup("FileHeaders")
FileHeadersGroup:autoCmd("BufNewFile", { "*.c", "*.cpp", "*.h", "*.hpp" }, function() 
    -- TODO:
    -- CreateSourceHeader()
end)

return M
