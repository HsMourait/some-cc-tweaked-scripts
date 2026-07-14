---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Chest = peripheral.wrap("minecraft:chest_1214") -- 中转容器
local Chest2 = peripheral.wrap("minecraft:chest_1215") -- 石磨输出缓存
local Basket = peripheral.wrap("farmersdelight:basket_5") -- 石磨-原料输入容器
-- 检查容量相关
local CONTAINER_TOTAL_SLOTS = 0          -- 容器总槽位（比如大箱子54）
local TRIGGER_THRESHOLD = 48             -- 触发信号的阈值
local RESET_THRESHOLD = 27               -- 停止信号的阈值
-- 输出
local IntervalQuantity = 1               -- 每次检查间隔的输送次数

-- ===================== 状态缓存 =====================
local isSignalOn = false                  -- 当前信号

-- ===================== 函数：计算已占用槽位数量 =====================
-- 返回值：已占用槽位数量
local function getOccupiedSlots(container)
    -- 步骤1：获取容器有物品的槽位数（复用之前的list()方法）
    if not container or type(container) ~= "table" or not container.list then
        return 0
        -- 找不到容器外设
    end
    local itemList = container.list()
    local usedSlots = 0
    for _ in pairs(itemList) do
        usedSlots = usedSlots + 1
    end

    return usedSlots
end

-- ===================== 函数：获取容器中某一个有物品槽位 =====================
local function getAnyValidSlot(container)
    -- 1.获取容器的list
    local ContainerItemList = container.list()
    if not ContainerItemList then return nil end

    -- 2. 遍历list，拿到第一个遇到的有效槽位就返回
    for slot in pairs(ContainerItemList) do
        return slot -- 找到任意一个有效槽位，立即返回，无需遍历全部
    end

    -- 3. 无有效槽位时返回nil
    return nil
end

-- ===================== 函数：运输 =====================
local function pushCraftedItemToContainer(Source, Target)
    -- 步骤1：检查源容器有物品槽位
    local SourceSlot = getAnyValidSlot(Source)
    if SourceSlot == nil then
        return false
    end

    -- 步骤2：将槽位物品推送至目标容器
    local pushCount = Target.pullItems(peripheral.getName(Source), SourceSlot, 64)

    -- 校验推送结果
    if pushCount <= 0 then
        return false
    end

    return true
end

-- ===================== 主循环：持续监测 =====================
while true do
    if not redstone.getInput("right") then
        if getOccupiedSlots(Basket) <= 24 and getOccupiedSlots(Chest2) <= 48 and getOccupiedSlots(Chest) >= 1 then
            pushCraftedItemToContainer(Chest, Basket)
            sleep(0.1)
        else
            sleep(1)
        end
    else
        sleep(10)
    end
end