
local json = require("jsonpath")

local exports = {}

function exports:getPath()
    local filetype = vim.bo.filetype

    -- This plugin has trouble loading right away, DO NOT put this require at the top level
    local yaml = require("yaml_nvim")

    if filetype == "json" then
        return json.get()
    elseif filetype == "yaml" then
        return yaml.get_yaml_key()
    end

    return ''
end

return exports
