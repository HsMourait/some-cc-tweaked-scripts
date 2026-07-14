---@diagnostic disable: undefined-global
local slot = 1
while (true) do
    if redstone.getInput("left")  or redstone.getInput("left") then
        sleep(10)
        else
            turtle.select(1)
            if not turtle.compare() then
                turtle.place()
            end
    end
    sleep(1)
end