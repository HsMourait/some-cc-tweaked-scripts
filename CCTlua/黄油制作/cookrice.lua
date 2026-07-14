---@diagnostic disable: undefined-global
local Interface1 = peripheral.wrap("redstoneIntegrator_56")
local Interface2 = peripheral.wrap("redstoneIntegrator_58")
local Interface3 = peripheral.wrap("redstoneIntegrator_60")
local Interface4 = peripheral.wrap("redstoneIntegrator_61")

local InterfaceCtrl = peripheral.wrap("redstoneIntegrator_53")

local deployer1 = peripheral.wrap("create:deployer_8")
local deployer2 = peripheral.wrap("create:deployer_10")
local deployer3 = peripheral.wrap("create:deployer_21")
local deployer4 = peripheral.wrap("create:deployer_14")

local itemPlatformBucket = peripheral.wrap("create:depot_141")
local itemPlatformRice = peripheral.wrap("create:depot_140")
local itemPlatformPotLid = peripheral.wrap("create:depot_139")
local itemPlatformBowl = peripheral.wrap("create:depot_138")
-- 水桶
-- 稻米
-- 锅盖
-- 碗

local itemVault = peripheral.wrap("create:item_vault_74")

-- ===================== 索引表定义（核心部分） =====================
-- 1. 红石接口索引表：索引1-4对应Interface1-4
local redstoneInterfaces = {
    [1] = Interface1,
    [2] = Interface2,
    [3] = Interface3,
    [4] = Interface4
}

-- 2. Deployer（机械手）索引表：索引1-4对应deployer1-4
local deployers = {
    [1] = deployer1,
    [2] = deployer2,
    [3] = deployer3,
    [4] = deployer4
}

-- 3. 置物台索引表：索引1-4依次对应水桶、稻米、锅盖、碗的置物台
local itemPlatforms = {
    [1] = itemPlatformBucket,   -- 1 = 水桶置物台
    [2] = itemPlatformRice,     -- 2 = 稻米置物台
    [3] = itemPlatformPotLid,   -- 3 = 锅盖置物台
    [4] = itemPlatformBowl      -- 4 = 碗置物台
}






-- 激活红石接口
Interface1.setAnalogOutput("east", 15)
Interface2.setAnalogOutput("east", 15)
Interface3.setAnalogOutput("east", 15)
Interface4.setAnalogOutput("east", 15)
InterfaceCtrl.setAnalogOutput("east", 15)



-- 1. 封装输入校验函数：确保输入是小于128的正整数
local function getValidNumber()
    -- 请输入一个小于128的整数
    print("Please enter a positive integer less than 128:")
    print("This determines the number of working cycles - it is expected to produce 20 bowls of rice each time it operates.")
    print("Correspondingly, 20 grains of rice will be consumed each time it works. Please ensure there is sufficient stock to complete the operation.")
    
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

-- 3. 执行对应次数的循环（功能暂留空）
print("Starting loop, total iterations: " .. loopCount)
for i = 1, loopCount do
    -- =====================
    sleep(1)
    -- 从置物台取水
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 1号置物台（水桶）固定为itemPlatformBucket
        local currentDeployer = deployers[j]
        ::Marker1::
        -- 检查水桶置物台是否有物品
        if not itemPlatformBucket.getItemDetail(1) then
            goto Marker1
        end

        -- 将水桶置物台物品推送至当前机械手
        itemPlatformBucket.pushItems(peripheral.getName(currentDeployer), 1)

        -- 考虑到懒惰刻，循环间休眠需要写得很长
        sleep(1)
    end

    -- 激活一次机械手
    --[[
    for k = 1, 4 do
        -- 获取当前k对应的红石接口
        local currentInterface = redstoneInterfaces[k]

        -- 执行红石接口模拟输出
        currentInterface.setAnalogOutput("east", 0)
        sleep(0.4)
        currentInterface.setAnalogOutput("east", 15)

        sleep(0.6)
    end
]]
    Interface1.setAnalogOutput("east", 0)
    Interface2.setAnalogOutput("east", 0)
    Interface3.setAnalogOutput("east", 0)
    Interface4.setAnalogOutput("east", 0)
    sleep(0.4)
    Interface1.setAnalogOutput("east", 15)
    Interface2.setAnalogOutput("east", 15)
    Interface3.setAnalogOutput("east", 15)
    Interface4.setAnalogOutput("east", 15)

    -- 将机械手的空桶放回保险库
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 保险库固定为itemVault
        local currentDeployer = deployers[j]
        -- 将机械手空桶推送回保险库
        itemVault.pullItems(peripheral.getName(currentDeployer), 1)
        -- sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取稻米
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 2号置物台（稻米）固定为itemPlatformRice
        local currentDeployer = deployers[j]
        ::Marker3::
        -- 检查稻米置物台是否有物品
        if not itemPlatformRice.getItemDetail(1) then
            goto Marker3
        end

        -- 将稻米置物台物品推送至当前机械手
        itemPlatformRice.pushItems(peripheral.getName(currentDeployer), 1, 5)

        -- 考虑到懒惰刻，循环间休眠需要写得很长
        -- sleep(1)
    end

    -- 激活五次机械手
    for j = 1, 5 do
        --[[
        for k = 1, 4 do
            -- 获取当前k对应的红石接口
            local currentInterface = redstoneInterfaces[k]

            -- 执行红石接口模拟输出
            currentInterface.setAnalogOutput("east", 0)
            sleep(0.4)
            currentInterface.setAnalogOutput("east", 15)

            sleep(0.6)
        end
        ]]
        Interface1.setAnalogOutput("east", 0)
        Interface2.setAnalogOutput("east", 0)
        Interface3.setAnalogOutput("east", 0)
        Interface4.setAnalogOutput("east", 0)
        sleep(0.4)
        Interface1.setAnalogOutput("east", 15)
        Interface2.setAnalogOutput("east", 15)
        Interface3.setAnalogOutput("east", 15)
        Interface4.setAnalogOutput("east", 15)
        sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取锅盖
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 3号置物台（锅盖）固定为itemPlatformPotLid
        local currentDeployer = deployers[j]
        ::Marker4::
        -- 检查锅盖置物台是否有物品
        if not itemPlatformPotLid.getItemDetail(1) then
            goto Marker4
        end

        -- 将锅盖置物台物品推送至当前机械手
        itemPlatformPotLid.pushItems(peripheral.getName(currentDeployer), 1, 5)

        -- 考虑到懒惰刻，循环间休眠需要写得很长
        sleep(1)
    end

    -- 激活一次机械手
    --[[
    for k = 1, 4 do
        -- 获取当前k对应的红石接口
        local currentInterface = redstoneInterfaces[k]

        -- 执行红石接口模拟输出
        currentInterface.setAnalogOutput("east", 0)
        sleep(0.4)
        currentInterface.setAnalogOutput("east", 15)

        sleep(0.6)
    end
    ]]
    Interface1.setAnalogOutput("east", 0)
    Interface2.setAnalogOutput("east", 0)
    Interface3.setAnalogOutput("east", 0)
    Interface4.setAnalogOutput("east", 0)
    sleep(0.4)
    Interface1.setAnalogOutput("east", 15)
    Interface2.setAnalogOutput("east", 15)
    Interface3.setAnalogOutput("east", 15)
    Interface4.setAnalogOutput("east", 15)

    -- =====================
    sleep(30)
    -- 等待烹饪

    -- 激活一次机械手取下锅盖
    Interface1.setAnalogOutput("east", 0)
    Interface2.setAnalogOutput("east", 0)
    Interface3.setAnalogOutput("east", 0)
    Interface4.setAnalogOutput("east", 0)
    sleep(0.4)
    Interface1.setAnalogOutput("east", 15)
    Interface2.setAnalogOutput("east", 15)
    Interface3.setAnalogOutput("east", 15)
    Interface4.setAnalogOutput("east", 15)

    -- 将机械手的锅盖放回保险库
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 保险库固定为itemVault
        local currentDeployer = deployers[j]
        -- 将机械手锅盖推送回保险库
        itemVault.pullItems(peripheral.getName(currentDeployer), 1)
        -- sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取碗
    for j = 1, 4 do
        -- 获取当前循环对应的机械手
        -- 4号置物台（碗）固定为itemPlatformBowl
        local currentDeployer = deployers[j]
        ::Marker5::
        -- 检查碗置物台是否有物品
        if not itemPlatformBowl.getItemDetail(1) then
            goto Marker5
        end

        -- 将稻米置物台物品推送至当前机械手
        itemPlatformBowl.pushItems(peripheral.getName(currentDeployer), 1, 5)

        -- 考虑到懒惰刻，循环间休眠需要写得很长
        -- sleep(1)
    end

    -- 激活五次机械手并在每一次激活后输出米饭
    for j = 1, 5 do
        --[[
        for k = 1, 4 do
            -- 获取当前k对应的红石接口
            local currentInterface = redstoneInterfaces[k]
            -- 获取当前循环对应的机械手
            local currentDeployer = deployers[k]
            -- 执行红石接口模拟输出
            currentInterface.setAnalogOutput("east", 0)
            sleep(0.4)
            currentInterface.setAnalogOutput("east", 15)

            sleep(1)
            -- 将机械手米饭推送回保险库
            itemVault.pullItems(peripheral.getName(currentDeployer), 1)
        end
        ]]
        Interface1.setAnalogOutput("east", 0)
        Interface2.setAnalogOutput("east", 0)
        Interface3.setAnalogOutput("east", 0)
        Interface4.setAnalogOutput("east", 0)
        sleep(0.4)
        Interface1.setAnalogOutput("east", 15)
        Interface2.setAnalogOutput("east", 15)
        Interface3.setAnalogOutput("east", 15)
        Interface4.setAnalogOutput("east", 15)
        
        sleep(1.5)

        itemVault.pullItems(peripheral.getName(deployer1), 1)
        itemVault.pullItems(peripheral.getName(deployer2), 1)
        itemVault.pullItems(peripheral.getName(deployer3), 1)
        itemVault.pullItems(peripheral.getName(deployer4), 1)

        sleep(1.5)
        --[[
        for k = 1, 4 do
            local currentDeployer = deployers[k]
            itemVault.pullItems(peripheral.getName(currentDeployer), 1)
        end
        ]]
    end

    -- 打印当前循环次数（可删除）
    print("Loop iteration: " .. i)
    -- =====================
        sleep(2)
    -- 循环间隔
end

-- 这东西不会自动重置
--[[
Interface1.setAnalogOutput("east", 0)
Interface2.setAnalogOutput("east", 0)
Interface3.setAnalogOutput("east", 0)
Interface4.setAnalogOutput("east", 0)
]]
InterfaceCtrl.setAnalogOutput("east", 0)
-- 循环结束提示
print("Loop completed! Total iterations executed: " .. loopCount)