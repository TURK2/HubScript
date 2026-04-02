repeat task.wait() until game:IsLoaded()

local CoreGui=game:GetService("CoreGui")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")

pcall(function()
    if CoreGui:FindFirstChild("NShinnenLib") then
        CoreGui.NShinnenLib:Destroy()
    end
end)

local Lib={}

function Lib:CreateWindow(title)

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="NShinnenLib"

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,420,0,270)
    main.Position=UDim2.new(0.5,-210,0.5,-135)
    main.BackgroundColor3=Color3.fromRGB(20,20,25)
    main.ClipsDescendants=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,10)

    local stroke=Instance.new("UIStroke",main)
    task.spawn(function()
        local h=0
        RunService.RenderStepped:Connect(function()
            h=(h+0.003)%1
            stroke.Color=Color3.fromHSV(h,0.7,1)
        end)
    end)

    -- TOP
    local top=Instance.new("Frame",main)
    top.Size=UDim2.new(1,0,0,40)
    top.BackgroundColor3=Color3.fromRGB(15,15,20)
    Instance.new("UICorner",top).CornerRadius=UDim.new(0,10)

    local txt=Instance.new("TextLabel",top)
    txt.Size=UDim2.new(1,-60,1,0)
    txt.Position=UDim2.new(0,10,0,0)
    txt.BackgroundTransparency=1
    txt.Text=title or "UI"
    txt.TextColor3=Color3.new(1,1,1)
    txt.Font=Enum.Font.GothamBold
    txt.TextSize=14
    txt.TextXAlignment=Enum.TextXAlignment.Left

    local toggle=Instance.new("TextButton",top)
    toggle.Size=UDim2.new(0,30,0,30)
    toggle.Position=UDim2.new(1,-35,0,5)
    toggle.Text="-"
    toggle.BackgroundTransparency=1
    toggle.TextColor3=Color3.new(1,1,1)

    -- CONTENT
    local pages={}
    local content=Instance.new("Frame",main)
    content.Size=UDim2.new(1,0,1,-80)
    content.Position=UDim2.new(0,0,0,40)
    content.BackgroundTransparency=1

    -- TAB BAR
    local tabScroll=Instance.new("ScrollingFrame",main)
    tabScroll.Size=UDim2.new(1,0,0,40)
    tabScroll.Position=UDim2.new(0,0,1,-40)
    tabScroll.BackgroundColor3=Color3.fromRGB(15,15,20)
    tabScroll.ScrollBarThickness=0
    Instance.new("UICorner",tabScroll)

    local layout=Instance.new("UIListLayout",tabScroll)
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.Padding=UDim.new(0,8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize=UDim2.new(0,layout.AbsoluteContentSize.X+40,0,0)
    end)

    -- DRAG
    local dragging=false; local dragInput,dragStart,startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dragStart=i.Position; startPos=main.Position
        end
    end)
    top.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta=dragInput.Position-dragStart
            main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)

    -- MINIMIZE
    local minimized=false
    toggle.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            toggle.Text="+"
            tabScroll.Visible=false
            content.Visible=false
            TweenService:Create(main,TweenInfo.new(0.25),{Size=UDim2.new(0,420,0,40)}):Play()
        else
            toggle.Text="-"
            tabScroll.Visible=true
            content.Visible=true
            TweenService:Create(main,TweenInfo.new(0.25),{Size=UDim2.new(0,420,0,270)}):Play()
        end
    end)

    -- CREATE TAB
    function Lib:CreateTab(name)
        local page=Instance.new("ScrollingFrame",content)
        page.Size=UDim2.new(1,0,1,0)
        page.BackgroundTransparency=1
        page.ScrollBarThickness=3
        page.Visible=false

        local list=Instance.new("UIListLayout",page)
        list.Padding=UDim.new(0,6)

        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize=UDim2.new(0,0,0,list.AbsoluteContentSize.Y+10)
        end)

        table.insert(pages,page)

        local btn=Instance.new("TextButton",tabScroll)
        btn.Size=UDim2.new(0,110,0,28)
        btn.Text=name
        btn.BackgroundColor3=Color3.fromRGB(30,30,35)
        btn.TextColor3=Color3.fromRGB(200,200,255)
        btn.Font=Enum.Font.GothamBold
        btn.TextSize=12
        Instance.new("UICorner",btn)

        btn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages) do p.Visible=false end
            page.Visible=true
        end)

        local tab={}

        -- BUTTON
        function tab:Button(text,callback)
            local b=Instance.new("TextButton",page)
            b.Size=UDim2.new(1,-10,0,30)
            b.Text=text
            b.BackgroundColor3=Color3.fromRGB(35,35,45)
            b.TextColor3=Color3.new(1,1,1)
            b.Font=Enum.Font.GothamBold
            b.TextSize=12
            Instance.new("UICorner",b)

            b.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function tab:Toggle(text,callback)
            local t=false

            local holder=Instance.new("Frame",page)
            holder.Size=UDim2.new(1,-10,0,30)
            holder.BackgroundColor3=Color3.fromRGB(35,35,45)
            Instance.new("UICorner",holder)

            local label=Instance.new("TextLabel",holder)
            label.Size=UDim2.new(1,-40,1,0)
            label.Position=UDim2.new(0,10,0,0)
            label.BackgroundTransparency=1
            label.Text=text
            label.TextColor3=Color3.new(1,1,1)
            label.Font=Enum.Font.GothamBold
            label.TextSize=12
            label.TextXAlignment=Enum.TextXAlignment.Left

            local btn=Instance.new("TextButton",holder)
            btn.Size=UDim2.new(0,20,0,20)
            btn.Position=UDim2.new(1,-25,0.5,-10)
            btn.BackgroundColor3=Color3.fromRGB(60,60,60)
            btn.Text=""
            Instance.new("UICorner",btn)

            btn.MouseButton1Click:Connect(function()
                t=not t
                TweenService:Create(btn,TweenInfo.new(0.2),{
                    BackgroundColor3=t and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)
                }):Play()
                callback(t)
            end)
        end

        return tab
    end

    return Lib
end

return Lib