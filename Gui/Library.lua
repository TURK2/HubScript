repeat task.wait() until game:IsLoaded()

local CoreGui=game:GetService("CoreGui")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")

-- 🔥 ลบ UI เก่า (สำคัญมาก)
pcall(function()
    local old=CoreGui:FindFirstChild("NSHINNEN_UI")
    if old then old:Destroy() end
end)

-- 🌐 GUI
local gui=Instance.new("ScreenGui",CoreGui)
gui.Name="NSHINNEN_UI"
gui.ResetOnSpawn=false

-- 🌑 MAIN
local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,420,0,270)
main.Position=UDim2.new(0.5,-210,0.5,-135)
main.BackgroundColor3=Color3.fromRGB(18,18,22)
main.ClipsDescendants=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

-- 🌫 SHADOW
local shadow=Instance.new("ImageLabel",main)
shadow.Size=UDim2.new(1,40,1,40)
shadow.Position=UDim2.new(0,-20,0,-20)
shadow.BackgroundTransparency=1
shadow.Image="rbxassetid://1316045217"
shadow.ImageTransparency=0.75
shadow.ZIndex=0

-- 🌈 RGB BORDER
local stroke=Instance.new("UIStroke",main)
stroke.Thickness=1.5
task.spawn(function()
    local h=0
    RunService.RenderStepped:Connect(function()
        h=(h+0.002)%1
        stroke.Color=Color3.fromHSV(h,0.7,1)
    end)
end)

-- 🔝 TOPBAR
local top=Instance.new("Frame",main)
top.Size=UDim2.new(1,0,0,45)
top.BackgroundColor3=Color3.fromRGB(12,12,16)
Instance.new("UICorner",top).CornerRadius=UDim.new(0,12)

local grad=Instance.new("UIGradient",top)
grad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(140,50,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(0,200,255))
}

-- TITLE
local title=Instance.new("TextLabel",top)
title.Size=UDim2.new(1,-60,1,0)
title.Position=UDim2.new(0,12,0,0)
title.BackgroundTransparency=1
title.Text="N-SHINNEN UI"
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.GothamBold
title.TextSize=15
title.TextXAlignment=Enum.TextXAlignment.Left

-- 🔘 MINIMIZE
local toggle=Instance.new("TextButton",top)
toggle.Size=UDim2.new(0,30,0,30)
toggle.Position=UDim2.new(1,-38,0,7)
toggle.Text="-"
toggle.BackgroundTransparency=1
toggle.TextColor3=Color3.new(1,1,1)

-- 📦 CONTENT
local content=Instance.new("Frame",main)
content.Size=UDim2.new(1,0,1,-90)
content.Position=UDim2.new(0,0,0,45)
content.BackgroundTransparency=1

-- 📌 TAB BAR (เลื่อน)
local tabBar=Instance.new("ScrollingFrame",main)
tabBar.Size=UDim2.new(1,0,0,45)
tabBar.Position=UDim2.new(0,0,1,-45)
tabBar.BackgroundColor3=Color3.fromRGB(12,12,16)
tabBar.ScrollBarThickness=3
tabBar.AutomaticCanvasSize=Enum.AutomaticSize.X
tabBar.ScrollingDirection=Enum.ScrollingDirection.X
Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,10)

local layout=Instance.new("UIListLayout",tabBar)
layout.FillDirection=Enum.FillDirection.Horizontal
layout.Padding=UDim.new(0,8)
layout.VerticalAlignment=Enum.VerticalAlignment.Center

-- 🔥 DRAG (ลาก UI ได้จริง)
local dragging=false
local dragInput,dragStart,startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=main.Position

        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging=false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement 
    or input.UserInputType==Enum.UserInputType.Touch then
        dragInput=input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta=dragInput.Position-dragStart
        main.Position=UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset+delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset+delta.Y
        )
    end
end)

-- 🔽 MINIMIZE FIX (ไม่ให้ tab ลอย)
local minimized=false
toggle.MouseButton1Click:Connect(function()
    minimized=not minimized

    if minimized then
        toggle.Text="+"
        content.Visible=false
        tabBar.Visible=false

        TweenService:Create(main,TweenInfo.new(0.25),{
            Size=UDim2.new(0,420,0,45)
        }):Play()
    else
        toggle.Text="-"

        TweenService:Create(main,TweenInfo.new(0.25),{
            Size=UDim2.new(0,420,0,270)
        }):Play()

        task.wait(0.2)
        content.Visible=true
        tabBar.Visible=true
    end
end)