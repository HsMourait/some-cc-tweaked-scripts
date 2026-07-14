-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local carrot = peripheral.wrap("create:depot_0")
local potato = peripheral.wrap("create:depot_1")
local tomato = peripheral.wrap("create:depot_2")
local bowl = peripheral.wrap("create:depot_3")

local crafting_bowl = peripheral.wrap("farm_and_charm:crafting_bowl_3")
--local salad = peripheral.wrap("minecraft:chest_0")


while (true) do
os.pullEvent("redstone")
-- 检查输出端是否有物品，若都没有则休眠
if carrot and potato and tomato and bowl
   and not carrot.getItemDetail(1)
   and not potato.getItemDetail(1)
   and not tomato.getItemDetail(1) 
   and not bowl.getItemDetail(1) then
    sleep(30)
   end

local transferred = carrot.pushItems(peripheral.getName(crafting_bowl), 1)
local transferred = potato.pushItems(peripheral.getName(crafting_bowl), 1)
local transferred = tomato.pushItems(peripheral.getName(crafting_bowl), 1)
local transferred = bowl.pushItems(peripheral.getName(crafting_bowl), 1)

--sleep(10)
--local transferred = crafting_bowl.pushItems(peripheral.getName(salad), 1)

end