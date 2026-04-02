-- [[ 1. ส่วนของ LIBRARY (ห้ามลบ) ]] --
local MyLib = {}

function MyLib:CreateWindow(Config)
    local WindowName = Config.Name or "UI Library"
    local cg = game:GetService("CoreGui")
    local uis = game:GetService("UserInputService")
    local ts = game:GetService("TweenService")

    -- ลบของเก่าออกก่อน
    for _, v in pairs(cg:GetChildren()) do
        if v.Name == "MyUI_Fixed" then v:Destroy() end
    end

    local gui = Instance.new("ScreenGui", cg); gui.Name = "MyUI_Fixed"; gui.ResetOnSpawn = false
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 450, 0, 300); main.Position = UDim2.new(0.5, -225, 0.5, -150)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 22); main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 40); top.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Instance.new("UICorner", top)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -50, 1, 0); title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = WindowName; title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = "GothamBold"; title.TextSize = 14; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"

    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Size = UDim2.new(0, 110, 1, -45); sidebar.Position = UDim2.new(0, 5, 0, 45)
    sidebar.BackgroundTransparency = 1; sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)

    local container = Instance.new("Frame", main)
    container.Size = UDim2.new(1, -125, 1, -45); container.Position = UDim2.new(0, 120, 0, 45); container.BackgroundTransparency = 1

    -- ระบบลาก (Drag)
    local dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position; startPos = main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragStart = nil end end)
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragStart and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Window = {}
    function Window:CreateTab(Name)
        local page = Instance.new("ScrollingFrame", container)
        page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1; page.ScrollBarThickness = 0
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 6)

        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, 0, 0, 32); tabBtn.Text = Name; tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        tabBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8); tabBtn.Font = "Gotham"; tabBtn.TextSize = 12
        Instance.new("UICorner", tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(container:GetChildren()) do v.Visible = false end
            page.Visible = true
        end)
        if #sidebar:GetChildren() == 2 then page.Visible = true end -- หน้าแรกเปิดอัตโนมัติ

        local Elements = {}
        function Elements:AddButton(txt, callback)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(0.95, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamSemibold"; b.TextSize = 12
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() pcall(callback) end)
        end
        return Elements
    end

    function Window:SetTheme(color, trans)
        ts:Create(main, TweenInfo.new(0.4), {BackgroundColor3 = color, BackgroundTransparency = trans}):Play()
    end

    return Window
end

-- [[ 2. วิธีใช้งาน (แบบ Rayfield) ]] --

local Window = MyLib:CreateWindow({
    Name = "MY PREMIUM HUB"
})

local MainTab = Window:CreateTab("Main")
local SettingTab = Window:CreateTab("Setting")

-- เพิ่มปุ่มในหน้า Main
MainTab:AddButton("Hello World!", function()
    print("ปุ่มทำงานแล้ว!")
end)

-- เพิ่มปุ่มตั้งค่าในหน้า Setting
SettingTab:AddButton("Ghost Mode (50%)", function()
    Window:SetTheme(Color3.fromRGB(15, 15, 18), 0.5)
end)

SettingTab:AddButton("Default Dark", function()
    Window:SetTheme(Color3.fromRGB(18, 18, 22), 0)
end)
