---@diagnostic disable: undefined-global
local slot = 1
while (true) do
    if not turtle.getItemDetail(16) == nil then
        sleep(10)
        else
        turtle.select(1)--上沙砾，前输出，下泥土
        if turtle.getItemDetail(1) == nil then
            turtle.suckDown(64)
        end
        turtle.select(2)
        if turtle.getItemDetail(2) == nil then
            turtle.suckUp(64)
        end
        turtle.select(5)
        if turtle.getItemDetail(5) == nil then
            turtle.suckUp(64)
             if turtle.getItemDetail(5) == nil then
                -- 如果还是空的，休眠20秒
                sleep(20)
            end
        end
        turtle.select(6)
        if turtle.getItemDetail(6) == nil then
            turtle.suckDown(64)
            if turtle.getItemDetail(6) == nil then
                -- 如果还是空的，休眠20秒
                sleep(20)
            end
        end
        turtle.select(7)
        turtle.craft(64)
        turtle.drop()
        turtle.select(8)
        turtle.drop()
        turtle.select(9)
        turtle.drop()
        turtle.select(10)
        turtle.drop()

        if turtle.getItemDetail(7) ~= nil or turtle.getItemDetail(8) ~= nil or turtle.getItemDetail(9) ~= nil or turtle.getItemDetail(10) ~= nil then
            sleep(10) -- 任一槽位有物品则休眠
        end
    end
end