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
            for _,i in pairs(MEItems) do
                if string.find(i.name, search) then
                    itemsFound = itemsFound .. i.name .. '\n'
                end
                if string.len(itemsFound) > 1500 then
                    bot.send(itemsFound, channel)
                    itemsFound = ''
                end
            end
            bot.send(itemsFound, channel)
       end
    end
    oldID = messages[1].id
    sleep(1)
end