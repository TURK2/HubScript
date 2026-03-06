local Players = game:GetService("Players")

local Discord = "https://discord.com/invite/v3dAeMKp4N"

local placeId = game.PlaceId

local GameURL =
"https://raw.githubusercontent.com/TURK2/HUB/main/Games/"..placeId..".lua"

local success,err = pcall(function()

    loadstring(game:HttpGet(GameURL))()

end)

if not success then

    pcall(function()
        setclipboard(Discord)
    end)

    Players.LocalPlayer:Kick(
        "This game is not supported.\nPlease contact support on Discord:\n"..Discord
    )

end