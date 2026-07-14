-- 库存运输自动化脚本
-- 功能：1. 运输depot_67到item_vault_16；2. 监控chest_1089并按需补充
---@diagnostic disable: undefined-global
local depot67 = peripheral.wrap("create:depot_67")
local vault16 = peripheral.wrap("create:item_vault_100")

while (true) do

if depot67 and depot66 
   and not depot67.getItemDetail(1) 
   and not depot66.getItemDetail(1) then
    sleep(10)
end

-- depot67是单槽位容器，直接操作第1槽位
if depot67 and vault16 then
    -- 检查源槽位是否有物品
    if depot67.getItemDetail(1) then
        -- 传输物品（自动处理目标容器空间）
        local transferred = depot67.pushItems(peripheral.getName(vault16), 1)
    end
end

-- 功能2：将create:depot_66的物品传输至minecraft:chest_1089（移除数量限制）
local depot66 = peripheral.wrap("create:depot_66")
local chest1089 = peripheral.wrap("minecraft:chest_1089")

-- depot66是单槽位容器，直接操作第1槽位
if depot66 and chest1089 then
    -- 检查源槽位是否有物品
    if depot66.getItemDetail(1) then
        -- 传输物品（自动处理目标容器空间）
        local transferred = depot66.pushItems(peripheral.getName(chest1089), 1)
    end
end
end