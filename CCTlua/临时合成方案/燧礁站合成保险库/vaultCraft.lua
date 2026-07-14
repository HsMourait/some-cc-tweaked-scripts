---@diagnostic disable: undefined-global

local Valut = peripheral.find("create:item_vault")
local turtleName = "turtle_84"

-- ===================== 获取容器中特定物品前两个槽位（需满足数量要求） =====================
local function getSpeValidSlots(container, itemName, amount)
    local itemList = container.list() or {}
    local slots = {}
    for slot, item in pairs(itemList) do
        if item.name == itemName and item.count == amount then
            table.insert(slots, slot)
            if #slots >= 2 then
                break
            end
        end
    end
    return slots[1], slots[2]  -- 返回两个值，没找到的为 nil
end

while true do
    local iSlot1, iSlot2 = getSpeValidSlots(Valut, "create:iron_sheet", 64)
    local bSlot1 = getSpeValidSlots(Valut, "minecraft:barrel", 64)
    if not (iSlot1 and iSlot2 and bSlot1) then
        break
    end

    Valut.pushItems(turtleName, iSlot1, 64, 1)
    Valut.pushItems(turtleName, iSlot2, 64, 9)
    Valut.pushItems(turtleName, bSlot1, 64, 5)
    turtle.craft(64)
    Valut.pullItems(turtleName, 1, 64)
    sleep(0.05)
end