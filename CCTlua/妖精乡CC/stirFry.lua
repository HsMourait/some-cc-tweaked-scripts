---@diagnostic disable: undefined-global
local Interface1 = peripheral.wrap("redstoneIntegrator_55")
local Interface2 = peripheral.wrap("redstoneIntegrator_57")
local Interface3 = peripheral.wrap("redstoneIntegrator_59")
local Interface4 = peripheral.wrap("redstoneIntegrator_62")
local Interface5 = peripheral.wrap("redstoneIntegrator_63")

local InterfaceCtrl = peripheral.wrap("redstoneIntegrator_54")

local deployer1 = peripheral.wrap("create:deployer_7")
local deployer2 = peripheral.wrap("create:deployer_9")
local deployer3 = peripheral.wrap("create:deployer_11")
local deployer4 = peripheral.wrap("create:deployer_13")
local deployer5 = peripheral.wrap("create:deployer_15")

local iPspatula1 = peripheral.wrap("create:depot_146")
local iPspatula2 = peripheral.wrap("create:depot_147")
local iPspatula3 = peripheral.wrap("create:depot_148")
local iPspatula4 = peripheral.wrap("create:depot_149")
local iPspatula5 = peripheral.wrap("create:depot_150")

local itemPlatformFat = peripheral.wrap("create:depot_151")
local itemPlatformChilli = peripheral.wrap("create:depot_143")
local itemPlatformCutlet = peripheral.wrap("create:depot_144")
local itemPlatformRice = peripheral.wrap("create:depot_145")
-- 脂肪
-- 辣椒
-- 猪排
-- 米饭

local itemVault = peripheral.wrap("create:item_vault_72")

-- ===================== 索引表定义 =====================
-- 1. 红石接口索引表：索引1-5对应Interface1-5
local redstoneInterfaces = {
    [1] = Interface1,
    [2] = Interface2,
    [3] = Interface3,
    [4] = Interface4,
    [5] = Interface5
}

-- 2. Deployer（机械手）索引表：索引1-5对应deployer1-5
local deployers = {
    [1] = deployer1,
    [2] = deployer2,
    [3] = deployer3,
    [4] = deployer4,
    [5] = deployer5
}

-- 3. iPspatula（锅铲）索引表：索引1-5对应iPspatula1-5
local iPspatulas = {
    [1] = iPspatula1,
    [2] = iPspatula2,
    [3] = iPspatula3,
    [4] = iPspatula4,
    [5] = iPspatula5
}

-- 4. 置物台索引表：索引1-4依次对应脂肪、辣椒、猪排、米饭的置物台
local itemPlatforms = {
    [1] = itemPlatformFat,   -- 1 = 脂肪置物台
    [2] = itemPlatformChilli,     -- 2 = 辣椒置物台
    [3] = itemPlatformCutlet,   -- 3 = 猪排置物台
    [4] = itemPlatformRice      -- 4 = 米饭置物台
}






-- 激活红石接口
Interface1.setAnalogOutput("west", 15)
Interface2.setAnalogOutput("west", 15)
Interface3.setAnalogOutput("west", 15)
Interface4.setAnalogOutput("west", 15)
Interface5.setAnalogOutput("west", 15)
InterfaceCtrl.setAnalogOutput("west", 15)



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
    sleep(1)
    -- 从置物台取油脂
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        -- 1号置物台（油脂）固定为itemPlatformFat
        local currentDeployer = deployers[j]
        ::Marker1::
        -- 检查稻米置物台是否有物品
        if not itemPlatformFat.getItemDetail(1) then
            goto Marker1
        end

        -- 将稻米置物台物品推送至当前机械手
        itemPlatformFat.pushItems(peripheral.getName(currentDeployer), 1, 1)
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
    Interface1.setAnalogOutput("west", 0)
    Interface2.setAnalogOutput("west", 0)
    Interface3.setAnalogOutput("west", 0)
    Interface4.setAnalogOutput("west", 0)
    Interface5.setAnalogOutput("west", 0)
    sleep(0.4)
    Interface1.setAnalogOutput("west", 15)
    Interface2.setAnalogOutput("west", 15)
    Interface3.setAnalogOutput("west", 15)
    Interface4.setAnalogOutput("west", 15)
    Interface5.setAnalogOutput("west", 15)

    -- =====================
    sleep(1)
    -- 从置物台取青辣椒
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        -- 2号置物台（青辣椒）固定为itemPlatformChilli
        local currentDeployer = deployers[j]
        ::Marker3::
        -- 检查青辣椒置物台是否有物品
        if not itemPlatformChilli.getItemDetail(1) then
            goto Marker3
        end

        -- 将青辣椒置物台物品推送至当前机械手
        itemPlatformChilli.pushItems(peripheral.getName(currentDeployer), 1, 3)
    end

    -- 激活三次机械手
    for j = 1, 3 do
        Interface1.setAnalogOutput("west", 0)
        Interface2.setAnalogOutput("west", 0)
        Interface3.setAnalogOutput("west", 0)
        Interface4.setAnalogOutput("west", 0)
        Interface5.setAnalogOutput("west", 0)
        sleep(0.4)
        Interface1.setAnalogOutput("west", 15)
        Interface2.setAnalogOutput("west", 15)
        Interface3.setAnalogOutput("west", 15)
        Interface4.setAnalogOutput("west", 15)
        Interface5.setAnalogOutput("west", 15)
        sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取猪排
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        -- 3号置物台（猪排）固定为itemPlatformCutlet
        local currentDeployer = deployers[j]
        ::Marker3::
        -- 检查猪排置物台是否有物品
        if not itemPlatformCutlet.getItemDetail(1) then
            goto Marker3
        end

        -- 将猪排置物台物品推送至当前机械手
        itemPlatformCutlet.pushItems(peripheral.getName(currentDeployer), 1, 2)
    end

    -- 激活两次机械手
    for j = 1, 2 do
        Interface1.setAnalogOutput("west", 0)
        Interface2.setAnalogOutput("west", 0)
        Interface3.setAnalogOutput("west", 0)
        Interface4.setAnalogOutput("west", 0)
        Interface5.setAnalogOutput("west", 0)
        sleep(0.4)
        Interface1.setAnalogOutput("west", 15)
        Interface2.setAnalogOutput("west", 15)
        Interface3.setAnalogOutput("west", 15)
        Interface4.setAnalogOutput("west", 15)
        Interface5.setAnalogOutput("west", 15)
        sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取锅铲
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        local currentDeployer = deployers[j]
        -- 获取当前循环对应的锅铲
        local currentSpatula = iPspatulas[j]
        ::Marker5::
        -- 检查置物台是否有物品
        if not currentSpatula.getItemDetail(1) then
            goto Marker5
        end

        currentSpatula.pushItems(peripheral.getName(currentDeployer), 1, 1)
    end

    -- 激活三次机械手
        for j = 1, 3 do
        Interface1.setAnalogOutput("west", 0)
        Interface2.setAnalogOutput("west", 0)
        Interface3.setAnalogOutput("west", 0)
        Interface4.setAnalogOutput("west", 0)
        Interface5.setAnalogOutput("west", 0)
        sleep(0.4)
        Interface1.setAnalogOutput("west", 15)
        Interface2.setAnalogOutput("west", 15)
        Interface3.setAnalogOutput("west", 15)
        Interface4.setAnalogOutput("west", 15)
        Interface5.setAnalogOutput("west", 15)
        sleep(1)
    end

    -- 将机械手的锅铲放回置物台
    for j = 1, 5 do
        -- 获取当前循环对应的机械手与置物台
        local currentDeployer = deployers[j]
        local currentSpatula = iPspatulas[j]

        currentSpatula.pullItems(peripheral.getName(currentDeployer), 1)
        -- sleep(1)
    end

    -- =====================
    sleep(1)
    -- 从置物台取米饭
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        -- 4号置物台（米饭）固定为itemPlatformRice
        local currentDeployer = deployers[j]
        ::Marker7::
        -- 检查米饭置物台是否有物品
        if not itemPlatformRice.getItemDetail(1) then
            goto Marker7
        end

        -- 将米饭置物台物品推送至当前机械手
        itemPlatformRice.pushItems(peripheral.getName(currentDeployer), 1, 1)
    end

    -- 等待烹饪
    sleep(10)

    -- 激活一次机械手
    Interface1.setAnalogOutput("west", 0)
    Interface2.setAnalogOutput("west", 0)
    Interface3.setAnalogOutput("west", 0)
    Interface4.setAnalogOutput("west", 0)
    Interface5.setAnalogOutput("west", 0)
    sleep(0.4)
    Interface1.setAnalogOutput("west", 15)
    Interface2.setAnalogOutput("west", 15)
    Interface3.setAnalogOutput("west", 15)
    Interface4.setAnalogOutput("west", 15)
    Interface5.setAnalogOutput("west", 15)

    -- 将机械手的青椒肉丝放回保险库
    for j = 1, 5 do
        -- 获取当前循环对应的机械手
        -- 保险库固定为itemVault
        local currentDeployer = deployers[j]
        -- 将机械手青椒肉丝推送回保险库
        itemVault.pullItems(peripheral.getName(currentDeployer), 1)
    end

    -- 打印当前循环次数
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