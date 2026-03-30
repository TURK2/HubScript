if not game:IsLoaded() then game.Loaded:Wait() end

local p = game.Players.LocalPlayer
local f = loadstring or load

-- 🔗 ใช้ CDN
local BASE = "https://cdn.jsdelivr.net/gh/TURK2/HubScript@main/Games/"
local MAIN = "https://cdn.jsdelivr.net/gh/TURK2/HubScript@main/Main.lua"
local DISCORD = "https://discord.com/invite/v3dAeMKp4N"

-- 📌 URL เกม
local GAME = BASE .. game.PlaceId .. ".lua"

-- ⚡ ฟังก์ชันโหลด (กันพัง)
local function get(u)
    local ok,r = pcall(game.HttpGet, game, u, true)
    if ok and r and r ~= "" and not r:find("404") and not r:lower():find("<html") then
        return r
    end
end

-- 🚀 โหลด
task.spawn(function()

    -- 1️⃣ โหลดเกมตรง
    local g = get(GAME)
    if g and f then
        return f(g)()
    end

    -- 2️⃣ โหลด Main (ไว้เลือกแมพ)
    local m = get(MAIN)
    if m and f then
        return f(m)()
    end

    -- ❌ โหลดไม่ได้จริงๆ
    warn("Load fail:", GAME)

    pcall(function()
        setclipboard(DISCORD)
    end)

    p:Kick("Load failed / Join Discord")

end)