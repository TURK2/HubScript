if not game:IsLoaded() then game.Loaded:Wait() end

local p = game.Players.LocalPlayer
local f = loadstring or load

local BASE = "https://cdn.jsdelivr.net/gh/TURK2/HubScript@main/Games/"
local DISCORD = "https://discord.com/invite/v3dAeMKp4N"

-- 🔥 โหลดหลายรอบกันพลาด
local function get(u)
    for i = 1,3 do
        local ok,r = pcall(game.HttpGet,game,u,true)
        if ok and r and #r > 50 and not r:lower():find("<html") then
            return r
        end
        task.wait(0.3)
    end
end

local url = BASE..game.PlaceId..".lua"
local g = get(url)

if g and f then
    -- ✅ มีจริง → copy + รัน
    pcall(function()
        setclipboard(DISCORD)
    end)

    local ok,err = pcall(function()
        f(g)()
    end)

    if not ok then
        warn("Script error:", err)
    end

else
    -- ❌ ไม่มี → copy + เตะ
    pcall(function()
        setclipboard(DISCORD)
    end)

    warn("Load fail:", url)

    p:Kick("Game not supported | Discord copied")
end