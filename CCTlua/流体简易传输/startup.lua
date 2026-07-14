---@diagnostic disable: undefined-global

-- 被用于熔岩池大量输出熔岩，所以规定一个固定的源容器
local SourceTankName = "create:hose_pulley_6"
-- 封装源容器对象（用于调用pushFluid）
local SourceTank = peripheral.wrap(SourceTankName)

local TargetTankName = "fluidTank_47" -- 目标
local TargetTank = peripheral.wrap(TargetTankName)
-- ===================== 传输指定数量流体 =====================
local function tranFluid(Source, Target, amount)
    return Source.pushFluid(Target, amount, "lava")
end


while true do

    :: Mark1 ::
    if  redstone.getInput("top") then
        sleep(10)
        goto Mark1
    end

    local tankInfo = TargetTank.tanks()[1]
    local lavaAmount = tankInfo and tankInfo.amount or 0
    if lavaAmount >= 300000 then
        sleep(10)
        goto Mark1
    end

    for i = 1, 10 do
        local transferredAmount = tranFluid(SourceTank, TargetTankName, 360000)
        print(transferredAmount)
    end
    sleep(0.05)

end