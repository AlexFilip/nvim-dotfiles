
-- TODO: Add tab management and drawing functions here
-- Shortcuts
vim.keymap.set("n", "<leader>cv", function() vim.cmd 'vnew' end)
vim.keymap.set("n", "<leader>ct", function() vim.cmd 'tabnew' end)
-- vim.keymap.set("n", "<leader>tv",  vim.cmd 'vnew | wincmd H')

vim.keymap.set("n", "<C-p>", "gt")
vim.keymap.set("n", "<C-n>", "gT")

function MoveTab(multiplier)
    local amount = (vim.v.count ~= 0) and vim.v.count or 1
    local cur_tab = vim.fn.tabpagenr()
    local n_tabs  = vim.fn.tabpagenr("$")
    local new_place = cur_tab + multiplier * amount

    if new_place <= 0 then
        amount = cur_tab - 1
    elseif new_place > n_tabs then
        amount = n_tabs - cur_tab
    end

    amount = multiplier * amount
    if amount ~= 0 then
        amount = (multiplier > 0 and "+" or "") .. amount
        vim.cmd.tabmove(amount)
    end
end

vim.keymap.set("n", "<leader>{", function() MoveTab(-1) end)
vim.keymap.set("n", "<leader>}", function() MoveTab( 1) end)

