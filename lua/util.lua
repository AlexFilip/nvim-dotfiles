local exports = {}

function exports.getKeys(obj)
    local keys = ""
    for key,value in pairs(obj) do
        keys = keys .. key .. ", "
    end
    return "{" .. keys .. "}"
end

function exports.stringify(obj)
    if type(obj) == "string" then
        return "\"" .. obj .. "\""
    elseif type(obj) == "function" then
        return "<function>"
    elseif type(obj) == "boolean" then
        return obj and "true" or "false"
    elseif type(obj) ~= "table" then
        return "" .. obj
    end

    local keys = ""
    for key,value in pairs(obj) do
        keys = keys .. key .. " = " .. exports.stringify(value) .. ", "
    end
    return "{" .. keys .. "}"
end

function exports.tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function exports.tableFindValue(tab, value)
    local result = -1
    for i, v in pairs(tab) do
        if v == value then
            result = i
            break
        end
    end
    return result
end

function exports.arrayReplace(array, value, newValue)
    local newArray = {}
    for _, v in pairs(array) do
        if v == value then
            newArray[#newArray+1] = newValue
        else
            newArray[#newArray+1] = v
        end
    end
    return newArray
end

function exports.arrayConcat(...)
    local newArray = {}
    for _, innerArray in ipairs({ ... }) do
        for _, v in ipairs(innerArray) do
            newArray[#newArray+1] = v
        end
    end
    return newArray
end

exports.config_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ":h")

return exports
