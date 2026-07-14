---@diagnostic disable: undefined-global

-- 1. 获取 Weak Automata 外设（核心前提）
local weakAutomata = peripheral.find("weakAutomata")
if not weakAutomata then
    print("Error: Weak Automata upgrade not found!")
    return
end

-- 2. 燃料相关配置（可根据需求调整）
local MIN_FUEL = 100  -- 执行操作的最低燃料阈值
local FUEL_CHARGE_LIMIT = 5000  -- 充能的上限（避免充太满）

-- 3. 检查并补充燃料的函数（移除不存在的 getFuelMaxLevel）
local function checkAndChargeFuel()
    local currentFuel = weakAutomata.getFuelLevel()  -- 仅保留存在的 getFuelLevel

    print(string.format("Current fuel level: %d", currentFuel))  -- 仅显示当前燃料

    -- 如果燃料低于阈值，尝试充能
    if currentFuel < MIN_FUEL then
        print("Warning: Low fuel, attempting to charge with energy cell...")
        -- 调用 chargeTurtle 充能（可选传参数限制充能数量）
        turtle.select(4)
        local fuelGained, err = weakAutomata.chargeTurtle(FUEL_CHARGE_LIMIT - currentFuel)
        turtle.refuel(FUEL_CHARGE_LIMIT - currentFuel)

        if fuelGained then
            print(string.format("Charge successful! Fuel added: %d, Current fuel: %d", fuelGained, currentFuel + fuelGained))
            return true
        else
            print("Charge failed: " .. (err or "Unknown error"))
            print("Check: 1.Energy cell in inventory 2.Cell has power 3.Cell in correct slot")
            return false
        end
    else
        print("Fuel sufficient, no charging needed")
        return true
    end
end

-- 4. 主逻辑：检查燃料 → 执行方块交互
local function main()
    -- 先检查/补充燃料
    local fuelOk = checkAndChargeFuel()
    if not fuelOk then
        print("Abort operation: Low fuel and unable to charge")
        return
    end
    
    -- 燃料充足，执行 useOnBlock
    print("\nAttempting to interact with block ahead...")
    turtle.select(1)
    local success, err = weakAutomata.useOnBlock()
    
    if success then
        print("Block interaction successful!")
    else
        print("Block interaction failed: " .. (err or "Unknown error"))
        -- 常见失败原因提示
        if err and err:find("fuel") then
            print("Still low fuel? Increase MIN_FUEL threshold (single operation cost > current fuel)")
        end
    end
end

-- 运行主逻辑
main()