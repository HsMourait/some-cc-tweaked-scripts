---@diagnostic disable: undefined-global
local tur =  peripheral.wrap("turtle_66")
local destroy = peripheral.find("create:item_vault")
local destroyName = peripheral.getName(destroy)
turtle.select(1)
sleep(1)

while true do
    for i=2,16 do
        destroy.pullItems("turtle_72", i, 64)
    end
    turtle.craft(15)
end
