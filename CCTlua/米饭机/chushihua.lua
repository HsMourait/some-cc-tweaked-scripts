---@diagnostic disable: undefined-global

-- ===================== 自动获取外设 =====================
local function wrapList(peripheralType)
    local sorted = {}
    peripheral.find(peripheralType, function(name, obj)
        table.insert(sorted, {name = name, obj = obj})
        return true
    end)
    table.sort(sorted, function(a, b) return a.name < b.name end)
    local result = {}
    for i, entry in ipairs(sorted) do
        result[i] = entry.obj
    end
    return result
end

-- 获取所有红石继电器和机械手（按名称排序）
local relays = wrapList("redstone_relay")

--开启所有继电器
for _, relay in ipairs(relays) do
    relay.setAnalogOutput("front", 15)
end