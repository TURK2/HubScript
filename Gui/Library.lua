local MyLib = {}

function MyLib:CreateWindow(Config)
    local WindowName = Config.Name or "My UI Library"
    
    local cg = game:GetService("CoreGui")
    local uis = game:GetService("UserInputService")
    local ts = game:GetService("TweenService")

    -- ลบ GUI เก่าถ้ามีชื่อซ้ำ
    pcall(function() if cg:FindFirstChild("MyUI_Lib") then cg.MyUI_Lib:Destroy() end end)

    local gui = Instance.new("ScreenGui", cg)
    gui.Name = "MyUI_Lib"
    gui.ResetOnSpawn = false

    -- MAIN FRAME
    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, 450, 0, 300)
    main.Position = UDim2.new(0.5, -225, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    -- TOP BAR
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 42)
    top.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Instance.new("UICorner", top)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = WindowName
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left

    local togBtn = Instance.new("TextButton", top)
    togBtn.Size = UDim2.new(0, 30, 0, 30)
    togBtn.Position = UDim2.new(1, -38, 0, 6)
    togBtn.Text = "-"
    togBtn.BackgroundTransparency = 1
    togBtn.TextColor3 = Color3.new(1, 1, 1)
    togBtn.TextSize = 20
    togBtn.Font = Enum.Font.GothamBold

    -- SIDEBAR (Tab Buttons)
    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Size = UDim2.new(0, 110, 1, -45)
    sidebar.Position = UDim2.new(0, 5, 0, 45)
    sidebar.BackgroundTransparency = 1
    sidebar.ScrollBarThickness = 0
    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0, 5)

    -- CONTAINER (Pages)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -125, 1, -45)
    container.Position = UDim2.new(0, 120, 0, 45)
    container.BackgroundTransparency = 1

    -- DRAGGING
    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    uis.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- MINIMIZE
    local mini = false
    togBtn.MouseButton1Click:Connect(function()
        mini = not mini
        togBtn.Text = mini and "+" or "-"
        container.Visible = not mini
        sidebar.Visible = not mini
        ts:Create(main, TweenInfo.new(0.3), {Size = mini and UDim2.new(0, 450, 0, 42) or UDim2.new(0, 450, 0, 300)}):Play()
    end)

    local Window = {}

    function Window:CreateTab(Name)
        local page = Instance.new("ScrollingFrame", container)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = false
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 2
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.Text = Name
        tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 12
        Instance.new("UICorner", tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do v.Visible = false end
            page.Visible = true
        end)

        local Elements = {}

        -- สร้างปุ่ม
        function Elements:CreateButton(text, callback)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(0.95, 0, 0, 35)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamSemibold
            b.TextSize = 12
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        -- สร้าง Toggle
        function Elements:CreateToggle(text, callback)
            local state = false
            local t = Instance.new("TextButton", page)
            t.Size = UDim2.new(0.95, 0, 0, 35)
            t.Text = text .. " : OFF"
            t.BackgroundColor3 = Color3.fromRGB(45, 30, 30)
            t.TextColor3 = Color3.new(1, 1, 1)
            t.Font = Enum.Font.GothamSemibold
            Instance.new("UICorner", t)

            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = text .. (state and " : ON" or " : OFF")
                ts:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(30, 45, 30) or Color3.fromRGB(45, 30, 30)}):Play()
                pcall(callback, state)
            end)
        end

        -- สร้าง Label (ข้อความโชว์)
        function Elements:CreateLabel(text)
            local l = Instance.new("TextLabel", page)
            l.Size = UDim2.new(0.95, 0, 0, 25)
            l.Text = text
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.fromRGB(180, 180, 180)
            l.Font = Enum.Font.Gotham
            l.TextSize = 11
        end

        return Elements
    end

    -- ฟังชั่นพิเศษสำหรับ Setting (เปลี่ยนสี UI)
    function Window:SetTheme(color, trans)
        ts:Create(main, TweenInfo.new(0.4), {BackgroundColor3 = color, BackgroundTransparency = trans}):Play()
    end

    return Window
end

return MyLib
