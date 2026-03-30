repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local TeleportService = game:GetService("TeleportService")
local plr = game.Players.LocalPlayer

-- 🔗 API list ไฟล์ใน GitHub
local API = "https://api.github.com/repos/TURK2/HubScript/contents/Games"

local Window = Rayfield:CreateWindow({
    Name = "Select Game",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Maps",4483362458)

local selected = false

-- ⚡ โหลดรายชื่อแมพ
task.spawn(function()
    local ok,res = pcall(game.HttpGet,game,API,true)
    if not ok then return end

    local data = game:GetService("HttpService"):JSONDecode(res)

    for _,file in pairs(data) do
        if file.name:find(".lua") then
            local id = file.name:gsub(".lua","")

            Tab:CreateButton({
                Name = "Join Map: "..id,
                Callback = function()
                    selected = true
                    TeleportService:Teleport(tonumber(id), plr)
                end
            })
        end
    end
end)