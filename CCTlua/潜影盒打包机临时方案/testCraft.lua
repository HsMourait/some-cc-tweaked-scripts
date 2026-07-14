---@diagnostic disable: undefined-global
local tur =  peripheral.wrap("turtle_46")
-- local destroy = peripheral.wrap("create:item_vault_21")
local destroy = peripheral.find("create:item_vault")

local function getValidNumber()
    -- 请输入一个正整数
    print("Please enter a positive integer to determine the number of items to be packed in boxes:")

    while true do
        -- 等待用户输入
        local userInput = read()
        -- 转换为数字
        local num = tonumber(userInput)

        -- 校验条件：是数字 + 是整数 + 大于0
        if num and math.floor(num) == num and num > 0 then
            return num  -- 输入有效，返回数字
        else
            -- 输入无效，给出英文提示并重新等待
            print("Invalid input! Please enter a positive integer")
        end
    end
end

-- 2. 获取用户输入的有效数字
local loopCount = getValidNumber()
turtle.select(1)
sleep(1)

for j=1, loopCount do

    turtle.craft(15)
    for i=2,16 do
        destroy.pullItems("turtle_46", i, 64)
    end

    turtle.craft(12)
    for i=2,13 do
        destroy.pullItems("turtle_46", i, 64)
    end

end
