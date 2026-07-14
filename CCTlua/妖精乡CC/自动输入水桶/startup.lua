-- 库存运输自动化脚本
-- 只是为了让置物台的水桶自动进入保险库而已
---@diagnostic disable: undefined-global
local depot = peripheral.wrap("create:depot_142")
local vault = peripheral.wrap("create:item_vault_73")

while true do
sleep(2)
::restart_slot1::

if not depot or not vault then
    sleep(10)
    goto restart_slot1
end

if depot.getItemDetail(1) then
    depot.pushItems(peripheral.getName(vault), 1)
end

end