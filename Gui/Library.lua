local Library = {}
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- [ Configuration & Palette ]
local Theme = {
    Main = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(0, 166, 255),
    Gradient1 = Color3.fromRGB(100, 80, 255),
    Gradient2 = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SecondaryText = Color3.fromRGB(160, 160, 160),
    Stroke = Color3.fromRGB(40, 40, 50)
}

-- [ Safe GUI Execution ]
local function GetSafeGui()
    local s = pcall(function() local _ = game:GetService("CoreGui").Name end)
    return s and game:GetService("CoreGui") or plr:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeGui()

-- Clean up
pcall(function()
    if SafeParent:FindFirstChild("NScannerUI") then SafeParent.NScannerUI:Destroy() end
    if SafeParent:FindFirstChild("NIntroUI") then SafeParent.NIntroUI:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "NScannerUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- [ Device Adaptive ]
local Viewport = Camera.ViewportSize
local IsMobile = Viewport.X <= 800
local MainSize = IsMobile and UDim2.new(0, 380, 0, 250) or UDim2.new(0, 520, 0, 360)
local TabWidth = IsMobile and 100 or 140

-- [ Utilities ]
local function MakeDraggable(DragPoint, TargetFrame)
    local dragging, dragInput, mousePos, framePos, isClick = false, nil, nil, nil, false
    DragPoint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; isClick = true; mousePos = input.Position; framePos = TargetFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            if delta.Magnitude > 5 then isClick = false end
            TargetFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    return function() return isClick end
end

local function ApplyGradient(parent)
    local grad = Instance.new("UIGradient", parent)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Gradient1),
        ColorSequenceKeypoint.new(1, Theme.Gradient2)
    })
    return grad
end

function Library:CreateWindow(windowName)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Main
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Visible = false; MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 1.5
    MainStroke.Color = Theme.Stroke
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- [ Header ]
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1
    local CheckClick = MakeDraggable(Header, MainFrame)

    local TitleText = Instance.new("TextLabel", Header)
    TitleText.Size = UDim2.new(1, -60, 1, 0); TitleText.Position = UDim2.new(0, 18, 0, 0)
    TitleText.BackgroundTransparency = 1; TitleText.Text = windowName or "N-SHINNEN"
    TitleText.TextColor3 = Color3.fromRGB(255,255,255); TitleText.Font = Enum.Font.GothamBlack; TitleText.TextSize = 16; TitleText.TextXAlignment = Enum.TextXAlignment.Left
    ApplyGradient(TitleText)

    -- [ Content Area ]
    local TabHolder = Instance.new("ScrollingFrame", MainFrame)
    TabHolder.Size = UDim2.new(0, TabWidth, 1, -60); TabHolder.Position = UDim2.new(0, 10, 0, 50)
    TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabHolder); TabList.Padding = UDim.new(0, 6)

    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -(TabWidth + 25), 1, -60); PageHolder.Position = UDim2.new(0, TabWidth + 15, 0, 50)
    PageHolder.BackgroundTransparency = 1

    -- [ Floating Button ]
    local Btn = Instance.new("TextButton", ScreenGui)
    Btn.Size = UDim2.new(0, 50, 0, 50); Btn.Position = UDim2.new(0.1, 0, 0.2, 0)
    Btn.BackgroundColor3 = Theme.Main; Btn.Text = "新"; Btn.Font = Enum.Font.GothamBlack; Btn.TextSize = 24; Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local BStroke = Instance.new("UIStroke", Btn); BStroke.Thickness = 2; ApplyGradient(BStroke)
    
    local isMenuOpen = false
    Btn.MouseButton1Click:Connect(function()
        isMenuOpen = not isMenuOpen
        if isMenuOpen then
            MainFrame.Visible = true
            TS:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = MainSize}):Play()
        else
            local tw = TS:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
            tw:Play(); tw.Completed:Connect(function() if not isMenuOpen then MainFrame.Visible = false end end)
        end
    end)
    MakeDraggable(Btn, Btn)

    -- [ API ]
    local TabEngine = {}
    local FirstTab = true

    function TabEngine:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, -5, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TabBtn.Text = name; TabBtn.TextColor3 = Theme.SecondaryText; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PageList = Instance.new("UIListLayout", Page); PageList.Padding = UDim.new(0, 10); PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local function Select()
            for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then TS:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,40), TextColor3 = Theme.SecondaryText}):Play() end end
            for _, v in pairs(PageHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
            TS:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if FirstTab then FirstTab = false; Select() end

        local Elements = {}
        function Elements:CreateSection(title)
            local SecFrame = Instance.new("Frame", Page)
            SecFrame.Size = UDim2.new(0.95, 0, 0, 30); SecFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35); SecFrame.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", SecFrame).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", SecFrame).Color = Color3.fromRGB(45, 45, 55)

            local SecTitle = Instance.new("TextLabel", SecFrame)
            SecTitle.Size = UDim2.new(1, 0, 0, 25); SecTitle.Position = UDim2.new(0, 12, 0, 5); SecTitle.Text = title; SecTitle.TextColor3 = Theme.Accent
            SecTitle.Font = Enum.Font.GothamBlack; SecTitle.TextSize = 12; SecTitle.TextXAlignment = Enum.TextXAlignment.Left; SecTitle.BackgroundTransparency = 1

            local Container = Instance.new("Frame", SecFrame)
            Container.Size = UDim2.new(1, 0, 0, 0); Container.Position = UDim2.new(0, 0, 0, 30); Container.AutomaticSize = Enum.AutomaticSize.Y; Container.BackgroundTransparency = 1
            Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5); Instance.new("UIPadding", Container).PaddingBottom = UDim.new(0, 10)

            local ItemLib = {}
            function ItemLib:CreateToggle(t_name, callback)
                local TFrame = Instance.new("TextButton", Container)
                TFrame.Size = UDim2.new(0.92, 0, 0, 38); TFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); TFrame.AutoButtonColor = false; TFrame.Text = ""
                Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 8)
                
                local Label = Instance.new("TextLabel", TFrame)
                Label.Size = UDim2.new(1, -50, 1, 0); Label.Position = UDim2.new(0, 12, 0, 0); Label.Text = t_name; Label.TextColor3 = Theme.Text; Label.Font = Enum.Font.GothamBold; Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.BackgroundTransparency = 1
                
                local Switch = Instance.new("Frame", TFrame)
                Switch.Size = UDim2.new(0, 34, 0, 18); Switch.Position = UDim2.new(1, -45, 0.5, -9); Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
                
                local Dot = Instance.new("Frame", Switch)
                Dot.Size = UDim2.new(0, 12, 0, 12); Dot.Position = UDim2.new(0, 3, 0.5, -6); Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

                local on = false
                TFrame.MouseButton1Click:Connect(function()
                    on = not on
                    TS:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = on and Theme.Accent or Color3.fromRGB(50, 50, 60)}):Play()
                    TS:Create(Dot, TweenInfo.new(0.2), {Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)}):Play()
                    callback(on)
                end)
            end

            function ItemLib:CreateButton(b_name, callback)
                local B = Instance.new("TextButton", Container)
                B.Size = UDim2.new(0.92, 0, 0, 35); B.BackgroundColor3 = Color3.fromRGB(45, 45, 55); B.Text = b_name; B.TextColor3 = Theme.Text; B.Font = Enum.Font.GothamBold; B.TextSize = 13
                Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
                B.MouseButton1Click:Connect(callback)
            end

            function ItemLib:CreateSlider(s_name, min, max, default, callback)
                local SFrame = Instance.new("Frame", Container); SFrame.Size = UDim2.new(0.92, 0, 0, 45); SFrame.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", SFrame); L.Text = s_name; L.Size = UDim2.new(1, 0, 0, 20); L.TextColor3 = Theme.Text; L.Font = Enum.Font.GothamBold; L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left; L.BackgroundTransparency = 1
                local V = Instance.new("TextLabel", SFrame); V.Text = tostring(default); V.Size = UDim2.new(1, 0, 0, 20); V.TextColor3 = Theme.Accent; V.Font = Enum.Font.GothamBold; V.TextSize = 12; V.TextXAlignment = Enum.TextXAlignment.Right; V.BackgroundTransparency = 1
                
                local Bar = Instance.new("Frame", SFrame); Bar.Size = UDim2.new(1, 0, 0, 6); Bar.Position = UDim2.new(0, 0, 1, -8); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60); Instance.new("UICorner", Bar)
                local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Fill)
                
                local dragging = false
                local function update(input)
                    local per = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * per)
                    Fill.Size = UDim2.new(per, 0, 1, 0); V.Text = tostring(val); callback(val)
                end
                Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
                UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
                UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            end

            return ItemLib
        end
        return Elements
    end

    -- [ Auto Open with Smooth Intro ]
    MainFrame.Visible = true
    TS:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Size = MainSize}):Play()
    
    return TabEngine
end

return Library
