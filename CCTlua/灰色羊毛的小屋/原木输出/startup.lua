---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_23") -- 海龟
local TurtleName = "turtle_23" -- 海龟
local Chest = peripheral.wrap("minecraft:chest_1214") -- 中转容器
local ItemVault = peripheral.wrap("create:item_vault_79") -- 原料输入容器
-- 检查容量相关
local CONTAINER_TOTAL_SLOTS = 54          -- 容器总槽位（比如大箱子54）
local TRIGGER_THRESHOLD = 48             -- 触发信号的阈值
local RESET_THRESHOLD = 27               -- 停止信号的阈值
-- local CHECK_INTERVAL = 1                  -- 检查间隔（秒）
-- local CONTAINER_NAME = "Chest"      -- 检查的容器外设名
-- 输出
local TargetContainer = ItemVault        -- 输出目标
local IntervalQuantity = 9               -- 每次检查间隔的输送次数

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

-- ===================== 函数：迟滞逻辑判断 =====================
local function updateSignal(container)
    local occupiedSlots = getOccupiedSlots(container)
    local newSignalState = isSignalOn -- 默认保持当前状态

    -- 情况1：已占用槽位≥触发阈值 且 当前信号未开 → 开启信号（设标签U）
    if occupiedSlots >= TRIGGER_THRESHOLD and not isSignalOn then
        newSignalState = true
    -- 情况2：已占用槽位≤恢复阈值 且 当前信号已开 → 关闭信号（设标签F）
    elseif occupiedSlots <= RESET_THRESHOLD and isSignalOn then
        newSignalState = false
    -- 情况3：介于恢复阈值和触发阈值之间 → 保持当前状态（不切换标签）
    end
    
    -- 仅当状态变化时，执行标签设置
    if newSignalState ~= isSignalOn then
        isSignalOn = newSignalState
    end
end

-- ===================== 函数：提取与运输黑洞内容 =====================
local function pushCraftedItemToContainer(Source, Target)
    -- 步骤1：检查海龟2号槽位是否为空
    if turtle.getItemDetail(2) ~= nil then
        return false
    end

    -- 步骤2：执行合成（填充2号槽位）
    if not turtle.craft(1) then
        return false
    end

    -- 步骤3：再次校验2号槽位是否有合成产物（防合成无输出）
    if turtle.getItemDetail(2) == nil then
        return false
    end

    -- 步骤4：将2号槽位物品推送至目标容器
    turtle.select(2) -- 选中2号槽
    local pushCount = Target.pullItems(peripheral.getName(Source), 2, 64)

    -- 校验推送结果
    if pushCount <= 0 then
        return false
    end

    return true
end

-- ===================== 5. 主循环：持续监测 =====================
local i = IntervalQuantity
while true do
    if not redstone.getInput("right") then
        if i >= IntervalQuantity then
            updateSignal(Chest)
            i = 0
            -- 执行迟滞判断，更新标签
            -- sleep(0.05)
        end

        if not isSignalOn then
            pushCraftedItemToContainer(Turtle, ItemVault)
            i = i + 1
            sleep(0.05)
        else
            i = IntervalQuantity
            sleep(2)
        end
    else
        sleep(10)
    end
end