if getgenv().TURKHUB_LOADED then return end
getgenv().TURKHUB_LOADED = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Whitelist Player
local WhitelistPlayers = {
    "maytawin29",
    "maytawin_test"
}

-- Links
local Discord = "https://discord.com/invite/v3dAeMKp4N"
local KeyURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/KEY"
local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"

-- Check Whitelist
for _,name in pairs(WhitelistPlayers) do
    if LocalPlayer.Name == name then
        loadstring(game:HttpGet(LoaderURL))()
        return
    end
end

-- Copy discord
pcall(function()
    setclipboard(Discord)
end)

-- Load UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Get Keys
local function GetKeys()

    local data = ""
    pcall(function()
        data = game:HttpGet(KeyURL)
    end)

    local keys = {}

    for line in string.gmatch(data,"[^\r\n]+") do
        table.insert(keys,line)
    end

    return keys
end

local ValidKeys = GetKeys()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "TURK HUB | Key System",
    LoadingTitle = "TURK HUB",
    LoadingSubtitle = "Secure Loader",
    Theme = "DarkBlue"
})

local KeyTab = Window:CreateTab("Authentication","lock")

local UserKey = ""

KeyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        UserKey = Text
    end
})

KeyTab:CreateButton({
    Name = "Submit Key",
    Callback = function()

        local Valid = false

        for _,k in pairs(ValidKeys) do
            if UserKey == k then
                Valid = true
                break
            end
        end

        if Valid then

            Rayfield:Notify({
                Title = "Access Granted",
                Content = "Loading Hub...",
                Duration = 4
            })

            wait(1)

            loadstring(game:HttpGet(LoaderURL))()

            Rayfield:Destroy()

        else

            pcall(function()
                setclipboard(Discord)
            end)

            Rayfield:Notify({
                Title = "Invalid Key",
                Content = "Join our Discord to get key (copied)",
                Duration = 5
            })

        end

    end
})

KeyTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()

        pcall(function()
            setclipboard(Discord)
        end)

        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord link copied",
            Duration = 3
        })

    end
})