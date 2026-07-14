-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local turtle_3 = peripheral.wrap("turtle_3")

local boneMeal = peripheral.wrap("create:depot_74")
local dirt = peripheral.wrap("create:depot_75")
local bark = peripheral.wrap("create:depot_76")
local straw = peripheral.wrap("create:depot_77")

local cfertilizer = peripheral.wrap("minecraft:chest_1099")


while (true) do
     if redstone.getInput("left") then
        sleep(10)
        else
-- 检查输出端是否有物品，若都没有则休眠
if boneMeal and dirt and bark and straw
   and not boneMeal.getItemDetail(1)
   and not dirt.getItemDetail(1)
   and not bark.getItemDetail(1) 
   and not straw.getItemDetail(1) then
    sleep(30)
end

-- 计算容器的空槽位数量
local cfertilizerEmptySlotCount = 0

for slot = 1, 54 do
    if not cfertilizer.getItemDetail(slot) then
        cfertilizerEmptySlotCount = cfertilizerEmptySlotCount + 1
    end
end




-- 获取顺序为树皮-骨粉-树皮-草秆-骨粉-树皮-草秆-树皮-泥土
if bark and turtle.getItemDetail(1) == nil then
        local transferred = bark.pushItems("turtle_3", 1, 64, 1)
        sleep(0.2)
end

if boneMeal and turtle.getItemDetail(2) == nil then
        local transferred = boneMeal.pushItems("turtle_3", 1, 64, 2)
        sleep(0.2)
end

if bark and turtle.getItemDetail(3) == nil then
        local transferred = bark.pushItems("turtle_3", 1, 64, 3)
        sleep(0.2)
end

if straw and turtle.getItemDetail(5) == nil then
        local transferred = straw.pushItems("turtle_3", 1, 64, 5)
        sleep(0.2)
end

if boneMeal and turtle.getItemDetail(6) == nil then
        local transferred = boneMeal.pushItems("turtle_3", 1, 64, 6)
        sleep(0.2)
end

if bark and turtle.getItemDetail(7) == nil then
        local transferred = bark.pushItems("turtle_3", 1, 64, 7)
        sleep(0.2)
end

if straw and turtle.getItemDetail(9) == nil then
        local transferred = straw.pushItems("turtle_3", 1, 64, 9)
        sleep(0.2)
end

if bark and turtle.getItemDetail(10) == nil then
        local transferred = bark.pushItems("turtle_3", 1, 64, 10)
        sleep(0.2)
end

if dirt and turtle.getItemDetail(11) == nil then
        local transferred = dirt.pushItems("turtle_3", 1, 64, 11)
        sleep(0.2)
end




    turtle.select(13)
    turtle.craft(64)
    turtle.dropUp()

if not turtle.getItemDetail(11) == nil then
    sleep(10)
end

if cfertilizerEmptySlotCount < 3 then
    sleep(30)
end
end
end