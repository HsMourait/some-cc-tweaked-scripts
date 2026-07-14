---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_25") -- 海龟
local Cabinet = peripheral.wrap("candlelight:cabinet_2") -- 原料输入容器

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

-- ===================== 函数：提取与运输黑洞内容 =====================
local function pushCraftedItemToContainer(Source, Target)
    -- 步骤1：检查海龟2号槽位是否为空
    if turtle.getItemDetail(2) == nil then
        if not turtle.craft(1) then
           return false
        end
    end

    -- 步骤2：将2号槽位物品推送至目标容器
    turtle.select(2) -- 选中2号槽
    local pushCount = Target.pullItems(Source, 2, 64)

    -- 校验推送结果
    if pushCount <= 0 then
        return false
    end

    return true
end

-- ===================== 5. 主循环：持续监测 =====================
local i = IntervalQuantity
while true do
    if not redstone.getInput("top") then
        if not (getOccupiedSlots(Cabinet) >= CapacityThreshold) then
            pushCraftedItemToContainer("turtle_25", Cabinet)
            sleep(0.05)
        else
            sleep(3)
        end
    else
        sleep(10)
    end
end