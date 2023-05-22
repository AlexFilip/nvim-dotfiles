
local function createCommand(customCommand, opts, handler)
    vim.api.nvim_create_user_command(customCommand, function(tbl)
        tbl.args = vim.api.nvim_parse_cmd("a " .. tbl.args, {}).args
        handler(tbl)
    end, opts)
end

createCommand("Q", { bang = true }, function(tbl)
    vim.cmd{ cmd = "q", bang = tbl.bang }
end)

local function doQA(tbl)
    vim.cmd { cmd = "qa" , bang = tbl.bang }
end
createCommand("Qa", { bang = true }, doQA)
createCommand("QA", { bang = true }, doQA)

createCommand("E", { bang = true, nargs = "?", complete = "file" }, function(tbl)
    vim.cmd { cmd = "e", bang = tbl.bang, args = tbl.args }
end)

createCommand("W", { bang = true, nargs = "?", complete = "file" }, function(tbl)
    vim.cmd { cmd = "w", bang = tbl.bang, args = tbl.args }
end)

createCommand("RmColor", {}, function(tbl)
    -- TODO: Save existing search, replace after performing current search then noh
    vim.cmd [[ %s/[[0-9;]*[mK]//g ]]
end)
