
local util = require("util")
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

local mason = require("mason")
mason.setup()

require("nvim-dap-virtual-text").setup()

-- Install in mason:
--     codelldb for rust

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Start debugger or continue"})
vim.keymap.set("n", "<F1>", function() dap.step_into() end , { desc = "Step into" })
vim.keymap.set("n", "<F2>", function() dap.step_over() end , { desc = "Step over" })
vim.keymap.set("n", "<F3>", function() dap.step_out()  end , { desc = "Step out"  })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional breakpoint" })
vim.keymap.set("n", "<leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { desc = "Logging breakpoint" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open debugger repl" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require('dap-go').setup({
    -- Additional dap configurations can be added.
    -- dap_configurations accepts a list of tables where each entry
    -- represents a dap configuration. For more details do:
    -- :help dap-configuration
    dap_configurations = {
        {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
        },
    },
    -- delve configurations
    delve = {
        -- the path to the executable dlv which will be used for debugging.
        -- by default, this is the "dlv" executable on your PATH.
        path = "dlv",
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
        -- a string that defines the port to start delve debugger.
        -- default to string "${port}" which instructs nvim-dap
        -- to start the process in a random available port
        port = "${port}",
        -- additional args to pass to dlv
        args = {}
    },
})

dap.configurations.rust = {
    {
        type = "rust",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
    },
}

-- Rust

local rt = require("rust-tools")
local mason_registry = require("mason-registry")

local extension_path = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so" -- Note: this may be .dylib on mac and .lib on some systems
local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
table.insert(adapter.executable.args, "${pid}")

-- print(util.stringify(adapter))

dap.adapters.rust = adapter

rt.setup({
    dap = {
        adapter = adapter
    },

    server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
            vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
    },

    tools = {
        hover_actions = {
            auto_focus = true
        }
    },
})


