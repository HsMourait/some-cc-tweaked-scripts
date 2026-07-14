---@diagnostic disable: undefined-global

local deployer1 = peripheral.wrap("create:deployer_5")

local itemPlat1 = peripheral.wrap("create:depot_26")
local itemPlat2 = peripheral.wrap("create:depot_27")

itemPlat1.pullItems(peripheral.getName(deployer1), 1, 1, 1)
itemPlat2.pullItems(peripheral.getName(deployer1), 1, 1, 2)