-- 定义输入输出容器
local chestSand = peripheral.wrap("minecraft:chest_1199")
local chestBlowing = peripheral.wrap("minecraft:chest_1200")
local chestQuartz = peripheral.wrap("minecraft:chest_1201")
local chestOutput = peripheral.wrap("minecraft:chest_1202")

while true do
    -- 从ChestSand将物品输入至ChestBlowing的每个槽位
    for slot = 1, 54 do
        if chestSand and chestBlowing then
            local transferred = chestSand.pushItems(peripheral.getName(chestBlowing), slot, 64)
            --[[
            if not transferred or transferred == 0 then
                sleep(10)  -- 输送失败，立即休眠10秒
                break  -- 跳出当前循环
            end
            ]]
        else
            sleep(10)  -- 容器不存在，立即休眠10秒
            break
        end
    end
    
    -- 从ChestQuartz将物品输入至ChestOutput的每个槽位
    for slot = 1, 54 do
        if chestQuartz and chestOutput then
            local transferred = chestQuartz.pushItems(peripheral.getName(chestOutput), slot, 64)
            --[[
            if not transferred or transferred == 0 then
                sleep(10)  -- 输送失败，立即休眠10秒
                break  -- 跳出当前循环
            end
            ]]
        else
            sleep(10)  -- 容器不存在，立即休眠10秒
            break
        end
    end
    
    -- 如果两个循环都成功完成，则休眠5秒
    sleep(5)
end