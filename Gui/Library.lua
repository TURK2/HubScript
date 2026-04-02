-- NShinnen Library (Rayfield Style)

local Library = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function Gradient(p)
    local g=Instance.new("UIGradient",p)
    g.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(138,43,226)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(0,191,255))
    }
end

function Library:CreateWindow(cfg)
    local CoreGui=game:GetService("CoreGui")

    pcall(function()
        if CoreGui:FindFirstChild("NShinnenUI") then
            CoreGui.NShinnenUI:Destroy()
        end
    end)

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="NShinnenUI"

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,650,0,420)
    main.Position=UDim2.new(0.5,-325,0.5,-210)
    main.BackgroundColor3=Color3.fromRGB(15,15,20)
    Instance.new("UICorner",main)

    -- RGB
    local stroke=Instance.new("UIStroke",main)
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

    local title=Instance.new("TextLabel",top)
    title.Size=UDim2.new(1,0,1,0)
    title.BackgroundTransparency=1
    title.Text=cfg.Title or "NShinnen UI"
    title.TextColor3=Color3.new(1,1,1)

    -- ปิด
    local close=Instance.new("TextButton",top)
    close.Size=UDim2.new(0,30,0,30)
    close.Position=UDim2.new(1,-35,0,10)
    close.Text="X"
    close.BackgroundTransparency=1
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Sidebar (Tab)
    local sidebar=Instance.new("Frame",main)
    sidebar.Size=UDim2.new(0,150,1,-50)
    sidebar.Position=UDim2.new(0,0,0,50)
    sidebar.BackgroundColor3=Color3.fromRGB(20,20,25)

    local container=Instance.new("Frame",main)
    container.Size=UDim2.new(1,-150,1,-50)
    container.Position=UDim2.new(0,150,0,50)
    container.BackgroundTransparency=1

    local tabs = {}

    function Library:CreateTab(name)
        local btn=Instance.new("TextButton",sidebar)
        btn.Size=UDim2.new(1,0,0,40)
        btn.Text=name
        btn.BackgroundColor3=Color3.fromRGB(30,30,35)

        local page=Instance.new("Frame",container)
        page.Size=UDim2.new(1,0,1,0)
        page.Visible=false

        local layout=Instance.new("UIListLayout",page)
        layout.Padding=UDim.new(0,5)

        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(container:GetChildren()) do
                if v:IsA("Frame") then v.Visible=false end
            end
            page.Visible=true
        end)

        tabs[name]=page
        return page
    end

    function Library:CreateButton(parent,text,callback)
        local btn=Instance.new("TextButton",parent)
        btn.Size=UDim2.new(1,0,0,40)
        btn.Text=text
        btn.BackgroundColor3=Color3.fromRGB(40,40,45)

        btn.MouseButton1Click:Connect(callback)
    end

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

    return Library
end

return Library