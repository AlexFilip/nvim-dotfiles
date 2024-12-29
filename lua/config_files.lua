local json = require("jsonpath")
local exports = {}

function exports.getPath()
    local filetype = vim.bo.filetype

    if filetype == "json" then
        return json.get()
    elseif filetype == "yaml" then
        -- This plugin has trouble loading right away...or working at all without careful babysitting, DO NOT put this require at the top level
        local yaml = require("yaml_nvim")

        local result
        local success, err = pcall(function()
            result = yaml.get_yaml_key()
        end)
        if success and result ~= nil then
            return result
        end
    end

    return ''
end

function exports.yankToRegister(register, modifiers)
    local filetype = vim.bo.filetype
    local success

    if filetype == "json" then
        local contents = json.get()
        if contents ~= nil and contents ~= "" then
            vim.fn.setreg(register, contents)
            success = true
        end

    elseif filetype == "yaml" then
        -- This plugin has trouble loading right away...or working at all without careful babysitting, DO NOT put this require at the top level
        local yaml = require("yaml_nvim")
        success = pcall(yaml.yank_key())
    end

    if success then
        vim.notify("Copied key in " .. register .. " register")
    else
        vim.notify("Could not copy key to " .. register .. " register")
    end
end

return exports
