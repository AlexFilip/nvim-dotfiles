
local MiscFileGroup  = vim.api.nvim_create_augroup("MiscFile", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    group = MiscFileGroup,
    callback = function() 
        vim.cmd.wincmd("L")
    end
})
-- augroup MiscFile
--     autocmd!
--     autocmd FileType help wincmd L
--     " Reload vimrc on write
--     " Neither of these work
--     autocmd BufWritePost $MYVIMRC  source $MYVIMRC
--     autocmd BufWritePost $MYGVIMRC source $MYGVIMRC
-- augroup END

local WrapLinesGroup = vim.api.nvim_create_augroup("WrapLines", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "txt", "org", "tex" },
    group = WrapLinesGroup,
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buffer_options = vim.bo[bufnr]
        buffer_options.wrap = true
        buffer_options.linebreak = true
        buffer_options.list = false
    end
})

local TerraformGroup = vim.api.nvim_create_augroup("Terraform", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tf",
    group = TerraformGroup,
    callback = function() 
        -- In lua anything that is not `false`, including 0, is true
        if vim.fn.executable("terraform") ~= 0 then
            io.popen("terraform fmt " .. vim.fn.expand("%"))
        end
    end
})

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
