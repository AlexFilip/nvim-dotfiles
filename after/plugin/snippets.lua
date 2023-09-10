local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local function P(x)
    print(vim.inspect(x))
end

local c_snippets = (function()
    local function FirstLetterUppercase(
        args, -- string[][]
        parent, -- node
        user_args -- whatever is passed into opts (3rd arg in f)
        )

        local str = args[1][1]
        local result = ""
        for component in string.gmatch(str, "[^_]+") do
            result = result .. (string.upper(string.sub(component, 1, 1)) .. string.lower(string.sub(component, 2, #component)))
        end
        return result
    end

    local function MakeTypeNameDefs(
        args, -- string[][]
        parent, -- node
        user_args -- whatever is passed into opts (3rd arg in f)
        )

        local result = {}
        for _, line in ipairs(args[1]) do
            varName = ""

            local findResult, _, maybeVarName = string.find(line, "^%s*.+ ([A-Za-z_]+);$")
            if findResult then
                varName = maybeVarName
                result[#result+1] = "  P(" .. varName .. "), \\"
            end
        end

        return result
    end

    return {
        s("enum_union", {
            t("#define Make"),
            f(FirstLetterUppercase, {1}, {}),
            t({ "Types(P) \\", "  P(None), \\", "" }),
            f(MakeTypeNameDefs, {2}, {}),
            t({ "", "", "enum " }),
            rep(1),
            t({ "_type {", "#define P(Name) " }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "Type ## Name", "    Make" }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "Types(P)", "#undef P", "};", "", "" }),

            t({ "struct " }),
            i(1, "type_name"),
            t({ " {", "    enum " }),
            rep(1),
            t({ "_type Type;", "", "    union {", "        " }),
            i(2, "<possible_types>"),
            t({ "", "    };", "};", "", "" }),

            t({ "char const* " }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "TypeNames[] = {", "#define P(Name) #Name", "    Make" }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "Types(P)", "#undef P", "};", "", "" }),

            t({"char const* Get" }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "TypeName(enum " }),
            rep(1),
            t({ "_type Type) {", "    if((int)Type < 0 || (int)Type >= ArrayLength(" }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "TypeNames)) {", "        return \"Unknown\";", "    }", "    return " }),
            f(FirstLetterUppercase, {1}, {}),
            t({ "TypeNames[Type];", "}", "", "" }),
        })
    }
end)(); -- semicolon so it doesn't try to call this table

local _ = (function()
    ls.add_snippets("c", c_snippets)
end)()

local _ = (function()
    ls.add_snippets("cpp", c_snippets)
end)()
