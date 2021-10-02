local M = {}

local key_map = {
    ["normal_mode"] = "n",
    ["insert_mode"] = "i",
    ["visual_mode"] = "v",
    ["visual_block_mode"] = "v",
    ["command_mode"] = "c",
    ["term_mode"] = "t"
}

local json_decode = function(data)
    local ok, result = pcall(vim.fn.json_decode, data)
    if ok then
        return result
    else
        return nil, result
    end
end

local set_keys = function(data)
    for key, value in pairs(data) do
        if value ~= nil then
            local mode = key_map[key]

            for _, v in pairs(value) do
                local _key = v['key']
                local func = v['func']
                local silent = v['silent']
                local noremap = v['noremap']

                vim.api.nvim_set_keymap(
                    mode,
                    _key,
                    func,
                    { noremap = noremap, silent = silent }
                )
            end
        end
    end
end

local load_settings_json = function(path)
    vim.validate {
        path = { path, 's' },
    }

    local decoded, err = json_decode(vim.fn.readfile(path))
    if err ~= nil then
        return true
    end
    if decoded == nil then
        return
    end

    set_keys(decoded)
end

M.set_settings = function(path)
    vim.validate {
        path = { path, 's' },
    }

    load_settings_json(path)
end

return M
