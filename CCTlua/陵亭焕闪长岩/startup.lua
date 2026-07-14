---@diagnostic disable: undefined-global

local quartzVault = peripheral.wrap("create:item_vault_185")
local cobblestone = peripheral.wrap("minecraft:chest_1303")
local dioriteVault = peripheral.wrap("create:item_vault_186")
local turtleName = "turtle_83"
-- 红石方向（顶部）
local redstoneSide = "top"

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
       -- 红石检查：如果顶部为高电平，休眠5秒后重新检查
    while redstone.getInput(redstoneSide) do
        sleep(5)
    end

    :: Mark1 ::
    local qSlot1, qSlot2 = getSpeValidSlots(quartzVault, "minecraft:quartz", 64)
    local cSlot1, cSlot2 = getSpeValidSlots(cobblestone, "minecraft:cobblestone", 64)
    if not (qSlot1 and qSlot2 and cSlot1 and cSlot2) then
        sleep(5)
        goto Mark1
    end

    quartzVault.pushItems(turtleName, qSlot1, 64, 2)
    quartzVault.pushItems(turtleName, qSlot2, 64, 5)
    cobblestone.pushItems(turtleName, cSlot1, 64, 1)
    cobblestone.pushItems(turtleName, cSlot2, 64, 6)
    turtle.craft(64)
    dioriteVault.pullItems(turtleName, 1, 64)
    dioriteVault.pullItems(turtleName, 2, 64)
    sleep(0.05)
end