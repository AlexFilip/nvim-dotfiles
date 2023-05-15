
local MiscFileGroup  = vim.api.nvim_create_augroup("MiscFile", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    group = MiscFileGroup,
    callback = function() 
        vim.cmd 'wincmd L'
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
        vim.cmd 'setlocal wrap linebreak nolist'
    end
})
-- augroup WrapLines
--     autocmd!
--     autocmd FileType {txt,org,tex} setlocal wrap linebreak nolist
-- augroup END

local TerraformGroup = vim.api.nvim_create_augroup("Terraform", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tf",
    group = TerraformGroup,
    callback = function() 
        system("terraform fmt %")
    end
})
-- augroup Terraform
--     autocmd!
--     autocmd BufWritePost *.tf silent !terraform fmt %
-- augroup END
