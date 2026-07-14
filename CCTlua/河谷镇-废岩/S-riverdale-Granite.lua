---@diagnostic disable: undefined-global

-- 定义输入输出容器
local chestCobblestone = peripheral.wrap("minecraft:chest_1203")
local chestQuartz = peripheral.wrap("minecraft:chest_1204")
local chestDiorite = peripheral.wrap("minecraft:chest_1205")
local chestGranite = peripheral.wrap("minecraft:chest_1206")

local GraniteVault = peripheral.wrap("create:item_vault_41")

local turtle_16 = peripheral.wrap("turtle_16") --闪长岩合成机
local turtle_17 = peripheral.wrap("turtle_17") --花岗岩合成机

--local slot = 1
while (true) do
    ::restart_slot1::
    if redstone.getInput("back") then
        sleep(10)
        goto restart_slot1
    end
--[[
    if chestCobblestone and chestDiorite and chestQuartz and chestGranite
    and turtle_16
    and turtle_17
    then
    else
        sleep(10)
    end
    --检查容器是否存在，若不存在则休眠
    ]]

    local ITEM_DIORITE = "minecraft:diorite" -- 闪长岩的ID
    local ITEM_QUARTZ = "minecraft:nether_quartz"    -- 下界石英的ID
    --[[
    if
        (turtle.getItemDetail(1) ~= nil and turtle.getItemDetail(1).count == 64 and turtle.getItemDetail(1).name == ITEM_DIORITE)
        and
        (turtle.getItemDetail(2) ~= nil and turtle.getItemDetail(2).count == 64 and turtle.getItemDetail(2).name == ITEM_QUARTZ)
    then
    -- 所有条件满足，跳转到restart_slot3标签
        goto restart_slot3
    end
    ]]

    ::restart_slot2::
    -- 获取配方
    for slot = 1, 54 do
        --if turtle.getItemDetail(1) == nil then
            local transferred = chestDiorite.pushItems("turtle_17", slot, 64, 1)
            if transferred and transferred == 64 then -- 传输成功
                break
            end
        --else
            --sleep(10)
            --goto restart_slot2
        --end
    end

    for slot = 1, 54 do
        --if turtle.getItemDetail(2) == nil then
            local transferred = chestQuartz.pushItems("turtle_17", slot, 64, 2)
            if transferred and transferred == 64 then -- 传输成功
                break
            end
        --else
            --sleep(10)
            --goto restart_slot2
        --end
    end

    ::restart_slot3::
    if turtle.getItemDetail(1)~=nil and turtle.getItemDetail(2)~=nil then
        turtle.select(9)
        turtle.craft(64)
        if GraniteVault then
            GraniteVault.pullItems("turtle_17", 9, 64)
        end
    else
        sleep(10)
        goto restart_slot2
    end
end