---@diagnostic disable: undefined-global

--红石继电器
local redstoneRelay1 = peripheral.wrap("redstone_relay_276")
local redstoneRelay2 = peripheral.wrap("redstone_relay_277")
local redstoneRelay3 = peripheral.wrap("redstone_relay_278")
local redstoneRelay4 = peripheral.wrap("redstone_relay_279")
local redstoneRelay5 = peripheral.wrap("redstone_relay_280")
local redstoneRelay6 = peripheral.wrap("redstone_relay_281")
local redstoneRelay7 = peripheral.wrap("redstone_relay_282")
local redstoneRelay8 = peripheral.wrap("redstone_relay_283")

-- 机械手
local deployer1 = peripheral.wrap("create:deployer_24")
local deployer2 = peripheral.wrap("create:deployer_25")
local deployer3 = peripheral.wrap("create:deployer_26")
local deployer4 = peripheral.wrap("create:deployer_27")
local deployer5 = peripheral.wrap("create:deployer_28")
local deployer6 = peripheral.wrap("create:deployer_29")
local deployer7 = peripheral.wrap("create:deployer_30")
local deployer8 = peripheral.wrap("create:deployer_31")

-- 箱子
-- 油脂
local oil = peripheral.wrap("minecraft:chest_1238")
-- 原料
local feedstock = peripheral.wrap("minecraft:chest_1240")
-- 碗
local bowl = peripheral.wrap("minecraft:chest_1242")
-- 产物
local out = peripheral.wrap("minecraft:chest_1244")

--木桶：锅铲
local spatula = peripheral.wrap("minecraft:barrel_108")

-- ===================== 索引表定义 =====================
-- 1. 红石接口索引表
local redstoneRelay = {
    [1] = redstoneRelay1,
    [2] = redstoneRelay2,
    [3] = redstoneRelay3,
    [4] = redstoneRelay4,
    [5] = redstoneRelay5,
    [6] = redstoneRelay6,
    [7] = redstoneRelay7,
    [8] = redstoneRelay8
}

-- 2. Deployer（机械手）索引表
local deployers = {
    [1] = deployer1,
    [2] = deployer2,
    [3] = deployer3,
    [4] = deployer4,
    [5] = deployer5,
    [6] = deployer6,
    [7] = deployer7,
    [8] = deployer8
}

-- 激活红石继电器
for i = 1, #redstoneRelay do
    local current = redstoneRelay[i]
    current.setAnalogOutput("front", 15)
end

-- ===================== 获取容器中某一个有物品槽位 =====================
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

-- ===================== 从容器推送物品至表 =====================
local function pushItemsToTargets(sourceContainer, targetIndexTable, pushCount)
    -- 遍历目标容器表，取出每个容器的索引和容器对象
    for targetIndex, targetContainer in pairs(targetIndexTable) do
        -- 从源容器中获取任意一个有效的物品槽位编号
        local validSlot = getAnyValidSlot(sourceContainer)
        -- 获取目标容器的外设名称
        local targetPeriphName = peripheral.getName(targetContainer)
        -- 调用源容器的pushItems方法，把物品推送到目标容器
        sourceContainer.pushItems(targetPeriphName, validSlot, pushCount)
    end
end

-- ===================== 从表内容器推送物品至输出 =====================
local function pushItemsFromSourcesToProduct(sourceIndexTable, productContainer, pushCount, targetSlot)
    -- 获取产物容器的外设名称（供pushItems调用）
    local productPeriphName = peripheral.getName(productContainer)
    -- 遍历源容器表，逐个向产物容器推送物品
    for sourceIndex, sourceContainer in pairs(sourceIndexTable) do
        -- 直接使用指定的槽位，不再调用getAnyValidSlot
        sourceContainer.pushItems(productPeriphName, targetSlot, pushCount)
    end
end

-- ===================== 短关闭继电器-使机械手定量工作 =====================
local function shortCloseRelays(redstoneRelay, closeTimes, closeDuration, closeDelay)
    -- 循环执行指定的关闭次数
    for time = 1, closeTimes do
        -- 第一步：将所有继电器统一关闭
        for i = 1, #redstoneRelay do
            local currentRelay = redstoneRelay[i]
            currentRelay.setAnalogOutput("front", 0)
        end

        -- 第二步：等待指定的关闭时长
        sleep(closeDuration)

        -- 第三步：将所有继电器统一开启（输出强度设为15）
        for i = 1, #redstoneRelay do
            local currentRelay = redstoneRelay[i]
            currentRelay.setAnalogOutput("front", 15)
        end

        -- 第四步：多次关闭间的间隔
        sleep(closeDelay)
    end
end

-- 1. 封装输入校验函数：确保输入是小于128的正整数
local function getValidNumber()
    -- 请输入一个小于128的整数
    print("Please enter a positive integer less than 128:")
    print("This value determines the number of working cycles each operation of the device is expected to produce 5 servings of shredded pork with green peppers.")
    print("Correspondingly, each operation will consume 5 units of fat, 15 green chilies, 10 pork chops and 5 bowls of rice. Please ensure there is sufficient stock to complete the operation.")

    while true do
        -- 等待用户输入
        local userInput = read()
        -- 转换为数字
        local num = tonumber(userInput)

        -- 校验条件：是数字 + 是整数 + 大于0 + 小于128
        if num and math.floor(num) == num and num > 0 and num < 128 then
            return num  -- 输入有效，返回数字
        else
            -- 输入无效，给出英文提示并重新等待
            print("Invalid input! Please enter a positive integer less than 128:")
        end
    end
end

-- 2. 获取用户输入的有效数字
local loopCount = getValidNumber()

-- 3. 执行对应次数的循环
print("Starting loop, total iterations: " .. loopCount)
for i = 1, loopCount do
    -- =====================
    -- 1.输入油脂
    pushItemsToTargets(oil, deployers, 1)
    -- 2.激活一次机械手
    shortCloseRelays(redstoneRelay, 1, 0.3, 0.3)
    -- 3.向机械手输入“原料”
    pushItemsToTargets(feedstock, deployers, 1)
    -- 4.激活一次机械手
    -- 或许之后要把这里弄成可自定义的
    shortCloseRelays(redstoneRelay, 1, 0.3, 0.3)
    -- 5.向机械手输入锅铲
    pushItemsToTargets(spatula, deployers, 1)
    -- 6.激活三次机械手
    shortCloseRelays(redstoneRelay, 3, 0.3, 0.4)
    -- 7.将锅铲放回木桶
    pushItemsFromSourcesToProduct(deployers, spatula, 1, 1)
    -- 8.向机械手输入碗
    pushItemsToTargets(bowl, deployers, 1)
    -- 9.等待烹饪完成
    sleep(8)
    -- 10.激活一次机械手
    shortCloseRelays(redstoneRelay, 1, 0.3, 0.3)
    -- 11.将产物输出至产物箱子
    pushItemsFromSourcesToProduct(deployers, out, 1, 1)
    -- 打印当前循环次数
    print("Loop iteration: " .. i)
    -- =====================
        sleep(0.5)
    -- 循环间隔
end

-- 循环结束提示
print("Loop completed! Total iterations executed: " .. loopCount)