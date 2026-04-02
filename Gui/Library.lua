-- NShinnen Library

local Library = {}

function Library:CreateWindow(title)
    local CoreGui=game:GetService("CoreGui")
    local UIS=game:GetService("UserInputService")
    local RunService=game:GetService("RunService")
    local TweenService=game:GetService("TweenService")

    -- ลบของเก่า
    pcall(function()
        if CoreGui:FindFirstChild("NShinnenUI") then
            CoreGui.NShinnenUI:Destroy()
        end
    end)

    -- Gradient
    local function Gradient(p)
        local g=Instance.new("UIGradient",p)
        g.Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,Color3.fromRGB(138,43,226)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(0,191,255))
        }
    end

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="NShinnenUI"
    gui.ResetOnSpawn=false

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,0,0,0)
    main.Position=UDim2.new(0.5,-325,0.5,-210)
    main.BackgroundColor3=Color3.fromRGB(15,15,20)
    main.ClipsDescendants=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,10)

    -- RGB border
    local stroke=Instance.new("UIStroke",main)
    stroke.Thickness=1.5
    task.spawn(function()
        local h=0
        RunService.RenderStepped:Connect(function()
            h=(h+0.003)%1
            stroke.Color=Color3.fromHSV(h,0.7,1)
        end)
    end)

    -- Topbar
    local top=Instance.new("Frame",main)
    top.Size=UDim2.new(1,0,0,50)
    top.BackgroundColor3=Color3.fromRGB(10,10,12)

    local line=Instance.new("Frame",top)
    line.Size=UDim2.new(1,0,0,1)
    line.Position=UDim2.new(0,0,1,0)
    Gradient(line)

    local txt=Instance.new("TextLabel",top)
    txt.Size=UDim2.new(1,-100,1,0)
    txt.Position=UDim2.new(0,15,0,0)
    txt.BackgroundTransparency=1
    txt.Text=title or "N-SHINNEN UI"
    txt.TextColor3=Color3.new(1,1,1)
    txt.Font=Enum.Font.GothamBold
    txt.TextSize=16
    txt.TextXAlignment=Enum.TextXAlignment.Left

    -- Close
    local close=Instance.new("TextButton",top)
    close.Size=UDim2.new(0,30,0,30)
    close.Position=UDim2.new(1,-40,0,10)
    close.Text="✕"
    close.TextColor3=Color3.fromRGB(255,80,80)
    close.BackgroundTransparency=1
    close.Font=Enum.Font.GothamBold

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Drag
    local dragging=false
    local dragStart,startPos

    top.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=i.Position
            startPos=main.Position
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local delta=i.Position-dragStart
            main.Position=UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset+delta.Y
            )
        end
    end)

    -- Animation
    TweenService:Create(main,TweenInfo.new(0.3),{
        Size=UDim2.new(0,650,0,420)
    }):Play()

    return main
end

return Library