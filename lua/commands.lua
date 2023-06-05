
local function createCommand(customCommand, opts, handler)
    vim.api.nvim_create_user_command(customCommand, function(tbl)
        tbl.args = vim.api.nvim_parse_cmd("a " .. tbl.args, {}).args
        handler(tbl)
    end, opts)
end

local function QWE_fn(str)
    return function(tbl)
        vim.cmd { cmd = str, bang = tbl.bang, args = tbl.args }
    end
end

createCommand("Q", { bang = true }, QWE_fn("q"))
createCommand("W", { bang = true, nargs = "?", complete = "file" }, QWE_fn("w"))
createCommand("E", { bang = true, nargs = "?", complete = "file" }, QWE_fn("e"))

createCommand("Qa", { bang = true }, QWE_fn("qa"))
createCommand("QA", { bang = true }, QWE_fn("qa"))
createCommand("Wq", { bang = true, nargs = "?", complete = "file" }, QWE_fn("wq"))
createCommand("WQ", { bang = true, nargs = "?", complete = "file" }, QWE_fn("wq"))

createCommand("RmColor", {}, function(tbl)
    local lastSearch = vim.fn.getreg("/", 1)
    vim.cmd [[ %s/[[0-9;]*[mK]//g ]]
    vim.fn.setreg("/", lastSearch)
end)


--[[
    Usage:
        1. cd to directory you want to use
            :cd directory
        2. Read add files from current directory
            :r !ls
        3. Edit file list. Do NOT:
            - Reorder names
            - Remove names
        4. Call the RenameFiles command
            :RenameFiles
        5. Run commands from buffer in your favorite shell
            :w !zsh
]]
createCommand("RenameFiles", {}, function()
    local lines = vim.fn.filter(vim.fn.getline(1, '$'), function(index, value)
        return value:len() > 0
    end)

    local file_list = vim.fn.split(vim.fn.system("ls"), '\n')

    if #lines ~= #file_list then
        vim.cmd("echoerr " .. vim.fn.join({
            "\"",
            "Number of lines in buffer (", #lines,
            ") does not match number of files in current directory (", #file_list,
            ")",
            "\""
        }, ""))
        return
    end

    vim.fn.deletebufline(vim.fn.bufnr(), 1, "$")

    local commands = vim.fn.map(vim.fn.range(#file_list), function(index, value)
        return vim.fn.join({ "mv \"", file_list[index + 1], "\" \"", lines[index + 1], "\"" }, "")
    end)
    vim.fn.append(0, commands)
end)
