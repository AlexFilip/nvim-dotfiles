
local function createCommand(customCommand, opts, handler)
    vim.api.nvim_create_user_command(customCommand, function(tbl)
        tbl.args = vim.api.nvim_parse_cmd("a " .. tbl.args, {}).args
        handler(tbl)
    end, opts)
end

function QWE_fn(str)
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
    -- TODO: Save existing search, replace after performing current search then noh
    vim.cmd [[ %s/[[0-9;]*[mK]//g ]]
end)


createCommand("RenameFiles", {}, function()
    -- local lines = filter(getline(1, '$'), {idx, val -> len(val) > 0})
    -- local file_list = split(system("ls"), '\n')

    -- if len(lines) != len(file_list) then
    --     echoerr join(["Number of lines in buffer (", len(lines),
    --                 \ ") does not match number of files in current directory (", \ len(file_list),
    --                 \ ")"], "")
    --     return
    -- end

    -- local commands = repeat([''], len(file_list))
    -- for index in range(len(file_list)) do
    --     -- TODO: replace characters that need escaping with \char
    --     commands[index] = join(["mv \"", file_list[index], "\" \"", lines[index], "\""], "")
    -- end

    -- vim.cmd.normal "gg\"_dG"

    -- Write value of `commands` to the buffer
    --   `put` writes value of register to file
    --   =<expr> treats an expression as a register
    -- vim.cmd.put "=commands"

    -- I would still have to make sure that all of the appropriate characters
    -- in the filename, like quotes, are escaped.
    --
    -- Start by running :r !ls
    -- Change names within the document
    -- Run :w !zsh after this (use your shell of choice. Can get this with &shell)
end)
