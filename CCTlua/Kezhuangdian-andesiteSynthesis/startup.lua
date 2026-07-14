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
            if turtle.getItemDetail(1) == nil then
                -- 如果还是空的，休眠20秒
                sleep(20)
            end
        end

        turtle.select(7)
        turtle.craft(64)
        turtle.dropDown()
        turtle.select(8)
        turtle.dropDown()

        if turtle.getItemDetail(7) ~= nil or turtle.getItemDetail(8) ~= nil then
            sleep(10) -- 任一槽位有物品则休眠
        end
    end
end