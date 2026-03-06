print("Blox Fruits Script Loaded")

-- ตัวอย่าง UI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.5,-100,0.5,-50)
frame.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,0,1,0)
text.Text = "Script Loaded!"
text.Parent = frame