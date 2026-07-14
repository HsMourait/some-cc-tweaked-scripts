---@diagnostic disable: undefined-global
local slot = 1
while (true) do
    if redstone.getInput("back") then
        sleep(10)
        else
        turtle.select(1)--上烟药，后红石，前沙子，下输出
        if turtle.getItemDetail(1) == nil then
            turtle.suckUp(64)
            if turtle.getItemDetail(1) == nil then
                -- 如果还是空的，休眠10秒
                sleep(10)
            end
        end
        turtle.select(2)
        if turtle.getItemDetail(2) == nil then
            turtle.suck(64)
            if turtle.getItemDetail(2) == nil then
                sleep(10)
            end
        end
        turtle.select(3)
        if turtle.getItemDetail(3) == nil then
            turtle.suckUp(64)
            if turtle.getItemDetail(3) == nil then
                sleep(10)
            end
        end
        turtle.select(5)
        if turtle.getItemDetail(5) == nil then
            turtle.suck(64)
            if turtle.getItemDetail(5) == nil then
                sleep(10)
            end
        end
        turtle.select(6)
        if turtle.getItemDetail(6) == nil then
            turtle.suckUp(64)
            if turtle.getItemDetail(6) == nil then
                sleep(10)
            end
        end
        turtle.select(7)
        if turtle.getItemDetail(7) == nil then
            turtle.suck(64)
            if turtle.getItemDetail(7) == nil then
                sleep(10)
            end
        end
        turtle.select(9)
        if turtle.getItemDetail(9) == nil then
            turtle.suckUp(64)
            if turtle.getItemDetail(9) == nil then
                sleep(10)
            end
        end
        turtle.select(10)
        if turtle.getItemDetail(10) == nil then
            turtle.suck(64)
            if turtle.getItemDetail(10) == nil then
                sleep(10)
            end
        end
        turtle.select(11)
        if turtle.getItemDetail(11) == nil then
            turtle.suckUp(64)
            if turtle.getItemDetail(11) == nil then
                sleep(10)
            end
        end
        turtle.select(14)
        turtle.craft(64)
        turtle.dropDown()
        if turtle.getItemDetail(14) ~= nil then
            sleep(10) -- 任一槽位有物品则休眠
        end
    end
end