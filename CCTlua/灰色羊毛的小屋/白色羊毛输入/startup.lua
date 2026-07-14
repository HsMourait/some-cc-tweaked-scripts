---@diagnostic disable: undefined-global

-- ===================== 配置项 =====================
-- 定义外设
local Turtle = peripheral.wrap("turtle_24") -- 海龟
local ItemVault = peripheral.wrap("create:item_vault_80") -- 原料输入容器

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
    if not redstone.getInput("front") and not redstone.getInput("top") then
        pushCraftedItemToContainer("turtle_24", ItemVault)
        sleep(0.05)
    else
        sleep(10)
    end
end