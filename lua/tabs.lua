
-- TODO: Add tab management and drawing functions here
-- Shortcuts
vim.keymap.set("n", "<leader>cv", function() vim.cmd 'vnew' end, { desc = "Create new vertical split" })
vim.keymap.set("n", "<leader>ct", function() vim.cmd 'tabnew' end, { desc = "Create new tab" })
-- vim.keymap.set("n", "<leader>tv",  vim.cmd 'vnew | wincmd H', { desc = "Create new vertial split on left" })


vim.keymap.set("n", "<M-1>",  "1gt", { desc = "Navigate to tab 1" })
vim.keymap.set("n", "<M-2>",  "2gt", { desc = "Navigate to tab 2" })
vim.keymap.set("n", "<M-3>",  "3gt", { desc = "Navigate to tab 3" })
vim.keymap.set("n", "<M-4>",  "4gt", { desc = "Navigate to tab 4" })
vim.keymap.set("n", "<M-5>",  "5gt", { desc = "Navigate to tab 5" })
vim.keymap.set("n", "<M-6>",  "6gt", { desc = "Navigate to tab 6" })
vim.keymap.set("n", "<M-7>",  "7gt", { desc = "Navigate to tab 7" })
vim.keymap.set("n", "<M-8>",  "8gt", { desc = "Navigate to tab 8" })
vim.keymap.set("n", "<M-9>",  "9gt", { desc = "Navigate to tab 9" })
vim.keymap.set("n", "<M-0>", "10gt", { desc = "Navigate to tab 10" })

vim.keymap.set("n", "<M-l>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<M-h>", "gT", { desc = "Prev tab" })

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

