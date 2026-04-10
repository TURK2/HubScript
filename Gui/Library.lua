-- [[ TURK-HUB V13: ULTIMATE NEON GLASS LIBRARY ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer
local Mouse = plr:GetMouse()

-- [ Cleanup ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V13" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(10, 10, 12), 
    Top = Color3.fromRGB(15, 15, 18), 
    Accent = Color3.fromRGB(0, 200, 255),
    Secondary = Color3.fromRGB(20, 20, 25), 
    Text = Color3.fromRGB(255, 255, 255), 
    TextSemi = Color3.fromRGB(150, 150, 155),
    Element = Color3.fromRGB(25, 25, 30), 
    Stroke = Color3.fromRGB(40, 40, 45),
    Section = Color3.fromRGB(0, 200, 255)
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quint), goal):Play() 
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
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V13"; Gui.IgnoreGuiInset = true
    local isMobile = UIS.TouchEnabled
    local UI_Size = isMobile and UDim2.new(0, 460, 0, 320) or UDim2.new(0, 620, 0, 420)

    -- [ Main UI ]
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12); Instance.new("UIStroke", Main).Color = Theme.Stroke

    -- [ Top Bar ]
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 45); Top.BackgroundColor3 = Theme.Top; MakeDraggable(Top, Main)
    local T = Instance.new("TextLabel", Top); T.Size = UDim2.new(1,-40,1,0); T.Position = UDim2.new(0,20,0,0); T.Text = Config.Name; T.TextColor3 = Theme.Accent; T.Font = "GothamBlack"; T.TextSize = 16; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1

    -- [ Mobile Toggle Button ]
    local TogF = Instance.new("Frame", Gui); TogF.Size = UDim2.new(0, 50, 0, 50); TogF.Position = UDim2.new(0.05, 0, 0.1, 0); TogF.BackgroundColor3 = Theme.Main; Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", TogF).Color = Theme.Accent
    local TBtn = Instance.new("TextButton", TogF); TBtn.Size = UDim2.new(1,0,1,0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"; TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 22; MakeDraggable(TBtn, TogF)
    
    local open = true
    TBtn.MouseButton1Click:Connect(function()
        open = not open; Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)})
    end)

    -- [ Sidebar ]
    local Side = Instance.new("ScrollingFrame", Main); Side.Size = UDim2.new(0, 150, 1, -60); Side.Position = UDim2.new(0, 10, 0, 50); Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 6)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -180, 1, -65); Container.Position = UDim2.new(0, 170, 0, 55); Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side); TabBtn.Size = UDim2.new(1, -10, 0, 36); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = "  "..name; TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 12; TabBtn.TextXAlignment = "Left"; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 0; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) end end
            Page.Visible = true; Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main})
        end)
        if Tabs.First then Tabs.First = false; Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main end

        local E = {}

        -- [[ 1. SECTION ]]
        function E:CreateSection(name)
            local SL = Instance.new("TextLabel", Page); SL.Size = UDim2.new(1, -10, 0, 25); SL.Text = "——  "..name:upper(); SL.TextColor3 = Theme.Accent; SL.Font = "GothamBlack"; SL.TextSize = 11; SL.TextXAlignment = "Left"; SL.BackgroundTransparency = 1
        end

        -- [[ 2. BUTTON ]]
        function E:CreateButton(D)
            local B = Instance.new("TextButton", Page); B.Size = UDim2.new(1, -10, 0, 40); B.BackgroundColor3 = Theme.Element; B.Text = D.Name; B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 13; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", B).Color = Theme.Stroke
            B.MouseButton1Click:Connect(D.Callback)
        end

        -- [[ 3. TOGGLE ]]
        function E:CreateToggle(D)
            local s = D.CurrentValue; local T = Instance.new("TextButton", Page); T.Size = UDim2.new(1,-10,0,45); T.BackgroundColor3 = Theme.Element; T.Text = "    "..D.Name; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize=13; T.TextXAlignment="Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", T).Color = Theme.Stroke
            local BG = Instance.new("Frame", T); BG.Size = UDim2.new(0,38,0,20); BG.Position = UDim2.new(1,-48,0.5,-10); BG.BackgroundColor3 = s and Theme.Accent or Theme.Secondary; Instance.new("UICorner", BG).CornerRadius = UDim.new(1,0)
            local Dt = Instance.new("Frame", BG); Dt.Size = UDim2.new(0,16,0,16); Dt.Position = UDim2.new(s and 0.52 or 0.08,0,0.5,-8); Dt.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dt).CornerRadius = UDim.new(1,0)
            T.MouseButton1Click:Connect(function() s = not s; Tween(BG, {BackgroundColor3 = s and Theme.Accent or Theme.Secondary}); Tween(Dt, {Position = UDim2.new(s and 0.52 or 0.08, 0, 0.5, -8)}); D.Callback(s) end)
        end

        -- [[ 4. SLIDER ]]
        function E:CreateSlider(D)
            local S = Instance.new("Frame", Page); S.Size = UDim2.new(1,-10,0,55); S.BackgroundColor3 = Theme.Element; Instance.new("UICorner", S).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", S).Color = Theme.Stroke
            local L = Instance.new("TextLabel", S); L.Size = UDim2.new(1,-20,0,30); L.Position = UDim2.new(0,15,0,2); L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font="GothamBold"; L.TextSize=12; L.TextXAlignment="Left"; L.BackgroundTransparency = 1
            local V = Instance.new("TextLabel", S); V.Size = UDim2.new(1,-20,0,30); V.Position = UDim2.new(0,0,0,2); V.Text = tostring(D.CurrentValue); V.TextColor3 = Theme.Accent; V.Font="GothamBold"; V.TextSize=12; V.TextXAlignment="Right"; V.BackgroundTransparency = 1
            local B = Instance.new("Frame", S); B.Size = UDim2.new(0.9,0,0,4); B.Position = UDim2.new(0.05,0,0.75,0); B.BackgroundColor3 = Theme.Secondary; Instance.new("UICorner", B)
            local F = Instance.new("Frame", B); F.Size = UDim2.new((D.CurrentValue-D.Range[1])/(D.Range[2]-D.Range[1]),0,1,0); F.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", F)
            B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local v = math.floor(((D.Range[2]-D.Range[1])*p)+D.Range[1]); Tween(F, {Size = UDim2.new(p,0,1,0)}, 0.1); V.Text = tostring(v); D.Callback(v) end end)
        end

        -- [[ 5. INPUT ]]
        function E:CreateInput(D)
            local I = Instance.new("Frame", Page); I.Size = UDim2.new(1,-10,0,45); I.BackgroundColor3 = Theme.Element; Instance.new("UICorner", I).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", I).Color = Theme.Stroke
            local T = Instance.new("TextBox", I); T.Size = UDim2.new(1,-20,1,0); T.Position = UDim2.new(0,15,0,0); T.BackgroundTransparency = 1; T.PlaceholderText = D.Name.."..."; T.Text = ""; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"
            T.FocusLost:Connect(function() D.Callback(T.Text) end)
        end

        -- [[ 6. DROPDOWN ]]
        function E:CreateDropdown(D)
            local drop = {Open = false}
            local DF = Instance.new("Frame", Page); DF.Size = UDim2.new(1,-10,0,45); DF.BackgroundColor3 = Theme.Element; DF.ClipsDescendants = true; Instance.new("UICorner", DF).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", DF).Color = Theme.Stroke
            local DT = Instance.new("TextButton", DF); DT.Size = UDim2.new(1,0,0,45); DT.BackgroundTransparency = 1; DT.Text = "    "..D.Name; DT.TextColor3 = Theme.Text; DT.Font="GothamBold"; DT.TextSize=13; DT.TextXAlignment="Left"
            local List = Instance.new("Frame", DF); List.Size = UDim2.new(1,0,0,#D.Options*30); List.Position = UDim2.new(0,0,0,45); List.BackgroundTransparency = 1
            local LLayout = Instance.new("UIListLayout", List); LLayout.Padding = UDim.new(0,2)

            for _, opt in pairs(D.Options) do
                local OB = Instance.new("TextButton", List); OB.Size = UDim2.new(1,0,0,28); OB.BackgroundTransparency = 1; OB.Text = opt; OB.TextColor3 = Theme.TextSemi; OB.Font="GothamBold"; OB.TextSize=12; OB.MouseButton1Click:Connect(function() DT.Text = "    "..D.Name..": "..opt; drop.Open = false; Tween(DF, {Size = UDim2.new(1,-10,0,45)}); D.Callback(opt) end)
            end
            DT.MouseButton1Click:Connect(function() drop.Open = not drop.Open; Tween(DF, {Size = drop.Open and UDim2.new(1,-10,0,45+(#D.Options*30)) or UDim2.new(1,-10,0,45)}) end)
        end

        -- [[ 7. COLOR PICKER ]]
        function E:CreateColorPicker(D)
            local CP = Instance.new("Frame", Page); CP.Size = UDim2.new(1,-10,0,45); CP.BackgroundColor3 = Theme.Element; Instance.new("UICorner", CP).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", CP).Color = Theme.Stroke
            local CT = Instance.new("TextLabel", CP); CT.Size = UDim2.new(1,0,1,0); CT.Position = UDim2.new(0,15,0,0); CT.BackgroundTransparency = 1; CT.Text = D.Name; CT.TextColor3 = Theme.Text; CT.Font="GothamBold"; CT.TextSize=13; CT.TextXAlignment="Left"
            local Box = Instance.new("TextButton", CP); Box.Size = UDim2.new(0,35,0,20); Box.Position = UDim2.new(1,-48,0.5,-10); Box.BackgroundColor3 = D.Default; Instance.new("UICorner", Box).CornerRadius = UDim.new(0,4)
            Box.MouseButton1Click:Connect(function() 
                local randColor = Color3.fromHSV(math.random(), 1, 1)
                Box.BackgroundColor3 = randColor; D.Callback(randColor)
            end)
        end

        return E
    end
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library
