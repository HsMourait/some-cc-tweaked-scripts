---@diagnostic disable: undefined-global
-- ===================== 核心：递归扫描NBT，提取魔力相关数据 =====================
local function extractBotaniaManaData(nbtData, manaData, prefix)
    prefix = prefix or ""
    for key, value in pairs(nbtData) do
        local fullKey = prefix .. tostring(key)
        -- 匹配Botania魔力相关字段（覆盖常见命名）
        local manaKeys = {"mana", "storedMana", "maxMana", "level", "Botania:mana", "Mana", "StoredMana"}
        for _, mk in pairs(manaKeys) do
            if string.lower(tostring(key)) == string.lower(mk) then
                manaData[fullKey] = value
            end
        end
        -- 递归扫描嵌套子表
        if type(value) == "table" then
            extractBotaniaManaData(value, manaData, fullKey .. ".")
        end
    end
end

-- ===================== 分页打印物品+魔力数据 =====================
local function printBotaniaItemManaDetails(container)
    -- 1. 基础校验
    if not container or not container.list then
        print("Error: Invalid container peripheral!")
        return
    end
    local itemSlots = container.list() or {}
    if next(itemSlots) == nil then
        print("No items in container!")
        return
    end

    local printLines = {}
    for slot in pairs(itemSlots) do
        -- 关键：获取完整NBT（第二个参数必须为true）
        local item = container.getItemDetail(slot, true)
        if item then
            table.insert(printLines, "=====================================")
            table.insert(printLines, "Slot " .. slot .. " - Botania Mana Info:")
            table.insert(printLines, "-------------------------------------")
            -- 基础物品信息
            table.insert(printLines, "Item Name: " .. (item.name or "Unknown"))
            table.insert(printLines, "Display Name: " .. (item.displayName or "Unknown"))
            -- 提取魔力数据
            local manaData = {}
            if item.nbt then
                extractBotaniaManaData(item.nbt, manaData)
                -- 打印魔力数据
                if next(manaData) ~= nil then
                    table.insert(printLines, "Mana Related Data:")
                    for k, v in pairs(manaData) do
                        table.insert(printLines, "  - " .. k .. ": " .. tostring(v))
                    end
                else
                    table.insert(printLines, "Mana Related Data: No mana data found (item may be empty/uncharged)")
                end
            else
                table.insert(printLines, "Mana Related Data: No full NBT available!")
            end
            table.insert(printLines, "")
        end
    end

    -- 分页打印
    textutils.pagedPrint(table.concat(printLines, "\n"))
end

-- ===================== 调用示例 =====================
-- 替换为你的容器地址（如create:depot_37/right/top）
local Container = peripheral.wrap("create:depot_37")
printBotaniaItemManaDetails(Container)