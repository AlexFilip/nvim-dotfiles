
local luasnip = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-j>", function() require("luasnip").jump( 1) end, { desc = "LuaSnip forward jump" })
vim.keymap.set({ "i", "s" }, "<C-k>", function() require("luasnip").jump(-1) end, { desc = "LuaSnip backward jump" })

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = {"./snippets"} })
