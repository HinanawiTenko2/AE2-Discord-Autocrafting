local DiscordBot = require('DiscordBot')

tokenF = fs.open('Token', 'r')
local token = tokenF.readLine()
tokenF.close()

channelF = fs.open('Channel', 'r')
local channel = channelF.readLine()
channelF.close()

local bot = createBot(token)
local systemME = peripheral.find('meBridge')

local messages = bot.getMessages(channel)
local oldID = messages[1].id


while true do
    messages = bot.getMessages(channel)

    if not(messages[1].id == oldID) then
       local message = messages[1].content
       if string.find(message, '!getCount') then
            local item = string.sub(message, 11)
            local MEItems = systemME.listItems()
            local found = false
            for _,i in pairs(MEItems) do
                if i.name == item then
                    bot.send('There is ' .. tostring(i.amount) .. ' ' .. item .. ' in the ME system', channel)
                    found = true
                end
            end
            if not found then
                bot.send(item .. ' was not found in the system', channel)
            end
       end 
       
       if message == '!dumpME' then
            local dump = ''
            local MEItems = systemME.listItems()
            for _,i in pairs(MEItems) do
                dump = dump .. i.name .. '\n'
                if string.len(dump) > 1500 then
                    bot.send(dump, channel)
                    dump = ''
                    sleep(1)
                end
            end
            bot.send(dump, channel)
       end

       if string.find(message, '!search') then
            local search = string.sub(message, 9)
            local MEItems = systemME.listItems()
            local itemsFound = ''
            local found = false
            for _,i in pairs(MEItems) do
                if string.find(i.name, search) then
                    itemsFound = itemsFound .. i.name .. '\n'
                    found = true
                end
                if string.len(itemsFound) > 1500 then
                    bot.send(itemsFound, channel)
                    itemsFound = ''
                    sleep(1)
                end
            end
            if found then
                bot.send(itemsFound, channel)
            else
                bot.send('No Items Found', channel)
            end
       end

       if message == '!dumpCrafting' then
            local craftables = systemME.listCraftableItems()
            local str = ''
            if craftables[1] then
                for _,i in pairs(craftables) do
                    str = str .. i.name .. '\n'
                    if string.len(str) > 1500 then
                        bot.send(str, channel)
                        str = ''
                    end
                end
                bot.send(str, channel)
            else   
                bot.send('No Craftable Items', channel)
            end
       end

       if string.find(message, '!craft') then
            local item = string.sub(message, 8)
            local craftables = systemME.listCraftableItems()
            local found = false
            if craftables[1] then
                for _,i in pairs(craftables) do
                    if item == i.name then
                        found = true
                        systemME.craftItem(i)
                        bot.send('Crafting...', channel)
                    end
                end
                if not found then
                    bot.send('Item Not Craftable', channel)
                end
            else
                bot.send('No Craftable Items', channel)
            end
       end
    end
    oldID = messages[1].id
    sleep(1)
end