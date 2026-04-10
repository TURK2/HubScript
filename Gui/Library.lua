-- [[ TURK-HUB V12: ULTIMATE MODERN UI + FIXED DRAG ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [ Cleanup ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V12" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(15, 15, 18), 
    Top = Color3.fromRGB(22, 22, 26), 
    Accent = Color3.fromRGB(0, 180, 255),
    Secondary = Color3.fromRGB(30, 30, 35), 
    Text = Color3.fromRGB(255, 255, 255), 
    TextSemi = Color3.fromRGB(160, 160, 165),
    Element = Color3.fromRGB(25, 25, 30), 
    Stroke = Color3.fromRGB(45, 45, 50)
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quint), goal):Play() 
end

-- [ Fixed Draggable Logic ]
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
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Library:CreateWindow(Config)
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V12"; Gui.IgnoreGuiInset = true
    local isMobile = UIS.TouchEnabled
    local UI_Size = isMobile and UDim2.new(0, 450, 0, 300) or UDim2.new(0, 600, 0, 400)

    -- [ Main UI ]
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MStr = Instance.new("UIStroke", Main); MStr.Color = Theme.Stroke; MStr.Thickness = 1.2

    -- [ Top Bar ]
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 45); Top.BackgroundColor3 = Theme.Top; MakeDraggable(Top, Main)
    local T = Instance.new("TextLabel", Top); T.Size = UDim2.new(1,-40,1,0); T.Position = UDim2.new(0,20,0,0); T.Text = Config.Name; T.TextColor3 = Theme.Accent; T.Font = "GothamBlack"; T.TextSize = 16; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1

    -- [[ MODERN TOGGLE BUTTON (MOBILE DRAG FIXED) ]]
    local TogF = Instance.new("Frame", Gui)
    TogF.Name = "MainToggle"; TogF.Size = UDim2.new(0, 55, 0, 55); TogF.Position = UDim2.new(0.05, 0, 0.2, 0)
    TogF.BackgroundColor3 = Theme.Main; Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0)
    local TStr = Instance.new("UIStroke", TogF); TStr.Color = Theme.Accent; TStr.Thickness = 2
    
    local TBtn = Instance.new("TextButton", TogF)
    TBtn.Size = UDim2.new(1,0,1,0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"; TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 24
    
    MakeDraggable(TBtn, TogF) -- ลากที่ปุ่ม ขยับที่กรอบ

    local open = true
    TBtn.MouseButton1Click:Connect(function()
        open = not open; Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)})
        Tween(TBtn, {TextColor3 = open and Theme.Accent or Theme.TextSemi})
    end)

    -- [ Layout ]
    local Side = Instance.new("ScrollingFrame", Main); Side.Size = UDim2.new(0, 150, 1, -60); Side.Position = UDim2.new(0, 10, 0, 50); Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 8)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -180, 1, -70); Container.Position = UDim2.new(0, 170, 0, 55); Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side); TabBtn.Size = UDim2.new(1, -10, 0, 38); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = "  "..name; TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13; TabBtn.TextXAlignment = "Left"; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 0; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) end end
            Page.Visible = true; Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main})
        end)
        if Tabs.First then Tabs.First = false; Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main end

        local E = {}
        
        -- [ MODERN BUTTON ]
        function E:CreateButton(D)
            local B = Instance.new("TextButton", Page); B.Size = UDim2.new(1, -10, 0, 42); B.BackgroundColor3 = Theme.Element; B.Text = D.Name; B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 13; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
            local BS = Instance.new("UIStroke", B); BS.Color = Theme.Stroke; BS.ApplyStrokeMode = "Border"
            B.MouseButton1Click:Connect(function() 
                Tween(B, {BackgroundColor3 = Theme.Accent}, 0.1); task.wait(0.1); Tween(B, {BackgroundColor3 = Theme.Element}, 0.1)
                D.Callback() 
            end)
        end

        -- [ MODERN TOGGLE ]
        function E:CreateToggle(D)
            local s = D.CurrentValue; Library.Flags[D.Flag] = s
            local T = Instance.new("TextButton", Page); T.Size = UDim2.new(1, -10, 0, 48); T.BackgroundColor3 = Theme.Element; T.Text = "     "..D.Name; T.TextColor3 = Theme.Text; T.Font = "GothamBold"; T.TextSize = 13; T.TextXAlignment = "Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", T).Color = Theme.Stroke
            
            local BG = Instance.new("Frame", T); BG.Size = UDim2.new(0, 40, 0, 22); BG.Position = UDim2.new(1, -50, 0.5, -11); BG.BackgroundColor3 = s and Theme.Accent or Theme.Secondary; Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)
            local Dt = Instance.new("Frame", BG); Dt.Size = UDim2.new(0, 16, 0, 16); Dt.Position = UDim2.new(s and 0.55 or 0.1, 0, 0.5, -8); Dt.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dt).CornerRadius = UDim.new(1, 0)
            
            T.MouseButton1Click:Connect(function()
                s = not s; Library.Flags[D.Flag] = s
                Tween(BG, {BackgroundColor3 = s and Theme.Accent or Theme.Secondary})
                Tween(Dt, {Position = UDim2.new(s and 0.55 or 0.1, 0, 0.5, -8)})
                D.Callback(s)
            end)
        end

        -- [ MODERN SLIDER ]
        function E:CreateSlider(D)
            local S = Instance.new("Frame", Page); S.Size = UDim2.new(1, -10, 0, 60); S.BackgroundColor3 = Theme.Element; Instance.new("UICorner", S).CornerRadius = UDim.new(0, 8)
            Instance.new("UIStroke", S).Color = Theme.Stroke
            
            local L = Instance.new("TextLabel", S); L.Size = UDim2.new(1, -20, 0, 30); L.Position = UDim2.new(0, 15, 0, 5); L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font = "GothamBold"; L.TextSize = 13; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
            local V = Instance.new("TextLabel", S); V.Size = UDim2.new(1, -20, 0, 30); V.Position = UDim2.new(0, 0, 0, 5); V.Text = tostring(D.CurrentValue); V.TextColor3 = Theme.Accent; V.Font = "GothamBold"; V.TextSize = 13; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1
            
            local B = Instance.new("Frame", S); B.Size = UDim2.new(0.9, 0, 0, 6); B.Position = UDim2.new(0.05, 0, 0.75, -5); B.BackgroundColor3 = Theme.Secondary; Instance.new("UICorner", B)
            local F = Instance.new("Frame", B); F.Size = UDim2.new((D.CurrentValue-D.Range[1])/(D.Range[2]-D.Range[1]), 0, 1, 0); F.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", F)
            local Knob = Instance.new("Frame", F); Knob.Size = UDim2.new(0, 12, 0, 12); Knob.Position = UDim2.new(1, -6, 0.5, -6); Knob.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local function Move(i)
                local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                local v = math.floor(((D.Range[2] - D.Range[1]) * p) + D.Range[1])
                Tween(F, {Size = UDim2.new(p, 0, 1, 0)}, 0.1); V.Text = tostring(v); D.Callback(v)
            end
            B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Move(i) end end)
        end

        return E
    end
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library
