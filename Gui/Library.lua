-- NShinnenLib

local Library = {}

function Library:CreateWindow(title)
    local CoreGui=game:GetService("CoreGui")
    local UIS=game:GetService("UserInputService")

    -- ลบของเก่า
    pcall(function()
        if CoreGui:FindFirstChild("NShinnenUI") then
            CoreGui.NShinnenUI:Destroy()
        end
    end)

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="NShinnenUI"

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,400,0,250)
    main.Position=UDim2.new(0.5,-200,0.5,-125)
    main.BackgroundColor3=Color3.fromRGB(20,20,25)
    Instance.new("UICorner",main)

    local top=Instance.new("Frame",main)
    top.Size=UDim2.new(1,0,0,40)
    top.BackgroundColor3=Color3.fromRGB(30,30,35)

    local txt=Instance.new("TextLabel",top)
    txt.Size=UDim2.new(1,0,1,0)
    txt.BackgroundTransparency=1
    txt.Text=title or "NShinnen UI"
    txt.TextColor3=Color3.new(1,1,1)
    txt.Font=Enum.Font.GothamBold
    txt.TextSize=14

    -- ปิด
    local close=Instance.new("TextButton",top)
    close.Size=UDim2.new(0,30,1,0)
    close.Position=UDim2.new(1,-30,0,0)
    close.Text="X"
    close.BackgroundTransparency=1
    close.TextColor3=Color3.fromRGB(255,80,80)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Drag
    local dragging=false
    local dragStart,startPos

    top.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=i.Position
            startPos=main.Position
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position-dragStart
            main.Position=UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset+delta.Y
            )
        end
    end)

    return main
end

return Library