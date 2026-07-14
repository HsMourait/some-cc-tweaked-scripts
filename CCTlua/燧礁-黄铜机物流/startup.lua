---@diagnostic disable: undefined-global

local CopperName = "farmersdelight:basket_6"
local ZincName = "farmersdelight:basket_7"
local Copper = peripheral.wrap(CopperName)
local Zinc = peripheral.wrap(ZincName)

-- 工作盆
local Basin1 = peripheral.wrap("basin_131")
local Basin2 = peripheral.wrap("basin_132")
local Basin3 = peripheral.wrap("basin_133")
local Basin4 = peripheral.wrap("basin_134")
local Basin5 = peripheral.wrap("basin_135")
local Basin6 = peripheral.wrap("basin_136")
local Basin7 = peripheral.wrap("basin_137")
local Basin8 = peripheral.wrap("basin_138")
local Basin9 = peripheral.wrap("basin_139")
local Basin10 = peripheral.wrap("basin_140")
local Basin11 = peripheral.wrap("basin_141")
local Basin12 = peripheral.wrap("basin_142")
local Basin13 = peripheral.wrap("basin_143")
local Basin14 = peripheral.wrap("basin_144")
local Basin15 = peripheral.wrap("basin_145")
local Basin16 = peripheral.wrap("basin_146")
local Basin17 = peripheral.wrap("basin_147")
local Basin18 = peripheral.wrap("basin_148")
local Basin19 = peripheral.wrap("basin_149")
local Basin20 = peripheral.wrap("basin_150")
local Basin21 = peripheral.wrap("basin_151")
local Basin22 = peripheral.wrap("basin_152")
local Basin23 = peripheral.wrap("basin_153")
local Basin24 = peripheral.wrap("basin_154")
local Basin25 = peripheral.wrap("basin_155")
local Basin26 = peripheral.wrap("basin_156")
local Basin27 = peripheral.wrap("basin_157")
local Basin28 = peripheral.wrap("basin_158")
local Basin29 = peripheral.wrap("basin_159")
local Basin30 = peripheral.wrap("basin_160")
local Basin31 = peripheral.wrap("basin_161")
local Basin32 = peripheral.wrap("basin_162")




-- ===================== 索引表定义 =====================
-- 工作盆索引表
local Basins = {
    [1] = Basin1,
    [2] = Basin2,
    [3] = Basin3,
    [4] = Basin4,
    [5] = Basin5,
    [6] = Basin6,
    [7] = Basin7,
    [8] = Basin8,
    [9] = Basin9,
    [10] = Basin10,
    [11] = Basin11,
    [12] = Basin12,
    [13] = Basin13,
    [14] = Basin14,
    [15] = Basin15,
    [16] = Basin16,
    [17] = Basin17,
    [18] = Basin18,
    [19] = Basin19,
    [20] = Basin20,
    [21] = Basin21,
    [22] = Basin22,
    [23] = Basin23,
    [24] = Basin24,
    [25] = Basin25,
    [26] = Basin26,
    [27] = Basin27,
    [28] = Basin28,
    [29] = Basin29,
    [30] = Basin30,
    [31] = Basin31,
    [32] = Basin32
}


-- ===================== 获取容器中某一个有物品槽位 =====================
local function getAnyValidSlot(container)
    -- 参数container填包装后的容器
    -- list() 是 CC:T 中外设对象的专属方法，只有通过 peripheral.wrap(容器名称) 得到的对象，才拥有这个方法。
    -- 1.获取容器的list
    local ContainerItemList = container.list() or {}
    if not ContainerItemList then return nil end

    -- 2. 遍历list，拿到第一个遇到的有效槽位就返回
    for slot in pairs(ContainerItemList) do
        return slot -- 找到任意一个有效槽位，立即返回，无需遍历全部
    end

    -- 3. 无有效槽位时返回nil
    return nil
end

-- ===================== 从容器推送物品至表 =====================
local function pushItemsToTargets(sourceContainer, targetIndexTable, pushCount)
    -- 遍历目标容器表，取出每个容器的索引和容器对象
    for targetIndex, targetContainer in pairs(targetIndexTable) do
        -- 从源容器中获取任意一个有效的物品槽位编号
        local validSlot = getAnyValidSlot(sourceContainer)
        -- 检查有效槽位，无则直接break并结束函数
        if not validSlot then break end
        
        -- 获取目标容器的外设名称
        local targetPeriphName = peripheral.getName(targetContainer)
        -- 调用源容器的pushItems方法，把物品推送到目标容器
        sourceContainer.pushItems(targetPeriphName, validSlot, pushCount)
    end
end


while true do
    -- 检查红石开关
    :: Mark1 ::
    if  redstone.getInput("top") then
        sleep(10)
        goto Mark1
    end

    -- 检查入料处是否有物料
    if getAnyValidSlot(Copper) == nil and getAnyValidSlot(Zinc) == nil then
        sleep(5)
        goto Mark1
    end

    -- 向每一个工作盆输入铜
    pushItemsToTargets(Copper, Basins, 32)
    -- 向每一个工作盆输入锌
    pushItemsToTargets(Zinc, Basins, 32)
end