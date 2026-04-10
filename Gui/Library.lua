-- [[ TURK-HUB V10: AESTHETIC & RESPONSIVE ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer

-- [ Cleanup ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V10" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(10, 10, 12), 
    Top = Color3.fromRGB(18, 18, 22), 
    Accent = Color3.fromRGB(0, 180, 255),
    Secondary = Color3.fromRGB(25, 25, 30),
    Text = Color3.fromRGB(255, 255, 255), 
    TextSemi = Color3.fromRGB(180, 180, 180),
    Element = Color3.fromRGB(22, 22, 28),
    Error = Color3.fromRGB(255, 80, 80)
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal):Play() 
end

-- [ Draggable System ]
local function MakeDraggable(dragPart, target)
    local dragging, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
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
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V10"; Gui.IgnoreGuiInset = true
    
    -- [ Responsive Size Calculation ]
    local View = workspace.CurrentCamera.ViewportSize
    local isMobile = UIS.TouchEnabled
    local MainWidth = isMobile and math.min(View.X * 0.9, 420) or 580
    local MainHeight = isMobile and math.min(View.Y * 0.8, 280) or 380
    local UI_Size = UDim2.new(0, MainWidth, 0, MainHeight)

    -- [ Main Frame ]
    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Main
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(45, 45, 50); MainStroke.Thickness = 1.5

    -- [ Top Bar ]
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 45)
    Top.BackgroundColor3 = Theme.Top
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)
    MakeDraggable(Top, Main)

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Text = Config.Name; Title.TextColor3 = Theme.Accent; Title.Font = "GothamBlack"
    Title.TextSize = 15; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

    -- [ Toggle Button (Mobile Friendly) ]
    local TogF = Instance.new("Frame", Gui)
    TogF.Size = UDim2.new(0, 45, 0, 45)
    TogF.Position = UDim2.new(0.05, 0, 0.15, 0)
    TogF.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0)
    local TSrt = Instance.new("UIStroke", TogF); TSrt.Color = Theme.Accent; TSrt.Thickness = 2
    
    local TBtn = Instance.new("TextButton", TogF)
    TBtn.Size = UDim2.new(1, 0, 1, 0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"
    TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 20
    MakeDraggable(TogF, TogF)

    local open = true
    TBtn.MouseButton1Click:Connect(function()
        open = not open
        Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)})
        Tween(TogF, {BackgroundColor3 = open and Theme.Main or Theme.Accent})
        TBtn.TextColor3 = open and Theme.Accent or Theme.Main
    end)

    -- [ Layout ]
    local Side = Instance.new("ScrollingFrame", Main)
    Side.Size = UDim2.new(0, 140, 1, -55)
    Side.Position = UDim2.new(0, 10, 0, 50)
    Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 8)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -170, 1, -65)
    Container.Position = UDim2.new(0, 160, 0, 55)
    Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side)
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = name
        TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then 
                Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) 
            end end
            Page.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main})
        end)

        if Tabs.First then 
            Tabs.First = false; Page.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main
        end

        local Elements = {}
        
        -- [[ Button ]]
        function Elements:CreateButton(D)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 40)
            B.BackgroundColor3 = Theme.Element; B.Text = D.Name
            B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 13
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
            
            B.MouseButton1Down:Connect(function() Tween(B, {Size = UDim2.new(1, -15, 0, 36)}, 0.1) end)
            B.MouseButton1Up:Connect(function() Tween(B, {Size = UDim2.new(1, -10, 0, 40)}, 0.1); D.Callback() end)
            return {Set = function(_, t) B.Text = t end}
        end

        -- [[ Toggle ]]
        function Elements:CreateToggle(D)
            local s = D.CurrentValue or false
            Library.Flags[D.Flag] = s
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -10, 0, 45); T.BackgroundColor3 = Theme.Element
            T.Text = "   "..D.Name; T.TextColor3 = Theme.Text; T.Font = "GothamBold"
            T.TextSize = 13; T.TextXAlignment = "Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)
            
            local BG = Instance.new("Frame", T)
            BG.Size = UDim2.new(0, 34, 0, 18); BG.Position = UDim2.new(1, -44, 0.5, -9)
            BG.BackgroundColor3 = s and Theme.Accent or Color3.fromRGB(50, 50, 60)
            Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)
            
            local Dot = Instance.new("Frame", BG)
            Dot.Size = UDim2.new(0, 12, 0, 12); Dot.Position = UDim2.new(s and 0.6 or 0.1, 0, 0.5, -6)
            Dot.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local function Update()
                Tween(BG, {BackgroundColor3 = s and Theme.Accent or Color3.fromRGB(50, 50, 60)})
                Tween(Dot, {Position = UDim2.new(s and 0.55 or 0.1, 0, 0.5, -6)})
                Library.Flags[D.Flag] = s; D.Callback(s)
            end
            T.MouseButton1Click:Connect(function() s = not s; Update() end)
            return {Set = function(_, v) s = v; Update() end}
        end

        -- [[ Slider ]]
        function Elements:CreateSlider(D)
            local S = Instance.new("Frame", Page)
            S.Size = UDim2.new(1, -10, 0, 55); S.BackgroundColor3 = Theme.Element
            Instance.new("UICorner", S).CornerRadius = UDim.new(0, 8)
            
            local L = Instance.new("TextLabel", S)
            L.Size = UDim2.new(1, -20, 0, 30); L.Position = UDim2.new(0, 15, 0, 0)
            L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font = "GothamBold"; L.TextSize = 13
            L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
            
            local V = Instance.new("TextLabel", S)
            V.Size = UDim2.new(1, -20, 0, 30); V.Position = UDim2.new(0, 0, 0, 0)
            V.Text = tostring(D.CurrentValue); V.TextColor3 = Theme.Accent; V.Font = "GothamBold"
            V.TextSize = 13; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1

            local Bar = Instance.new("Frame", S)
            Bar.Size = UDim2.new(0.9, 0, 0, 5); Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55); Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((D.CurrentValue - D.Range[1]) / (D.Range[2] - D.Range[1]), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Fill)

            local function Move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(((D.Range[2] - D.Range[1]) * pos) + D.Range[1])
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                V.Text = tostring(val)..(D.Suffix or ""); D.Callback(val)
            end
            Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Move(i) end end)
            return {Set = function(_, v) Move({Position = {X = Bar.AbsolutePosition.X + ((v-D.Range[1])/(D.Range[2]-D.Range[1])*Bar.AbsoluteSize.X)}}) end}
        end

        return Elements
    end
    
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library
