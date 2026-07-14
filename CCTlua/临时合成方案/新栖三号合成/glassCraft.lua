---@diagnostic disable: undefined-global

local glassVault = peripheral.wrap("create:item_vault_188")
local greenDyeVault = peripheral.wrap("create:item_vault_189")
local turtleName = "turtle_85"

-- ===================== 获取容器中特定物品前数个槽位（需满足数量要求） =====================
local function getSpeValidSlots(container, itemName, amount, slotsCount)
    local itemList = container.list() or {}
    local slots = {}
    for slot, item in pairs(itemList) do
        if item.name == itemName and item.count == amount then
            table.insert(slots, slot)
            if #slots >= slotsCount then
                break
            end
        end
    end
    return table.unpack(slots)
end

while true do
    local gSlot1, gSlot2, gSlot3, gSlot4, gSlot5, gSlot6, gSlot7, gSlot8 = getSpeValidSlots(glassVault, "minecraft:glass", 64, 8)
    local dSlot1 = getSpeValidSlots(greenDyeVault, "minecraft:green_dye", 64, 1)
    if not (gSlot1 and gSlot2 and gSlot3 and gSlot4 and gSlot5 and gSlot6 and gSlot7 and gSlot8 and dSlot1) then
        break
    end

    glassVault.pushItems(turtleName, gSlot1, 64, 1)
    glassVault.pushItems(turtleName, gSlot2, 64, 2)
    glassVault.pushItems(turtleName, gSlot3, 64, 3)
    glassVault.pushItems(turtleName, gSlot4, 64, 5)
    glassVault.pushItems(turtleName, gSlot5, 64, 7)
    glassVault.pushItems(turtleName, gSlot6, 64, 9)
    glassVault.pushItems(turtleName, gSlot7, 64, 10)
    glassVault.pushItems(turtleName, gSlot8, 64, 11)

    greenDyeVault.pushItems(turtleName, dSlot1, 64, 6)
    turtle.craft(64)
    for slot = 1, 8 do
        glassVault.pullItems(turtleName, slot, 64)
    end
    sleep(0.05)
end