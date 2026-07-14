---@diagnostic disable: undefined-global

-- 定义输入输出容器
local Deployer1 = peripheral.wrap("create:deployer_11")
local Deployer2 = peripheral.wrap("create:deployer_12")
local Deployer3 = peripheral.wrap("create:deployer_13")

local Barrel = peripheral.wrap("minecraft:barrel_1")
-- 存储干草叉

local Computer = peripheral.wrap("computer_13")

--local slot = 1
while (true) do
    if redstone.getInput("front") then
        sleep(10)
        goto restart_slot1
    end

    local ITEMFORK = "farm_and_charm:pitchfork" -- 干草叉的ID Item.of('farm_and_charm:pitchfork')

    -- ::restart_slot2::
    for slot = 1, 27 do
        if Deployer1.getItemDetail(1) == nil then
            Barrel.pushItems(peripheral.getName(Deployer1), slot, 1, 1)
        end
    end

    for slot = 1, 27 do
        if Deployer2.getItemDetail(1) == nil then
            Barrel.pushItems(peripheral.getName(Deployer2), slot, 1, 1)
        end
    end

    for slot = 1, 27 do
        if Deployer3.getItemDetail(1) == nil then
            Barrel.pushItems(peripheral.getName(Deployer3), slot, 1, 1)
        end
    end

    sleep(3)
    ::restart_slot1::
end