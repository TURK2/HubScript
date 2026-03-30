if not game:IsLoaded() then game.Loaded:Wait() end

local f = loadstring or load
local BASE = "https://cdn.jsdelivr.net/gh/TURK2/HubScript@main/Games/"
local MAIN = "https://raw.githubusercontent.com/TURK2/HubScript/main/Main.lua"

local function get(u)
    local ok,r = pcall(game.HttpGet,game,u,true)
    if ok and r and r ~= "" and not r:find("404") and not r:lower():find("<html") then
        return r
    end
end

local g = get(BASE..game.PlaceId..".lua")

if g and f then
    f(g)()
else
    f(get(MAIN))()
end