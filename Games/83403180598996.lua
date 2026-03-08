local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = Rayfield:CreateWindow({
   Name = "TURKXSRCIPT Hub",
   LoadingTitle = "TURKXSRCIPT Hub",
   LoadingSubtitle = "YT: TURKXSRCIPT",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- MAIN EN
local MainTab = Window:CreateTab("Main EN", 4483362458)

-- MAIN TH
local MainTH = Window:CreateTab("Main TH", 4483362458)

-- เลือกโลก
local SelectedZone = "1"

MainTab:CreateDropdown({
   Name = "Select World",
   Options = {"1","2","3","4","5","6","7","8","9","10","11","12"},
   CurrentOption = {"1"},
   Callback = function(Option)
      SelectedZone = Option[1]
   end,
})

MainTH:CreateDropdown({
   Name = "เลือกโลก",
   Options = {"1","2","3","4","5","6","7","8","9","10","11","12"},
   CurrentOption = {"1"},
   Callback = function(Option)
      SelectedZone = Option[1]
   end,
})

-- AUTO WIN
local AutoWin = false

local function StartAutoWin()
   while AutoWin do
      local player = Players.LocalPlayer
      local char = player.Character

      if char and char:FindFirstChild("HumanoidRootPart") then
         local win = workspace.Zones[SelectedZone].Gameplay.WinPlatforms["8"].WinButton
         char.HumanoidRootPart.CFrame = win.CFrame + Vector3.new(0,3,0)
      end

      task.wait(0.5)
   end
end

MainTab:CreateToggle({
   Name = "Auto Win",
   CurrentValue = false,
   Callback = function(Value)
      AutoWin = Value
      if Value then
         task.spawn(StartAutoWin)
      end
   end,
})

MainTH:CreateToggle({
   Name = "วินอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoWin = Value
      if Value then
         task.spawn(StartAutoWin)
      end
   end,
})

-- AUTO REBIRTH
local AutoRebirth = false

local function StartRebirth()
   while AutoRebirth do

      local args = {
         "Rebirths",
         "MaxRebirth"
      }

      ReplicatedStorage.Events.InvokeServerAction:InvokeServer(unpack(args))

      task.wait(1)
   end
end

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
      if Value then
         task.spawn(StartRebirth)
      end
   end,
})

MainTH:CreateToggle({
   Name = "รีเบิร์ดอัตโนมัติ",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value
      if Value then
         task.spawn(StartRebirth)
      end
   end,
})

-- ABOUT
local AboutTab = Window:CreateTab("About", 4483362458)

AboutTab:CreateParagraph({
   Title = "Credits",
   Content = "YouTube: TURKXSRCIPT"
})

AboutTab:CreateButton({
   Name = "Copy Discord",
   Callback = function()
      setclipboard("https://discord.gg/yourlink")
      Rayfield:Notify({
         Title = "Copied!",
         Content = "Discord copied",
         Duration = 4
      })
   end,
})