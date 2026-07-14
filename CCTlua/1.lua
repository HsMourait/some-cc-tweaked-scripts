---@diagnostic disable: undefined-global
local string = peripheral.getNames()
print(string)
for key, value in pairs(string) do
    -- 直接拼接键和值，无任何额外结构
    print(key .. " = " .. tostring(value))
end

