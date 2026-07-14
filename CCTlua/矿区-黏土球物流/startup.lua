-- 库存运输自动化脚本
-- o：输出，i：输入，cache：缓存
---@diagnostic disable: undefined-global
local oClayBall = peripheral.wrap("create:depot_81")
local iClayBall = peripheral.wrap("create:item_vault_20")

while (true) do
-- 检查输出端是否有物品，若都没有则休眠

if redstone.getInput("top") then
        sleep(10)
else
if oClayBall
   and not oClayBall.getItemDetail(1)then
    sleep(10)
end

-- 将小麦运输至面包机
if oClayBall and iClayBall then
    -- 检查源槽位是否有物品
    if oClayBall.getItemDetail(1) then
        -- 传输物品（自动处理目标容器空间）
        local transferred = oClayBall.pushItems(peripheral.getName(iClayBall), 1)
    end
end

end
end