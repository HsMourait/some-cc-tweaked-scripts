---@diagnostic disable: undefined-global
local slot = 1
while (true) do
    if redstone.getInput("back") then
        sleep(10)
        else
        turtle.select(1)--上输出，前铁粒，下安山岩
        if turtle.getItemDetail(1) == nil then
            turtle.suck(64)
        end
        turtle.select(2)
        if turtle.getItemDetail(2) == nil then
            turtle.suckDown(64)
        end
        turtle.select(5)
        if turtle.getItemDetail(5) == nil then
            turtle.suckDown(64)
        end
        turtle.select(6)
        if turtle.getItemDetail(6) == nil then
            turtle.suck(64)
        end

        turtle.select(7)
        turtle.craft(64)
        turtle.dropUp()
        turtle.select(8)
        turtle.dropUp()
    end
    sleep(3)
end