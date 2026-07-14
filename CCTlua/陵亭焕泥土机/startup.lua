---@diagnostic disable: undefined-global

local coarseDirt = peripheral.wrap("create:item_vault_119")
local gravel  = peripheral.wrap("create:item_vault_120")
local dirt  = peripheral.wrap("create:item_vault_121")
local dustbin = peripheral.wrap("minecraft:barrel_123")

-- ===================== 获取容器中符合条件的前两个物品槽位 =====================
local function getFirstTwoValidSlots(container, requiredName, requiredCount)
    -- 参数：
    --   container: 包装后的容器对象
    --   requiredName: 需要的物品名称（字符串），如果为nil则不检查名称
    --   requiredCount: 需要的物品数量（数字），如果为nil则不检查数量
    -- 返回值：
    --   成功：两个有效槽位（number, number）
    --   失败：nil（当容器中符合条件的有效槽位少于2个时）
    
    -- 1.获取容器的list
    local ContainerItemList = container.list() or {}
    if not ContainerItemList then return nil end

    -- 2. 遍历list，收集符合条件的槽位
    local validSlots = {}
    for slot, item in pairs(ContainerItemList) do
        -- 检查名称条件
        if (not requiredName or item.name == requiredName) then
            -- 检查数量条件
            if (not requiredCount or item.count == requiredCount) then
                table.insert(validSlots, slot)
                if #validSlots >= 2 then
                    return validSlots[1], validSlots[2]  -- 收集到两个槽位，立即返回
                end
            end
        end
    end

    -- 3. 符合条件的槽位少于2个，返回nil
    return nil, nil
end

while true do
-- 检查红石开关
    :: Mark1 ::
    if  redstone.getInput("bottom") then
        sleep(10)
        goto Mark1
    end

-- 清理缓存
    for _, num in ipairs({1, 2, 5, 6, 7, 8}) do
        dustbin.pullItems("turtle_48", num, 64)
    end

-- 检查泥土与沙砾
    local gravelslot1, gravelslot2 = getFirstTwoValidSlots(gravel, "minecraft:gravel", 64)
    local dirtlslot1, dirtlslot2 = getFirstTwoValidSlots(dirt, "minecraft:dirt", 64)
-- 若没有两组沙砾则休眠
    if gravelslot1 == nil then
        sleep(10)
        goto Mark1
    end
-- 若没有两组泥土则休眠
    if dirtlslot1 == nil then
        sleep(10)
        goto Mark1
    end

-- 获取沙砾
    gravel.pushItems("turtle_48", gravelslot1, 64, 2)
    gravel.pushItems("turtle_48", gravelslot2, 64, 5)

-- 获取泥土
    dirt.pushItems("turtle_48", dirtlslot1, 64, 1)
    dirt.pushItems("turtle_48", dirtlslot2, 64, 6)

-- 合成砂土
    turtle.craft(64)

-- 推送至砂土
    coarseDirt.pullItems("turtle_48", 1, 64)
    coarseDirt.pullItems("turtle_48", 2, 64)
    coarseDirt.pullItems("turtle_48", 3, 64)
    coarseDirt.pullItems("turtle_48", 4, 64)

-- 好像不能公式化休眠了，不改机器的话就要保证消耗砂土的速度更大，不然会卡缓存
-- 我写个15s试试
    sleep(15)
-- 还是不行，再多睡3s罢
    sleep(3)

-- 疑似和转速的检查点相关，这个我真没招了，得改物理层
end