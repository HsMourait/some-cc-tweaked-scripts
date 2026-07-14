---@diagnostic disable: undefined-global

local outlet1Name = "minecraft:chest_1256"
local outlet2Name = "minecraft:chest_1257"
local outlet3Name = "minecraft:chest_1258"
local outlet4Name = "minecraft:chest_1259"
local outlet5Name = "minecraft:chest_1260"
local outlet6Name = "minecraft:chest_1261"
local outlet7Name = "minecraft:chest_1262"
local outlet8Name = "minecraft:chest_1263"
local outlet9Name = "minecraft:chest_1264"

local outlet1 = peripheral.wrap(outlet1Name)
local outlet2 = peripheral.wrap(outlet2Name)
local outlet3 = peripheral.wrap(outlet3Name)
local outlet4 = peripheral.wrap(outlet4Name)
local outlet5 = peripheral.wrap(outlet5Name)
local outlet6 = peripheral.wrap(outlet6Name)
local outlet7 = peripheral.wrap(outlet7Name)
local outlet8 = peripheral.wrap(outlet8Name)
local outlet9 = peripheral.wrap(outlet9Name)

local inlet1Name = "minecraft:hopper_111"
local inlet2Name = "minecraft:hopper_112"
local inlet3Name = "minecraft:hopper_113"
local inlet4Name = "minecraft:hopper_114"
local inlet5Name = "minecraft:hopper_115"
local inlet6Name = "minecraft:hopper_116"
local inlet7Name = "minecraft:hopper_117"
local inlet8Name = "minecraft:hopper_118"
local inlet9Name = "minecraft:hopper_119"

local inlet1 = peripheral.wrap(inlet1Name)
local inlet2 = peripheral.wrap(inlet2Name)
local inlet3 = peripheral.wrap(inlet3Name)
local inlet4 = peripheral.wrap(inlet4Name)
local inlet5 = peripheral.wrap(inlet5Name)
local inlet6 = peripheral.wrap(inlet6Name)
local inlet7 = peripheral.wrap(inlet7Name)
local inlet8 = peripheral.wrap(inlet8Name)
local inlet9 = peripheral.wrap(inlet9Name)


-- ===================================== 配置区 =====================================
-- 1. 设备映射表：出料口→入料口 一一对应
local DEVICE_MAP = {
    {outlet = outlet1, inlet = inlet1, outletName = outlet1Name, inletName = inlet1Name},
    {outlet = outlet2, inlet = inlet2, outletName = outlet2Name, inletName = inlet2Name},
    {outlet = outlet3, inlet = inlet3, outletName = outlet3Name, inletName = inlet3Name},
    {outlet = outlet4, inlet = inlet4, outletName = outlet4Name, inletName = inlet4Name},
    {outlet = outlet5, inlet = inlet5, outletName = outlet5Name, inletName = inlet5Name},
    {outlet = outlet6, inlet = inlet6, outletName = outlet6Name, inletName = inlet6Name},
    {outlet = outlet7, inlet = inlet7, outletName = outlet7Name, inletName = inlet7Name},
    {outlet = outlet8, inlet = inlet8, outletName = outlet8Name, inletName = inlet8Name},
    {outlet = outlet9, inlet = inlet9, outletName = outlet9Name, inletName = inlet9Name}
}

-- 2. 核心参数（按设备工作时间/红石配置调整）
local CONFIG = {
    loop_interval = 1,          -- 轮询态固定间隔
    stable_idle_time = 3,         -- 回置监听态间隔
    redstone_side = "left",        -- 监听红石输入的侧面（top/bottom/left/right/front/back）
    -- redstone_debounce_time = 0.3, -- 红石信号防抖时间
    push_item_count = 1          -- 每次推送物品数量
}

-- 3. 全局状态
local GLOBAL_STATE = {
    current_mode = "listen",      -- listen（监听红石）/ loop（轮询处理）
    last_item_detected_time = 0,  -- 最后检测到物品的时间
    -- last_redstone_trigger_time = 0 -- 最后触发红石的时间（防抖用）
}

-- ===================================== 健壮性工具函数（显式标注，可取舍） =====================================
-- 【健壮性】安全包装外设：校验存在性+有效性
local function safeWrapPeripheral(periphName)
    if not peripheral.isPresent(periphName) then
        -- print("[警告] 外设 " .. periphName .. " 不存在！")
        return nil
    end
    
    local periphObj = peripheral.wrap(periphName)
    if not periphObj or not periphObj.list then
        -- print("[警告] 外设 " .. periphName .. " 不是有效物品容器！")
        return nil
    end
    return periphObj
end

-- 【健壮性】红石信号防抖：短时间重复触发则忽略
local function checkRedstoneDebounce()
    local currentTime = os.clock()
    if currentTime - GLOBAL_STATE.last_redstone_trigger_time < CONFIG.redstone_debounce_time then
        return false
    end
    GLOBAL_STATE.last_redstone_trigger_time = currentTime
    return true
end

-- ===================================== 函数 =====================================
-- 1. 获取容器任意有效槽位
local function getAnyValidSlot(containerObj)
    if not containerObj then return nil end -- 【健壮性】校验对象有效性
    local itemList = containerObj.list() or {}
    for slot in pairs(itemList) do
        return slot
    end
    return nil
end

-- 2. 初始化设备：批量包装外设
local function initDevices()
    -- print("开始初始化设备...")
    for _, device in ipairs(DEVICE_MAP) do
        local periphObj = peripheral.wrap(periphName)
        [[
        device.outlet = safeWrapPeripheral(device.outlet)
        device.inlet = safeWrapPeripheral(device.inlet)
        if not device.outlet or not device.inlet then
            print("[错误] 设备组初始化失败：" .. device.outlet .. "/" .. device.inlet)
        end
        ]]
    end
    -- print("设备初始化完成！")
end

-- 3. 处理单组设备：出料口→入料口推送
local function processSingleDevice(device)
    -- 【健壮性】校验设备对象

    if not device.outlet or not device.inlet then
        print("[Warning] The device group " .. device.outletName .. "/" .. device.inletName .. " is invalid")
        return false
    end

    local validSlot = getAnyValidSlot(device.outlet)
    if not validSlot then
        goto Contin
    end
    -- 推送物品（【健壮性】捕获异常）
    local inletPeriphName = peripheral.getName(device.inlet)
    local success, err = pcall(function()
        device.outlet.pushItems(inletPeriphName, validSlot, CONFIG.push_item_count)
    end)

    if success then
        print("[success] " .. device.outletName .. " -> " .. device.inletName .. " End")
        GLOBAL_STATE.last_item_detected_time = os.clock()
        return true
    else
        print("[ERROR] F：" .. err)
        return false
    end

    ::Contin::
end

-- 4. 遍历映射表轮询所有设备（核心封装）
local function pollAllDevices()
    local hasAnyItem = false
    for _, device in ipairs(DEVICE_MAP) do
        local processed = processSingleDevice(device)
        if processed then
            hasAnyItem = true
        end
    end
    return hasAnyItem
end

-- ===================================== 状态逻辑函数 =====================================
-- 1. 监听态：监听红石输入，触发后切轮询态
local function runListenMode()
    -- print("进入监听态：等待 " .. CONFIG.redstone_side .. " 侧红石信号...")
    while GLOBAL_STATE.current_mode == "listen" do
---@diagnostic disable-next-line: undefined-field
        os.pullEvent("redstone")
            --print("[触发] 检测到红石信号，切换至轮询态！")
        print("listenEnd")
        GLOBAL_STATE.current_mode = "loop"
        GLOBAL_STATE.last_item_detected_time = os.clock()
        sleep(0.2)
    end
end

-- 2. 轮询态：固定间隔处理，满足条件切回监听态
local function runLoopMode()
    -- print("进入轮询态：固定间隔 " .. CONFIG.loop_interval .. " 秒轮询...")

    while GLOBAL_STATE.current_mode == "loop" do
        -- 轮询处理所有设备
        local hasAnyItem = pollAllDevices()

        -- 检查切回条件：无物品 + 稳定空闲N秒
        local currentTime = os.clock()
        local isStableIdle = (not hasAnyItem) and (currentTime - GLOBAL_STATE.last_item_detected_time >= CONFIG.stable_idle_time)

        if isStableIdle then
            -- print("[完成] 所有设备空闲且稳定，切回监听态！")
            print("loopEnd")
            GLOBAL_STATE.current_mode = "listen"
            break
        end

        -- 固定间隔休眠
        sleep(CONFIG.loop_interval)
    end
end

-- ===================================== 主程序 =====================================
    -- 主循环：监听态 ↔ 轮询态 切换
while true do
    if GLOBAL_STATE.current_mode == "listen" then
        runListenMode()
    elseif GLOBAL_STATE.current_mode == "loop" then
        runLoopMode()
    end
end