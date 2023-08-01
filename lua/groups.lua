
local groups = {}

local exports = {}
function exports:makeGroup(name)
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

local OpenInNewTab = exports:makeGroup("OpenInNewTab")
OpenInNewTab:autoCmd("FileType", { "help", "man" }, function() 
    vim.cmd.wincmd("T")
end)

local WrapLines = exports:makeGroup("WrapLines")
WrapLines:autoCmd("FileType", { "txt", "markdown", "md", "notes", "org", "tex", "plaintex" }, function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value('wrap', true, { buf = bufnr })
    vim.api.nvim_set_option_value('linebreak', true, { buf = bufnr })
    vim.api.nvim_set_option_value('list', false, { buf = bufnr })

    vim.keymap.set("n", "j", "gj", { buffer = bufnr, desc = "Go down one visual line" })
    vim.keymap.set("n", "k", "gk", { buffer = bufnr, desc = "Go up one visual line" })

end)

local Python = exports:makeGroup("Python")
Python:autoCmd("FileType", { "py" }, function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value('tabstop', 4, { buf = bufnr })
end)


local Terraform = exports:makeGroup("Terraform")
Terraform:autoCmd("BufWritePre",  "*.tf", function() 
    -- In lua anything that is not `false`, including 0, is true
    if vim.fn.executable("terraform") ~= 0 then
        vim.lsp.buf.format()
    end
end)

local EncryptedFile  = exports:makeGroup("EncryptedFile")
EncryptedFile:autoCmd("User", "GnuPG", function() 
    vim.o.undofile = false

    local filename = vim.fn.expand("%")
    filename = string.sub(filename, 1, #filename - #".gpg")
    vim.o.filetype = vim.filetype.match { filename = filename }
end)

local JSONComments = exports:makeGroup("JSONComments")
JSONComments:autoCmd("FileType", "json", function()
    vim.cmd.syntax([[match Comment +\/\/.\+$+]])
end)

local TabOnlyFiles = exports:makeGroup("TabOnlyFiles")
TabOnlyFiles:autoCmd({ "BufNewFile", "BufRead" }, { "Makefile", "makefile" }, function()
    vim.o.expandtab = false
end)

local EnterAndLeave = exports:makeGroup("EnterAndLeave")
EnterAndLeave:autoCmd("WinEnter",    "*", function() vim.o.cursorline = true  end)
EnterAndLeave:autoCmd("WinLeave",    "*", function() vim.o.cursorline = false end)
EnterAndLeave:autoCmd("InsertEnter", "*", function() vim.o.cursorline = false end)
EnterAndLeave:autoCmd("InsertLeave", "*", function() vim.o.cursorline = true  end)

-- TODO: I may be able to do this differently so that I don't have to use
-- a terminal but I also need to make sure that the buffer is deleted when
-- it's closed. Maybe I should reuse existing ones and allow the number of
-- buffers to be adjustable.
local NeovimTerm = exports:makeGroup("NeovimTerm")
NeovimTerm:autoCmd("TermOpen", "*", function() 
    -- TODO:
    -- let g:term_statuses[b:terminal_job_id] = 1
end)
NeovimTerm:autoCmd("TermClose", "*", function() 
    -- TODO:
    -- let g:term_statuses[b:terminal_job_id] = 0
end)

local FileHeaders = exports:makeGroup("FileHeaders")
FileHeaders:autoCmd("BufNewFile", { "*.c", "*.cpp", "*.h", "*.hpp" }, function() 
    -- TODO:
    -- CreateSourceHeader()
end)

local Recording = exports:makeGroup("Recording")
Recording:autoCmd("RecordingEnter", "*", function()
    -- vim.o.cmdheight = 1
end)
Recording:autoCmd("RecordingLeave", "*", function()
    -- vim.o.cmdheight = 0
end)

return exports
