-- [[ TURK-HUB V11: RAYFIELD STYLE + MOBILE DRAG FIXED ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [ Cleanup ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V11" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(12, 12, 15), Top = Color3.fromRGB(20, 20, 25), Accent = Color3.fromRGB(0, 180, 255),
    Secondary = Color3.fromRGB(25, 25, 30), Text = Color3.fromRGB(255, 255, 255), TextSemi = Color3.fromRGB(180, 180, 180),
    Element = Color3.fromRGB(22, 22, 28), Error = Color3.fromRGB(255, 80, 80)
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quint), goal):Play() 
end

-- [ Improved Draggable Logic ]
local function MakeDraggable(obj, target)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = target.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(Config)
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V11"; Gui.IgnoreGuiInset = true
    
    local View = workspace.CurrentCamera.ViewportSize
    local isMobile = UIS.TouchEnabled
    local UI_Size = isMobile and UDim2.new(0, 430, 0, 280) or UDim2.new(0, 580, 0, 380)

    -- [ Main Frame ]
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14); local MStr = Instance.new("UIStroke", Main); MStr.Color = Color3.fromRGB(40, 40, 45)
    
    -- [ Top Bar ]
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 45); Top.BackgroundColor3 = Theme.Top; Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14); MakeDraggable(Top, Main)
    local T = Instance.new("TextLabel", Top); T.Size = UDim2.new(1,-40,1,0); T.Position = UDim2.new(0,20,0,0); T.Text = Config.Name; T.TextColor3 = Theme.Accent; T.Font = "GothamBlack"; T.TextSize = 15; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1

    -- [[ FIXED TOGGLE BUTTON (MOBILE DRAG OK) ]]
    local TogF = Instance.new("Frame", Gui)
    TogF.Name = "MainToggle"; TogF.Size = UDim2.new(0, 50, 0, 50); TogF.Position = UDim2.new(0.05, 0, 0.15, 0)
    TogF.BackgroundColor3 = Theme.Main; Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0)
    local TogStr = Instance.new("UIStroke", TogF); TogStr.Color = Theme.Accent; TogStr.Thickness = 2
    
    local TBtn = Instance.new("TextButton", TogF)
    TBtn.Size = UDim2.new(1, 0, 1, 0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"
    TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 22
    
    -- ลากที่ TBtn แต่ให้เลื่อนทั้ง TogF
    MakeDraggable(TBtn, TogF)

    local open = true
    TBtn.MouseButton1Click:Connect(function()
        if not dragging then -- ป้องกันการเปิด/ปิดตอนกำลังลาก
            open = not open; Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)})
            Tween(TBtn, {TextColor3 = open and Theme.Accent or Theme.TextSemi})
        end
    end)

    -- [ Content Area ]
    local Side = Instance.new("ScrollingFrame", Main); Side.Size = UDim2.new(0, 140, 1, -55); Side.Position = UDim2.new(0, 10, 0, 50); Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 8)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -65); Container.Position = UDim2.new(0, 160, 0, 55); Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side); TabBtn.Size = UDim2.new(1, -10, 0, 36); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = name; TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 12; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) end end
            Page.Visible = true; Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main})
        end)
        if Tabs.First then Tabs.First = false; Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main end

        local E = {}
        -- [[ RAYFIELD STYLE ELEMENTS ]]
        
        function E:CreateButton(D)
            local B = Instance.new("TextButton", Page); B.Size = UDim2.new(1, -10, 0, 40); B.BackgroundColor3 = Theme.Element; B.Text = D.Name; B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 12; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
            B.MouseButton1Click:Connect(D.Callback)
        end

        function E:CreateToggle(D)
            local s = D.CurrentValue; Library.Flags[D.Flag] = s
            local T = Instance.new("TextButton", Page); T.Size = UDim2.new(1, -10, 0, 45); T.BackgroundColor3 = Theme.Element; T.Text = "   "..D.Name; T.TextColor3 = Theme.Text; T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
            local BG = Instance.new("Frame", T); BG.Size = UDim2.new(0, 36, 0, 20); BG.Position = UDim2.new(1, -46, 0.5, -10); BG.BackgroundColor3 = s and Theme.Accent or Theme.Secondary; Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)
            local Dt = Instance.new("Frame", BG); Dt.Size = UDim2.new(0, 14, 0, 14); Dt.Position = UDim2.new(s and 0.55 or 0.1, 0, 0.5, -7); Dt.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dt).CornerRadius = UDim.new(1, 0)
            
            local function Up() 
                Tween(BG, {BackgroundColor3 = s and Theme.Accent or Theme.Secondary}); 
                Tween(Dt, {Position = UDim2.new(s and 0.55 or 0.1, 0, 0.5, -7)}); 
                Library.Flags[D.Flag] = s; D.Callback(s) 
            end
            T.MouseButton1Click:Connect(function() s = not s; Up() end)
        end

        function E:CreateSlider(D)
            local S = Instance.new("Frame", Page); S.Size = UDim2.new(1, -10, 0, 55); S.BackgroundColor3 = Theme.Element; Instance.new("UICorner", S).CornerRadius = UDim.new(0, 8)
            local L = Instance.new("TextLabel", S); L.Size = UDim2.new(1, -20, 0, 30); L.Position = UDim2.new(0, 15, 0, 0); L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font = "GothamBold"; L.TextSize = 12; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
            local V = Instance.new("TextLabel", S); V.Size = UDim2.new(1, -20, 0, 30); V.Text = tostring(D.CurrentValue); V.TextColor3 = Theme.Accent; V.Font = "GothamBold"; V.TextSize = 12; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1
            local B = Instance.new("Frame", S); B.Size = UDim2.new(0.9, 0, 0, 4); B.Position = UDim2.new(0.05, 0, 0.75, 0); B.BackgroundColor3 = Theme.Secondary; Instance.new("UICorner", B)
            local F = Instance.new("Frame", B); F.Size = UDim2.new((D.CurrentValue-D.Range[1])/(D.Range[2]-D.Range[1]), 0, 1, 0); F.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", F)
            
            local function Move(i)
                local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                local v = math.floor(((D.Range[2] - D.Range[1]) * p) + D.Range[1])
                Tween(F, {Size = UDim2.new(p, 0, 1, 0)}, 0.1); V.Text = tostring(v); D.Callback(v)
            end
            B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Move(i) end end)
        end

        function E:CreateInput(D)
            local I = Instance.new("Frame", Page); I.Size = UDim2.new(1, -10, 0, 45); I.BackgroundColor3 = Theme.Element; Instance.new("UICorner", I).CornerRadius = UDim.new(0, 8)
            local T = Instance.new("TextBox", I); T.Size = UDim2.new(1, -20, 1, -10); T.Position = UDim2.new(0, 10, 0, 5); T.BackgroundTransparency = 1; T.Text = ""; T.PlaceholderText = D.PlaceholderText; T.TextColor3 = Theme.Text; T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"
            T.FocusLost:Connect(function() D.Callback(T.Text) end)
        end

        return E
    end
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library
