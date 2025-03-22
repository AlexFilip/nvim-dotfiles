
require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
        -- "c", "cpp",
        -- "java",
        -- "lua", "vim", "vimdoc",
        -- "python", "r", "julia",
        -- "bash", "awk",
        -- "make", "cmake",
        -- "javascript", "typescript",
        -- "rust",
        -- -- "swift",
        -- "go",
        -- "dockerfile",
        -- "html", "css",
        -- "json", "yaml",
        -- -- "json5",
        -- "markdown", "comment",
    },

    textobjects = {
        select = {
            enable = false,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "Select around a function" },
                ["if"] = { query = "@function.inner", desc = "Select inside a function" },
                ["ac"] = { query = "@class.outer", desc = "Select around a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inside a class" },
                ["a/"] = { query = "@comment.outer", desc = "Select around a comment" },
                ["i/"] = { query = "@comment.inner", desc = "Select inside a comment" },
                -- You can also use captures from other query groups like `locals.scm`
                -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
        },

        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "v",
            ["@class.outer"] = "V", -- linewise

            -- <c-v> -- blockwise
        },

        -- Swap function parameters
        swap = {
            enable = false,
            swap_next = {
                ["<leader>l"] = "@parameter.inner",
            },

            swap_previous = {
                ["<leader>h"] = "@parameter.inner",
            },
        },

        lsp_interop = {
            enable = false,
            border = "single",
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>vf"] = "@function.outer",
                ["<leader>vc"] = "@class.outer",
            },
        },
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
    -- auto_install = true,

    -- ignore_install = {},

    highlight = {
        enable = false,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,

        -- disable = {},
    },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-----------------------------------------------------------
-- Terraform
-- parser_config.hcl = {
--     install_info = {
--         url = "https://github.com/MichaHoffmann/tree-sitter-hcl", -- local path or git repo
--         files = {"src/parser.c", "src/scanner.c"}
--     }
-- }
-- vim.treesitter.language.register('hcl', 'tf')

-----------------------------------------------------------
-- Templ
-- parser_config.templ = {
--   install_info = {
--     url = "https://github.com/vrischmann/tree-sitter-templ.git",
--     files = {"src/parser.c", "src/scanner.c"},
--     branch = "master",
--   },
-- }
-- vim.treesitter.language.register('templ', 'templ')

-----------------------------------------------------------
-- Caddy
parser_config.caddy = {
  install_info = {
    url = "https://github.com/Samonitari/tree-sitter-caddy",
    files = {"src/parser.c", "src/scanner.c"},
    branch = "master",
  },
}
vim.treesitter.language.register('caddy', 'Caddyfile')
