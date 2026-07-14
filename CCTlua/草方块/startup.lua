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

-- ===================== 传输指定数量流体 =====================
local function tranFluid(Source, Target, amount)
    return Source.pushFluid(Target, amount)
end

-- ===================== 获取容器中特定物品槽位 =====================
local function getSpeValidSlot(container, itemName)
    -- 参数container填包装后的容器
    -- 1.获取容器的list
    local ContainerItemList = container.list() or {}
    if not ContainerItemList then return nil end

    -- 2. 遍历list，拿到第一个遇到的有效槽位就返回
    for slot, item in pairs(ContainerItemList) do
        if item.name == itemName then
            return slot
        end
    end

    -- 3. 无有效槽位时返回nil
    return nil
end

-- ===================== 从容器推送物品至表 =====================
local function pushItemsToTargets(sourceContainer, targetIndexTable, itemName, pushCount)
    -- 遍历目标容器表，取出每个容器的索引和容器对象
    for targetIndex, targetContainer in pairs(targetIndexTable) do
        -- 从源容器中获取任意一个有效的物品槽位编号
        local validSlot = getSpeValidSlot(sourceContainer, itemName)
        -- 检查有效槽位，无则直接break并结束函数
        if not validSlot then break end

        -- 获取目标容器的外设名称
        local targetPeriphName = peripheral.getName(targetContainer)
        -- 调用源容器的pushItems方法，把物品推送到目标容器
        sourceContainer.pushItems(targetPeriphName, validSlot, pushCount)
    end
end

-- ===================== 从表内容器推送物品至输出 =====================
local function pushItemsFromSourcesToProduct(sourceIndexTable, productContainer, pushCount, targetSlot)
    -- 获取产物容器的外设名称（供pushItems调用）
    local productPeriphName = peripheral.getName(productContainer)
    -- 遍历源容器表，逐个向产物容器推送物品
    for sourceIndex, sourceContainer in pairs(sourceIndexTable) do
        -- 直接使用指定的槽位，不再调用getAnyValidSlot
        sourceContainer.pushItems(productPeriphName, targetSlot, pushCount)
    end
end

-- ===================== 从容器推送液体至目标列表 =====================
-- 参数：
--   sourceContainer: 源流体容器对象（如 fluidTank）
--   targetIndexTable: 目标容器索引表（数组，元素为容器对象，如喷头列表）
--   pushAmount: 每次推送的液体量（单位为 mB）
--   fluidName: （可选）指定液体类型，如 "minecraft:water"，不指定则推送任意液体
local function pushFluidToTargets(sourceContainer, targetIndexTable, pushAmount, fluidName)
    for targetIndex, targetContainer in pairs(targetIndexTable) do
        -- 获取目标容器外设名称
        local targetName = peripheral.getName(targetContainer)

        local actualPushed
        actualPushed = sourceContainer.pushFluid(targetName, pushAmount, fluidName)

        -- 可选：如果推送量为 0，说明源容器无液体或目标已满，可决定是否停止循环
        if actualPushed == 0 then
            -- 例如，如果第一个目标就推送失败，可能整体无法进行，可以选择 break
            -- 根据需求决定是否 break 或继续尝试其他目标
            -- break
        end

        -- 此处可添加打印调试信息
        -- print(string.format("向目标 %d 推送了 %d mB 液体", targetIndex, actualPushed))
    end
end


-- 封装源容器对象
local SourceTank = peripheral.find("fluidTank")
-- 原料与产物
local itemVault = peripheral.find("create:item_vault")

-- 获取所有喷头对象（按名称排序）
local spouts = wrapList("create:spout")
-- 获取所有 depot 对象（按名称排序）
local depots = wrapList("create:depot")

-- 关于控制电脑的红石开关在哪一个方向
local redstoneSide = "left"

while true do

    :: Mark1 ::
    -- 红石开关
    if  redstone.getInput(redstoneSide) then
        sleep(3)
        goto Mark1
    end

    -- 检查储罐水位，若过低则等待其恢复
    local tankInfo = SourceTank.tanks()[1]
    local Amount = tankInfo and tankInfo.amount or 0
    if Amount <= 300000 then
        sleep(10)
        goto Mark1
    end

    -- 检查是否有原料，完全没有时休眠
    if getSpeValidSlot(itemVault, "minecraft:dirt") == nil then
        sleep(10)
        goto Mark1
    end

    pushItemsFromSourcesToProduct(depots, itemVault, 64, 1)
    pushItemsFromSourcesToProduct(depots, itemVault, 64, 2)

    if getSpeValidSlot(itemVault, "minecraft:dirt") then
        pushItemsToTargets(itemVault, depots, "minecraft:dirt", 64)
    end

    for _=1, 32 do
        for i = 1, math.min(#spouts, #depots) do
            SourceTank.pushFluid(peripheral.getName(spouts[i]), 1000)
        end
        sleep(0.6)
    end

    sleep(0)
end