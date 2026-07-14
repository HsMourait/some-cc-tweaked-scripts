---@diagnostic disable: undefined-global

-- 函数区域
-- ===================== 返回按外设名称排序的对象数组 =====================
-- 功能：获取网络中所有指定类型的外设，并按名称排序后以数组形式返回。
-- 参数：
--   peripheralType: string - 外设类型，如 "create:spout" 或 "fluidTank"
-- 返回值：
--   table - 排序后的外设对象数组，按外设名称升序排列；如果未找到任何外设，返回空表 {}。
-- 实现说明：
--   1. 使用 peripheral.find(peripheralType, callback) 的迭代器形式，
--      在回调中收集每个匹配外设的名称和对象。
--   2. 将收集到的 {name = name, obj = obj} 存入临时表。
--   3. 按 name 字段进行字符串排序。
--   4. 提取排序后的 obj 字段，形成最终的对象数组。
-- 注意：
--   - 确保外设名称是可排序的字符串（通常带数字后缀，排序后自然按数字升序）。
--   - 回调函数必须返回 true 以继续遍历所有外设。
-- 示例：
--   local spouts = wrapList("create:spout")
--   for i, spout in ipairs(spouts) do
--       print(i, peripheral.getName(spout))
--   end
-- =========================================================================
local function wrapList(peripheralType)
    local sorted = {}
    peripheral.find(peripheralType, function(name, obj)
        table.insert(sorted, {name = name, obj = obj})
        return true  -- 继续遍历下一个
    end)
    
    table.sort(sorted, function(a, b) return a.name < b.name end)
    
    local result = {}
    for i, entry in ipairs(sorted) do
        result[i] = entry.obj
    end
    return result
end

-- 获取所有喷头对象（按名称排序）
local spouts = wrapList("create:spout")
-- 获取所有 depot 对象（按名称排序）
local depots = wrapList("create:depot")

print(spouts, depots)
-- Print spouts
print("Spouts (sorted by name):")
for i, spout in ipairs(spouts) do
    local name = peripheral.getName(spout)
    print(string.format("  [%d] %s", i, name))
end

-- Print depots
print("Depots (sorted by name):")
for i, depot in ipairs(depots) do
    local name = peripheral.getName(depot)
    print(string.format("  [%d] %s", i, name))
end

-- Optional: print counts
print("Number of spouts: " .. #spouts)
print("Number of depots: " .. #depots)