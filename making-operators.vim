
" This was an experiment that was in my init file but really has no place
" there. It allows you to create a new operator key like g or z
" =============================================

" From vim wiki to identify the syntax group under the cursor
" nnoremap <F10> :echo "hi<" . synIDattr(           synID(line("."), col("."), 1) , "name") . '> trans<'
"                          \ . synIDattr(           synID(line("."), col("."), 0) , "name") . "> lo<"
"                          \ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

let g:OperatorList = {}
let g:OperatorChar = 0
let s:visual_modes = {    'v':'char',    'V':'line', '\<C-V>':'block',
                     \ 'char':'char', 'line':'line',  'block':'block' }
function! s:is_a_visual_mode(mode)
    return has_key(s:visual_modes, a:mode)
endfunction

function! s:do_nothing(...)
endfunction
let s:do_nothing_map = { 'handler': funcref('s:do_nothing') }

" This can't be a script-only (s:) function because it needs to be called from
" the command-line.

function! OperEntireLine(col)
    let result = { 'line':line("."), 'column':a:col }

    if a:col < 0
        let result['column'] = len(getline("."))
    endif

    return result
endfunction

function! PerformOperator(visual)
    if g:OperatorChar isnot 0
        call get(g:OperatorList, g:OperatorChar, s:do_nothing_map)['handler'](a:visual)
        let g:OperatorChar = 0
    endif
endfunction

function! MakeOperator(char, func)
    let func_holder = { 'func' : a:func }
    function! func_holder.handler(visual) dict
        let mode = get(s:visual_modes, a:visual, 0)

        if a:visual != 'char' && mode isnot 0
            let [start_mark, end_mark] = ["'<", "'>"]
        else
            let [start_mark, end_mark] = ["'[", "']"]
            let mode = 'normal'
        endif

        let [start_line, start_column] = getpos(start_mark)[1:2]
        let [  end_line,   end_column] = getpos(  end_mark)[1:2]
        " echoerr start_line . " " . end_line
        let start = { 'line': start_line, 'column': start_column }
        let   end = { 'line':   end_line, 'column':   end_column }
        call self['func'](mode, start, end)
    endfunction

    let char = a:char[0]
    let g:OperatorList[char] = func_holder
    " let escaped_char = substitute(char, '\', '\\\\', 'g')

    let normal_command = "nnoremap <silent> " . char . " :let g:OperatorChar = '" . char . "'<CR>:set operatorfunc=PerformOperator<CR>g@"
    let oper_func_get  = "OperatorList['"     . char . "']['handler']"
    let visual_command = "vnoremap <silent> " . char . " :<C-U>call " . oper_func_get . "(visualmode())<CR>"

    silent execute normal_command
    silent execute visual_command
endfunction

function! Backslash(mode, start, end)
    " a:start and a:end are dictionaries with 'line' and 'column' components
    echo "Backslash" a:mode a:start a:end
endfunction

" Create mappings like this
nnoremap <silent> \\ :call Backslash("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
nnoremap <silent> \/ :call Backslash("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
call MakeOperator('\', funcref('Backslash'))

function! OpenParen(mode, start, end)
    echo "Open paren" a:mode a:start a:end
endfunction

nnoremap <silent> (( :call OpenParen("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
nnoremap <silent> () :call OpenParen("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
call MakeOperator('(', funcref('OpenParen'))

function! CloseParen(mode, start, end)
    echo "Close paren" a:mode a:start a:end
endfunction

nnoremap <silent> )) :call CloseParen("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
nnoremap <silent> )( :call CloseParen("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
call MakeOperator(')', funcref('CloseParen'))

" NOTE: So far I haven't been able to remap anything starting with [ or ]. I'm not sure why.
function! OpenBracket(mode, start, end)
    echo "Open bracket " a:mode a:start a:end
endfunction

nnoremap <silent> [[ :call OpenBracket("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
nnoremap <silent> [] :call OpenBracket("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
call MakeOperator('[', funcref('OpenBracket'))

function! CloseBracket(mode, start, end)
    echo "Close bracket" a:mode a:start a:end
endfunction

nnoremap <silent> ]] :call CloseBracket("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
nnoremap <silent> ][ :call CloseBracket("normal", OperEntireLine(0), OperEntireLine(-1))<CR>
call MakeOperator(']', funcref('CloseBracket'))
