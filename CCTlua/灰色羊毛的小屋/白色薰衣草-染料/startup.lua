---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_29") -- 海龟
local Cabinet = peripheral.wrap("candlelight:cabinet_2") -- 花容器
local Cabinet2 = peripheral.wrap("candlelight:cabinet_1") -- 白色染料容器

local CapacityThreshold = 50 -- 当目标容器的已占用槽位数量达到此值时停止

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
    if itemList ~= nil then
        for _ in pairs(itemList) do
            usedSlots = usedSlots + 1
        end
    else
        sleep(1)
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

-- ===================== 函数：合成与运输 =====================
local function pushCraftedItemToContainer(Source, Craft, Target)
    -- 步骤1：检查海龟1号槽位是否为空
    if turtle.getItemDetail(1) == nil then
        local SourceSlot = getAnyValidSlot(Source)
        if SourceSlot ~= nil then
            Source.pushItems(Craft, SourceSlot, 64)
        end
    end

    local itemSlot1 = turtle.getItemDetail(1)
    if itemSlot1 and itemSlot1.name == "biomesoplenty:tall_white_lavender" and turtle.getItemDetail(2) == nil then
        turtle.craft(64)
    end

    -- 步骤2：物品推送至目标容器
    if turtle.getItemDetail(1) ~= nil and turtle.getItemDetail(1).name == "minecraft:white_dye" then
        local pushCount1 = Target.pullItems(Craft, 1, 64)
    end
    local pushCount2 = Target.pullItems(Craft, 2, 64)
    -- 校验推送结果
    if pushCount1 ~= nil and pushCount2 ~= nil then
        if pushCount1 <= 0 or pushCount2 <= 0 then
            return false
        end
    end

    return true
end

-- ===================== 5. 主循环：持续监测 =====================
local i = IntervalQuantity
turtle.select(1)
while true do
    if not redstone.getInput("top") then
        if not (getOccupiedSlots(Cabinet2) >= CapacityThreshold) then
            pushCraftedItemToContainer(Cabinet, "turtle_29", Cabinet2)
            sleep(0.05)
        else
            sleep(3)
        end
    else
        sleep(10)
    end
end