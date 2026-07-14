while true do
    local event, username, message, uuid, isHidden, messageUtf8 = os.pullEvent("chat")
     if messageUtf8 == "w" then
        local chatBox = peripheral.find("chatBox")
        chatBox.sendMessage("...", "Niliko",  "<>", nil, nil, true)
     end
    sleep(1)
end