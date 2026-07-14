---@diagnostic disable: undefined-global
local tur =  peripheral.wrap("turtle_2")
local destroy = peripheral.wrap("create:item_vault_21")
turtle.select(1)
sleep(1)

while true do
    for i=2,16 do
        destroy.pullItems("turtle_2", i, 64)
    end
    turtle.craft(15)
end
