
local util = require('util')

-- Tabs
util.nnoremap("<leader>mt", function() vim.cmd.tabnew() end, { desc = "Create new tab" })

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

util.nnoremap("<leader>{", function() MoveTab(-1) end, { desc = "Move current tab to the left" })
util.nnoremap("<leader>}", function() MoveTab( 1) end, { desc = "Move current tab to the right" })

-- Splits
util.nnoremap("<leader>mv", function() vim.cmd 'vnew' end, { desc = "Create new vertical split" })

util.nnoremap("<M-s>", function()
    local layout = vim.fn.winlayout()
    -- Any layout of multiple splits will be turned into a single buffer view
    -- single buffer view will turn into 2 side-by-side buffers
    if layout[1] ~= 'leaf' then
        vim.cmd.wincmd("o")
    else
        -- TODO: If window is thinner than it is wide, make it use horizontal splits
        vim.cmd.vnew()
    end
end, { desc = "Toggle a vertical split" })

util.nnoremap("<M-k>", function() vim.cmd.wincmd("k") end, { desc = "Move one pane up" })
util.nnoremap("<M-j>", function() vim.cmd.wincmd("j") end, { desc = "Move one pane down" })
util.nnoremap("<M-h>", function() vim.cmd.wincmd("h") end, { desc = "Move one pane left" })
util.nnoremap("<M-l>", function() vim.cmd.wincmd("l") end, { desc = "Move one pane right" })

