
local json = require("jsonpath")

local exports = {}

function exports:getPath()
    -- This plugin has trouble loading right away, DO NOT put this require at the top level
    local yaml = require("yaml_nvim")
    local filetype = vim.bo.filetype

    if filetype == "json" then
        return json.get()
    elseif filetype == "yaml" then
        return yaml.get_yaml_key_and_value()
    end

    return ''
end

return exports
