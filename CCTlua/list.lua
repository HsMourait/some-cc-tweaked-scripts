---@diagnostic disable: undefined-global

local depot = peripheral.find("create:depot")
for slot, item in pairs(depot.list()) do
 print(("%d x %s in slot %d"):format(item.count, item.name, slot))
end