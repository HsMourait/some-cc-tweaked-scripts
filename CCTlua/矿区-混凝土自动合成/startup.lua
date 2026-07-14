-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local turtle_4 = peripheral.wrap("turtle_4")

local gravel = peripheral.wrap("create:depot_78")
local sand = peripheral.wrap("create:depot_79")
local dye = peripheral.wrap("create:depot_80")


while (true) do
-- 检查输出端是否有物品，若都没有则休眠
if gravel and sand and dye
   and not gravel.getItemDetail(1)
   and not sand.getItemDetail(1) 
   and not dye.getItemDetail(1) then
    sleep(30)
   end

::restart_slot1::

-- 获取配方
if gravel and turtle.getItemDetail(1) == nil then
        local transferred = gravel.pushItems("turtle_4", 1, 64, 1)
        sleep(0.2)
        if turtle.getItemDetail(1) == nil then
            sleep(10)
        end
end

if sand and turtle.getItemDetail(2) == nil then
        local transferred = sand.pushItems("turtle_4", 1, 64, 2)
        sleep(0.2)
        if turtle.getItemDetail(2) == nil then
            sleep(10)
        end
end

if gravel and turtle.getItemDetail(3) == nil then
        local transferred = gravel.pushItems("turtle_4", 1, 64, 3)
        sleep(0.2)
        if turtle.getItemDetail(3) == nil then
            sleep(10)
        end
end

if sand and turtle.getItemDetail(5) == nil then
        local transferred = sand.pushItems("turtle_4", 1, 64, 5)
        sleep(0.2)
        if turtle.getItemDetail(5) == nil then
            sleep(10)
        end
end

if gravel and turtle.getItemDetail(6) == nil then
        local transferred = gravel.pushItems("turtle_4", 1, 64, 6)
        sleep(0.2)
        if turtle.getItemDetail(6) == nil then
            sleep(10)
        end
end

if sand and turtle.getItemDetail(7) == nil then
        local transferred = sand.pushItems("turtle_4", 1, 64, 7)
        sleep(0.2)
        if turtle.getItemDetail(7) == nil then
            sleep(10)
        end
end

if gravel and turtle.getItemDetail(9) == nil then
        local transferred = gravel.pushItems("turtle_4", 1, 64, 9)
        sleep(0.2)
        if turtle.getItemDetail(9) == nil then
            sleep(10)
        end
end

if sand and turtle.getItemDetail(10) == nil then
        local transferred = sand.pushItems("turtle_4", 1, 64, 10)
        sleep(0.2)
        if turtle.getItemDetail(10) == nil then
            sleep(10)
        end
end

if dye and turtle.getItemDetail(11) == nil then
        local transferred = dye.pushItems("turtle_4", 1, 64, 11)
        if turtle.getItemDetail(11) == nil then
            goto restart_slot1
        end
end

    turtle.select(13)
    turtle.craft(64)
    sleep(0.2)
    
    turtle.drop()
    turtle.select(14)
    turtle.drop()
    turtle.select(15)
    turtle.drop()
    turtle.select(16)
    turtle.drop()
    turtle.select(1)
    turtle.drop()
    turtle.select(2)
    turtle.drop()
    turtle.select(3)
    turtle.drop()
    turtle.select(4)
    turtle.drop()

end