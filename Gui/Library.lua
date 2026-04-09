local Library = {}
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera

-- [ Safe GUI Execution ]
local function GetSafeGui()
    local s = pcall(function() local _ = game:GetService("CoreGui").Name end)
    return s and game:GetService("CoreGui") or plr:WaitForChild("PlayerGui")
end
local SafeParent = GetSafeGui()

-- Clean up old instances
pcall(function()
    if SafeParent:FindFirstChild("NScannerUI") then SafeParent.NScannerUI:Destroy() end
    if SafeParent:FindFirstChild("NIntroUI") then SafeParent.NIntroUI:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "NScannerUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- [ Responsive Device Detection ]
local Viewport = Camera.ViewportSize
local IsMobile = Viewport.X <= 800
local IsTablet = Viewport.X > 800 and Viewport.X <= 1100
local MainSize = IsMobile and UDim2.new(0, 400, 0, 260) or (IsTablet and UDim2.new(0, 480, 0, 320) or UDim2.new(0, 550, 0, 380))
local TabWidth = IsMobile and 110 or 130

-- [ Utilities ]
local function MakeDraggable(DragPoint, TargetFrame)
    local dragging, dragInput, mousePos, framePos, isClick = false, nil, nil, nil, false
    DragPoint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; isClick = true; mousePos = input.Position; framePos = TargetFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    DragPoint.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            if delta.Magnitude > 3 then isClick = false end
            TargetFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    return function() return isClick end
end

local function ApplyGradient(parent)
    local grad = Instance.new("UIGradient", parent)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
    })
    return grad
end

local function PlayProIntro(callback)
    task.spawn(function()
        local IntroGui = Instance.new("ScreenGui", SafeParent); IntroGui.Name = "NIntroUI"; IntroGui.DisplayOrder = 9999
        local Kanji = Instance.new("TextLabel", IntroGui)
        Kanji.Size = UDim2.new(0,0,0,0); Kanji.Position = UDim2.new(0.5,0,0.5,-20); Kanji.AnchorPoint = Vector2.new(0.5,0.5)
        Kanji.BackgroundTransparency = 1; Kanji.Text = "新"; Kanji.Font = Enum.Font.GothamBlack; Kanji.TextSize = 0; Kanji.TextColor3 = Color3.fromRGB(150, 50, 255); Kanji.TextTransparency = 1
        
        local NameTitle = Instance.new("TextLabel", IntroGui)  
        NameTitle.Size = UDim2.new(0,0,0,0); NameTitle.Position = UDim2.new(0.5,0,0.5,45); NameTitle.AnchorPoint = Vector2.new(0.5,0.5)  
        NameTitle.BackgroundTransparency = 1; NameTitle.Text = "N - S H I N N E N"; NameTitle.Font = Enum.Font.GothamBold; NameTitle.TextSize = 0; NameTitle.TextColor3 = Color3.fromRGB(255,255,255); NameTitle.TextTransparency = 1
        
        TS:Create(Kanji, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = 110, TextTransparency = 0}):Play()  
        task.wait(0.3); TS:Create(NameTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextSize = IsMobile and 18 or 24, TextTransparency = 0}):Play()  
        task.wait(1.5)  
        TS:Create(Kanji, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextSize = 150, TextTransparency = 1}):Play()  
        TS:Create(NameTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextSize = 30, TextTransparency = 1}):Play()  
        task.wait(0.5); IntroGui:Destroy(); if callback then callback() end  
    end)
end

local RGBStrokes = {}

function Library:CreateWindow(windowName)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Visible = false; MainFrame.Active = true; MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Thickness = 2  
    local MainGrad = ApplyGradient(MainStroke); table.insert(RGBStrokes, MainStroke)  

    -- [ Header ]
    local Header = Instance.new("Frame", MainFrame)  
    Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1  
    MakeDraggable(Header, MainFrame)  

    local TitleText = Instance.new("TextLabel", Header)  
    TitleText.Size = UDim2.new(1, -60, 1, 0); TitleText.Position = UDim2.new(0, 15, 0, 0)  
    TitleText.BackgroundTransparency = 1; TitleText.Text = windowName or "新 • N-SHINNEN"  
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255); TitleText.Font = Enum.Font.GothamBlack; TitleText.TextSize = 15; TitleText.TextXAlignment = Enum.TextXAlignment.Left

    local MinBtn = Instance.new("TextButton", Header)  
    MinBtn.Size = UDim2.new(0, 40, 1, 0); MinBtn.Position = UDim2.new(1, -40, 0, 0); MinBtn.BackgroundTransparency = 1  
    MinBtn.Text = "—"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 18  

    local isMinimized = false  
    MinBtn.MouseButton1Click:Connect(function()  
        isMinimized = not isMinimized  
        if isMinimized then  
            TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainSize.X.Offset, 0, 40)}):Play()  
        else  
            TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = MainSize}):Play()  
        end  
    end)  
-- [ UI Layout: Left Sidebar (Tabs) & Right Area (Pages) ]
    local Divider = Instance.new("Frame", MainFrame)
    Divider.Size = UDim2.new(1, -20, 0, 2); Divider.Position = UDim2.new(0, 10, 0, 40)
    Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Divider.BorderSizePixel = 0

    local TabHolder = Instance.new("ScrollingFrame", MainFrame)  
    TabHolder.Size = UDim2.new(0, TabWidth, 1, -50); TabHolder.Position = UDim2.new(0, 10, 0, 45)
    TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    TabHolder.ScrollingDirection = Enum.ScrollingDirection.Y
    TabHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Vertical; TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left

    local PageHolder = Instance.new("Frame", MainFrame)  
    PageHolder.Size = UDim2.new(1, -(TabWidth + 25), 1, -50); PageHolder.Position = UDim2.new(0, TabWidth + 15, 0, 45)
    PageHolder.BackgroundTransparency = 1  

    -- [ Toggle Button & Stealth ]
    local Btn = Instance.new("TextButton", ScreenGui)  
    Btn.Size = UDim2.new(0, 45, 0, 45); Btn.Position = UDim2.new(0.1, 0, 0.1, 0); Btn.AnchorPoint = Vector2.new(0.5, 0.5)  
    Btn.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Btn.Text = "新"; Btn.Font = Enum.Font.GothamBlack; Btn.TextSize = 22; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.BackgroundTransparency = 0.1  
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)   
    
    local BtnStroke = Instance.new("UIStroke", Btn); BtnStroke.Thickness = 2.5; table.insert(RGBStrokes, BtnStroke)  
    local SpinGrad = ApplyGradient(BtnStroke)   

    local hue = 0  
    RS.RenderStepped:Connect(function(dt)  
        hue = (hue + 0.15 * dt) % 1  
        local rgb = Color3.fromHSV(hue, 1, 1)  
        for _, stroke in pairs(RGBStrokes) do stroke.Color = rgb end  
        Btn.Rotation = (Btn.Rotation + 90 * dt) % 360   
        Btn.TextColor3 = rgb; TitleText.TextColor3 = rgb  
        SpinGrad.Rotation = (SpinGrad.Rotation + 150 * dt) % 360  
        MainGrad.Rotation = (MainGrad.Rotation + 50 * dt) % 360
    end)

    local CheckClick = MakeDraggable(Btn, Btn)  
    local isMenuOpen = false  

    Btn.InputEnded:Connect(function(input)  
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and CheckClick() then  
            isMenuOpen = not isMenuOpen  
            if isMenuOpen then  
                MainFrame.Visible = true; MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)   
                TS:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, MainSize.X.Offset, 0, 40) or MainSize}):Play()  
            else  
                local tw = TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})  
                tw:Play(); tw.Completed:Connect(function() if not isMenuOpen then MainFrame.Visible = false end end)  
            end  
        end  
    end)  

    local isStealth, VolUpPressed, VolDownPressed = false, false, false  
    local function ToggleStealth()  
        isStealth = not isStealth  
        if isStealth then  
            TS:Create(Btn, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1, TextTransparency = 1}):Play()  
            TS:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()  
            task.wait(0.3); Btn.Visible = false; MainFrame.Visible = false  
        else  
            Btn.Visible = true  
            TS:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,45,0,45), BackgroundTransparency = 0.1, TextTransparency = 0}):Play()  
            if isMenuOpen then  
                MainFrame.Visible = true  
                TS:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMinimized and UDim2.new(0, MainSize.X.Offset, 0, 40) or MainSize, BackgroundTransparency = 0.15}):Play()  
            end  
        end  
    end  

    UIS.InputBegan:Connect(function(input, gpe)  
        if input.KeyCode == Enum.KeyCode.VolumeUp then VolUpPressed = true end  
        if input.KeyCode == Enum.KeyCode.VolumeDown then VolDownPressed = true end  
        if not gpe and input.KeyCode == Enum.KeyCode.RightControl then ToggleStealth() end  
        if VolUpPressed and VolDownPressed then ToggleStealth(); task.wait(0.5) end  
    end)  
    UIS.InputEnded:Connect(function(input)  
        if input.KeyCode == Enum.KeyCode.VolumeUp then VolUpPressed = false end  
        if input.KeyCode == Enum.KeyCode.VolumeDown then VolDownPressed = false end  
    end)  

    PlayProIntro(function()  
        isMenuOpen = true; MainFrame.Visible = true; MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)  
        TS:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = MainSize}):Play()  
    end)  

-- [ API Engine ]
    local TabEngine = {}  
    local FirstTab = true  

    function TabEngine:CreateTab(name)  
        local TabBtn = Instance.new("TextButton", TabHolder)  
        TabBtn.Size = UDim2.new(1, 0, 0, 32)  
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)  
        TabBtn.BackgroundTransparency = 0.4  
        TabBtn.Text = tostring(name) -- ใช้ Text ธรรมดาแก้บัคอักษรหายล้านเปอร์เซ็นต์
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)  

        local Page = Instance.new("ScrollingFrame", PageHolder)  
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Color3.fromRGB(100,100,255)  
        Page.ScrollingDirection = Enum.ScrollingDirection.Y; Page.AutomaticCanvasSize = Enum.AutomaticSize.Y; Page.Visible = false  
        local PageList = Instance.new("UIListLayout", Page); PageList.Padding = UDim.new(0, 8); PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center  
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 2); Instance.new("UIPadding", Page).PaddingBottom = UDim.new(0, 10)  

        if FirstTab then   
            Page.Visible = true  
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 190, 255)  
            TabBtn.BackgroundTransparency = 0.2  
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
            FirstTab = false   
        end  

        TabBtn.MouseButton1Click:Connect(function()  
            for _, p in pairs(PageHolder:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end  
            for _, t in pairs(TabHolder:GetChildren()) do   
                if t:IsA("TextButton") then   
                    TS:Create(t, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), BackgroundTransparency = 0.4, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()   
                end
            end
            Page.Visible = true
            TS:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 190, 255), BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        local SectionEngine = {}  
        function SectionEngine:CreateSection(sec_name)  
            local SecFrame = Instance.new("Frame", Page)  
            SecFrame.Size = UDim2.new(0.98, 0, 0, 30); SecFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); SecFrame.BackgroundTransparency = 0.3; SecFrame.AutomaticSize = Enum.AutomaticSize.Y; Instance.new("UICorner", SecFrame).CornerRadius = UDim.new(0, 6)  
            local SecStroke = Instance.new("UIStroke", SecFrame); SecStroke.Thickness = 1; table.insert(RGBStrokes, SecStroke)  
            
            local TopLine = Instance.new("Frame", SecFrame); TopLine.Size = UDim2.new(1, 0, 0, 2); TopLine.BorderSizePixel = 0; Instance.new("UICorner", TopLine).CornerRadius = UDim.new(0, 6); ApplyGradient(TopLine)  
            local SecTitle = Instance.new("TextLabel", SecFrame); SecTitle.Size = UDim2.new(1, -20, 0, 25); SecTitle.Position = UDim2.new(0, 10, 0, 3); SecTitle.BackgroundTransparency = 1; SecTitle.Text = " " .. sec_name; SecTitle.TextColor3 = Color3.fromRGB(255, 255, 255); SecTitle.Font = Enum.Font.GothamBlack; SecTitle.TextSize = 13; SecTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ItemHolder = Instance.new("Frame", SecFrame); ItemHolder.Size = UDim2.new(1, 0, 0, 0); ItemHolder.Position = UDim2.new(0, 0, 0, 30); ItemHolder.BackgroundTransparency = 1; ItemHolder.AutomaticSize = Enum.AutomaticSize.Y  
            local ItemList = Instance.new("UIListLayout", ItemHolder); ItemList.Padding = UDim.new(0, 5); ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIPadding", ItemHolder).PaddingBottom = UDim.new(0, 8)  

            local Elements = {}  
            
            function Elements:CreateToggle(t_name, callback)  
                local TFrame = Instance.new("Frame", ItemHolder); TFrame.Size = UDim2.new(0.96, 0, 0, 35); TFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); TFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 6)  
                local TText = Instance.new("TextLabel", TFrame); TText.Size = UDim2.new(1, -70, 1, 0); TText.Position = UDim2.new(0, 12, 0, 0); TText.BackgroundTransparency = 1; TText.Text = t_name; TText.TextColor3 = Color3.fromRGB(255, 255, 255); TText.TextXAlignment = Enum.TextXAlignment.Left; TText.Font = Enum.Font.GothamBold; TText.TextSize = 12
                local TBtn = Instance.new("TextButton", TFrame); TBtn.Size = UDim2.new(0, 45, 0, 22); TBtn.Position = UDim2.new(1, -55, 0.5, -11); TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50); TBtn.Text = "OFF"; TBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 11; Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)  
                
                local on = false  
                TBtn.MouseButton1Click:Connect(function()  
                    on = not on; TS:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = on and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 45, 50)}):Play()  
                    TBtn.Text = on and "ON" or "OFF"; TBtn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150); callback(on)  
                end)  
            end  

            function Elements:CreateInput(i_name, placeholder, callback)  
                local IFrame = Instance.new("Frame", ItemHolder); IFrame.Size = UDim2.new(0.96, 0, 0, 35); IFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); IFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", IFrame).CornerRadius = UDim.new(0, 6)  
                local IText = Instance.new("TextLabel", IFrame); IText.Size = UDim2.new(0.4, 0, 1, 0); IText.Position = UDim2.new(0, 12, 0, 0); IText.BackgroundTransparency = 1; IText.Text = i_name; IText.TextColor3 = Color3.fromRGB(255, 255, 255); IText.TextXAlignment = Enum.TextXAlignment.Left; IText.Font = Enum.Font.GothamBold; IText.TextSize = 12
                local IBox = Instance.new("TextBox", IFrame); IBox.Size = UDim2.new(0.55, -5, 0, 24); IBox.Position = UDim2.new(1, -5, 0.5, -12); IBox.AnchorPoint = Vector2.new(1, 0); IBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25); IBox.TextColor3 = Color3.fromRGB(255, 255, 255); IBox.Text = ""; IBox.PlaceholderText = placeholder; IBox.Font = Enum.Font.GothamBold; IBox.TextSize = 11; Instance.new("UICorner", IBox).CornerRadius = UDim.new(0, 6)  
                IBox.FocusLost:Connect(function() callback(IBox.Text) end)  
            end  
            function Elements:CreateSlider(s_name, min, max, default, callback)  
                local SFrame = Instance.new("Frame", ItemHolder); SFrame.Size = UDim2.new(0.96, 0, 0, 45); SFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 6)  
                local SText = Instance.new("TextLabel", SFrame); SText.Size = UDim2.new(0.5, 0, 0, 20); SText.Position = UDim2.new(0, 12, 0, 3); SText.BackgroundTransparency = 1; SText.Text = s_name; SText.TextColor3 = Color3.fromRGB(255, 255, 255); SText.TextXAlignment = Enum.TextXAlignment.Left; SText.Font = Enum.Font.GothamBold; SText.TextSize = 12
                local ValueTxt = Instance.new("TextLabel", SFrame); ValueTxt.Size = UDim2.new(0.5, 0, 0, 20); ValueTxt.Position = UDim2.new(0.5, -12, 0, 3); ValueTxt.BackgroundTransparency = 1; ValueTxt.Text = tostring(default); ValueTxt.TextColor3 = Color3.fromRGB(0, 190, 255); ValueTxt.TextXAlignment = Enum.TextXAlignment.Right; ValueTxt.Font = Enum.Font.GothamBold; ValueTxt.TextSize = 12  
                local BarBG = Instance.new("Frame", SFrame); BarBG.Size = UDim2.new(1, -24, 0, 6); BarBG.Position = UDim2.new(0, 12, 1, -10); BarBG.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)  
                local Fill = Instance.new("Frame", BarBG); Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255); Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)  
                
                local dragging = false  
                local function move(input)  
                    local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)  
                    local val = math.floor(min + ((max - min) * pos))  
                    TS:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play(); ValueTxt.Text = tostring(val); callback(val)  
                end  
                BarBG.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; move(input) end end)  
                UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then move(input) end end)  
                UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)  
            end  

            function Elements:CreateDropdown(d_name, options, callback)  
                local DFrame = Instance.new("Frame", ItemHolder); DFrame.Size = UDim2.new(0.96, 0, 0, 35); DFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); DFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", DFrame).CornerRadius = UDim.new(0, 6)  
                local DText = Instance.new("TextLabel", DFrame); DText.Size = UDim2.new(0.4, 0, 1, 0); DText.Position = UDim2.new(0, 12, 0, 0); DText.BackgroundTransparency = 1; DText.Text = d_name; DText.TextColor3 = Color3.fromRGB(255, 255, 255); DText.TextXAlignment = Enum.TextXAlignment.Left; DText.Font = Enum.Font.GothamBold; DText.TextSize = 12
                local DBtn = Instance.new("TextButton", DFrame); DBtn.Size = UDim2.new(0.55, -5, 0, 24); DBtn.Position = UDim2.new(1, -5, 0.5, -12); DBtn.AnchorPoint = Vector2.new(1, 0); DBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); DBtn.Text = options[1] or "Select"; DBtn.TextColor3 = Color3.fromRGB(0, 190, 255); DBtn.Font = Enum.Font.GothamBold; DBtn.TextSize = 11; Instance.new("UICorner", DBtn).CornerRadius = UDim.new(0, 6)  
                
                local index = 1  
                DBtn.MouseButton1Click:Connect(function()  
                    index = index + 1; if index > #options then index = 1 end  
                    DBtn.Text = options[index]; callback(options[index])  
                end)  
            end  
return Elements  
        end  
        return SectionEngine  
    end  
    return TabEngine
end

return Library