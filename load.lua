if not game:IsLoaded() then game.Loaded:Wait() end

local p = game.Players.LocalPlayer
local f = loadstring or load

local BASE = "https://cdn.jsdelivr.net/gh/TURK2/HubScript@main/Games/"
local DISCORD = "https://discord.com/invite/v3dAeMKp4N"

local function get(u)
    local ok,r = pcall(game.HttpGet,game,u,true)
    if ok and r and r ~= "" and not r:find("404") and not r:lower():find("<html") then
        return r
    end
end

local g = get(BASE..game.PlaceId..".lua")

if g and f then
    -- ✅ มีแมพ → copy + รัน
    pcall(function()
        setclipboard(DISCORD)
    end)

    f(g)()
else
    -- ❌ ไม่มีแมพ → copy + เตะ
    pcall(function()
        setclipboard(DISCORD)
    end)

    p:Kick("Game not supported | Discord copied")
end