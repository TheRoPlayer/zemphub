-- =============================================
-- Zemp UI Library v7 - FULL COMPLETE
-- All Features + Stable + Safe Scripts
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

-- ==================== CREATE WINDOW ====================
function Zemp:CreateWindow(config)
    config = config or {}
    local window = setmetatable({}, Window)

    local ScreenGui = Create("ScreenGui", {Name = "ZempUI", ResetOnSpawn = false, Parent = PlayerGui})
    window.ScreenGui = ScreenGui

    local Main = Create("Frame", {
        Size = UDim2.new(0, 780, 0, 540),
        Position = UDim2.new(0.5, -390, 0.5, -270),
        BackgroundColor3 = Theme.Background,
        Parent = ScreenGui
    })
    window.Main = Main
    Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Main})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.5, Parent = Main})

    local Topbar = Create("Frame", {Size = UDim2.new(1,0,0,65), BackgroundColor3 = Theme.Topbar, Parent = Main})
    Create("UICorner", {CornerRadius = UDim.new(0,18), Parent = Topbar})

    Create("TextLabel", {
        Size = UDim2.new(1,-140,1,0),
        Position = UDim2.new(0,30,0,0),
        BackgroundTransparency = 1,
        Text = config.Title or "Zemp",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBlack,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })

    -- Top Buttons
    local function TopButton(text, pos, color, callback)
        local btn = Create("TextButton", {
            Size = UDim2.new(0,42,0,42),
            Position = pos,
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = color or Theme.Text,
            TextSize = 24,
            Font = Enum.Font.GothamBold,
            Parent = Topbar
        })
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

    local btn = Create("TextButton", {
        Size = UDim2.new(1,0,0,50),
        BackgroundColor3 = Theme.Element,
        Text = "  "..name,
        TextColor3 = Theme.Text,
        TextSize = 17,
        Font = Enum.Font.GothamSemibold,
        Parent = self.Main -- fallback, adjust if needed
    })
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = btn})

    tab.Page = Create("ScrollingFrame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        Visible = false,
        Parent = self.Content
    })
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

-- ==================== ALL ELEMENTS ====================
function Tab:CreateLabel(text)
    return Create("TextLabel", {
        Size = UDim2.new(1,0,0,30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Page
    })
end

function Tab:CreateButton(config)
    local btn = Create("TextButton", {
        Size = UDim2.new(1,0,0,50),
        BackgroundColor3 = Theme.Element,
        Text = config.Name or "Button",
        TextColor3 = Theme.Text,
        TextSize = 17,
        Font = Enum.Font.GothamSemibold,
        Parent = self.Page
    })
    Create("UICorner", {CornerRadius = UDim.new(0,12), Parent = btn})

    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Element}, 0.2) end)
    btn.MouseButton1Click:Connect(config.Callback or function() end)
    return btn
end

function Tab:CreateToggle(config)
    local state = config.Default or false
    local holder = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Page})

    Create("TextLabel", {
        Size = UDim2.new(0.7,0,1,0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = holder
    })

    local tog = Create("TextButton", {Size = UDim2.new(0,56,0,30), Position = UDim2.new(1,-70,0.5,-15), BackgroundColor3 = Theme.Element, Parent = holder})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = tog})

    local circle = Create("Frame", {Size = UDim2.new(0,24,0,24), Position = UDim2.new(0,3,0.5,-12), BackgroundColor3 = Theme.Text, Parent = tog})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = circle})

    local function update()
        if state then
            Tween(tog, {BackgroundColor3 = Theme.Accent}, 0.3)
            Tween(circle, {Position = UDim2.new(1,-27,0.5,-12)}, 0.3)
        else
            Tween(tog, {BackgroundColor3 = Theme.Element}, 0.3)
            Tween(circle, {Position = UDim2.new(0,3,0.5,-12)}, 0.3)
        end
    end

    tog.MouseButton1Click:Connect(function()
        state = not state
        update()
        if config.Callback then config.Callback(state) end
    end)
    update()
end

function Tab:CreateSlider(config)
    local holder = Create("Frame", {Size = UDim2.new(1,0,0,80), BackgroundTransparency = 1, Parent = self.Page})

    Create("TextLabel", {Size = UDim2.new(1,0,0,25), BackgroundTransparency = 1, Text = config.Name or "Slider", TextColor3 = Theme.Text, TextSize = 16, Parent = holder})

    local bar = Create("Frame", {Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,0,42), BackgroundColor3 = Theme.Element, Parent = holder})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = bar})

    local fill = Create("Frame", {Size = UDim2.new(0.5,0,1,0), BackgroundColor3 = Theme.Accent, Parent = bar})
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})

    local valLabel = Create("TextLabel", {Position = UDim2.new(1,-70,0,35), BackgroundTransparency = 1, Text = tostring(config.Default or 50), TextColor3 = Theme.Text, TextSize = 15, Parent = holder})

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

function Zemp:Notify(config)
    local gui = PlayerGui:FindFirstChild("ZempNotifs") or Create("ScreenGui", {Name = "ZempNotifs", Parent = PlayerGui})
    local n = Create("Frame", {Size = UDim2.new(0,390,0,100), Position = UDim2.new(1,50,1,-130), BackgroundColor3 = Theme.Background, Parent = gui})
    Create("UICorner", {CornerRadius = UDim.new(0,16), Parent = n})

    Create("TextLabel", {Size = UDim2.new(1,0,0.4,0), BackgroundTransparency = 1, Text = "Zemp • " .. (config.Title or ""), TextColor3 = Theme.Accent, TextSize = 18, Parent = n})
    Create("TextLabel", {Size = UDim2.new(1,0,0.6,0), Position = UDim2.new(0,0,0.4,0), BackgroundTransparency = 1, Text = config.Content or "", TextColor3 = Theme.Text, TextSize = 15, Parent = n})

    Tween(n, {Position = UDim2.new(1,-410,1,-130)}, 0.6)
    task.delay(config.Duration or 4, function()
        Tween(n, {Position = UDim2.new(1,50,1,-130)}, 0.5)
        task.wait(0.6) n:Destroy()
    end)
end

function Window:Minimize()
    self.Minimized = not (self.Minimized or false)
    Tween(self.Main, {Size = self.Minimized and UDim2.new(0,780,0,65) or UDim2.new(0,780,0,540)}, 0.4)
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end

return Zemp
