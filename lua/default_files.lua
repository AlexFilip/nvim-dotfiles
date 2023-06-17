
local header = {
    "/*",
    "  File: {{file_name}}",
    "  Date: {{date}}",
    "  Creator: {{creator}}",
    "  Notice: (C) Copyright %Y by {{copyright_holder}}. All rights reserved.",
    "*/",
}

local header_sub_options = {
    date_format      = "%d %B %Y",
    creator          = "Alexandru Filip",
    copyright_holder = "Alexandru Filip"
}

-- TODO: Make the headers project specific
local function CreateSourceHeader()
    local file_name = vim.fn.expand("%:t")
    local file_extension = vim.fn.split(file_name, "\\.")[1]
    local date = vim.fn.strftime(header_sub_options["date_format"])
    local year = vim.fn.strftime("%Y")

    local created_header = {}
--     for str in header
--         let start_idx = 0
--         while 1
--             let option_idx =  match(str, '{[A-Za-z_]\+}', start_idx)
-- 
--             if option_idx == -1
--                 break
--             endif
-- 
--             let end_idx = match(str, '}', option_idx)
--             let length = end_idx - option_idx - 1
-- 
--             let key = str[option_idx:end_idx]
-- 
--             if key == '{file_name}'
--                 let value = file_name
--             elseif key == '{date}'
--                 let value = date
--             elseif has_key(header_sub_options, key[1:-2])
--                 let value = get(header_sub_options, key[1:-2])
--             else
--                 let value = 0
--                 let start_idx = end_idx + 1
--             endif
-- 
--             if value isnot 0
--                 let str = substitute(str, key, value, 'g')
--                 let start_idx = option_idx + len(value)
--             endif
--         endwhile
-- 
--         let str = strftime(str)
--         call add(created_header, str)
--     endfor
-- 
--     call append(0, created_header)
-- 
--     if file_extension =~ '^[hH]\(pp\|PP\)\?$'
--         let modified_filename = substitute(toupper(file_name), '[^A-Z]', '_', 'g')
-- 
--         let guard = [
--                     \ '#ifndef ' . modified_filename,
--                     \ '#define ' . modified_filename,
--                     \ '',
--                     \ '',
--                     \ '',
--                     \ '#endif',
--                     \ ]
--         call append(line("$"), guard)
-- 
--         let pos = getpos("$")
--         let pos[1] -= 2
--         call setpos(".", pos)
--     endif
end
