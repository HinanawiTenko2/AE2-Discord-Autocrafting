local DiscordBot = require(DiscordBot)

tokenF = fs.open('Token', 'r')
local token = tokenF.readLine()
tokenF.close()

channelF = fs.open('Channel', 'r')
local channel = channelF.readLine()
channelF.close()

local bot = createBot(token)
local systemME = peripheral.find('meBridge')

local oldID = nil


while true do
    local messages = bot.getMessages(channel)
    if not(messages[1].id == oldID) then
       local message = messages[1].content
       if strfind(message, '!getCount') then
            local item = strsub(message, 11)
            local count = systemME.getItem(item).amount
            bot.send(tostring(count), channel)
       end 
    end
    oldID = messages[1].id
end