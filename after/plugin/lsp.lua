local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local lspconfig_util = require('lspconfig/util')
local lspcontainers = require('lspcontainers')

local virtual_types_onattach = require('virtualtypes').on_attach
function lsp_attach(client, bufnr)
    if client.supports_method("textDocument/codeLens") then
        virtual_types_onattach(client, bufnr)
    end
end

vim.lsp.inlay_hint.enable(true)

lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = default_capabilities,
    cmd = lspcontainers.command('clangd'),
    root_dir = lspconfig_util.root_pattern(".git", vim.fn.getcwd()),
}

lspconfig.gopls.setup {
    on_attach = lsp_attach,
    capabilities = default_capabilities,
    cmd = lspcontainers.command('gopls'),
    root_dir = lspconfig_util.root_pattern(".git", vim.fn.getcwd()),
}

lspconfig.rust_analyzer.setup {
    on_attach = lsp_attach,
    capabilities = default_capabilities,
    cmd = require'lspcontainers'.command('rust_analyzer'),
    root_dir = lspconfig_util.root_pattern(".git", vim.fn.getcwd()),
}

-- vim.g.rustaceanvim = {
--     -- Plugin configuration
--     -- tools = { },
--     -- LSP configuration
--     server = {
--         on_attach = function(client, bufnr)
--             lsp_attach(client, bufnr)
--         end,
--         cmd = lspcontainers.command('rust-analyzer', {
--             image = "lspcontainers/rust-analyzer:latest",
--             cmd = function (runtime, volume, image)
--                 return {
--                     runtime,
--                     "container",
--                     "run",
--                     "--interactive",
--                     "--rm",
--                     "--volume",
--                     volume,
--                     image
--                 }
--             end,
--         }),
--         default_settings = {
--             -- rust-analyzer language server configuration
--             ['rust-analyzer'] = {
--             },
--         },
--     },
--     -- DAP configuration
--     dap = {
--         type = "rust",
--         name = "Attach remote",
--         mode = "remote",
--         request = "attach",
--     },
-- }

lspconfig.terraformls.setup{
    on_attach = lsp_attach,
    capabilities = default_capabilities,
    cmd = lspcontainers.command('terraformls'),
    filetypes = { "hcl", "tf", "terraform", "tfvars" },
    root_dir = lspconfig_util.root_pattern(".git", vim.fn.getcwd()),
}

-- lspconfig.tflint.setup{ }

-- TODO: Disable specifically for C & C++
-- vim.diagnostic.enable(false)
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
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show documentation" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add to workspace folder" })
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "Remove from workspace folder" })
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = ev.buf, desc = "Print workspace folders" })
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Go to type definition" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename identifier" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Show references" })
        vim.keymap.set("n", "<leader>=", function()
            vim.lsp.buf.format { async = true }
        end, { buffer = ev.buf, desc = "Format code" })
        vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Expand error message" })
        vim.keymap.set("n", "<leader>et", function() vim.cmd ':Telescope diagnostics' end, { buffer = ev.buf, desc = "Show all diagnostics in telescope" })
    end,
})

