-- [[ TURK-HUB V15: COSMIC GLASS & ADAPTIVE NEON PRO ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer
local Mouse = plr:GetMouse()

-- [ Cleanup ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V15" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(10, 10, 14), -- ดำ Cosmic
    Top = Color3.fromRGB(15, 15, 20), 
    Accent = Color3.fromRGB(0, 230, 255), -- ฟ้า Neon
    AccentDark = Color3.fromRGB(0, 100, 150), -- น้ำเงินเข้ม (สำหรับ Gradient)
    Secondary = Color3.fromRGB(20, 20, 28), 
    Text = Color3.fromRGB(255, 255, 255), 
    TextSemi = Color3.fromRGB(170, 170, 175),
    Element = Color3.fromRGB(22, 22, 30), 
    Stroke = Color3.fromRGB(40, 40, 50),
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal):Play() 
end

local function MakeDraggable(obj, target)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = target.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

function Library:CreateWindow(Config)
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V15"; Gui.IgnoreGuiInset = true
    
    -- [[ 🛠️ RESPONSIVE SCALING LOGIC (ขนาดกลางพอดีทุกอุปกรณ์) ]] --
    local View = workspace.CurrentCamera.ViewportSize
    local isMobile = UIS.TouchEnabled
    
    -- คำนวณขนาดหน้าต่างแบบ Adaptive
    local MainWidth, MainHeight
    if isMobile then
        -- สำหรับมือถือ: ใช้ 85% ของความกว้างหน้าจอ แต่ไม่เกิน 480px
        MainWidth = math.min(View.X * 0.85, 480)
        -- สูง 70% ของหน้าจอ แต่ไม่เกิน 320px
        MainHeight = math.min(View.Y * 0.70, 320)
    else
        -- สำหรับคอม/แท็บเล็ตใหญ่: ใช้ขนาดสมดุลกลางๆ
        MainWidth = math.min(View.X * 0.50, 620) -- ไม่เกิน 620px
        MainHeight = math.min(View.Y * 0.55, 400) -- ไม่เกิน 400px
    end
    
    local UI_Size = UDim2.new(0, MainWidth, 0, MainHeight)
    local open = true

    -- [ Main UI: Cosmic Glass Effect ]
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.ClipsDescendants = true; Main.BackgroundTransparency = 0.08
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14); local MStr = Instance.new("UIStroke", Main); MStr.Color = Theme.Stroke; MStr.Thickness = 1.2
    
    -- [ Top Bar: Neon Gradient ]
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 48); Top.BackgroundColor3 = Color3.new(1,1,1); MakeDraggable(Top, Main)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14); local TStr = Instance.new("UIStroke", Top); TStr.Color = Theme.Stroke; TStr.Thickness = 1
    local UIGrad = Instance.new("UIGradient", Top); UIGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Theme.AccentDark)})
    
    local T = Instance.new("TextLabel", Top); T.Size = UDim2.new(1,-50,1,0); T.Position = UDim2.new(0,25,0,0); T.Text = Config.Name; T.TextColor3 = Theme.Text; T.Font = "GothamBlack"; T.TextSize = isMobile and 16 or 18; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1

    -- [[ MODERN TOGGLE BUTTON (MOBILE DRAG OK & GLOW) ]]
    local TogF = Instance.new("Frame", Gui); TogF.Size = UDim2.new(0, 52, 0, 52); TogF.Position = UDim2.new(0.05, 0, 0.15, 0); TogF.BackgroundColor3 = Theme.Main; Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0); local TogStr = Instance.new("UIStroke", TogF); TogStr.Color = Theme.Accent; TogStr.Thickness = 2.5
    local TBtn = Instance.new("TextButton", TogF); TBtn.Size = UDim2.new(1,0,1,0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"; TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 26; MakeDraggable(TBtn, TogF)
    
    TBtn.MouseButton1Click:Connect(function() open = not open; Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)}); Tween(TBtn, {TextColor3 = open and Theme.Accent or Theme.TextSemi}) end)

    -- [ Content Layout ]
    local Side = Instance.new("ScrollingFrame", Main); Side.Size = UDim2.new(0, 160, 1, -65); Side.Position = UDim2.new(0, 12, 0, 58); Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 6)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -190, 1, -75); Container.Position = UDim2.new(0, 182, 0, 62); Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side); TabBtn.Size = UDim2.new(1, -10, 0, 40); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = "  "..name; TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13; TabBtn.TextXAlignment = "Left"; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12); Page.CanvasSize = UDim2.new(0,0,0,0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PL = Page:FindFirstChildWhichIsA("UIListLayout")

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) end end
            Page.Visible = true; Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}); task.wait(); PL:ApplyLayout()
        end)
        if Tabs.First then Tabs.First = false; Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main end

        local E = {}
        -- [[ ULTRA AESTHETIC ELEMENTS ]]
        
        -- [ 1. SECTION: Neon Line Glow ]
        function E:CreateSection(name)
            local S_H = Instance.new("Frame", Page); S_H.Size = UDim2.new(1, -10, 0, 28); S_H.BackgroundTransparency = 1
            local SL = Instance.new("TextLabel", S_H); SL.Size = UDim2.new(1,0,1,0); SL.Text = name:upper(); SL.TextColor3 = Theme.Accent; SL.Font = "GothamBlack"; SL.TextSize = 13; SL.TextXAlignment = "Left"; SL.BackgroundTransparency = 1
            local Line = Instance.new("Frame", S_H); Line.Size = UDim2.new(1,-4,0,2.5); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Line).CornerRadius = UDim.new(1,0); local LS = Instance.new("UIStroke", Line); LS.Color = Theme.Accent; LS.Thickness = 1.5; LS.Transparency = 0.5
            task.wait(); PL:ApplyLayout()
        end

        -- [ 2. BUTTON: Full Neon Glow ]
        function E:CreateButton(D)
            local B = Instance.new("TextButton", Page); B.Size = UDim2.new(1, -10, 0, 44); B.BackgroundColor3 = Theme.Element; B.Text = D.Name; B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 14; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8); local BStr = Instance.new("UIStroke", B); BStr.Color = Theme.Stroke; BStr.Thickness = 1.2
            B.MouseButton1Down:Connect(function() Tween(BStr, {Color = Theme.Accent, Thickness = 2}, 0.1); Tween(B, {BackgroundColor3 = Theme.Secondary}, 0.1) end)
            B.MouseButton1Up:Connect(function() Tween(BStr, {Color = Theme.Stroke, Thickness = 1.2}, 0.1); Tween(B, {BackgroundColor3 = Theme.Element}, 0.1); D.Callback() end)
            task.wait(); PL:ApplyLayout()
        end

        -- [ 3. TOGGLE: Cosmic Glow Animation ]
        function E:CreateToggle(D)
            local s = D.CurrentValue; Library.Flags[D.Flag] = s; local T = Instance.new("TextButton", Page); T.Size = UDim2.new(1,-10,0,50); T.BackgroundColor3 = Theme.Element; T.Text = "       "..D.Name; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize=14; T.TextXAlignment="Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0,8); local TStr = Instance.new("UIStroke", T); TStr.Color = Theme.Stroke
            local BG = Instance.new("Frame", T); BG.Size = UDim2.new(0,42,0,24); BG.Position = UDim2.new(1,-54,0.5,-12); BG.BackgroundColor3 = s and Theme.Accent or Theme.Secondary; Instance.new("UICorner", BG).CornerRadius = UDim.new(1,0); local BGStr = Instance.new("UIStroke", BG); BGStr.Color = Theme.Accent; BGStr.Thickness = 1.8; BGStr.Transparency = s and 0.2 or 1
            local Dt = Instance.new("Frame", BG); Dt.Size = UDim2.new(0,18,0,18); Dt.Position = UDim2.new(s and 0.52 or 0.1,0,0.5,-9); Dt.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dt).CornerRadius = UDim.new(1,0)
            T.MouseButton1Click:Connect(function() s = not s; Library.Flags[D.Flag] = s; Tween(BG, {BackgroundColor3 = s and Theme.Accent or Theme.Secondary}); Tween(Dt, {Position = UDim2.new(s and 0.52 or 0.1, 0, 0.5, -9)}); Tween(BGStr, {Transparency = s and 0.2 or 1}); D.Callback(s) end)
            task.wait(); PL:ApplyLayout()
        end

        -- [ 4. SLIDER: Neon Line & Cosmic Knob ]
        function E:CreateSlider(D)
            local S = Instance.new("Frame", Page); S.Size = UDim2.new(1,-10,0,65); S.BackgroundColor3 = Theme.Element; Instance.new("UICorner", S).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", S).Color = Theme.Stroke
            local L = Instance.new("TextLabel", S); L.Size = UDim2.new(1,-20,0,30); L.Position = UDim2.new(0,18,0,5); L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font="GothamBold"; L.TextSize=13; L.TextXAlignment="Left"; L.BackgroundTransparency = 1
            local V = Instance.new("TextLabel", S); V.Size = UDim2.new(1,-20,0,30); V.Position = UDim2.new(0,0,0,5); V.Text = D.CurrentValue..(D.Suffix or ""); V.TextColor3 = Theme.Accent; V.Font="GothamBold"; V.TextSize=13; V.TextXAlignment="Right"; V.BackgroundTransparency = 1
            local B = Instance.new("Frame", S); B.Size = UDim2.new(0.92,0,0,7); B.Position = UDim2.new(0.04,0,0.80,-5); B.BackgroundColor3 = Theme.Secondary; Instance.new("UICorner", B); Instance.new("UIStroke", B).Color = Theme.Stroke
            local F = Instance.new("Frame", B); F.Size = UDim2.new((D.CurrentValue-D.Range[1])/(D.Range[2]-D.Range[1]),0,1,0); F.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", F); local FS = Instance.new("UIStroke", F); FS.Color = Theme.Accent; FS.Thickness = 1.5; FS.Transparency = 0.4
            local Knob = Instance.new("Frame", F); Knob.Size = UDim2.new(0,16,0,16); Knob.Position = UDim2.new(1,-8,0.5,-8); Knob.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Knob).Color = Theme.Accent; Instance.new("UIStroke", Knob).Thickness = 1.5
            local isSliding = false; B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isSliding = true; local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local v = math.floor(((D.Range[2]-D.Range[1])*p)+D.Range[1]); Tween(F, {Size = UDim2.new(p,0,1,0)}, 0.1); V.Text = tostring(v)..(D.Suffix or ""); D.Callback(v) end end)
            UIS.InputChanged:Connect(function(i) if isSliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local v = math.floor(((D.Range[2]-D.Range[1])*p)+D.Range[1]); Tween(F, {Size = UDim2.new(p,0,1,0)}, 0.1); V.Text = tostring(v)..(D.Suffix or ""); D.Callback(v) end end)
            UIS.InputEnded:Connect(function(i) if isSliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then isSliding = false end end)
            task.wait(); PL:ApplyLayout()
        end

        -- [ 5. INPUT: Glass Style ]
        function E:CreateInput(D)
            local I = Instance.new("Frame", Page); I.Size = UDim2.new(1,-10,0,50); I.BackgroundColor3 = Theme.Element; Instance.new("UICorner", I).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", I).Color = Theme.Stroke
            local T = Instance.new("TextBox", I); T.Size = UDim2.new(1,-30,1,0); T.Position = UDim2.new(0,15,0,0); T.BackgroundTransparency = 1; T.PlaceholderText = D.Name.." [Type Here]"; T.Text = ""; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize = 13; T.TextXAlignment = "Left"; T.PlaceholderColor3 = Theme.TextSemi
            T.FocusLost:Connect(function() Tween(I, {BackgroundColor3 = Theme.Element}, 0.2); D.Callback(T.Text) end); T.Focused:Connect(function() Tween(I, {BackgroundColor3 = Theme.Secondary}, 0.2) end)
            task.wait(); PL:ApplyLayout()
        end

        return E
    end
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library