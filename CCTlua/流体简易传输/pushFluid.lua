---@diagnostic disable: undefined-global

-- 被用于熔岩池大量输出熔岩，所以规定一个固定的源容器
local SourceTankName = "basin_1"
-- 封装源容器对象（用于调用pushFluid）
local SourceTank = peripheral.wrap(SourceTankName)

local TargetTankName = "fluidTank_4" -- 目标
local TargetTank = peripheral.wrap(TargetTankName)
-- ===================== 输入数量返回数字 =====================
local function getValidNumber()
    print("Please enter a positive integer less than 1024000:")
    while true do
        -- 等待用户输入
        local userInput = read()
        -- 转换为数字
        local num = tonumber(userInput)

        -- 校验条件：是数字 + 是整数 + 大于0 + 小于等于1024000
        if num and math.floor(num) == num and num > 0 and num <= 1024000 then
            return num  -- 输入有效，返回数字
        else
            -- 输入无效
            print("Invalid input! Please enter a positive integer less than 1024:")
        end
    end
end

-- ===================== 传输指定数量流体 =====================
local function tranFluid(Source, Target, amount)
    return Target.pullFluid(Source, amount)
end


local Count = getValidNumber()

local transferredAmount = tranFluid(SourceTankName, TargetTank, Count)
print(transferredAmount)