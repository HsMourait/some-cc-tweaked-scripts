---@diagnostic disable: undefined-global
local slot = 1

while true do
  os.pullEvent("redstone") -- Wait for a change to inputs.
  turtle.select(1)
  turtle.place()
    turtle.select(2)
  turtle.place()
    turtle.select(3)
  turtle.place()
    turtle.select(4)
  turtle.place()
  print(111)
end