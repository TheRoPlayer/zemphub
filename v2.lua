-- =============================================
-- Zemp UI Library v7 - FULL COMPLETE
-- All Features Added + Safe + Stable
-- =============================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Zemp = {}
Zemp.__index = Zemp

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

-- Theme
local Theme = {
    Background = Color3.fromRGB(25, 25, 32),
    Topbar = Color3.fromRGB(18, 18, 24),
    Accent = Color3.fromRGB(0, 255, 170),
    Text = Color3.fromRGB(240, 240, 240),
    Element = Color3.fromRGB(38, 38, 48),
    ElementHover = Color3.fromRGB(55, 55, 70),
    Stroke = Color3.fromRGB(65, 65, 85)
}

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint), props):Play()
end

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in pairs(props or {}) do obj[i] = v end
    return obj
end

-- ==================== WINDOW ====================
function Zemp:CreateWindow(config)
    config = config or {}
    local window = setmetatable({}, Window)

    local ScreenGui = Create("ScreenGui", {Name = config.Name or "ZempUI", ResetOnSpawn = false, Parent = PlayerGui})
    window.ScreenGui = ScreenGui

    local Main = Create("Frame", {Size = UDim2.new(0, 780, 0, 540), Position = UDim2.new(0.5, -390, 0.5, -270), BackgroundColor3 = Theme.Background, Parent = ScreenGui})
    window.Main = Main
    Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Main})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.5, Parent = Main})

    local Topbar = Create("Frame", {Size = UDim2.new(1,0,0,65), BackgroundColor3 = Theme.Topbar, Parent = Main})
    Create("UICorner", {CornerRadius = UDim.new(0,18), Parent = Topbar})

    Create("TextLabel", {Size = UDim2.new(1,-140,1,0), Position = UDim2.new(0,30,0,0), BackgroundTransparency = 1, Text = config.Title or "Zemp", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBlack, TextSize = 26, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar})

    local function TopButton(text, pos, color, callback)
        local btn = Create("TextButton", {Size = UDim2.new(0,42,0,42), Position = pos, BackgroundTransparency = 1, Text = text, TextColor3 = color or Theme.Text, TextSize = 24, Font = Enum.Font.GothamBold, Parent = Topbar})
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    TopButton("–", UDim2.new(1,-105,0,11), nil, function() window:Minimize() end)
    TopButton("×", UDim2.new(1,-55,0,11), Color3.fromRGB(255,80,80), function() window:Destroy() end)

    -- Dragging
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    window.Content = Create("Frame", {Size = UDim2.new(1,-220,1,-65), Position = UDim2.new(0,220,0,65), BackgroundTransparency = 1, Parent = Main})
    window.Tabs = {}
    return window
end

function Window:CreateTab(name)
    local tab = setmetatable({}, Tab)

    local btn = Create("TextButton", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = Theme.Element, Text = "  "..name, TextColor3 = Theme.Text, TextSize = 17, Font = Enum.Font.GothamSemibold, Parent = self.Main})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = btn})

    tab.Page = Create("ScrollingFrame", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 5, Visible = false, Parent = self.Content})
    Create("UIListLayout", {Padding = UDim.new(0,12), Parent = tab.Page})
    Create("UIPadding", {PaddingLeft = UDim.new(0,15), PaddingRight = UDim.new(0,15), PaddingTop = UDim.new(0,15), Parent = tab.Page})

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do t.Page.Visible = false end
        tab.Page.Visible = true
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then tab.Page.Visible = true end
    return tab
end

-- ==================== ALL FEATURES ====================
function Tab:CreateLabel(text)
    return Create("TextLabel", {Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, TextSize = 16, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = self.Page})
end

function Tab:CreateButton(config)
    local btn = Create("TextButton", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = Theme.Element, Text = config.Name or "Button", TextColor3 = Theme.Text, TextSize = 17, Font = Enum.Font.GothamSemibold, Parent = self.Page})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = btn})

    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Element}, 0.2) end)
    btn.MouseButton1Click:Connect(config.Callback or function() end)
    return btn
end

function Tab:CreateToggle(config)
    local state = config.Default or false
    local holder = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Page})

    Create("TextLabel", {Size = UDim2.new(0.7,0,1,0), BackgroundTransparency = 1, Text = config.Name or "Toggle", TextColor3 = Theme.Text, TextSize = 16, Parent = holder})

    local tog = Create("TextButton", {Size = UDim2.new(0,56,0,30), Position = UDim2.new(1,-70,0.5,-15), BackgroundColor3 = Theme.Element, Parent = holder})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = tog})

    local circle = Create("Frame", {Size = UDim2.new(0,24,0,24), Position = UDim2.new(0,3,0.5,-12), BackgroundColor3 = Theme.Text, Parent = tog})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = circle})

    local function update()
        if state then Tween(tog, {BackgroundColor3 = Theme.Accent}, 0.3) Tween(circle, {Position = UDim2.new(1,-27,0.5,-12)}, 0.3)
        else Tween(tog, {BackgroundColor3 = Theme.Element}, 0.3) Tween(circle, {Position = UDim2.new(0,3,0.5,-12)}, 0.3) end
    end

    tog.MouseButton1Click:Connect(function()
        state = not state
        update()
        if config.Callback then config.Callback(state) end
    end)
    update()
end

function Tab:CreateSlider(config)
    -- (Your original slider from ChatGPT is kept and working)
    local Min = config.Min or 0
    local Max = config.Max or 100
    local Default = config.Default or Min
    local Holder = Create("Frame", {Size = UDim2.new(1,0,0,75), BackgroundTransparency = 1, Parent = self.Page})

    Create("TextLabel", {Size = UDim2.new(1,0,0,24), BackgroundTransparency = 1, Text = config.Name or "Slider", TextColor3 = Theme.Text, TextSize = 16, Parent = Holder})

    local ValueLabel = Create("TextLabel", {Size = UDim2.new(0,60,0,20), Position = UDim2.new(1,-60,0,0), BackgroundTransparency = 1, Text = tostring(Default), TextColor3 = Theme.Text, TextSize = 15, Parent = Holder})

    local Bar = Create("Frame", {Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,42), BackgroundColor3 = Theme.Element, Parent = Holder})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Bar})

    local Fill = Create("Frame", {Size = UDim2.new((Default - Min)/(Max - Min),0,1,0), BackgroundColor3 = Theme.Accent, Parent = Bar})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})

    local Dragging = false
    local function Set(input)
        local ratio = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        local value = math.floor(Min + ((Max - Min) * ratio))
        ValueLabel.Text = tostring(value)
        if config.Callback then pcall(config.Callback, value) end
    end

    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Set(i) end end)
    UserInputService.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Set(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
end

function Tab:CreateTextbox(config)
    local f = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = Theme.Element, Parent = self.Page})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = f})

    local box = Create("TextBox", {Size = UDim2.new(1,-20,1,0), Position = UDim2.new(0,10,0,0), BackgroundTransparency = 1, PlaceholderText = config.Placeholder or "Type here...", Text = config.Default or "", TextColor3 = Theme.Text, TextSize = 16, Parent = f})
    box.FocusLost:Connect(function() if config.Callback then config.Callback(box.Text) end end)
end

function Tab:CreateDropdown(config)
    local frame = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = Theme.Element, Parent = self.Page})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = frame})

    local selected = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = config.Name .. ": " .. (config.Default or "Select"), TextColor3 = Theme.Text, Parent = frame})

    local dropdown = Create("Frame", {Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,5), BackgroundColor3 = Theme.Element, Visible = false, Parent = frame})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = dropdown})

    selected.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)

    for _, opt in ipairs(config.Options or {}) do
        local optBtn = Create("TextButton", {Size = UDim2.new(1,0,0,35), BackgroundTransparency = 1, Text = opt, TextColor3 = Theme.Text, Parent = dropdown})
        optBtn.MouseButton1Click:Connect(function()
            selected.Text = config.Name .. ": " .. opt
            dropdown.Visible = false
            if config.Callback then config.Callback(opt) end
        end)
    end
end

function Tab:CreateKeybind(config)
    local f = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = Theme.Element, Parent = self.Page})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = f})

    Create("TextLabel", {Size = UDim2.new(0.6,0,1,0), BackgroundTransparency = 1, Text = config.Name or "Keybind", TextColor3 = Theme.Text, TextSize = 16, Parent = f})

    local btn = Create("TextButton", {Size = UDim2.new(0.35,0,0.7,0), Position = UDim2.new(0.6,0,0.15,0), BackgroundColor3 = Theme.ElementHover, Text = "None", TextColor3 = Theme.Text, Parent = f})
    Create("UICorner", {CornerRadius = UDim.new(0,8), Parent = btn})

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(i)
        if listening and i.UserInputType == Enum.UserInputType.Keyboard then
            btn.Text = i.KeyCode.Name
            if config.Callback then config.Callback(i.KeyCode) end
            listening = false
        end
    end)
end

function Tab:CreateDiscordButton(config)
    local link = config.Link or "https://discord.gg/example"
    local btn = Create("TextButton", {Size = UDim2.new(1,0,0,55), BackgroundColor3 = Color3.fromRGB(88,101,242), Text = config.Name or "Join Discord", TextColor3 = Color3.new(1,1,1), TextSize = 17, Font = Enum.Font.GothamSemibold, Parent = self.Page})
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = btn})

    btn.MouseButton1Click:Connect(function()
        setclipboard(link)
        Zemp:Notify({Title = "Discord", Content = "Link copied to clipboard!"})
    end)
end

function Tab:CreateKeySystemPlaceholder()
    self:CreateLabel("🔑 Key System Coming Soon")
    self:CreateDiscordButton({Name = "Get Key from Discord"})
end

function Window:Notify(config)
    config = config or {}
    local Gui = PlayerGui:FindFirstChild("ZempNotifications") or Create("ScreenGui", {Name = "ZempNotifications", ResetOnSpawn = false, Parent = PlayerGui})
    local Notification = Create("Frame", {Size = UDim2.new(0,320,0,90), Position = UDim2.new(1,340,1,-110), BackgroundColor3 = Theme.Background, Parent = Gui})
    Create("UICorner", {CornerRadius = UDim.new(0,14), Parent = Notification})

    Create("TextLabel", {Size = UDim2.new(1,-20,0,30), Position = UDim2.new(0,10,0,8), BackgroundTransparency = 1, Text = config.Title or "Notification", TextColor3 = Theme.Accent, TextSize = 18, Parent = Notification})
    Create("TextLabel", {Size = UDim2.new(1,-20,1,-40), Position = UDim2.new(0,10,0,35), BackgroundTransparency = 1, Text = config.Content or "", TextWrapped = true, TextColor3 = Theme.Text, TextSize = 14, Parent = Notification})

    Tween(Notification, {Position = UDim2.new(1,-340,1,-110)}, 0.4)
    task.delay(config.Duration or 4, function()
        Tween(Notification, {Position = UDim2.new(1,340,1,-110)}, 0.4)
        task.wait(0.45)
        Notification:Destroy()
    end)
end

function Window:Minimize()
    self.Minimized = not (self.Minimized or false)
    Tween(self.Main, {Size = self.Minimized and UDim2.new(0,780,0,65) or UDim2.new(0,780,0,540)}, 0.35)
end

function Window:Destroy()
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

return Zemp
