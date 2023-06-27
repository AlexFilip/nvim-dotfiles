
-- TODO: Add tab management and drawing functions here
-- Shortcuts
vim.keymap.set("n", "<leader>cv", function() vim.cmd 'vnew' end, { desc = "Create new vertical split" })
vim.keymap.set("n", "<leader>ct", function() vim.cmd 'tabnew' end, { desc = "Create new tab" })
-- vim.keymap.set("n", "<leader>tv",  vim.cmd 'vnew | wincmd H', { desc = "Create new vertial split on left" })

vim.keymap.set("n", "<M-p>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<M-n>", "gT", { desc = "Prev tab" })

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

vim.keymap.set("n", "<leader>{", function() MoveTab(-1) end, { desc = "Move current tab to the left" })
vim.keymap.set("n", "<leader>}", function() MoveTab( 1) end, { desc = "Move current tab to the right" })

