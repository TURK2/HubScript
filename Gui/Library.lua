local MyLib = {}

function MyLib:CreateWindow(Config)
    local Title = Config.Name or "My UI Library"
    
    local cg = game:GetService("CoreGui")
    local uis = game:GetService("UserInputService")
    local ts = game:GetService("TweenService")

    -- ลบ GUI เก่า
    pcall(function() if cg:FindFirstChild("MyLibrary") then cg.MyLibrary:Destroy() end end)

    local gui = Instance.new("ScreenGui", cg); gui.Name = "MyLibrary"; gui.ResetOnSpawn = false
    
    -- Main Frame
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 450, 0, 300)
    main.Position = UDim2.new(0.5, -225, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    -- Top Bar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 40)
    top.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Instance.new("UICorner", top)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -60, 1, 0); title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = Title; title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"

    -- Sidebar (Tabs Area)
    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Size = UDim2.new(0, 110, 1, -45); sidebar.Position = UDim2.new(0, 5, 0, 45)
    sidebar.BackgroundTransparency = 1; sidebar.ScrollBarThickness = 0
    local sideLayout = Instance.new("UIListLayout", sidebar); sideLayout.Padding = UDim.new(0, 5)

    -- Container (Pages Area)
    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -125, 1, -45); container.Position = UDim2.new(0, 120, 0, 45); container.BackgroundTransparency = 1

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = main.Position end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    uis.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local Window = {}
    
    function Window:CreateTab(Name)
        local page = Instance.new("ScrollingFrame", container)
        page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; page.ScrollBarThickness = 2
        local pageLayout = Instance.new("UIListLayout", page); pageLayout.Padding = UDim.new(0, 6); pageLayout.HorizontalAlignment = "Center"

        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, 0, 0, 32); tabBtn.Text = Name; tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200); tabBtn.Font = "Gotham"; tabBtn.TextSize = 12
        Instance.new("UICorner", tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do v.Visible = false end
            page.Visible = true
        end)

        local Elements = {}

        -- Button Element
        function Elements:AddButton(text, callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(0.95, 0, 0, 35); btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamSemibold"; btn.TextSize = 12
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        -- Toggle Element
        function Elements:AddToggle(text, callback)
            local tglState = false
            local tgl = Instance.new("TextButton", page)
            tgl.Size = UDim2.new(0.95, 0, 0, 35); tgl.Text = text .. " : OFF"
            tgl.BackgroundColor3 = Color3.fromRGB(45, 30, 30); tgl.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", tgl)
            
            tgl.MouseButton1Click:Connect(function()
                tglState = not tglState
                tgl.Text = text .. (tglState and " : ON" or " : OFF")
                ts:Create(tgl, TweenInfo.new(0.2), {BackgroundColor3 = tglState and Color3.fromRGB(30, 45, 30) or Color3.fromRGB(45, 30, 30)}):Play()
                pcall(callback, tglState)
            end)
        end

        return Elements
    end

    -- ฟังก์ชันตั้งค่าพิเศษ (Theme)
    function Window:SetTheme(color, trans)
        ts:Create(main, TweenInfo.new(0.4), {BackgroundColor3 = color, BackgroundTransparency = trans}):Play()
    end

    return Window
end

---------------------------------------------------------
-- ใช้งานจริง (เหมือน Rayfield เป๊ะ!)
---------------------------------------------------------

local Window = MyLib:CreateWindow({
    Name = "RAYFIELD STYLE UI",
})

local MainTab = Window:CreateTab("Main")
local SettingTab = Window:CreateTab("Setting")

-- เพิ่มปุ่มในหน้า Main
MainTab:AddButton("Click Me!", function()
    print("Clicked!")
end)

MainTab:AddToggle("Auto Farm", function(state)
    print("Auto Farm is:", state)
end)

-- เพิ่มปุ่มในหน้า Setting เพื่อคุมความใสและสี
SettingTab:AddButton("Theme: Ocean", function()
    Window:SetTheme(Color3.fromRGB(20, 40, 70), 0)
end)

SettingTab:AddButton("Theme: Glass (50%)", function()
    Window:SetTheme(Color3.fromRGB(15, 15, 18), 0.5)
end)

SettingTab:AddButton("Theme: Default", function()
    Window:SetTheme(Color3.fromRGB(18, 18, 22), 0)
end)

