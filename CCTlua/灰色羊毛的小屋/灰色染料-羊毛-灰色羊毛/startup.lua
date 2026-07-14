---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_27") -- 海龟
local Chest = peripheral.wrap("minecraft:chest_1218") -- 灰色染料容器
local ItemVault = peripheral.wrap("create:item_vault_81") -- 灰色羊毛预期
-- local Chest2 = peripheral.wrap("minecraft:chest_1217") -- 白色羊毛容器
-- 白色羊毛容器
local iPf1 = peripheral.wrap("create:depot_153")
local iPf2 = peripheral.wrap("create:depot_154")
local iPf3 = peripheral.wrap("create:depot_155")
local iPf4 = peripheral.wrap("create:depot_156")
local iPf5 = peripheral.wrap("create:depot_157")
local iPf6 = peripheral.wrap("create:depot_158")
local iPf7 = peripheral.wrap("create:depot_159")
local iPf8 = peripheral.wrap("create:depot_160")
local iPf9 = peripheral.wrap("create:depot_161")
-- ===================== 索引表定义 =====================
local itemPlatform = {
    [1] = iPf1,
    [2] = iPf2,
    [3] = iPf3,
    [4] = iPf4,
    [5] = iPf5,
    [6] = iPf6,
    [7] = iPf7,
    [8] = iPf8,
    [9] = iPf9
}

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

-- ===================== 函数：从外部获取原料 =====================
local function ObtainMaterials(Source1, Source2, Target)
    -- 步骤1：海龟1号槽位为空则尝试拉取羊毛
    if turtle.getItemDetail(1) == nil then
        for j = 1, 9 do
            local currentIPF = Source1[j]
            if currentIPF.pushItems(Target, 1, 64, 1) == 64 then
                break;
            end
        end
    end

    if turtle.getItemDetail(2) == nil then
        local Source2Slot = getAnyValidSlot(Source2)
        if Source2Slot ~= nil then
            local PullCount1 = Source2.pushItems(Target, Source2Slot, 64, 2)
            if PullCount1 ~= 64 then
                sleep(1)
            end
        end
    end

    return true
end

-- ===================== 函数：合成并输出 =====================
local function SynthesisOutput(Source, Target)
    if turtle.getItemDetail(1) ~= nil and turtle.getItemDetail(2) ~= nil then
        turtle.craft(64)
        local PullCount2 = Target.pullItems(Source, 1, 64)
        if PullCount2 ~= 64 then
            sleep(1)
        end
    else
        sleep(3)
    end
end


-- ===================== 主循环：持续监测 =====================
turtle.select(1)
while true do
    if not redstone.getInput("bottom") then
        ObtainMaterials(itemPlatform, Chest, "turtle_27")
        SynthesisOutput("turtle_27", ItemVault)
        sleep(0.1)
    else
        sleep(10)
    end
end