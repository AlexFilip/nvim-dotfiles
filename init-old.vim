
let s:dot_vim_path = fnamemodify(expand("$MYVIMRC"), ":p:h")

filetype plugin indent on
" colorscheme custom

" let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme='apprentice'
let g:airline_theme='pencil'

function! MoveTab(multiplier, count)
    let amount  = a:count ? a:count : 1
    let cur_tab = tabpagenr()
    let n_tabs  = tabpagenr("$")
    let new_place = cur_tab + a:multiplier * amount

    if new_place <= 0
        let amount = cur_tab - 1
    elseif new_place > n_tabs
        let amount = n_tabs - cur_tab
    endif

    if amount != 0
        let cmd = ['tabmove ', '', a:multiplier * amount]

        if a:multiplier > 0
            let cmd[1] = '+'
        endif

        let cmd = join(cmd, "")
        execute cmd
    endif
endfunction

nnoremap <silent> <leader>{ :<C-U>call MoveTab(-1, v:count)<CR>
nnoremap <silent> <leader>} :<C-U>call MoveTab(+1, v:count)<CR>


" Commands for convenience
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! -bang -nargs=? -complete=file W w<bang> <args>
command! -bang -nargs=? -complete=file E e<bang> <args>

let s:comment_leaders = {
    \ 'c' : '//',
    \ 'cpp' : '//',
    \ 'm' : '//',
    \ 'mm' : '//',
    \ 'vim' : '"',
    \ 'python' : '#',
    \ 'tex' : '%'
\ }

function! s:normRemoveCommentsAndJoinLines()
    if has_key(s:comment_leaders, &filetype)
        let leader = substitute(s:comment_leaders[&filetype], '\/', '\\/', 'g')

        let cur_pos = getpos(".")
        let current_line = cur_pos[1]

        " TODO: consider making the removal of the comment leader depend on
        " whether or not the previous line has the leader.
        if getline(current_line) =~ '^\s*' . leader
            let lastline = current_line + (v:count == 0 ? 1 : v:count)
            let command = join([(current_line+1), ",", lastline, 's/^\s*', leader, "\s*//e"], "")
            execute command
        endif

        call setpos(".", cur_pos)
    endif

    execute join(["normal! ", (v:count+1), "J"], "")
    silent! call repeat#set("\<Plug>JoinLines", v:count - 1)
endfunction
nnoremap <silent> <Plug>JoinLines :<C-U>call <SID>normRemoveCommentsAndJoinLines()<CR>
nmap <silent> J <Plug>JoinLines

function! RemoveCommentLeadersVisual() range
    if has_key(s:comment_leaders, &filetype)
        let leader = substitute(s:comment_leaders[&filetype], '\/', '\\/', 'g')

        if getline(a:firstline) =~ '^\s*' . leader
            let command = join([(a:firstline + 1), ",", a:lastline, 's/^\s*', leader, '\s*//e'], "")
            execute command
        endif
    endif

    normal! gvJ
    let count = a:lastline - a:firstline
    silent! call repeat#set("\<Plug>JoinLines", count)
endfunction
vnoremap <silent> J :call RemoveCommentLeadersVisual()<CR>

" NOTE: redrawtabline doesn't exist on all vim compiles so I have to check for
" it. Use this function instead so that the check isn't done every time
if exists(":redrawtabline")
    function! RedrawTabLine()
        redrawtabline
    endfunction
else
    function! RedrawTabLine()
    endfunction
endif

" =============================================
" Style changes

" Change cursor shape in different mode (macOS default terminal)
" For all cursor shapes visit
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
"                 Blink   Static
"         block ¦   1   ¦   2   ¦
"     underline ¦   3   ¦   4   ¦
" vertical line ¦   5   ¦   6   ¦

let &t_SI.="\e[6 q" " Insert mode
let &t_SR.="\e[4 q" " Replace mode
let &t_EI.="\e[2 q" " Normal mode

" Directory tree listing options
let g:netrw_liststyle = 0
let g:netrw_banner = 0
let g:netrw_keepdir = 1

" Docs: http://vimhelp.appspot.com/eval.txt.html
set fillchars=stlnc:\|,vert:\|,fold:.,diff:.

" Hours (24-hour clock) followed by minutes
let s:timeformat = has('win32') ? '%H:%M' : '%k:%M'

" Custom tabs
function! Tabs() abort
    " NOTE: getbufinfo() gets all variables of all buffers
    " Colours
    let cur_tab_page = tabpagenr()
    let n_tabs = tabpagenr("$")
    let max_file_name_length = 30

    " NOTE: Repeat is used to pre-allocate space, make sure that this is the
    " correct number of characters, otherwise you'll get an error

    let prefixes = []
    " %= is the separator between left and right side of tabline
    " %T specifies the end of the last tab
    let suffixes = ["%T%#TabLineFill#%=%#TabLineSel# ", strftime(s:timeformat), " "]

    let num_prefixes = len(prefixes)
    let num_suffixes = len(suffixes)

    let strings_per_tab = 7
    let s = repeat(['EMPTY!!!'], num_prefixes + n_tabs * strings_per_tab + num_suffixes)

    " TODO: Make this a different colour
    for i in range(num_prefixes)
        let s[i] = prefixes[i]
    endfor

    for i in range(num_suffixes)
        let s[i - num_suffixes] = suffixes[i]
    endfor

    for i in range(n_tabs)
        let n = i + 1
        let bufnum = tabpagebuflist(n)[tabpagewinnr(n) - 1]

        " %<num>T specifies the beginning of a tab
        let first_index = num_prefixes + i * strings_per_tab
        let s[first_index + 0] = "%"
        let s[first_index + 1] = n
        let s[first_index + 2] = n == cur_tab_page ? "T%#TabLineSel# " : "T%#TabLine# "
        let s[first_index + 3] = n

        " '-' for non-modifiable buffer, '+' for modified, ':' otherwise
        let modifiable = getbufvar(bufnum, "&modifiable")
        let modified   = getbufvar(bufnum, "&modified")
        let s[first_index + 4] = !modifiable ?  "- " : modified ? "* " : ": "

        let name = bufname(bufnum)
        let s[first_index + 5] = name == "" ?
                    \ "[New file]" : 
                    \ (len(name) >= max_file_name_length ?
                        \ "<" . name[-max_file_name_length:] :
                        \ name)
        let s[first_index + 6] = " "
    endfor

    return join(s, "")
endfunction

" Can type unicode codepoints with C-V u <codepoint> (ex. 2002)
" Maybe put the tabs in the status bar or vice-versa (probably better in the
" tab bar so that information is not duplicated
set tabline=%!Tabs()

call timer_stopall()
function! RedrawTabLineRepeated(timer)
    " Periodically redraw the tabline so that the current time is correct
    " echo "Redrawing tab line repeated " . strftime('%H:%M:%S')
    call RedrawTabLine()
endfunction

function! RedrawTabLineFirst(timer)
    " The first redraw of the tab line so that it updates on the minute
    " echo "Redrawing tab line first " . strftime('%H:%M:%S')
    call RedrawTabLine()
    call timer_start(1 * 1000 * 60, 'RedrawTabLineRepeated', {'repeat':-1})
endfunction

let s:seconds_until_next_minute = 60 - str2nr(strftime('%S'))
call timer_start(s:seconds_until_next_minute * 1000, 'RedrawTabLineFirst')

function! RemoveColorOutputFn()
    " TODO: Save existing search, replace after performing current search then noh
    %s/[[0-9;]*[mK]//g
endfunction

" ============================================
" Color Additions
" Highlighting in comments

" NOTE: Reloading causes tests above to stop working, just use :e to reload
" the file
augroup my_todo
    autocmd!
    autocmd Syntax *
        \   syn keyword CustomYellow     containedin=[a-zA-Z]*CommentL\? TODO OPTIMIZE HACK
        \ | syn keyword CustomGreen      containedin=[a-zA-Z]*CommentL\? NOTE INCOMPLETE
        \ | syn keyword CustomRed        containedin=[a-zA-Z]*CommentL\? XXX FIX FIXME BUG IMPORTANT
        \ | syn keyword CustomBlue       containedin=[a-zA-Z]*CommentL\? REVIEW SIMPLIFY
        \ | syn region  CustomDarkBlue   containedin=[a-zA-Z]*CommentL\? start='%\['  end='\]\|$'
augroup END

" Fruit salad for testing
"     FIX - FIXME - TODO - NOTE - XXX - OPTIMIZE - INCOMPLETE - BUG - HACK - REVIEW - SIMPLIFY

" cterm colours are not correct
hi CustomRed         guifg=#eb4034 guibg=NONE ctermfg=160 ctermbg=NONE gui=none cterm=none
hi CustomYellow      guifg=#d7d7af guibg=NONE ctermfg=187 ctermbg=NONE gui=none cterm=none
hi CustomGreen       guifg=#55bd53 guibg=NONE ctermfg=112 ctermbg=NONE gui=none cterm=none
hi CustomBlue        guifg=#33c0d6 guibg=NONE ctermfg=153 ctermbg=NONE gui=none cterm=none
hi CustomOrange      guifg=#e54f00 guibg=NONE ctermfg=166 ctermbg=NONE gui=none cterm=none
hi CustomDarkBlue    guifg=#5f87ff guibg=NONE ctermfg=69  ctermbg=NONE gui=none cterm=none
hi CustomHotPink     guifg=#d75faf guibg=NONE ctermfg=169 ctermbg=NONE gui=none cterm=none
hi CustomPurple      guifg=#950087 guibg=NONE ctermfg=90  ctermbg=NONE gui=none cterm=none

" ============================================
" Common variables that may be needed by other functions

" = Terminal commands ========================

" Search for a script named "build.bat" or "compile" moving up from the current path and run it.
" TODO: fix this for neovim
function! IsTerm()
    return get(getwininfo(bufwinid(bufnr()))[0], 'terminal', 0)
endfunction

if has('nvim')
    if !exists('g:term_statuses')
        " Don't remove terminal statuses if I'm working on this init file
        let g:term_statuses = {}
    endif
    " augroup NeovimTerm
    "     autocmd!
    "     " autocmd TermOpen  * let g:term_statuses[b:terminal_job_id] = 1
    "     " autocmd TermClose * let g:term_statuses[b:terminal_job_id] = 0
    " augroup END
endif

" function! s:TermExit(job_id, data, event) dict
"     let g:term_statuses[job_id] = 0
"     echo "Terminal exited"
" endfunction

function! IsTermAlive()
    if has('nvim') 
        let name = getbufvar("%", "terminal_job_id")
        return get(g:term_statuses, name, 0)
    else
        let job = term_getjob(bufnr())
        return job != v:null && job_status(job) != "dead"
    endif
endfunction

function! SwitchToOtherPaneOrCreate()
    let start_win = winnr()
    let layout = winlayout()

    if layout[0] == 'leaf'
        " Create new vertical pane and go to left one
        let is_window_vertical = str2float(&lines) * 2 > str2float(&columns)
        if has('nvim')
            if (is_window_vertical)
                new
            else
                vnew
            endif
        else
            if (is_window_vertical) 
                wincmd s
                wincmd j
            else
                wincmd v
                wincmd l
            endif
        endif
    elseif layout[0] == 'row'
        " Buffers layed out side by side
        wincmd l
        if winnr() == start_win
            wincmd h
        endif
    elseif layout[0] == 'col'
        " Buffers layed out one on top of the other
        wincmd j
        if winnr() == start_win
            wincmd k
        endif
    endif
endfunction

function! GotoLineFromTerm()
    if IsTerm()
        let line_contents = getline(".")
        let regex = has('win32') ? '[_A-Za-z0-9\.:\\]\+([0-9]\+)' : '^[_A-Za-z0-9/\-\.]\+:[0-9]\+:'

        if match(line_contents, regex) != -1
            if has('win32')
                let  open_paren = match(line_contents, '(', 0)
                let close_paren = match(line_contents, ')', open_paren)

                let filepath = line_contents[:open_paren-1]
                let line_num = line_contents[open_paren+1:close_paren-1]
                let col_num = 0
            else
                let [filepath, line_num, col_num] = split(line_contents, ":")[:2]
            endif

            let line_num = str2nr(line_num)
            if col_num =~ '^[0-9]\+'
                let col_num = str2nr(col_num)
            else
                let col_num = 0
            endif

            call SwitchToOtherPaneOrCreate()
            " NOTE: We might want to save the current file before switching
            execute "edit " . filepath

            if col_num == 0
                let col_num = indent(line_num) + 1
            endif

            call setpos(".", [0, line_num, col_num, 0])
            normal! zz
        else
            echo join(["Line does not match known error message format (", regex, ")"], "")
        endif
    endif
endfunction

function! DoCommandsInTerm(shell, commands, parent_dir, message)
    " Currently, this assumes you only have one split and uses only the top-most
    " part of the layout as the guide.

    " NOTE: The problem with this is that a terminal in a split that is not
    " right beside the current one will not be reused. This will create a new
    " terminal.

    if !IsTerm()
        call SwitchToOtherPaneOrCreate()
    endif

    let all_commands = a:commands
    if a:parent_dir isnot 0
        let all_commands = join(['cd "', a:parent_dir, '" && ', all_commands], "")
    endif

    if a:message isnot 0
        let all_commands .= ' && echo ' . a:message
    endif

    if has('nvim')
        if IsTermAlive()
            call chansend(b:terminal_job_id, all_commands . "\n")
        else
            let cmd = join(["terminal ", a:shell, "-c", '"' . all_commands . '"'], " ")
            execute cmd
            " call termopen(['zsh', '-c', all_commands]) ", { 'on_exit': 's:TermExit' })
        endif
    else
        if IsTermAlive()
            if get(job_info(term_getjob(bufnr())), 'cmd', [''])[0] =~ 'zsh'
                let all_commands = join(["\<Esc>cc", all_commands, "\r\n"], "")
            endif

            call term_sendkeys(bufnr(), all_commands)
        else
            let cmd = join(["terminal", a:shell, all_commands], " ")
            execute cmd
        endif
    endif
endfunction

function! SearchAndRun(script_names)
    " NOTE: I'm separating this out because it seems like it would be handy
    " for running tests as well
    let working_dir = has('win32') ? [] : [""]
    call extend(working_dir, split(getcwd(), g:path_separator))

    let directory_path = join(working_dir, g:path_separator) . g:path_separator
    let completed_message = "Completed Successfully"

    for script_name in a:script_names
        let file_path = directory_path . script_name

        if filereadable(file_path)
            if !executable(file_path)
                echoerr script_name . " found but is not executable"
            else
                " One problem with this is that I can't scroll through the
                " history to see all the errors from the beginning

                if has('win32')
                    " shell-init.bat should contain information to initialize the
                    " terminal environment with the compile path. This usually means
                    " calling vcvarsall.bat in the appropriate directory.
                    let script_name = 'C:\tools\shell-init.bat && ' . script_name
                    let completed_message = 0
                endif
                call DoCommandsInTerm(&shell, script_name, directory_path, completed_message)
            endif
        endif
    endfor

    if filereadable(join([directory_path, g:path_separator, "Makefile"], ""))
        call DoCommandsInTerm(&shell, "make", directory_path, completed_message)
    elseif filereadable(join([directory_path, g:path_separator, "Cargo.toml"], ""))
        call DoCommandsInTerm(&shell, "cargo build", directory_path, completed_message)
    else
        echo join(["No file named ", a:script_names, " found in current directory"], "")
    endif
endfunction

function! SearchAndCompile()
    let compile_script_name = has('win32') ? 'build.bat' : './compile'
    call SearchAndRun([compile_script_name, './run'])
endfunction

nnoremap <silent> <leader>g :call GotoLineFromTerm()<CR>
nnoremap <silent> <leader>c :call SearchAndCompile()<CR>

" =======================================

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

" = Projects ==================================

" NOTE: Option idea for project:
"   C/C++ with compile scripts and main
"   Client projects (compile scripts and a directory inside with the actual code)
" TODO: Project files that do not rely on compile command
if !exists('g:projects_directory')
    let g:projects_directory = has('win32') ? 'C:\projects' : '~/projects'
endif

function! ProjectsCompletionList(ArgLead, CmdLine, CursorPos)
    if a:ArgLead =~ '^-.\+' || a:ArgLead =~ '^++.\+'
        " TODO: command completion for options
    else
        let slash_index = len(a:ArgLead)
        while(slash_index >= 0 && a:ArgLead[slash_index] != '/')
            let slash_index -= 1
        endwhile

        let [project_lead, project_name_start] = slash_index < 0 ? ["", a:ArgLead ] : [a:ArgLead[:slash_index], a:ArgLead[slash_index + 1:]]

        let result = []
        let arg_match = join(["^", project_name_start, '.*\c'], "")

        for path in split(globpath(g:projects_directory . g:path_separator . project_lead, "*"), "\n")
            if isdirectory(path)
                let directory_name = split(path, g:path_separator)[-1]
                if directory_name =~ arg_match
                    call add(result, project_lead . directory_name . '/')
                endif
            endif
        endfor

        return sort(result, 'i')
    endif
endfunction

function! GoToProjectOrMake(bang, command_line)
    let path_start = 0
    let options = []

    while path_start < len(a:command_line)
        if match(a:command_line, '++', path_start) == path_start
            let path_start += 2
        elseif match(a:command_line, '-', path_start) == path_start
            let path_start += 1
        else
            break
        endif

        let option_end = match(a:command_line, '[ \t]\|$', path_start)
        let option = a:command_line[path_start:option_end-1]
        call add(options, option)

        let path_start = match(a:command_line, '[^ \t]\|$', option_end)
    endwhile

    let project_name = a:command_line[path_start:]

    if len(project_name) != 0
        execute 'cd ' . g:projects_directory
        if !isdirectory(project_name)
            if filereadable(project_name)
                if a:bang
                    call delete(project_name)
                else
                    echoerr project_name . ' exists and is not a directory. Use Project! to replace it with a new project.'
                    return
                endif
            endif
            echo join(['Created new project called "',  project_name, '"'], "")
            call mkdir(project_name)
        endif

        execute 'cd ' . project_name
        edit .
    else
        echoerr 'No project name specified'
        return
    endif
endfunction
command! -bang -nargs=1 -complete=customlist,ProjectsCompletionList  Project :call GoToProjectOrMake(<bang>0, <q-args>)

" = RFC =======================================
function! GetRFC(num)
    " NOTE: Does not work on windows unless curl is installed
    if a:num =~ '^[0-9]\+$'
        let num = a:num
        if len(num) < 4
            if num == '0'
                let num = '000'
            else
                let num = repeat('0', 4 - len(num)) . l:num
            endif
        endif

        let rfc_name = join(['rfc', l:num, '.txt'], "")
        let rfc_path = join([g:rfc_download_location, '/', rfc_name], "")

        if filereadable(rfc_path)
            " Do nothing here. Open file after if-else blocks
        elseif executable('curl')
            if !isdirectory(g:rfc_download_location)
                call mkdir(g:rfc_download_location)
            endif
            echo 'Downloading'
            call system(join(['curl https://www.ietf.org/rfc/', rfc_name, " -o '", rfc_path, "'"], ""))
        else
            echoerr 'curl is not installed on this machine'
            return
        endif

        call SwitchToOtherPaneOrCreate()
        execute 'edit ' . rfc_path

    else
        echoerr join(['"', a:num, '" is not a number'], "")
    endif
endfunction
command! -nargs=1 RFC :call GetRFC(<q-args>)

" Can change this in the machine specific vimrc
let g:rfc_download_location = $HOME . '/RFC-downloads'

" Abbreviations in insert mode (should these be commands?)
iabbrev <silent> :Now:     <Esc>:let @x = strftime("%X")<CR>"xpa
iabbrev <silent> :Date:     <Esc>:let @x = strftime("%X")<CR>"xpa
iabbrev <silent> :Today:   <Esc>:let @x = strftime("%d %b %Y")<CR>"xpa
iabbrev <silent> :Time:   <Esc>:let @x = strftime("%d %b %Y")<CR>"xpa
iabbrev <silent> :Random:  <Esc>:let @x = rand()<CR>"xpa

" Re-source gvimrc when vimrc is reloaded
let s:gvim_path = join([s:dot_vim_path, 'gvimrc'], g:path_separator)
if has('gui') && filereadable(s:gvim_path)
    execute "source " . s:gvim_path
endif

" if exists('*g:LocalVimRCEnd')
"     call g:LocalVimRCEnd()
" endif