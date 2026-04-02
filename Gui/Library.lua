repeat task.wait() until game:IsLoaded()

local CoreGui=game:GetService("CoreGui")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")

pcall(function()
    if CoreGui:FindFirstChild("V2UI") then
        CoreGui.V2UI:Destroy()
    end
end)

local Lib={}

function Lib:CreateWindow(title)

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="V2UI"

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,420,0,270)
    main.Position=UDim2.new(0.5,-210,0.5,-135)
    main.BackgroundColor3=Color3.fromRGB(20,20,25)
    main.ClipsDescendants=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,10)

    -- TOP
    local top=Instance.new("Frame",main)
    top.Size=UDim2.new(1,0,0,40)
    top.BackgroundColor3=Color3.fromRGB(15,15,20)
    Instance.new("UICorner",top).CornerRadius=UDim.new(0,10)

    local txt=Instance.new("TextLabel",top)
    txt.Size=UDim2.new(1,-60,1,0)
    txt.Position=UDim2.new(0,10,0,0)
    txt.BackgroundTransparency=1
    txt.Text=title
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
    layout.VerticalAlignment=Enum.VerticalAlignment.Center
    layout.Padding=UDim.new(0,8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize=UDim2.new(0,layout.AbsoluteContentSize.X+40,0,0)
    end)

    -- DRAG
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

    -- TAB
    function Lib:CreateTab(name)

        local page=Instance.new("ScrollingFrame",content)
        page.Size=UDim2.new(1,0,1,0)
        page.BackgroundTransparency=1
        page.ScrollBarThickness=3
        page.Visible=false

        local list=Instance.new("UIListLayout",page)
        list.Padding=UDim.new(0,8)
        list.HorizontalAlignment=Enum.HorizontalAlignment.Center

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
            b.Size=UDim2.new(0.9,0,0,32)
            b.Text=text
            b.BackgroundColor3=Color3.fromRGB(35,35,45)
            b.TextColor3=Color3.new(1,1,1)
            b.Font=Enum.Font.GothamBold
            b.TextSize=13
            Instance.new("UICorner",b)

            b.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function tab:Toggle(text,callback)
            local state=false

            local holder=Instance.new("Frame",page)
            holder.Size=UDim2.new(0.9,0,0,32)
            holder.BackgroundColor3=Color3.fromRGB(35,35,45)
            Instance.new("UICorner",holder)

            local label=Instance.new("TextLabel",holder)
            label.Size=UDim2.new(1,-40,1,0)
            label.Position=UDim2.new(0,10,0,0)
            label.BackgroundTransparency=1
            label.Text=text
            label.TextColor3=Color3.new(1,1,1)
            label.Font=Enum.Font.GothamBold
            label.TextSize=13
            label.TextXAlignment=Enum.TextXAlignment.Left

            local btn=Instance.new("TextButton",holder)
            btn.Size=UDim2.new(0,22,0,22)
            btn.Position=UDim2.new(1,-28,0.5,-11)
            btn.BackgroundColor3=Color3.fromRGB(60,60,60)
            btn.Text=""
            Instance.new("UICorner",btn)

            btn.MouseButton1Click:Connect(function()
                state=not state
                TweenService:Create(btn,TweenInfo.new(0.2),{
                    BackgroundColor3=state and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)
                }):Play()
                callback(state)
            end)
        end

        -- SLIDER 🔥
        function tab:Slider(text,min,max,default,callback)
            local val=default or min

            local holder=Instance.new("Frame",page)
            holder.Size=UDim2.new(0.9,0,0,40)
            holder.BackgroundColor3=Color3.fromRGB(35,35,45)
            Instance.new("UICorner",holder)

            local label=Instance.new("TextLabel",holder)
            label.Size=UDim2.new(1,0,0,15)
            label.BackgroundTransparency=1
            label.Text=text.." : "..val
            label.TextColor3=Color3.new(1,1,1)
            label.Font=Enum.Font.GothamBold
            label.TextSize=12

            local bar=Instance.new("Frame",holder)
            bar.Size=UDim2.new(1,-20,0,6)
            bar.Position=UDim2.new(0,10,1,-15)
            bar.BackgroundColor3=Color3.fromRGB(50,50,60)
            Instance.new("UICorner",bar)

            local fill=Instance.new("Frame",bar)
            fill.Size=UDim2.new((val-min)/(max-min),0,1,0)
            fill.BackgroundColor3=Color3.fromRGB(0,170,255)
            Instance.new("UICorner",fill)

            local dragging=false

            bar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
            end)

            UIS.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
            end)

            UIS.InputChanged:Connect(function(i)
                if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local pos=(i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
                    pos=math.clamp(pos,0,1)

                    fill.Size=UDim2.new(pos,0,1,0)

                    val=math.floor((min+(max-min)*pos))
                    label.Text=text.." : "..val

                    callback(val)
                end
            end)
        end

        return tab
    end

    return Lib
end

return Lib