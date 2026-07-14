-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local turtle_15 = peripheral.wrap("turtle_15")

-- 沙砾，沙子和染料
local s1 = peripheral.wrap("create:depot_125")
local s2 = peripheral.wrap("create:depot_126")
local s3 = peripheral.wrap("create:depot_127")
local s4 = peripheral.wrap("create:depot_128")

local g1 = peripheral.wrap("create:depot_129")
local g2 = peripheral.wrap("create:depot_130")
local g3 = peripheral.wrap("create:depot_131")
local g4 = peripheral.wrap("create:depot_132")

local dye = peripheral.wrap("create:depot_124")
-- 混凝土粉末缓存
local silo1 = peripheral.wrap("create_connected:item_silo_29")

while (true) do
-- 检查输出端是否有物品，若都没有则休眠
if gravel and sand and dye
   and not s1.getItemDetail(1)
   and not s2.getItemDetail(1)
   and not s3.getItemDetail(1)
   and not s4.getItemDetail(1)
   and not g1.getItemDetail(1)
   and not g2.getItemDetail(1)
   and not g3.getItemDetail(1)
   and not g4.getItemDetail(1)
   and not dye.getItemDetail(1) then
    sleep(30)
   end

::restart_slot1::

-- 获取配方
if turtle.getItemDetail(1) == nil then
        local transferred = g1.pushItems("turtle_15", 1, 64, 1)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(2) == nil then
        local transferred = g2.pushItems("turtle_15", 1, 64, 2)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(3) == nil then
        local transferred = g3.pushItems("turtle_15", 1, 64, 3)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(5) == nil then
        local transferred = g4.pushItems("turtle_15", 1, 64, 5)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(6) == nil then
        local transferred = s1.pushItems("turtle_15", 1, 64, 6)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(7) == nil then
        local transferred = s2.pushItems("turtle_15", 1, 64, 7)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(9) == nil then
        local transferred = s3.pushItems("turtle_15", 1, 64, 9)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(10) == nil then
        local transferred = s4.pushItems("turtle_15", 1, 64, 10)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    end
end

if turtle.getItemDetail(11) == nil then
        local transferred = dye.pushItems("turtle_15", 1, 64, 11)
        if transferred and transferred == 64 then
    -- 传输成功
else
    -- 传输失败
    sleep(10)
    goto restart_slot1
    end
end

    turtle.select(13)
    turtle.craft(64)

    local slotsToEmpty = {13, 14, 15, 16, 1, 2, 3, 4}
    for _, slot in ipairs(slotsToEmpty) do
    turtle.select(slot)
    -- 尝试推送到silo1
    if silo1 then
        local transferred = silo1.pullItems("turtle_15", slot, 64)
        if transferred == 0 then
            sleep(30)
        end
    else
        sleep(30)
        goto restart_slot1
    end
end


end