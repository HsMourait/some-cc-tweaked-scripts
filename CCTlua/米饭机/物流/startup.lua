---@diagnostic disable: undefined-global

-- 红石输入方向（顶部）
local redstoneSide = "top"

-- 外设包装（请根据实际外设名称修改）
local vault = peripheral.wrap("create:item_vault_23")   -- 中央保险库，存放稻米和碗
local riceChest = peripheral.wrap("minecraft:chest_43") -- 稻米目标箱子
local bowlChest = peripheral.wrap("minecraft:chest_41") -- 碗目标箱子

-- 定义需要转移的物品及其目标容器
local items = {
    {name = "farmersdelight:rice", target = riceChest},   -- 稻米
    {name = "minecraft:bowl", target = bowlChest}    -- 碗
}

-- 获取容器中指定物品的所有槽位号（升序），返回前 n 个
-- 参数：container - 容器对象，itemName - 物品ID，n - 最多取前几个槽位
local function getSpeSlots(container, itemName, n)
    local slots = container.list() or {}   -- 获取容器所有槽位的稀疏表，键=槽位号，值=物品数据
    local validSlots = {}
    -- 遍历所有非空槽位，筛选出物品名称匹配的槽位号
    for slot, item in pairs(slots) do
        if item.name == itemName then
            table.insert(validSlots, slot)
        end
    end
    -- 按槽位号升序排序
    table.sort(validSlots)
    -- 只保留前 n 个，多余的置 nil
    for i = n + 1, #validSlots do
        validSlots[i] = nil
    end
    return validSlots
end

-- 主循环
while true do
    -- 红石开关：若顶部有红石信号（高电平），每5秒检测一次，直到信号消失
    while redstone.getInput(redstoneSide) do
        sleep(5)
    end

    -- 分别处理每种物品（先稻米，后碗）
    for _, itemInfo in ipairs(items) do
        local itemName = itemInfo.name
        local target = itemInfo.target
        local targetName = peripheral.getName(target)   -- 目标容器的外设名称

        -- 获取保险库中该物品的前54个槽位号（按编号升序）
        local targetSlots = getSpeSlots(vault, itemName, 54)

        -- 依次推送每个槽位的全部物品到目标箱子
        for _, realSlot in ipairs(targetSlots) do
            -- 尝试推送整个槽位的物品，返回实际推送数量
            local success = vault.pushItems(targetName, realSlot)
            -- 如果推送失败（返回0或nil），说明目标箱子已满或出错，停止推送该物品的剩余槽位
            if not success or success == 0 then
                break
            end
        end
    end

    -- 所有物品处理完毕后，休眠20秒，然后重复整个流程
    sleep(20)
end