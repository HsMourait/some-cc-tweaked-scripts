---@diagnostic disable: undefined-global
local slot = 1
while (true) do
    if redstone.getInput("right") then
        sleep(10)
        else
        turtle.select(1)
        if turtle.getItemDetail(1) == nil then
            turtle.suckUp(64)
        end
        turtle.select(2)
        if turtle.getItemDetail(2) == nil then
            turtle.suck(64)
        end

        turtle.select(7)
        turtle.craft(64)
        turtle.dropDown()
        turtle.select(8)
        turtle.dropDown()
    end
    sleep(3)
end