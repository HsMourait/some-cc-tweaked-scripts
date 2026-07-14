---@diagnostic disable: undefined-global

-- ===================== 返回按外设名称排序的对象数组 =====================
local function wrapList(peripheralType)
    local sorted = {}
    peripheral.find(peripheralType, function(name, obj)
        table.insert(sorted, {name = name, obj = obj})
        return true
    end)
    table.sort(sorted, function(a, b) return a.name < b.name end)
    local result = {}
    for i, entry in ipairs(sorted) do
        result[i] = entry.obj
    end
    return result
end

-- ===================== 获取容器的空槽位数量 =====================
-- 参数：容器对象（必须支持 size() 和 list() 方法）
-- 返回值：空槽位数量（整数）
local function getEmptySlotCount(container)
    if not container or not container.size or not container.list then
        error("Invalid container object")
        -- 无效的容器对象
    end
    local total = container.size()               -- 总槽位数
    local items = container.list()               -- 非空槽位表（键=槽位号）
    local occupied = 0
    for _ in pairs(items) do occupied = occupied + 1 end
    return total - occupied
end

-- ===================== 根据外设容器表和总需求组数计算分配 =====================
-- 功能：给定所有外设对象列表和需要插入的总组数（每组占一个槽位），
--       返回一个分配表，表示每个 vault 应该插入多少组。
-- 参数：
--   vaults:      table - wrapList 返回的外设对象数组，按名称排序。
--   totalGroups: number - 需要插入的总组数
--   buffer:      number - 为每个Vault预留的缓冲空槽位数量
-- 返回值：
--   table|nil - 分配表 allocation，allocation[i] 表示第 i 个 vault 应插入的组数；
--               如果所有 vault 的空槽总和小于 totalGroups，则返回 nil。
-- 分配策略：顺序填充（从第一个 vault 开始，依次填满，直到满足 totalGroups）。
--           未被分配的 vault 对应值为 0。
-- 依赖函数：getEmptySlotCount
-- ========================================================================================
local function allocateGroups(vaults, totalGroups, buffer)
    buffer = buffer or 9  -- 默认预留9个槽位
    local emptySlots = {}
    local totalAvailable = 0

    for i, vault in ipairs(vaults) do
        local empty = getEmptySlotCount(vault)
        local available = math.max(0, empty - buffer)  -- 可用空槽数，不能为负
        emptySlots[i] = available
        totalAvailable = totalAvailable + available
    end

    -- 总量不足
    if totalAvailable < totalGroups then
        return nil
    end

    -- 顺序分配
    local allocation = {}
    local remaining = totalGroups
    for i, available in ipairs(emptySlots) do
        if remaining <= 0 then
            allocation[i] = 0
        else
            local insert = math.min(remaining, available)
            allocation[i] = insert
            remaining = remaining - insert
        end
    end
    return allocation
end

-- ===================== 合成指定次数并推送 =====================
-- 功能：执行 batch 次合成，并将产物（位于槽位2~1+batch）依次推送到
--       由 allocation 指定的 Vault，按顺序使用，每推送一组减少对应 Vault 的计数。
-- 参数：
--   table: table - 所有 vault 的对象列表
--   batch: number - 本次合成的次数，产物将占据槽位2到1+batch。
--   allocation: table - 每个 Vault 剩余需要插入的组数数组，与全局 vaults 列表索引对应。
--   startIndex: number - 开始使用的 Vault 索引（从 1 开始）。
-- 返回值：
--   number - 处理完本次 batch 后，下一个要使用的 Vault 索引。
-- 注意：
--   - 假设全局变量 vaults 存在，且与 allocation 索引一致。
--   - 函数会修改 allocation 表，扣除已推送的组数。
--   - 当当前 Vault 的剩余组数用尽时，自动切换到下一个 Vault。
--   - 如果所有 Vault 的剩余组数都用尽但仍有物品未推送，则抛出错误。
--   - 推送失败（返回0）视为异常（目标可能被其他进程占用），此时将当前 Vault 标记为不可用并切换。
-- ===========================================================================
local function pullCraftTake(vaultTable, batch, allocation, startIndex)
    -- 执行合成
    turtle.craft(batch)

    local vaultIndex = startIndex
    for slot = 2, 1 + batch do
        -- 寻找下一个还有剩余组数的 Vault
        while vaultIndex <= #allocation and allocation[vaultIndex] <= 0 do
            vaultIndex = vaultIndex + 1
        end

        if vaultIndex > #allocation then
            error ("Error: No available Vault to receive items in slot" .. slot .. "")
            -- 错误：没有可用的 Vault 来接收槽位 slot 的物品
        end

        -- 推送一组物品（64个）到目标 Vault 的第一个空槽
        local actual = vaultTable[vaultIndex].pullItems("turtle_47", slot, 64)
        if actual == 0 then
            break
        else
            -- 推送成功，减少该 Vault 的剩余组数
            allocation[vaultIndex] = allocation[vaultIndex] - 1
            -- 注意：如果该 Vault 剩余组数变为 0，下次循环会自动跳过
        end
    end
    return vaultIndex
end
-- ===================== 主程序 =====================
-- 0. 获取自身
local turtleName = "turtle_47"

-- 1. 获取所有 itemVaults
local vaults = wrapList("create:item_vault")
if #vaults == 0 then
    print("No itemVaults found, the program exits")
    -- 未找到任何 itemVault，程序退出
    return
end

-- 2. 显示每个 vault 的空槽位数量
print("Found " .. #vaults .. " itemVaults:")
-- 找到 #vaults 个 itemVault：
for i, vault in ipairs(vaults) do
    local empty = getEmptySlotCount(vault)
    local name = peripheral.getName(vault) or "Unknown name"
    print(string.format("[%d] %s Empty slots: %d", i, name, empty))
    -- [序号] 名称 空槽位: 数量
end

-- 3. 用户选择操作模式
print("\nPlease select an operation:")
-- 请选择操作：
print("1. Auto - insert (execute insertion for all vaults)")
-- 1. 自动插入（对所有 vault 执行插入）
-- print("2. Insert into a specific vault")
-- 2. 指定某个 vault 插入
local choice = tonumber(read())
if not choice or (choice ~= 1) then
    print("Invalid choice, the program exits")
    -- 无效选择，程序退出
    return
end

-- 4. 根据选择确定目标 vault 列表
local targetVaults = {}
if choice == 1 then
    targetVaults = vaults   -- 所有 vault
    print("Selected: Auto - insert into all vaults")
end

-- 5. 输入数量（组）
print("Please enter the quantity (in groups) to insert:")
-- 请输入要插入的数量（组）：
local amount = tonumber(read())
if not amount or amount < 1 then
    print("Invalid quantity. The program will exit.")
    -- 无效数量，程序退出
    return
end
-- 缓冲槽位数量
print("Please enter buffer slots per vault (default: 9):")
local buffer = tonumber(read()) or 9

-- 6. 等待用户按 Enter 确认运行
print("\n===== Input completed =====")
-- ===== 输入完成 ====="
print("Operation mode: " .. (choice == 1 and "Auto - insert" or "Specify insert"))
-- 操作模式：自动插入（如果choice为1）或指定插入（如果choice不为1）
print("Quantity (in groups): " .. amount)
-- 数量（组）：amount
if choice == 2 then
    print("Target vault serial number: " .. idx)
    -- 目标vault序号：idx
else
    print("Number of target vaults: " .. #targetVaults)
    -- 目标vault数量：#targetVaults
end
print("\nEnsure there are enough items in the black_hole_talisman.")
print("\nPress Enter to start execution...")
-- 按Enter键开始执行...
read()  -- 等待用户按下回车


-- 7.最后一次校验

-- 检查槽位1是否存在且为黑洞护符
local item = turtle.getItemDetail(1)  -- 先获取基本信息
-- 检查是否为空
if not item then
    print("\nSlot 1 is empty.")
    return
end
-- 检查是否为黑洞
if item.name ~= "botania:black_hole_talisman" then
    print("\nNo black_hole_talisman detected in slot 1.")
    return
end

-- 8.===================== 推送循环 =====================
if choice == 1 then
    local allocation = allocateGroups(vaults, amount, buffer)
    if not allocation then
        print("Insufficient available empty slots")
        -- 可用空槽不足
        return
    end

    local remainingGroups = amount
    local vaultIndex = 1

    while remainingGroups > 0 do
        local batch = math.min(remainingGroups, 15)
        vaultIndex = pullCraftTake(vaults, batch, allocation, vaultIndex)
        remainingGroups = remainingGroups - batch
    end

    print("All items have been pushed successfully!")
    -- 所有物品推送完成！
end
