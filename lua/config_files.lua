
local json = require("jsonpath")

local exports = {}

function exports:getPath()
    local filetype = vim.bo.filetype

    -- This plugin has trouble loading right away...or working at all without careful babysitting, DO NOT put this require at the top level
    local yaml = require("yaml_nvim")

    if filetype == "json" then
        return json.get()
    elseif filetype == "yaml" then
        local result
        local success, response = pcall(function()
            result = yaml.get_yaml_key()
        end)
        if success and result ~= nil then
            return result
        end
    end

    return ''
end

return exports
