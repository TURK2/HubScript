-- Wait game load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Discord
local Discord = "https://discord.com/invite/v3dAeMKp4N"

-- Base Script URL
local BaseURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"

-- Current Game ID
local PlaceID = game.PlaceId

-- Script URL
local ScriptURL = BaseURL .. PlaceID .. ".lua"

-- Try load script
local success, result = pcall(function()
    return game:HttpGet(ScriptURL)
end)

-- ถ้าโหลดไม่ได้
if not success or result == "404: Not Found" or result == "" then
    
    -- copy discord
    pcall(function()
        setclipboard(Discord)
    end)

    -- kick player
    LocalPlayer:Kick("Game not supported.\nJoin our Discord (copied to clipboard): "..Discord)

    return
end

-- ถ้าเจอสคริป
local runSuccess, runError = pcall(function()
    loadstring(result)()
end)

-- ถ้าสคริป error
if not runSuccess then
    
    pcall(function()
        setclipboard(Discord)
    end)

    LocalPlayer:Kick("Script error.\nContact support in Discord (copied): "..Discord)

end