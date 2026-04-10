-- [[ TURK-HUB V14: NEON ULTRA GLOSS LIBRARY | FIXED FRAME & STYLE ]] --
local Library = {Flags = {}, Keybinds = {}}
local TS, UIS, plr = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("Players").LocalPlayer
local Mouse = plr:GetMouse()

-- [ Cleanup: ลบของเก่าก่อนรันใหม่ ]
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "TURK_V14" then v:Destroy() end end

local Theme = {
    Main = Color3.fromRGB(8, 8, 10), -- ดำเข้มเกือบสนิท
    Top = Color3.fromRGB(12, 12, 15), -- เทาเข้ม
    Accent = Color3.fromRGB(0, 230, 255), -- ฟ้า Neon สว่างสุดๆ
    Secondary = Color3.fromRGB(18, 18, 22), 
    Text = Color3.fromRGB(255, 255, 255), 
    TextSemi = Color3.fromRGB(160, 160, 165),
    Element = Color3.fromRGB(20, 20, 25), -- ปรับให้กลมกลืนกับ Main
    Stroke = Color3.fromRGB(35, 35, 40),
}

local function Tween(obj, goal, t) 
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal):Play() 
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
    local Gui = Instance.new("ScreenGui", game:GetService("CoreGui")); Gui.Name = "TURK_V14"; Gui.IgnoreGuiInset = true
    local isMobile = UIS.TouchEnabled
    local UI_Size = isMobile and UDim2.new(0, 480, 0, 340) or UDim2.new(0, 650, 0, 450)

    -- [ Main UI: ปรับให้ดูเป็นแก้ว Glow ๆ ]
    local Main = Instance.new("Frame", Gui); Main.Size = UDim2.new(0, 0, 0, 0); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Theme.Main; Main.ClipsDescendants = true; Main.BackgroundTransparency = 0.05 -- เพิ่มความโปร่งแสงนิดหน่อย
    local MCorner = Instance.new("UICorner", Main); MCorner.CornerRadius = UDim.new(0, 14); local MStr = Instance.new("UIStroke", Main); MStr.Color = Theme.Stroke; MStr.Thickness = 1.2
    
    -- [ Top Bar ]
    local Top = Instance.new("Frame", Main); Top.Size = UDim2.new(1, 0, 0, 48); Top.BackgroundColor3 = Theme.Top; MakeDraggable(Top, Main)
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14); local TStr = Instance.new("UIStroke", Top); TStr.Color = Theme.Stroke; TStr.Thickness = 1
    local T = Instance.new("TextLabel", Top); T.Size = UDim2.new(1,-40,1,0); T.Position = UDim2.new(0,20,0,0); T.Text = Config.Name; T.TextColor3 = Theme.Accent; T.Font = "GothamBlack"; T.TextSize = 18; T.TextXAlignment = "Left"; T.BackgroundTransparency = 1

    -- [ Mobile Toggle Button: แก้ปัญหาการลาก ]
    local TogF = Instance.new("Frame", Gui); TogF.Size = UDim2.new(0, 52, 0, 52); TogF.Position = UDim2.new(0.05, 0, 0.1, 0); TogF.BackgroundColor3 = Theme.Main; Instance.new("UICorner", TogF).CornerRadius = UDim.new(1, 0); local TogStr = Instance.new("UIStroke", TogF); TogStr.Color = Theme.Accent; TogStr.Thickness = 2
    local TBtn = Instance.new("TextButton", TogF); TBtn.Size = UDim2.new(1,0,1,0); TBtn.BackgroundTransparency = 1; TBtn.Text = "T"; TBtn.TextColor3 = Theme.Accent; TBtn.Font = "GothamBlack"; TBtn.TextSize = 24; MakeDraggable(TBtn, TogF)
    
    local open = true
    TBtn.MouseButton1Click:Connect(function() open = not open; Tween(Main, {Size = open and UI_Size or UDim2.new(0,0,0,0)}); Tween(TBtn, {TextColor3 = open and Theme.Accent or Theme.TextSemi}) end)

    -- [ Content Layout ]
    local Side = Instance.new("ScrollingFrame", Main); Side.Size = UDim2.new(0, 160, 1, -65); Side.Position = UDim2.new(0, 10, 0, 55); Side.BackgroundTransparency = 1; Side.ScrollBarThickness = 0
    Instance.new("UIListLayout", Side).Padding = UDim.new(0, 6)
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -190, 1, -70); Container.Position = UDim2.new(0, 180, 0, 60); Container.BackgroundTransparency = 1

    local Tabs = {First = true}
    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", Side); TabBtn.Size = UDim2.new(1, -10, 0, 38); TabBtn.BackgroundColor3 = Theme.Secondary; TabBtn.Text = "  "..name; TabBtn.TextColor3 = Theme.TextSemi; TabBtn.Font = "GothamBold"; TabBtn.TextSize = 13; TabBtn.TextXAlignment = "Left"; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        local Page = Instance.new("ScrollingFrame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12); Page.CanvasSize = UDim2.new(0,0,0,0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y -- บังคับให้ขยายตาม Y
        local PL = Page:FindFirstChildWhichIsA("UIListLayout") -- เก็บเลเอาท์ไว้

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Side:GetChildren()) do if v:IsA("TextButton") then Tween(v, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSemi}) end end
            Page.Visible = true; Tween(TabBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}); task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์เมื่อกดเปิด Tab
        end)
        if Tabs.First then Tabs.First = false; Page.Visible = true; TabBtn.BackgroundColor3 = Theme.Accent; TabBtn.TextColor3 = Theme.Main end

        local E = {}
        -- [[ MODERN NEON ELEMENTS ]]
        
        -- [ 1. SECTION ]
        function E:CreateSection(name)
            local S_H = Instance.new("Frame", Page); S_H.Size = UDim2.new(1, -10, 0, 25); S_H.BackgroundTransparency = 1
            local SL = Instance.new("TextLabel", S_H); SL.Size = UDim2.new(1,0,1,0); SL.Text = name:upper(); SL.TextColor3 = Theme.Accent; SL.Font = "GothamBlack"; SL.TextSize = 12; SL.TextXAlignment = "Left"; SL.BackgroundTransparency = 1
            local Line = Instance.new("Frame", S_H); Line.Size = UDim2.new(1,-4,0,2); Line.Position = UDim2.new(0,0,1,0); Line.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", Line).CornerRadius = UDim.new(1,0)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์เมื่อสร้าง Section
        end

        -- [ 2. BUTTON: Glow Effect ]
        function E:CreateButton(D)
            local B = Instance.new("TextButton", Page); B.Size = UDim2.new(1, -10, 0, 42); B.BackgroundColor3 = Theme.Element; B.Text = D.Name; B.TextColor3 = Theme.Text; B.Font = "GothamBold"; B.TextSize = 14; B.TextStrokeTransparency = 0.5; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8); local BStr = Instance.new("UIStroke", B); BStr.Color = Theme.Stroke; BStr.Thickness = 1
            B.MouseButton1Down:Connect(function() Tween(B, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}, 0.1) end)
            B.MouseButton1Up:Connect(function() Tween(B, {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Text}, 0.1); D.Callback() end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        -- [ 3. TOGGLE: Smooth Neon Animation ]
        function E:CreateToggle(D)
            local s = D.CurrentValue; Library.Flags[D.Flag] = s; local T = Instance.new("TextButton", Page); T.Size = UDim2.new(1,-10,0,48); T.BackgroundColor3 = Theme.Element; T.Text = "      "..D.Name; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize=14; T.TextXAlignment="Left"; Instance.new("UICorner", T).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", T).Color = Theme.Stroke
            local BG = Instance.new("Frame", T); BG.Size = UDim2.new(0,40,0,22); BG.Position = UDim2.new(1,-50,0.5,-11); BG.BackgroundColor3 = s and Theme.Accent or Theme.Secondary; Instance.new("UICorner", BG).CornerRadius = UDim.new(1,0); local BGStr = Instance.new("UIStroke", BG); BGStr.Color = Theme.Accent; BGStr.Transparency = 0.3
            local Dt = Instance.new("Frame", BG); Dt.Size = UDim2.new(0,18,0,18); Dt.Position = UDim2.new(s and 0.52 or 0.08,0,0.5,-9); Dt.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Dt).CornerRadius = UDim.new(1,0)
            T.MouseButton1Click:Connect(function() s = not s; Library.Flags[D.Flag] = s; Tween(BG, {BackgroundColor3 = s and Theme.Accent or Theme.Secondary}); Tween(Dt, {Position = UDim2.new(s and 0.52 or 0.08, 0, 0.5, -9)}); Tween(BGStr, {Transparency = s and 0.3 or 1}); D.Callback(s) end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        -- [ 4. SLIDER: Modern Knob & Neon Line ]
        function E:CreateSlider(D)
            local S = Instance.new("Frame", Page); S.Size = UDim2.new(1,-10,0,60); S.BackgroundColor3 = Theme.Element; Instance.new("UICorner", S).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", S).Color = Theme.Stroke
            local L = Instance.new("TextLabel", S); L.Size = UDim2.new(1,-20,0,30); L.Position = UDim2.new(0,15,0,2); L.Text = D.Name; L.TextColor3 = Theme.Text; L.Font="GothamBold"; L.TextSize=13; L.TextXAlignment="Left"; L.BackgroundTransparency = 1
            local V = Instance.new("TextLabel", S); V.Size = UDim2.new(1,-20,0,30); V.Position = UDim2.new(0,0,0,2); V.Text = D.CurrentValue..(D.Suffix or ""); V.TextColor3 = Theme.Accent; V.Font="GothamBold"; V.TextSize=13; V.TextXAlignment="Right"; V.BackgroundTransparency = 1
            local B = Instance.new("Frame", S); B.Size = UDim2.new(0.92,0,0,6); B.Position = UDim2.new(0.04,0,0.78,-5); B.BackgroundColor3 = Theme.Secondary; Instance.new("UICorner", B)
            local F = Instance.new("Frame", B); F.Size = UDim2.new((D.CurrentValue-D.Range[1])/(D.Range[2]-D.Range[1]),0,1,0); F.BackgroundColor3 = Theme.Accent; Instance.new("UICorner", F)
            local Knob = Instance.new("Frame", F); Knob.Size = UDim2.new(0,14,0,14); Knob.Position = UDim2.new(1,-7,0.5,-7); Knob.BackgroundColor3 = Theme.Text; Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Knob).Color = Theme.Accent
            local isSliding = false; B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isSliding = true; local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local v = math.floor(((D.Range[2]-D.Range[1])*p)+D.Range[1]); Tween(F, {Size = UDim2.new(p,0,1,0)}, 0.1); V.Text = tostring(v)..(D.Suffix or ""); D.Callback(v) end end)
            UIS.InputChanged:Connect(function(i) if isSliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local p = math.clamp((i.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1); local v = math.floor(((D.Range[2]-D.Range[1])*p)+D.Range[1]); Tween(F, {Size = UDim2.new(p,0,1,0)}, 0.1); V.Text = tostring(v)..(D.Suffix or ""); D.Callback(v) end end)
            UIS.InputEnded:Connect(function(i) if isSliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then isSliding = false end end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        -- [ 5. INPUT: Glass Style ]
        function E:CreateInput(D)
            local I = Instance.new("Frame", Page); I.Size = UDim2.new(1,-10,0,48); I.BackgroundColor3 = Theme.Element; Instance.new("UICorner", I).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", I).Color = Theme.Stroke
            local T = Instance.new("TextBox", I); T.Size = UDim2.new(1,-30,1,0); T.Position = UDim2.new(0,15,0,0); T.BackgroundTransparency = 1; T.PlaceholderText = D.Name.." [Type Here]"; T.Text = ""; T.TextColor3 = Theme.Text; T.Font="GothamBold"; T.TextSize = 13; T.TextXAlignment = "Left"; T.PlaceholderColor3 = Theme.TextSemi
            T.FocusLost:Connect(function() Tween(I, {BackgroundColor3 = Theme.Element, BorderTransparency = 1}, 0.2); D.Callback(T.Text) end); T.Focused:Connect(function() Tween(I, {BackgroundColor3 = Theme.Secondary, BorderTransparency = 0.5}, 0.2) end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        -- [ 6. DROPDOWN: Clean Expandable ]
        function E:CreateDropdown(D)
            local drop = {Open = false}; local DF = Instance.new("Frame", Page); DF.Size = UDim2.new(1,-10,0,48); DF.BackgroundColor3 = Theme.Element; DF.ClipsDescendants = true; Instance.new("UICorner", DF).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", DF).Color = Theme.Stroke
            local DT = Instance.new("TextButton", DF); DT.Size = UDim2.new(1,0,0,48); DT.BackgroundTransparency = 1; DT.Text = "      "..D.Name; DT.TextColor3 = Theme.Text; DT.Font="GothamBold"; DT.TextSize=13; DT.TextXAlignment="Left"; local Arrow = Instance.new("TextLabel", DT); Arrow.Size = UDim2.new(0,20,1,0); Arrow.Position = UDim2.new(1,-30,0,0); Arrow.Text = "▼"; Arrow.TextColor3 = Theme.TextSemi; Arrow.Font="GothamBlack"; Arrow.TextSize=14; Arrow.BackgroundTransparency = 1
            local List = Instance.new("Frame", DF); List.Size = UDim2.new(1,-10,0,#D.Options*32); List.Position = UDim2.new(0,5,0,48); List.BackgroundTransparency = 1; Instance.new("UIListLayout", List).Padding = UDim.new(0,2)
            for _, opt in pairs(D.Options) do local OB = Instance.new("TextButton", List); OB.Size = UDim2.new(1,-10,0,30); OB.BackgroundColor3 = Theme.Secondary; OB.Text = opt; OB.TextColor3 = Theme.TextSemi; OB.Font="GothamBold"; OB.TextSize=12; Instance.new("UICorner", OB).CornerRadius = UDim.new(0,6); OB.MouseButton1Click:Connect(function() DT.Text = "      "..D.Name..": "..opt; drop.Open = false; Tween(DF, {Size = UDim2.new(1,-10,0,48)}); Arrow.Text = "▼"; D.Callback(opt) end) end
            DT.MouseButton1Click:Connect(function() drop.Open = not drop.Open; Tween(DF, {Size = drop.Open and UDim2.new(1,-10,0,48+(#D.Options*32)+5) or UDim2.new(1,-10,0,48)}); Arrow.Text = drop.Open and "▲" or "▼"; task.wait(); PL:ApplyLayout() end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        -- [ 7. COLOR PICKER: Modern Circle ]
        function E:CreateColorPicker(D)
            local CP = Instance.new("Frame", Page); CP.Size = UDim2.new(1,-10,0,48); CP.BackgroundColor3 = Theme.Element; Instance.new("UICorner", CP).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", CP).Color = Theme.Stroke
            local CT = Instance.new("TextLabel", CP); CT.Size = UDim2.new(1,0,1,0); CT.Position = UDim2.new(0,15,0,0); CT.BackgroundTransparency = 1; CT.Text = D.Name; CT.TextColor3 = Theme.Text; CT.Font="GothamBold"; CT.TextSize=13; CT.TextXAlignment="Left"
            local Box = Instance.new("TextButton", CP); Box.Size = UDim2.new(0,28,0,28); Box.Position = UDim2.new(1,-42,0.5,-14); Box.BackgroundColor3 = D.Default; Instance.new("UICorner", Box).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", Box).Color = Theme.Text; Instance.new("UIStroke", Box).Thickness = 1.5
            Box.MouseButton1Click:Connect(function() 
                local randColor = Color3.fromHSV(math.random(), math.random(), math.random()) -- จำลองการเลือกสี
                Box.BackgroundColor3 = randColor; D.Callback(randColor)
            end)
            task.wait(); PL:ApplyLayout() -- 🔥 แก้ปัญหา: บังคับ Refresh เลเอาท์
        end

        return E
    end
    Tween(Main, {Size = UI_Size}); return Tabs
end

return Library
