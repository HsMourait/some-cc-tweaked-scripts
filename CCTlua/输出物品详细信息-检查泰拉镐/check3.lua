local item = turtle.getItemDetail(1)  -- 先获取基本信息
-- 检查是否为空
if not item then
    print("\nSlot 1 is empty.")
    return
end
-- 检查是否为黑洞
if item.name ~= "botania:black_hole_talisman" then
    print("\nNo black_hole_talisman detected in slot 1.")
    return
end
-- 获取详细信息以读取 NBT
local detail = turtle.getItemDetail(1, true)
if not detail.nbt then
    print("\nUnable to read talisman data.")
    return
end
-- 检查物品数量是否足够
if detail.nbt then
    print(detail.nbt)
    return
end