
---@diagnostic disable: undefined-global


local reader = peripheral.find("blockReader")

-- 获取方块的状态属性（返回表格或 nil）
local blockStates = reader.getBlockStates()

-- 打印状态内容（先判断是否存在数据，避免 nil 错误）
if blockStates then
    print("value：")
    for key, value in pairs(blockStates) do
        print(key, value)  -- 打印每个属性的键和值
    end
else
    print("XXX")
end