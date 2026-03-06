-- Anti double run
if getgenv().TURKHUB_LOADED then
    return
end
getgenv().TURKHUB_LOADED = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Links
local Discord = "https://discord.com/invite/v3dAeMKp4N"

local KeyURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/KEY"
local DevKeyURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/DEVKEY"

local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"

-- Copy discord auto
pcall(function()
    setclipboard(Discord)
end)

-- Load UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Get Keys
local function GetKeys(url)

    local data = ""

    pcall(function()
        data = game:HttpGet(url)
    end)

    local keys = {}

    for line in string.gmatch(data,"[^\r\n]+") do
        table.insert(keys,line)
    end

    return keys
end

local NormalKeys = GetKeys(KeyURL)
local DevKeys = GetKeys(DevKeyURL)

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "TURK HUB | Authentication",
    LoadingTitle = "TURK HUB",
    LoadingSubtitle = "Secure Loader",
    Theme = "DarkBlue",
    DisableRayfieldPrompts = true
})

-- Tab
local KeyTab = Window:CreateTab("Key System","lock")

local UserKey = ""

-- Input
KeyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        UserKey = Text
    end
})

-- Validate function
local function CheckKey()

    for _,k in pairs(NormalKeys) do
        if UserKey == k then
            return true
        end
    end

    for _,k in pairs(DevKeys) do
        if UserKey == k then
            return true
        end
    end

    return false
end

-- Submit Button
KeyTab:CreateButton({
    Name = "Submit Key",
    Callback = function()

        if CheckKey() then

            Rayfield:Notify({
                Title = "Access Granted",
                Content = "Loading Hub...",
                Duration = 4
            })

            wait(1)

            -- Load loader
            loadstring(game:HttpGet(LoaderURL))()

            Rayfield:Destroy()

        else

            pcall(function()
                setclipboard(Discord)
            end)

            Rayfield:Notify({
                Title = "Invalid Key",
                Content = "Join our Discord to get the key (copied)",
                Duration = 6
            })

        end

    end
})

-- Copy Discord
KeyTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()

        pcall(function()
            setclipboard(Discord)
        end)

        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord link copied to clipboard",
            Duration = 3
        })

    end
})