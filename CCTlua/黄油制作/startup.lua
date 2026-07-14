---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_28") -- 海龟
local Cabinet = peripheral.wrap("candlelight:cabinet_1") -- 白色染料容器
local Chest2 = peripheral.wrap("minecraft:chest_1215") -- 黑色染料容器
local Chest3 = peripheral.wrap("minecraft:chest_1218") -- 灰色染料容器


-- ===================== 函数：获取容器中某一个有物品槽位 =====================
local function getAnyValidSlot(container)
    -- 1.获取容器的list
    local ContainerItemList = container.list() or {}
    if not ContainerItemList then return nil end

    -- 2. 遍历list，拿到第一个遇到的有效槽位就返回
    for slot in pairs(ContainerItemList) do
        return slot -- 找到任意一个有效槽位，立即返回，无需遍历全部
    end

    -- 3. 无有效槽位时返回nil
    return nil
end

-- ===================== 函数：获取容器中某一个有物品槽位，且要求Name对应 =====================
local function getAnyValidSlotWithName(container, targetItemName)
    -- 获取容器物品列表
    local ContainerItemList = container.list() or {}

    -- 遍历槽位，检查物品名称
    for slot, itemInfo in pairs(ContainerItemList) do
        -- 校验物品信息完整性（避免nil）
        if itemInfo and itemInfo.name then
            -- 匹配物品名称（严格匹配，包括命名空间）
            if itemInfo.name == targetItemName and itemInfo.count == 64 then
                return slot -- 找到匹配槽位，立即返回
            end
        end
    end

    -- 4. 无匹配槽位时返回nil
    return nil
end

-- ===================== 函数：从外部获取原料 =====================
local function ObtainMaterials(Source1, Source1Name, Source2, Target)
    if turtle.getItemDetail(1) == nil then
        local Source1Slot = getAnyValidSlotWithName(Source1, Source1Name)
        if Source1Slot ~= nil then
            Source1.pushItems(Target, Source1Slot, 64, 1)
        end
    end

    if turtle.getItemDetail(2) == nil then
        local Source2Slot = getAnyValidSlot(Source2)
        if Source2Slot ~= nil then
            Source2.pushItems(Target, Source2Slot, 64, 2)
        end
    end

    return true
end

-- ===================== 函数：合成并输出 =====================
local function SynthesisOutput(Source, Target)
    local Info1 = turtle.getItemDetail(1)
    local Info2 = turtle.getItemDetail(2)
    if Info1 and Info1.name == "minecraft:black_dye" and Info2 and Info2.name == "minecraft:white_dye" then
        turtle.craft(64)
    else
        sleep(3)
    end
    local isGray1 = turtle.getItemDetail(1) and turtle.getItemDetail(1).name == "minecraft:gray_dye"
    local isGray2 = turtle.getItemDetail(2) and turtle.getItemDetail(2).name == "minecraft:gray_dye"
    if isGray1 then
        local PullCount1 = Target.pullItems(Source, 1, 64)
        if PullCount1 ~= 64 then
            sleep(1)
        end
    end
    if isGray2 then
        local PullCount2 = Target.pullItems(Source, 2, 64)
        if PullCount2 ~= 64 then
            sleep(1)
        end
    end
end


-- ===================== 主循环：持续监测 =====================
turtle.select(1)
while true do
    if not redstone.getInput("top") then
        ObtainMaterials(Chest2, "minecraft:black_dye", Cabinet, "turtle_28")
        SynthesisOutput("turtle_28", Chest3)
        sleep(0.1)
    else
        sleep(10)
    end
end