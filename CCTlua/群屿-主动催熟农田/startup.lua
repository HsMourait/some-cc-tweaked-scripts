---@diagnostic disable: undefined-global
local slot = 1

while true do
    -- 如果后方有红石信号，停机10秒
    if redstone.getInput("back") then
        sleep(10)
    else
            turtle.select(1)  -- 选择第1个物品栏
            
            -- 如果下方没有方块，放置方块
            if not turtle.detectDown() then
                turtle.placeDown()
            end
            
            -- 短暂延迟，确保操作完成
            sleep(1.5)
            
            -- 如果下方有方块，挖掘它
            if turtle.detectDown() then
                turtle.digDown(left)
            end
        
        -- 加入小延迟，防止循环过快导致超时
        sleep(0.1)
    end
end