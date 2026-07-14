---@diagnostic disable: undefined-global

-- ===================== 自动获取外设 =====================
local function wrapList(peripheralType)
    local sorted = {}
    peripheral.find(peripheralType, function(name, obj)
        table.insert(sorted, {name = name, obj = obj})
        return true
    end)
    table.sort(sorted, function(a, b) return a.name < b.name end)
    local result = {}
    for i, entry in ipairs(sorted) do
        result[i] = entry.obj
    end
    return result
end

-- 获取所有红石继电器和机械手（按名称排序）
local relays = wrapList("redstone_relay")
local deployers = wrapList("create:deployer")

-- ===================== 用户需根据实际修改的容器 =====================
-- 保险库（存放水桶、回收空桶、最终成品）
local vault = peripheral.wrap("create:item_vault_22")
-- 稻米箱
local riceChest = peripheral.wrap("minecraft:chest_43")
-- 锅盖箱
local potLidChest = peripheral.wrap("minecraft:chest_42")
-- 碗箱
local bowlChest = peripheral.wrap("minecraft:chest_41")

-- ===================== 辅助函数 =====================
-- 获取容器中指定物品的第一个槽位，且该槽位的物品数量 >= minCount（如果提供了 minCount）
-- 参数：container - 容器对象，itemName - 物品ID，minCount - 可选，最低数量要求
-- 返回值：满足条件的槽位号，若未找到则返回 nil
local function getSpeValidSlot(container, itemName, minCount)
    local itemList = container.list() or {}
    for slot, item in pairs(itemList) do
        if item.name == itemName then
            -- 如果没有指定最低数量，或者当前物品数量满足最低数量，则返回该槽位
            if minCount == nil or item.count >= minCount then
                return slot
            end
        end
    end
    return nil
end

-- 从源容器中取出指定名称的物品，推送给目标容器列表中的每一个（每个目标推送固定数量）
-- 若源容器中暂无该物品，则无限等待直到出现
local function pushItemsToTargets(sourceContainer, targetIndexTable, itemName, pushCount)
    for _, targetContainer in ipairs(targetIndexTable) do
        local validSlot = getSpeValidSlot(sourceContainer, itemName, pushCount)
        if not validSlot then
            -- 若源容器无所需物品，无限等待
            while not validSlot do
                sleep(1)
                validSlot = getSpeValidSlot(sourceContainer, itemName)
            end
        end
        sourceContainer.pushItems(peripheral.getName(targetContainer), validSlot, pushCount)
    end
end

-- 从源容器列表中的每个容器（指定槽位）取出固定数量物品，统一推送给产物容器
local function pushItemsFromSourcesToProduct(sourceIndexTable, productContainer, pushCount, targetSlot)
    local productPeriphName = peripheral.getName(productContainer)
    for _, sourceContainer in ipairs(sourceIndexTable) do
        sourceContainer.pushItems(productPeriphName, targetSlot, pushCount)
    end
end

-- 短时关闭所有继电器（同步控制）
local function shortCloseRelays(relayTable, closeTimes, closeDuration, closeDelay)
    for _ = 1, closeTimes do
        for _, relay in ipairs(relayTable) do
            relay.setAnalogOutput("bottom", 0)   -- 假设继电器输出方向为 front，请根据实际调整
        end
        sleep(closeDuration)
        for _, relay in ipairs(relayTable) do
            relay.setAnalogOutput("bottom", 15)
        end
        sleep(closeDelay)
    end
end

-- ===================== 输入循环次数 =====================
local function getValidNumber()
    print("Please enter the number of production cycles:")
    while true do
        local userInput = read()
        local num = tonumber(userInput)
        if num and math.floor(num) == num and num > 0 then
            return num
        else
            print("Invalid input! Please enter a positive integer:")
        end
    end
end

local loopCount = getValidNumber()
--开启所有继电器
for _, relay in ipairs(relays) do
    relay.setAnalogOutput("front", 15)
end
-- ===================== 主循环 =====================
print("Starting loop, total iterations: " .. loopCount)
for i = 1, loopCount do
    -- 1. 取水桶（从保险库给每个机械手1个水桶）
    pushItemsToTargets(vault, deployers, "minecraft:water_bucket", 1)

    -- 2. 激活一次机械手（将水桶放入锅）
    shortCloseRelays(relays, 1, 0.4, 0)

    -- 3. 回收空桶（从机械手推回保险库）
    pushItemsFromSourcesToProduct(deployers, vault, 1, 1)

    -- 4. 取稻米（从稻米箱给每个机械手5个稻米）
    pushItemsToTargets(riceChest, deployers, "farmersdelight:rice", 5)

    -- 5. 激活五次机械手（淘米/搅拌）
    shortCloseRelays(relays, 5, 0.4, 1)

    -- 6. 从箱子获取锅盖
    pushItemsToTargets(potLidChest, deployers, "kaleidoscope_cookery:stockpot_lid", 1)

    -- 7. 激活一次机械手（盖上锅盖）
    shortCloseRelays(relays, 1, 0.4, 0)

    -- 8. 烹饪等待
    sleep(30)

    -- 9. 激活一次机械手（取下锅盖）
    shortCloseRelays(relays, 1, 0.4, 0)

    -- 10. 回收锅盖（从机械手推回锅盖箱）
    pushItemsFromSourcesToProduct(deployers, potLidChest, 1, 1)

    -- 11. 取碗（从碗箱给每个机械手5个碗）
    pushItemsToTargets(bowlChest, deployers, "minecraft:bowl", 5)

    -- 12. 五次盛饭（每次激活后拉取米饭到保险库）
    for _ = 1, 5 do
        shortCloseRelays(relays, 1, 0.4, 0)
        sleep(1.5)   -- 等待机械手动作完成
        -- 从每个机械手拉取1个米饭（成品）到保险库
        for _, deployer in ipairs(deployers) do
            vault.pullItems(peripheral.getName(deployer), 1)
        end
        sleep(1.5)
    end

    print("Loop iteration: " .. i)
    sleep(2)   -- 循环间隔
end

-- 结束时关闭所有继电器（可选）
for _, relay in ipairs(relays) do
    relay.setAnalogOutput("front", 0)
end
print("Loop completed! Total iterations executed: " .. loopCount)