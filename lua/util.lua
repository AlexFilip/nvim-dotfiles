
local exports = {}
function exports.stringify(obj)
    if type(obj) == "string" then
        return "\"" .. obj .. "\""
    elseif type(obj) ~= "table" then
        return "" .. obj
    end

    local keys=""
    for key,value in pairs(obj) do
        keys = keys .. key .. " = " .. exports.stringify(value) .. ", "
    end
    return "{" .. keys .. "}"
end

return exports
