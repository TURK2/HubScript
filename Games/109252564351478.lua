repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "TURKXSRCIPT Hub",
   LoadingTitle = "Auto Farm",
   LoadingSubtitle = "Script",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Main",4483362458)

-- หา HRP
local function getHRP()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- หา CFrame object
local function getCF(obj)
    if obj:IsA("BasePart") then
        return obj.CFrame
    else
        return obj:GetPivot()
    end
end

-- AUTO FARM NIVEL21 + ขยับตัว
local AutoFarm = false

MainTab:CreateToggle({
   Name = "Auto Farm Nivel21",
   CurrentValue = false,
   Callback = function(Value)
      AutoFarm = Value

      task.spawn(function()
        while AutoFarm do

            local entorno = workspace:FindFirstChild("Entorno")
            if entorno then
                local nivel = entorno:FindFirstChild("Nivel21")

                if nivel and nivel:FindFirstChild("Gameplay") then
                    local boton = nivel.Gameplay:FindFirstChild("BotonWins")

                    if boton then
                        local hrp = getHRP()
                        hrp.CFrame = getCF(boton) + Vector3.new(0,3,0)

                        -- ขยับตัวเล็กน้อย
                        hrp.CFrame = hrp.CFrame * CFrame.new(0,0,1)
                    end
                end
            end

            task.wait(0.5) -- วาร์ปทุก 0.5 วินาที
        end
      end)

   end
})

-- AUTO BUY
local AutoBuy = false

MainTab:CreateToggle({
   Name = "Auto Buy Upgrade",
   CurrentValue = false,
   Callback = function(Value)
      AutoBuy = Value

      task.spawn(function()
        while AutoBuy do
            local char = Player.Character or Player.CharacterAdded:Wait()
            local remote = char:WaitForChild("Eventos"):WaitForChild("Mejorar")

            remote:FireServer("Experiencia", true)
            remote:FireServer("Combustible", true)
            remote:FireServer("Trofeos", true)

            task.wait(0.5)
        end
      end)

   end
})

-- AUTO REBIRTH
local AutoRebirth = false

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(Value)
      AutoRebirth = Value

      task.spawn(function()
        while AutoRebirth do
            local char = Player.Character or Player.CharacterAdded:Wait()
            local rebirth = char:WaitForChild("Eventos"):WaitForChild("Renacimiento")

            rebirth:FireServer()

            task.wait(0.5)
        end
      end)

   end
})