-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local turtle_2 = peripheral.wrap("turtle_2")

local oBread = peripheral.wrap("create:depot_68")
local oOil = peripheral.wrap("create:depot_69")
local oWheat = peripheral.wrap("create:depot_70")
local oBeet = peripheral.wrap("create:depot_71")
local oMilk = peripheral.wrap("create:depot_72")
local iSugar = peripheral.wrap("minecraft:barrel_13")
local iBread = peripheral.wrap("minecraft:barrel_14")

local cSugar = peripheral.wrap("farmersdelight:basket_0")
local cBread = peripheral.wrap("minecraft:chest_1095")
local cSugarBread = peripheral.wrap("minecraft:chest_1096")


while (true) do
     if redstone.getInput("left") then
        sleep(10)
        else
-- 检查输出端是否有物品，若都没有则休眠
if oBread and oOil and oMilk
   and not oBread.getItemDetail(1)
   and not oOil.getItemDetail(1) 
   and not oMilk.getItemDetail(1) then
    sleep(30)
end

-- 计算容器的空槽位数量
local cSugarBreadEmptySlotCount = 0

for slot = 1, 54 do
    if not cSugarBread.getItemDetail(slot) then
        cSugarBreadEmptySlotCount = cSugarBreadEmptySlotCount + 1
    end
end




-- 获取牛奶
if oMilk and turtle.getItemDetail(1) == nil then
        local transferred = oMilk.pushItems("turtle_2", 1, 64, 1)
end

-- 获取糖
if turtle.getItemDetail(2) == nil then
turtle.select(2)
-- 循环尝试吸取物品，直到成功
while true do
    turtle.suckUp(64)
    if turtle.getItemDetail(2) then
        -- 有物品，退出循环，继续后续流程
        break
    else
        sleep(10)
    end
end
end

-- 获取油
if oOil and turtle.getItemDetail(3) == nil then
        local transferred = oOil.pushItems("turtle_2", 1, 64, 3)
end

-- 获取面包
if oBread then
    if turtle.getItemDetail(5) == nil then
        oBread.pushItems("turtle_2", 1, 64, 5)
        sleep(0.5)
    end
    if turtle.getItemDetail(6) == nil then
        oBread.pushItems("turtle_2", 1, 64, 6)
        sleep(0.5)
    end
    if turtle.getItemDetail(7) == nil then    
        oBread.pushItems("turtle_2", 1, 64, 7)
        sleep(0.5)
    end
end

    turtle.select(8)
    turtle.craft(64)
    turtle.drop()

if cSugarBreadEmptySlotCount < 3 then
    sleep(30)
end
end
end