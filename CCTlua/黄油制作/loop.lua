---@diagnostic disable: undefined-global
local Interface1 = peripheral.wrap("redstoneIntegrator_64")
local Interface2 = peripheral.wrap("redstoneIntegrator_65")
local Interface3 = peripheral.wrap("redstoneIntegrator_66")
local Interface4 = peripheral.wrap("redstoneIntegrator_67")

local Bowl1 = peripheral.wrap("farm_and_charm:crafting_bowl_0")
local Bowl2 = peripheral.wrap("farm_and_charm:crafting_bowl_1")
local Bowl3 = peripheral.wrap("farm_and_charm:crafting_bowl_2")
local Bowl4 = peripheral.wrap("farm_and_charm:crafting_bowl_3")

local Milk = peripheral.wrap("minecraft:chest_1236")

local Butter = peripheral.wrap("cluttered:retro_fridge_be_1")

-- ===================== 索引表定义 =====================
local Bowl = {
    [1] = Bowl1,
    [2] = Bowl2,
    [3] = Bowl3,
    [4] = Bowl4
}

-- ===================== 函数：获取容器中某一个有物品槽位 =====================
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

-- 1. 封装输入校验函数：确保输入是小于等于216的正整数
local function getValidNumber()
    -- 请输入一个小于等于216的整数
    print("Please enter a positive integer less than 216:")
    while true do
        -- 等待用户输入
        local userInput = read()
        -- 转换为数字
        local num = tonumber(userInput)
        
        -- 校验条件：是数字 + 是整数 + 大于0 + 小于217
        if num and math.floor(num) == num and num > 0 and num < 217 then
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
    for j = 1, 4 do
        -- 获取当前循环对应的碗
        local currentBowl = Bowl[j]
        -- 将奶推送至当前碗
        local nslot = getAnyValidSlot(Milk)
        Milk.pushItems(peripheral.getName(currentBowl), nslot, 1)
    end

    sleep(3)
        for j = 1, 4 do
        -- 获取当前循环对应的碗
        local currentBowl = Bowl[j]
        -- 将当前碗黄油推送至容器
        currentBowl.pushItems(peripheral.getName(Butter), 5, 4)
    end

    Interface1.setAnalogOutput("top", 15)
    Interface2.setAnalogOutput("top", 15)
    Interface3.setAnalogOutput("top", 15)
    Interface4.setAnalogOutput("top", 15)
    sleep(0.6)
    Interface1.setAnalogOutput("top", 0)
    Interface2.setAnalogOutput("top", 0)
    Interface3.setAnalogOutput("top", 0)
    Interface4.setAnalogOutput("top", 0)
    sleep(0.1)
    Interface1.setAnalogOutput("top", 15)
    Interface2.setAnalogOutput("top", 15)
    Interface3.setAnalogOutput("top", 15)
    Interface4.setAnalogOutput("top", 15)
    sleep(0.6)
    Interface1.setAnalogOutput("top", 0)
    Interface2.setAnalogOutput("top", 0)
    Interface3.setAnalogOutput("top", 0)
    Interface4.setAnalogOutput("top", 0)

    print("Loop iteration: " .. i)
end

-- 循环结束提示
print("Loop completed! Total iterations executed: " .. loopCount)