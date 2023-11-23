
local exports = {}

function exports:getPath()
    local filetype = vim.bo.filetype
    if filetype == "json" then
        return require("jsonpath").get()
    elseif filetype == "yaml" then
        return require("yaml_nvim").get_yaml_key_and_value()
    end

    return ''
end

return exports
