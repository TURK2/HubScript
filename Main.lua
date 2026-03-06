-- Loader System
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

local DiscordInvite = "https://discord.com/invite/v3dAeMKp4N"
local GamesURL = "https://api.github.com/repos/TURK2/HubScript/contents/Games"

-- API analytics (ต้องมี server)
local AnalyticsAPI = "https://your-api.com/hub-analytics"

-- copy discord
pcall(function()
    setclipboard(DiscordInvite)
end)

-- request support
local request =
    syn and syn.request or
    http_request or
    request or
    (http and http.request)

-- ===== SEND ANALYTICS =====
local function SendAnalytics()

    if not request then
        return
    end

    local country = "Unknown"

    pcall(function()
        local geo = game:HttpGet("http://ip-api.com/json")
        local decoded = HttpService:JSONDecode(geo)
        country = decoded.country
    end)

    local data = {
        user = LocalPlayer.UserId,
        game = PlaceId,
        country = country,
        time = os.time()
    }

    pcall(function()

        request({
            Url = AnalyticsAPI,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })

    end)

end

-- ===== Kick =====
local function KickPlayer()

    pcall(function()
        setclipboard(DiscordInvite)
    end)

    LocalPlayer:Kick(
        "This game is not supported.\n\nJoin our Discord for support:\n"..DiscordInvite
    )

end

-- ===== Load Games =====
local function GetGames()

    local data = nil

    pcall(function()
        data = game:HttpGet(GamesURL)
    end)

    if not data then
        KickPlayer()
        return
    end

    local decoded = HttpService:JSONDecode(data)

    for _,file in pairs(decoded) do

        local name = file.name
        local place = name:gsub(".lua","")

        if tonumber(place) == PlaceId then

            local raw =
            "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"..name

            SendAnalytics()

            loadstring(game:HttpGet(raw))()

            return
        end

    end

    KickPlayer()

end

GetGames()