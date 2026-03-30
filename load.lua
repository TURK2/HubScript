if not game:IsLoaded() then game.Loaded:Wait() end

local plr = game.Players.LocalPlayer

-- 🔗 ตั้งค่า
local BASE = "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"
local DISCORD = "https://discord.com/invite/v3dAeMKp4N"

-- 📌 URL เกม
local URL = BASE .. game.PlaceId .. ".lua"

-- ⚡ โหลดแบบไว (ไม่ค้าง)
task.spawn(function()
    local ok,res = pcall(game.HttpGet, game, URL)

    if ok and res and res ~= "" and not res:find("404") then
        -- ✅ เจอ → รันทันที
        loadstring(res)()
    else
        -- ❌ ไม่เจอ → copy + เตะ
        pcall(function() setclipboard(DISCORD) end)
        plr:Kick("Game not supported | Discord copied")
    end
end)