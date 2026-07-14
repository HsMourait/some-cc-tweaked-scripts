---@diagnostic disable: undefined-global
local slot = 1

while true do
    -- 如果左侧有红石信号，停机10秒
    if redstone.getInput("left") then
        sleep(10)
    else
            turtle.select(1)  -- 选择第1个物品栏

            -- 如果下方没有方块，放置方块
            if not turtle.detectUp() then
                turtle.placeUp()
            end

            -- 短暂延迟，确保放置操作完成
            sleep(0.6)

            -- 如果下方有方块，挖掘它
            if turtle.detectUp() then
                turtle.digUp(left)
            end

        -- 加入小延迟，防止循环过快导致超时
        sleep(0.1)
    end
end