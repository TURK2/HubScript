-- TURK HUB Loader

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ป้องกันรันซ้ำ
if getgenv().TURK_LOADER then
    return
end
getgenv().TURK_LOADER = true

-- Main script URL
local MAIN_URL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Main.lua"

-- โหลด Main
local success,err = pcall(function()
    loadstring(game:HttpGet(MAIN_URL))()
end)

if not success then
    warn("TURK HUB failed to load:",err)
end