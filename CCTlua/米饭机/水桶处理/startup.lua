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
-- ===================== 返回按外设名称排序的对象数组 =====================
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

-- ===================== 获取容器中特定物品第一个槽位 =====================
local function getSpeValidSlot(container, itemName)
    local itemList = container.list() or {}
    for slot, item in pairs(itemList) do
        if item.name == itemName then
            return slot
        end
    end
    return nil
end

-- ===================== 从表向容器推送 =====================
local function recycleItemsFromSources(sources, target, count, itemID)
    local targetName = peripheral.getName(target)
    local successCount = 0
    for _, source in ipairs(sources) do
        local slot = getSpeValidSlot(source, itemID)
        if slot then
            source.pushItems(targetName, slot, count)
            successCount = successCount + 1
        end
    end
    return successCount
end



-- 搜寻外设
local depots = wrapList("create:depot")          -- 所有物品放置台
local Vault = peripheral.find("create:item_vault") -- 中央保险库

-- 红石方向（顶部）
local redstoneSide = "top"

-- 主循环
while true do
    -- 红石检查：如果顶部为高电平，休眠5秒后重新检查
    while redstone.getInput(redstoneSide) do
        sleep(5)
    end

    -- 检查保险库中是否存在空桶
    local bucketSlot = getSpeValidSlot(Vault, "minecraft:bucket")

    if bucketSlot then
        -- 有桶：向每个 depot 推送 2 个空桶
        for _, depot in ipairs(depots) do
            Vault.pushItems(peripheral.getName(depot), bucketSlot, 2)
        end

        -- 回收水桶
        recycleItemsFromSources(depots, Vault, 1, "minecraft:water_bucket")
        sleep(1)
    else
        -- 无桶：仅执行回收水桶操作
        local recycled = recycleItemsFromSources(depots, Vault, 1, "minecraft:water_bucket")
        -- print(peripheral.getName(Vault))
        if recycled > 0 then
            sleep(0.5)
        else
            sleep(5)
        end
    end


end