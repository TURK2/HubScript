repeat task.wait() until game:IsLoaded()

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- Window
local Window = Rayfield:CreateWindow({
   Name = "🚣 Kayak Racing Hub",
   LoadingTitle = "TURKXSRCIPT Hub",
   LoadingSubtitle = "YT: TURKXSRCIPT",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main",4483362458)
local SettingsTab = Window:CreateTab("Settings",4483362458)

-- Remote
local Reliable = ReplicatedStorage:WaitForChild("Warp"):WaitForChild("Index"):WaitForChild("Event"):WaitForChild("Reliable")

-- Variables
local AutoReliable = false
local AutoWin = false
local CurrentStage = 1
local MaxStage = 18
local SpeedWarp = 0.1

local TargetPosition = Vector3.new(119.26,5.63,-18.36)

-- Buffers
local Buffers = {
"\254\002\000\006\005Power\001\001",
"\254\002\000\006\005Power\001\002",
"\254\002\000\006\005Power\001\003",
"\254\002\000\006\005Power\001\004",
"\254\002\000\006\005Power\001\005",
"\254\002\000\006\005Power\001\006",
"\254\002\000\006\005Power\001\007",
"\254\002\000\006\005Power\001\008",
"\254\002\000\006\005Power\001\009",
"\254\002\000\006\005Power\001\0010",
"\254\002\000\006\005Power\001\0011",
"\254\002\000\006\005Power\001\0012",

}

-- Functions

local function WarpToSign(stage)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local track = Workspace:FindFirstChild("Track")
    if not track then return end

    local stageName = "Stage"..string.format("%02d",stage)
    local stageFolder = track:FindFirstChild(stageName)

    if stageFolder then
        local sign = stageFolder:FindFirstChild("Sign")
        if sign then
            hrp.CFrame = sign.CFrame + Vector3.new(0,3,0)
        end
    end
end

local function WarpToPosition(pos)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos)
end

-- =========================
-- UI TOGGLES
-- =========================

MainTab:CreateToggle({
   Name = "Auto Reliable",
   CurrentValue = false,
   Callback = function(Value)
      AutoReliable = Value
   end
})

MainTab:CreateToggle({
   Name = "Auto Win",
   CurrentValue = false,
   Callback = function(Value)
      AutoWin = Value
   end
})

SettingsTab:CreateSlider({
   Name = "Warp Speed",
   Range = {0,1},
   Increment = 0.05,
   CurrentValue = 0.1,
   Callback = function(Value)
      SpeedWarp = Value
   end
})

-- =========================
-- AUTO RELIABLE LOOP
-- =========================

task.spawn(function()
while true do
task.wait()

if AutoReliable then
    for _,buf in ipairs(Buffers) do
        pcall(function()
            Reliable:FireServer(
                buffer.fromstring("\27"),
                buffer.fromstring(buf)
            )
        end)
    end
end

end
end)

-- =========================
-- AUTO WIN LOOP
-- =========================

task.spawn(function()

while true do
task.wait(SpeedWarp)

if AutoWin then

pcall(function()

local doorFolder = Workspace:FindFirstChild("WorldMain") and Workspace.WorldMain:FindFirstChild("Door")
local signStatus = doorFolder and doorFolder:FindFirstChild("SignStatus")

if signStatus then

WarpToPosition(TargetPosition)

else

WarpToSign(CurrentStage)

CurrentStage += 1
if CurrentStage > MaxStage then
CurrentStage = 1
end

end

end)

end

end

end)

Rayfield:Notify({
   Title = "TURKXSRCIPT Hub",
   Content = "Script Loaded Successfully",
   Duration = 5
})