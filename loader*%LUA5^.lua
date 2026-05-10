-- =============================================
-- Zemp UI Library v5.0 - PREMIUM
-- Smoother Animations + Beautiful Design
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Zemp = {}
Zemp.__index = Zemp

local Theme = {
    Background = Color3.fromRGB(28, 28, 36),
    Topbar = Color3.fromRGB(18, 18, 24),
    Accent = Color3.fromRGB(0, 255, 180),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(40, 40, 50),
    ElementHover = Color3.fromRGB(55, 55, 70),
    Stroke = Color3.fromRGB(70, 70, 90)
}

local function Tween(obj, props, time, style)
    style = style or Enum.EasingStyle.Quint
    TweenService:Create(obj, TweenInfo.new(time, style, Enum.EasingDirection.Out), props):Play()
end

function Zemp:CreateWindow(config)
    local window = setmetatable({}, Zemp)
    
    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.Name = "ZempUI"
    window.ScreenGui.ResetOnSpawn = false
    window.ScreenGui.Parent = playerGui

    window.Main = Instance.new("Frame")
    window.Main.Size = UDim2.new(0, 760, 0, 520)
    window.Main.Position = UDim2.new(0.5, -380, 0.5, -260)
    window.Main.BackgroundColor3 = Theme.Background
    window.Main.Parent = window.ScreenGui

    Instance.new("UICorner", window.Main).CornerRadius = UDim.new(0, 18)
    local stroke = Instance.new("UIStroke", window.Main)
    stroke.Color = Theme.Stroke
    stroke.Thickness = 2.5

    -- Topbar
    window.Topbar = Instance.new("Frame")
    window.Topbar.Size = UDim2.new(1, 0, 0, 72)
    window.Topbar.BackgroundColor3 = Theme.Topbar
    window.Topbar.Parent = window.Main
    Instance.new("UICorner", window.Topbar).CornerRadius = UDim.new(0, 18)

    local title = Instance.new("TextLabel")
    title.Text = "Zemp"
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Theme.Accent
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = window.Topbar
    Instance.new("UIPadding", title).PaddingLeft = UDim.new(0, 32)

    -- Top Buttons
    local function TopBtn(symbol, color, pos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 44, 0, 44)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = symbol
        btn.TextColor3 = color or Theme.Text
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = window.Topbar
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    TopBtn("–", nil, UDim2.new(1, -105, 0, 14), function() window:Minimize() end)
    TopBtn("×", Color3.fromRGB(255, 85, 85), UDim2.new(1, -52, 0, 14), function() window:Destroy() end)

    -- Draggable
    local dragging, dragStart, startPos
    window.Topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = window.Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            window.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Containers
    window.TabContainer = Instance.new("ScrollingFrame")
    window.TabContainer.Size = UDim2.new(0.28, 0, 1, -72)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 72)
    window.TabContainer.BackgroundTransparency = 1
    window.TabContainer.ScrollBarThickness = 5
    window.TabContainer.Parent = window.Main

    Instance.new("UIListLayout", window.TabContainer).Padding = UDim.new(0, 10)
    local tp = Instance.new("UIPadding", window.TabContainer)
    tp.PaddingLeft = UDim.new(0,18); tp.PaddingRight = UDim.new(0,18); tp.PaddingTop = UDim.new(0,18)

    window.Content = Instance.new("Frame")
    window.Content.Size = UDim2.new(0.72, 0, 1, -72)
    window.Content.Position = UDim2.new(0.28, 0, 0, 72)
    window.Content.BackgroundTransparency = 1
    window.Content.Parent = window.Main

    window.Tabs = {}
    window.Minimized = false

    return window
end

function Zemp:CreateTab(name)
    local tab = {}

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,58)
    btn.BackgroundColor3 = Theme.Element
    btn.Text = "   "..name
    btn.TextColor3 = Theme.Text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = self.TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.25) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Element}, 0.25) end)

    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1,0,1,0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 6
    tab.Content.Visible = false
    tab.Content.Parent = self.Content

    Instance.new("UIListLayout", tab.Content).Padding = UDim.new(0,18)
    local cp = Instance.new("UIPadding", tab.Content)
    cp.PaddingLeft = UDim.new(0,22)
    cp.PaddingRight = UDim.new(0,22)
    cp.PaddingTop = UDim.new(0,22)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do t.Content.Visible = false end
        tab.Content.Visible = true
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then tab.Content.Visible = true end

    return tab
end

-- ==================== PREMIUM ELEMENTS ====================

function Zemp:CreateLabel(tab, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,0,40)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Theme.Text
    l.TextScaled = true
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = tab.Content
end

function Zemp:CreateDivider(tab)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, -20, 0, 2)
    d.BackgroundColor3 = Theme.Stroke
    d.Parent = tab.Content
end

function Zemp:CreateButton(tab, config)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,60)
    b.BackgroundColor3 = Theme.Element
    b.Text = config.Name or "Button"
    b.TextColor3 = Theme.Text
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    b.Parent = tab.Content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Theme.Accent}, 0.3) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Theme.Element}, 0.3) end)
    b.MouseButton1Click:Connect(config.Callback or function() end)
end

function Zemp:CreateToggle(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,60)
    f.BackgroundTransparency = 1
    f.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = Theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0,58,0,32)
    tog.Position = UDim2.new(1,-75,0.5,-16)
    tog.BackgroundColor3 = Theme.Element
    tog.Parent = f
    Instance.new("UICorner", tog).CornerRadius = UDim.new(1,0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,26,0,26)
    circle.Position = UDim2.new(0,3,0.5,-13)
    circle.BackgroundColor3 = Theme.Text
    circle.Parent = tog
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

    local state = config.Default or false
    local function update()
        if state then
            Tween(tog, {BackgroundColor3 = Theme.Accent}, 0.4)
            Tween(circle, {Position = UDim2.new(1,-29,0.5,-13)}, 0.4)
        else
            Tween(tog, {BackgroundColor3 = Theme.Element}, 0.4)
            Tween(circle, {Position = UDim2.new(0,3,0.5,-13)}, 0.4)
        end
    end

    tog.MouseButton1Click:Connect(function()
        state = not state
        update()
        if config.Callback then config.Callback(state) end
    end)
    update()
end

function Zemp:CreateSlider(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,85)
    f.BackgroundTransparency = 1
    f.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Text = config.Name or "Slider"
    label.Size = UDim2.new(1,0,0,25)
    label.BackgroundTransparency = 1
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,0,0,14)
    bar.Position = UDim2.new(0,0,0,45)
    bar.BackgroundColor3 = Theme.Element
    bar.Parent = f
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5,0,1,0)
    fill.BackgroundColor3 = Theme.Accent
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(config.Default or 50)
    valLabel.Position = UDim2.new(1,-75,0,38)
    valLabel.BackgroundTransparency = 1
    valLabel.TextColor3 = Theme.Text
    valLabel.Parent = f

    local min, max = config.Min or 0, config.Max or 100
    local dragging = false

    local function update(inp)
        local rel = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        local value = math.floor(min + (max - min) * rel)
        valLabel.Text = tostring(value)
        if config.Callback then config.Callback(value) end
    end

    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(i) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- More features below...

function Zemp:CreateTextbox(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,60)
    f.BackgroundColor3 = Theme.Element
    f.Parent = tab.Content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,14)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-20,1,0)
    box.Position = UDim2.new(0,10,0,0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = config.Placeholder or "Type here..."
    box.Text = config.Default or ""
    box.TextColor3 = Theme.Text
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.Parent = f

    box.FocusLost:Connect(function() if config.Callback then config.Callback(box.Text) end end)
end

function Zemp:Notify(config)
    local gui = playerGui:FindFirstChild("ZempNotifs") or Instance.new("ScreenGui")
    gui.Name = "ZempNotifs"
    gui.Parent = playerGui

    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 390, 0, 115)
    n.Position = UDim2.new(1, 60, 1, -150)
    n.BackgroundColor3 = Theme.Background
    n.Parent = gui
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 16)

    local t = Instance.new("TextLabel", n)
    t.Text = "Zemp • " .. (config.Title or "")
    t.Size = UDim2.new(1,0,0.4,0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Theme.Accent
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold

    local c = Instance.new("TextLabel", n)
    c.Text = config.Content or ""
    c.Size = UDim2.new(1,0,0.6,0)
    c.Position = UDim2.new(0,0,0.4,0)
    c.BackgroundTransparency = 1
    c.TextColor3 = Theme.Text
    c.TextScaled = true

    Tween(n, {Position = UDim2.new(1, -410, 1, -150)}, 0.7, Enum.EasingStyle.Back)
    task.delay(config.Duration or 5, function()
        Tween(n, {Position = UDim2.new(1, 60, 1, -150)}, 0.5)
        task.wait(0.6)
        n:Destroy()
    end)
end

function Zemp:Minimize()
    self.Minimized = not (self.Minimized or false)
    local target = self.Minimized and UDim2.new(0,760,0,72) or UDim2.new(0,760,0,520)
    Tween(self.Main, {Size = target}, 0.5, Enum.EasingStyle.Back)
end

function Zemp:Destroy()
    Tween(self.Main, {Size = UDim2.new(0,0,0,0)}, 0.4)
    task.wait(0.45)
    self.ScreenGui:Destroy()
end

return Zemp
