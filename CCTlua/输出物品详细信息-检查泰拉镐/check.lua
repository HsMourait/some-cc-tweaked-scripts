---@diagnostic disable: undefined-global
-- ===================== Recursive function: Print all key-value pairs in table =====================
local function printAllTableData(tbl, prefix, printLines)
    prefix = prefix or ""  -- Prefix for indentation (nested level)
    for key, value in pairs(tbl) do
        local keyStr = prefix .. tostring(key) .. ": "
        if type(value) == "table" then
            -- If value is table, add title and recurse
            table.insert(printLines, keyStr .. "{")
            printAllTableData(value, prefix .. "  ", printLines)  -- Indent +2 for nested table
            table.insert(printLines, prefix .. "}")
        else
            -- If value is basic type (string/number/boolean/nil), print directly
            table.insert(printLines, keyStr .. tostring(value))
        end
    end
end

-- ===================== Paged print ALL item details in container =====================
local function printPagedAllItemDetails(container)
    -- 1. Validate container
    if not container or not container.list then
        print("Error: Invalid container peripheral!")
        return
    end

    -- 2. Get all slots with items
    local itemSlots = container.list() or {}
    if next(itemSlots) == nil then
        print("No items in container!")
        return
    end

    -- 3. Build all print lines (all item fields)
    local printLines = {}
    for slot in pairs(itemSlots) do
        local item = container.getItemDetail(slot, true)
        if item then
            -- Slot header
            table.insert(printLines, "=====================================")
            table.insert(printLines, "Slot " .. slot .. " - All Item Details:")
            table.insert(printLines, "-------------------------------------")
            -- Recursively get ALL fields of item table
            printAllTableData(item, "  ", printLines)
            -- Empty line separator between slots
            table.insert(printLines, "")
        end
    end

    -- 4. Paged print (Space = next page, Q = quit)
    textutils.pagedPrint(table.concat(printLines, "\n"))
end

-- ===================== Usage Example =====================
-- Replace "create:depot_37" with your actual container address (e.g. "right", "top")
local Container = peripheral.wrap("create:depot_38")
printPagedAllItemDetails(Container)