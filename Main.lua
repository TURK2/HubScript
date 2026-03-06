local Players = game:GetService("Players")
local player = Players.LocalPlayer

local KEY_URL = "https://raw.githubusercontent.com/TURK2/HubScript/main/key.txt"
local GAME_SCRIPT_URL = "https://raw.githubusercontent.com/TURK2/HubScript/main/games/"
local DISCORD = "https://discord.gg/yourdiscord"

local correctKey = game:HttpGet(KEY_URL)

-- UI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.Parent = gui

local box = Instance.new("TextBox")
box.Size = UDim2.new(0,260,0,40)
box.Position = UDim2.new(0,20,0,30)
box.PlaceholderText = "Enter Key"
box.Parent = frame

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(0,120,0,40)
verify.Position = UDim2.new(0,20,0,100)
verify.Text = "Verify Key"
verify.Parent = frame

local discord = Instance.new("TextButton")
discord.Size = UDim2.new(0,120,0,40)
discord.Position = UDim2.new(0,160,0,100)
discord.Text = "Copy Discord"
discord.Parent = frame

-- copy discord
discord.MouseButton1Click:Connect(function()
    setclipboard(DISCORD)
end)

-- verify key
verify.MouseButton1Click:Connect(function()

    if box.Text == correctKey then

        local gameID = game.PlaceId

        local success, script = pcall(function()
            return game:HttpGet(GAME_SCRIPT_URL .. gameID .. ".lua")
        end)

        if success then

            gui:Destroy()

            loadstring(script)()

        else

            player:Kick(
                "This game is not supported.\nContact support: "..DISCORD
            )

        end

    else

        box.Text = "Invalid Key"

    end

end)