---@diagnostic disable: undefined-global


local Turtle = peripheral.wrap("turtle_44") -- 海龟
local Chest = peripheral.wrap("minecraft:chest_1246") -- 容器


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

while true do
    os.pullEvent("redstone")

    for i = 1, 27 do
        pushCraftedItemToContainer("turtle_44", Chest)
    end
end