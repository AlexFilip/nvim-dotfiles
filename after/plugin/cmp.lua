-- Set up nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")
local remap = require("remap") -- In lua/ directory
local util = require("util") -- In lua/ directory

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "orgmode" },
    }, {
        { name = "buffer" },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
        { name = "buffer" },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<space>o", vim.diagnostic.open_float, { desc = "" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous use" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next use" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Set location list" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local lst = {
            --        description                        keys         action         modes
            { "Go to declaration",                       "gD", "declaration" },
            { "Go to definition",                        "gd", "definition" },
            { "Show documentation",                       "K", "hover" },
            { "Go to implementation",                    "gi", "implementation" },
            { "Signature help",                       "<C-k>", "signature_help" },
            { "Show references",                         "gr", "references" },
            { "Add to workspace folder",      leader.on("wa"), "add_workspace_folder" },
            { "Remove from workspace folder", leader.on("wr"), "remove_workspace_folder" },
            { "Go to type definition",        leader.on( "D"), "type_definition" },
            { "Rename identifier",            leader.on("rn"), "rename" },
            { "Code action",                  leader.on("ca"), "code_action", { "n", "v" } },
            { "Expand error message",         leader.on("er"), vim.diagnostic.open_float },
            { "Format code",                  leader.on( "="), function() vim.lsp.buf.format({ async = true }) end },
            { "Print workspace folders",      leader.on("wl"), function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end },
        }

        for k, v in lst do
            vim.keymap.set(
                lst[4] == nil and "n" or lst[4],
                lst[2],
                (type(lst[3]) == "string") and lst[3] or vim.lsp.buf[lst[3]],
                { buffer = ev.buf, desc = lst[1]})
        end
    end,
})

