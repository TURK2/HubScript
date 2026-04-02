local Lib={}

function Lib:CreateWindow(title)
    local CoreGui=game:GetService("CoreGui")
    local UIS=game:GetService("UserInputService")
    local RunService=game:GetService("RunService")
    local TweenService=game:GetService("TweenService")

    pcall(function()
        local old=CoreGui:FindFirstChild("NSHINNEN_UI")
        if old then old:Destroy() end
    end)

    local gui=Instance.new("ScreenGui",CoreGui)
    gui.Name="NSHINNEN_UI"

    local main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,420,0,270)
    main.Position=UDim2.new(0.5,-210,0.5,-135)
    main.BackgroundColor3=Color3.fromRGB(18,18,22)
    main.ClipsDescendants=true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

    local stroke=Instance.new("UIStroke",main)
    task.spawn(function()
        local h=0
        RunService.RenderStepped:Connect(function()
            h=(h+0.002)%1
            stroke.Color=Color3.fromHSV(h,0.7,1)
        end)
    end)

    local top=Instance.new("Frame",main)
    top.Size=UDim2.new(1,0,0,45)
    top.BackgroundColor3=Color3.fromRGB(12,12,16)
    Instance.new("UICorner",top).CornerRadius=UDim.new(0,12)

    local titleLbl=Instance.new("TextLabel",top)
    titleLbl.Size=UDim2.new(1,-60,1,0)
    titleLbl.Position=UDim2.new(0,12,0,0)
    titleLbl.BackgroundTransparency=1
    titleLbl.Text=title or "NSHINNEN"
    titleLbl.TextColor3=Color3.new(1,1,1)
    titleLbl.Font=Enum.Font.GothamBold
    titleLbl.TextSize=15
    titleLbl.TextXAlignment=Enum.TextXAlignment.Left

    local toggle=Instance.new("TextButton",top)
    toggle.Size=UDim2.new(0,30,0,30)
    toggle.Position=UDim2.new(1,-38,0,7)
    toggle.Text="-"
    toggle.BackgroundTransparency=1
    toggle.TextColor3=Color3.new(1,1,1)

    local content=Instance.new("Frame",main)
    content.Size=UDim2.new(1,0,1,-90)
    content.Position=UDim2.new(0,0,0,45)
    content.BackgroundTransparency=1

    local tabBar=Instance.new("ScrollingFrame",main)
    tabBar.Size=UDim2.new(1,0,0,45)
    tabBar.Position=UDim2.new(0,0,1,-45)
    tabBar.BackgroundColor3=Color3.fromRGB(12,12,16)
    tabBar.AutomaticCanvasSize=Enum.AutomaticSize.X
    tabBar.ScrollingDirection=Enum.ScrollingDirection.X
    tabBar.ScrollBarThickness=3
    Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,10)

    local layout=Instance.new("UIListLayout",tabBar)
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.Padding=UDim.new(0,8)

    local pages={}

    -- 🔥 CREATE TAB
    function Lib:CreateTab(name)
        local btn=Instance.new("TextButton",tabBar)
        btn.Size=UDim2.new(0,90,0,28)
        btn.Text=name
        btn.BackgroundColor3=Color3.fromRGB(30,30,35)
        btn.TextColor3=Color3.fromRGB(180,180,180)
        Instance.new("UICorner",btn)

        local page=Instance.new("ScrollingFrame",content)
        page.Size=UDim2.new(1,0,1,0)
        page.Visible=false
        page.AutomaticCanvasSize=Enum.AutomaticSize.Y

        local list=Instance.new("UIListLayout",page)
        list.Padding=UDim.new(0,6)

        pages[name]=page

        btn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages) do p.Visible=false end
            page.Visible=true
        end)

        local tab={}

        function tab:Button(text,callback)
            local b=Instance.new("TextButton",page)
            b.Size=UDim2.new(1,-10,0,32)
            b.Text=text
            b.BackgroundColor3=Color3.fromRGB(35,35,40)
            b.TextColor3=Color3.new(1,1,1)
            Instance.new("UICorner",b)
            b.MouseButton1Click:Connect(callback)
        end

        function tab:Toggle(text,callback)
            local state=false
            local b=Instance.new("TextButton",page)
            b.Size=UDim2.new(1,-10,0,32)
            b.Text=text.." : OFF"
            b.BackgroundColor3=Color3.fromRGB(35,35,40)
            b.TextColor3=Color3.new(1,1,1)
            Instance.new("UICorner",b)

            b.MouseButton1Click:Connect(function()
                state=not state
                b.Text=text.." : "..(state and "ON" or "OFF")
                callback(state)
            end)
        end

        function tab:Label(text)
            local l=Instance.new("TextLabel",page)
            l.Size=UDim2.new(1,-10,0,25)
            l.Text=text
            l.BackgroundTransparency=1
            l.TextColor3=Color3.fromRGB(180,180,180)
        end

        return tab
    end

    -- DRAG
    local dragging=false
    local dragStart,startPos

    top.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=i.Position
            startPos=main.Position
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

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)

    -- MINIMIZE
    local minimized=false
    toggle.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            content.Visible=false
            tabBar.Visible=false
            main.Size=UDim2.new(0,420,0,45)
        else
            main.Size=UDim2.new(0,420,0,270)
            content.Visible=true
            tabBar.Visible=true
        end
    end)

    return Lib
end

return Lib