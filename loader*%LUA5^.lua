-- =============================================
-- Zemp UI Library v3 - Complete & Stable
-- Branded for Zemp | All Major Elements
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Zemp = {}
Zemp.__index = Zemp

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Topbar = Color3.fromRGB(28, 28, 35),
    Accent = Color3.fromRGB(0, 255, 170),
    Text = Color3.fromRGB(245, 245, 245),
    Element = Color3.fromRGB(35, 35, 42),
    ElementHover = Color3.fromRGB(48, 48, 58),
    Stroke = Color3.fromRGB(55, 55, 65)
}

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

function Zemp:CreateWindow(config)
    local window = setmetatable({}, Zemp)
    
    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.Name = "ZempUI"
    window.ScreenGui.ResetOnSpawn = false
    window.ScreenGui.Parent = playerGui

    window.Main = Instance.new("Frame")
    window.Main.Size = UDim2.new(0, 680, 0, 460)
    window.Main.Position = UDim2.new(0.5, -340, 0.5, -230)
    window.Main.BackgroundColor3 = Theme.Background
    window.Main.Parent = window.ScreenGui

    Instance.new("UICorner", window.Main).CornerRadius = UDim.new(0, 16)
    Instance.new("UIStroke", window.Main).Color = Theme.Stroke

    -- Topbar
    window.Topbar = Instance.new("Frame")
    window.Topbar.Size = UDim2.new(1, 0, 0, 60)
    window.Topbar.BackgroundColor3 = Theme.Topbar
    window.Topbar.Parent = window.Main
    Instance.new("UICorner", window.Topbar).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Text = "Zemp"
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Theme.Accent
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = window.Topbar
    Instance.new("UIPadding", title).PaddingLeft = UDim.new(0, 25)

    -- Top Buttons
    local function TopBtn(text, color, pos, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 36, 0, 36)
        b.Position = pos
        b.BackgroundTransparency = 1
        b.Text = text
        b.TextColor3 = color or Theme.Text
        b.TextScaled = true
        b.Font = Enum.Font.GothamBold
        b.Parent = window.Topbar
        b.MouseButton1Click:Connect(cb)
        return b
    end

    TopBtn("−", nil, UDim2.new(1, -90, 0, 12), function() window:Minimize() end)
    TopBtn("×", Color3.fromRGB(255, 80, 80), UDim2.new(1, -45, 0, 12), function() window:Destroy() end)

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
    window.TabContainer.Size = UDim2.new(0.27, 0, 1, -60)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 60)
    window.TabContainer.BackgroundTransparency = 1
    window.TabContainer.ScrollBarThickness = 4
    window.TabContainer.Parent = window.Main
    Instance.new("UIListLayout", window.TabContainer).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", window.TabContainer).PaddingAll = UDim.new(0, 12)

    window.Content = Instance.new("Frame")
    window.Content.Size = UDim2.new(0.73, 0, 1, -60)
    window.Content.Position = UDim2.new(0.27, 0, 0, 60)
    window.Content.BackgroundTransparency = 1
    window.Content.Parent = window.Main

    window.Tabs = {}
    window.Minimized = false

    return window
end

function Zemp:CreateTab(name)
    local tab = {}

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Theme.Element
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = self.TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Element}, 0.2) end)

    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1,0,1,0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 6
    tab.Content.Visible = false
    tab.Content.Parent = self.Content
    Instance.new("UIListLayout", tab.Content).Padding = UDim.new(0, 12)
    Instance.new("UIPadding", tab.Content).PaddingAll = UDim.new(0, 15)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do t.Content.Visible = false end
        tab.Content.Visible = true
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then tab.Content.Visible = true end

    return tab
end

-- ==================== ELEMENTS ====================

function Zemp:CreateLabel(tab, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,0,30)
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
    d.Size = UDim2.new(1,0,0,2)
    d.BackgroundColor3 = Theme.Stroke
    d.Parent = tab.Content
end

function Zemp:CreateButton(tab, config)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,50)
    b.BackgroundColor3 = Theme.Element
    b.Text = config.Name or "Button"
    b.TextColor3 = Theme.Text
    b.Font = Enum.Font.GothamSemibold
    b.TextScaled = true
    b.Parent = tab.Content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Theme.Element}, 0.2) end)
    b.MouseButton1Click:Connect(config.Callback or function() end)
end

function Zemp:CreateToggle(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,50)
    f.BackgroundTransparency = 1
    f.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = Theme.Text
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0,52,0,28)
    tog.Position = UDim2.new(1,-62,0.5,-14)
    tog.BackgroundColor3 = Theme.Element
    tog.Parent = f
    Instance.new("UICorner", tog).CornerRadius = UDim.new(1,0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,22,0,22)
    circle.Position = UDim2.new(0,3,0.5,-11)
    circle.BackgroundColor3 = Theme.Text
    circle.Parent = tog
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

    local state = config.Default or false
    local function Update()
        if state then
            Tween(tog, {BackgroundColor3 = Theme.Accent}, 0.3)
            Tween(circle, {Position = UDim2.new(1,-25,0.5,-11)}, 0.3)
        else
            Tween(tog, {BackgroundColor3 = Theme.Element}, 0.3)
            Tween(circle, {Position = UDim2.new(0,3,0.5,-11)}, 0.3)
        end
    end
    tog.MouseButton1Click:Connect(function()
        state = not state
        Update()
        if config.Callback then config.Callback(state) end
    end)
    Update()
end

function Zemp:CreateSlider(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,70)
    f.BackgroundTransparency = 1
    f.Parent = tab.Content

    local label = Instance.new("TextLabel")
    label.Text = config.Name or "Slider"
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,0,0,10)
    bar.Position = UDim2.new(0,0,0,35)
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
    valLabel.Position = UDim2.new(1,-55,0,28)
    valLabel.BackgroundTransparency = 1
    valLabel.TextColor3 = Theme.Text
    valLabel.Parent = f

    local min, max = config.Min or 0, config.Max or 100
    local dragging = false

    local function Update(pos)
        local rel = math.clamp((pos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        local value = math.floor(min + (max - min) * rel)
        valLabel.Text = tostring(value)
        if config.Callback then config.Callback(value) end
    end

    bar.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true Update(inp) end end)
    UserInputService.InputChanged:Connect(function(inp) if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then Update(inp) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function Zemp:CreateTextbox(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,50)
    f.BackgroundColor3 = Theme.Element
    f.Parent = tab.Content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.new(0,10,0,0)
    box.BackgroundTransparency = 1
    box.Text = config.Default or ""
    box.PlaceholderText = config.Placeholder or "Type here..."
    box.TextColor3 = Theme.Text
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.Parent = f

    box.FocusLost:Connect(function(enter)
        if config.Callback then config.Callback(box.Text) end
    end)
end

function Zemp:CreateKeybind(tab, config)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,50)
    f.BackgroundColor3 = Theme.Element
    f.Parent = tab.Content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Keybind"
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0.35,0,0.7,0)
    bindBtn.Position = UDim2.new(0.6,0,0.15,0)
    bindBtn.BackgroundColor3 = Theme.ElementHover
    bindBtn.Text = config.Default and config.Default.Name or "None"
    bindBtn.TextColor3 = Theme.Text
    bindBtn.Parent = f
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,8)

    local listening = false
    bindBtn.MouseButton1Click:Connect(function()
        listening = true
        bindBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
            bindBtn.Text = inp.KeyCode.Name
            if config.Callback then config.Callback(inp.KeyCode) end
            listening = false
        end
    end)
end

function Zemp:CreateColorPicker(tab, config)
    -- Simple color picker (click to cycle through colors for demo)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,50)
    f.BackgroundColor3 = Theme.Element
    f.Parent = tab.Content
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0,80,0,30)
    preview.Position = UDim2.new(1,-95,0.5,-15)
    preview.BackgroundColor3 = config.Default or Color3.fromRGB(0,255,170)
    preview.Parent = f
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0,6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.6,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = config.Name or "Color Picker"
    btn.TextColor3 = Theme.Text
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        -- Simple random color demo (you can expand with full picker later)
        local r = math.random(100,255)
        local g = math.random(100,255)
        local b = math.random(100,255)
        preview.BackgroundColor3 = Color3.fromRGB(r,g,b)
        if config.Callback then config.Callback(preview.BackgroundColor3) end
    end)
end

function Zemp:Notify(config)
    local gui = playerGui:FindFirstChild("ZempNotifs") or Instance.new("ScreenGui")
    gui.Name = "ZempNotifs"
    gui.Parent = playerGui

    local n = Instance.new("Frame")
    n.Size = UDim2.new(0,350,0,95)
    n.Position = UDim2.new(1,30,1,-120)
    n.BackgroundColor3 = Theme.Background
    n.Parent = gui
    Instance.new("UICorner", n).CornerRadius = UDim.new(0,14)

    local t = Instance.new("TextLabel")
    t.Text = "Zemp • " .. (config.Title or "Info")
    t.Size = UDim2.new(1,0,0.4,0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Theme.Accent
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold
    t.Parent = n

    local c = Instance.new("TextLabel")
    c.Text = config.Content or ""
    c.Size = UDim2.new(1,0,0.6,0)
    c.Position = UDim2.new(0,0,0.4,0)
    c.BackgroundTransparency = 1
    c.TextColor3 = Theme.Text
    c.TextScaled = true
    c.Parent = n

    Tween(n, {Position = UDim2.new(1,-370,1,-120)}, 0.6)
    task.delay(config.Duration or 5, function()
        Tween(n, {Position = UDim2.new(1,30,1,-120)}, 0.5)
        task.wait(0.6)
        n:Destroy()
    end)
end

function Zemp:Minimize()
    self.Minimized = not self.Minimized
    local target = self.Minimized and UDim2.new(0,680,0,60) or UDim2.new(0,680,0,460)
    Tween(self.Main, {Size = target}, 0.45)
end

function Zemp:Destroy()
    Tween(self.Main, {Size = UDim2.new(0,0,0,0)}, 0.4)
    task.wait(0.45)
    self.ScreenGui:Destroy()
end

return Zemp
