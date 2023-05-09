shell.run('wget https://raw.githubusercontent.com/HinanawiTenko2/CC-Tweaked-DiscordBot/main/DiscordBot.lua DiscordBot')
shell.run('wget https://raw.githubusercontent.com/HinanawiTenko2/AE2-Discord-Autocrafting/main/startup.lua startup')

local arg = { ... }
if #arg ~= 2 then
    print('Useage:\n <program name> <discord bot token> <channel ID>')
    return
else
    tokenFile = fs.open('Token', 'w')
    tokenFile.write(arg[1])
    tokenFile.close()
    channelFile = fs.open('Channel', 'w')
    channelFile.write(arg[2])
    channelFile.close()
    print('Restart Computer to start the program')
end