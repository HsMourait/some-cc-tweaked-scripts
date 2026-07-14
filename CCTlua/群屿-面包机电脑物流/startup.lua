-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local oBread = peripheral.wrap("create:depot_68")
local oOil = peripheral.wrap("create:depot_69")
local oWheat = peripheral.wrap("create:depot_70")
local oBeet = peripheral.wrap("create:depot_71")
local oMilk = peripheral.wrap("create:depot_72")
local iSugar = peripheral.wrap("minecraft:barrel_13")
local iBread = peripheral.wrap("minecraft:barrel_14")

local cSugar = peripheral.wrap("farmersdelight:basket_0")
local cBread = peripheral.wrap("minecraft:chest_1095")


while (true) do
-- 检查输出端是否有物品，若都没有则休眠
if oWheat and oBeet
   and not oWheat.getItemDetail(1)
   and not oBeet.getItemDetail(1) then
    sleep(10)
end

-- 计算容器的空槽位数量
local iBreadEmptySlotCount = 0
local cBreadEmptySlotCount = 0
local cSugarEmptySlotCount = 0

for slot = 1, 27 do
    -- 检查当前槽位是否为空（getItemDetail返回nil表示空槽）
    if not iBread.getItemDetail(slot) then
        iBreadEmptySlotCount = iBreadEmptySlotCount + 1
    end
end

for slot = 1, 54 do
    if not cBread.getItemDetail(slot) then
        cBreadEmptySlotCount = cBreadEmptySlotCount + 1
    end
end

for slot = 1, 27 do
    if not cSugar.getItemDetail(slot) then
        cSugarEmptySlotCount = cSugarEmptySlotCount + 1
    end
end



-- 将小麦运输至面包机
if oWheat and iBread then
    -- 检查源槽位是否有物品
    if oWheat.getItemDetail(1) and cBreadEmptySlotCount > 6 and iBreadEmptySlotCount > 3 then
        -- 传输物品（自动处理目标容器空间）
        local transferred = oWheat.pushItems(peripheral.getName(iBread), 1)
    end
end

-- 将甜菜运输至机巧箱合成糖
if oBeet and iSugar then
    -- 检查源槽位是否有物品
    if oBeet.getItemDetail(1) and cSugarEmptySlotCount > 3 then
        -- 传输物品（自动处理目标容器空间）
        local transferred = oBeet.pushItems(peripheral.getName(iSugar), 1)
    end
end

if cBreadEmptySlotCount < 3 and iBreadEmptySlotCount < 2 and cSugarEmptySlotCount < 2 then
    sleep(30)
end

end