---@diagnostic disable: undefined-global
local destroy = peripheral.find("create:item_vault")
turtle.select(1)

-- ===================== 输入提取数量（组） =====================
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

local count = getValidNumber()
local count2 = 0

while count2 < count do
    turtle.craft(15)
    for i=2,16 do
        local stack = destroy.pullItems("turtle_100", i, 64)
        if stack == nil or stack ~= 64 then
            break
        else
            count2 = count2 + 1
            if count2 >= count then
                break
            end
        end
    end
end
