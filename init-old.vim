function! RenameFiles()
    " NOTE: Does not work on Windows, yet.
    " Empty lines are allowed
    let lines = filter(getline(1, '$'), {idx, val -> len(val) > 0})
    let file_list = split(system("ls"), '\n')

    if len(lines) != len(file_list)
        echoerr join(["Number of lines in buffer (", len(lines),
                    \ ") does not match number of files in current directory (", \ len(file_list),
                    \ ")"], "")
        return
    endif

    let commands = repeat([''], len(file_list))
    for index in range(len(file_list))
        " TODO: replace characters that need escaping with \char
        let commands[index] = join(["mv \"", file_list[index], "\" \"", lines[index], "\""], "")
    endfor

    normal gg"_dG
    " Write value of `commands` to the buffer
    "   `put` writes value of register to file
    "   =<expr> treats an expression as a register
    put =commands

    " I would still have to make sure that all of the appropriate characters
    " in the filename, like quotes, are escaped.
    "
    " Start by running :r !ls
    " Change names within the document
    " Run :w !zsh after this (use your shell of choice. Can get this with &shell)
endfunction
command! RenameFiles :call RenameFiles()