
local function paste_command(extra_args)
    local args = extra_args or ""
    return function()
        return vim.fn.systemlist("wl-paste " .. args .. " --no-newline | tr -d '\\n\\r'", {""}, 1) -- "1" keeps empty lines
    end
end

if vim.fn.executable("wl-copy") then
    vim.g.clipboard = {
        name = "wl-clipboard (wsl)",
        copy = {
            ["+"] = "wl-copy --foreground --type text/plain",
            ["*"] = "wl-copy --foreground --primary --type text/plain",
        },
        paste = {
            ["+"] = paste_command(),
            ["*"] = paste_command("--primary"),
        },
        cache_enabled = true
    }
else
    print("wl-clipboard not found, clipboard integration won't work")
end
