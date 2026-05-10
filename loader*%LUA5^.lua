--// =========================================
--// Zemp UI Library v7 - Fixed & Stable
--// Clean OOP Structure + Working Elements
--// =========================================

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

--// ================= THEME =================

local Theme = {
    Background = Color3.fromRGB(25, 25, 32),
    Topbar = Color3.fromRGB(18, 18, 24),
    Accent = Color3.fromRGB(0, 255, 170),
    Text = Color3.fromRGB(240, 240, 240),
    Element = Color3.fromRGB(38, 38, 48),
    ElementHover = Color3.fromRGB(55, 55, 70),
    Stroke = Color3.fromRGB(65, 65, 85)
}

--// ================= HELPERS =================

local function Tween(obj, props, time)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            time or 0.25,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )

    tween:Play()
    return tween
end

local function Create(class, props)
    local obj = Instance.new(class)

    for i, v in pairs(props or {}) do
        obj[i] = v
    end

    return obj
end

--// =========================================
--// WINDOW CREATION
--// =========================================

function Zemp:CreateWindow(config)
    config = config or {}

    local window = setmetatable({}, Window)

    --// GUI

    local ScreenGui = Create("ScreenGui", {
        Name = config.Name or "ZempUI",
        ResetOnSpawn = false,
        Parent = PlayerGui
    })

    window.ScreenGui = ScreenGui

    --// MAIN

    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 780, 0, 540),
        Position = UDim2.new(0.5, -390, 0.5, -270),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    window.Main = Main

    local MainCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 18),
        Parent = Main
    })

    local MainStroke = Create("UIStroke", {
        Color = Theme.Stroke,
        Thickness = 1,
        Parent = Main
    })

    --// TOPBAR

    local Topbar = Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        Parent = Main
    })

    window.Topbar = Topbar

    local TopCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 18),
        Parent = Topbar
    })

    --// TITLE

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 25, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Zemp",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBlack,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })

    --// BUTTON CREATOR

    local function TopButton(text, pos, color, callback)
        local Btn = Create("TextButton", {
            Size = UDim2.new(0, 42, 0, 42),
            Position = pos,
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 24,
            TextColor3 = color or Theme.Text,
            Parent = Topbar
        })

        Btn.MouseButton1Click:Connect(callback)

        return Btn
    end

    TopButton(
        "—",
        UDim2.new(1, -100, 0, 11),
        Theme.Text,
        function()
            window:Minimize()
        end
    )

    TopButton(
        "×",
        UDim2.new(1, -50, 0, 11),
        Color3.fromRGB(255, 80, 80),
        function()
            window:Destroy()
        end
    )

    --// DRAGGING

    do
        local dragging = false
        local dragInput
        local dragStart
        local startPos

        Topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart

                Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    --// TAB HOLDER

    local TabHolder = Create("ScrollingFrame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 210, 1, -65),
        Position = UDim2.new(0, 0, 0, 65),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0,0,0,0),
        Parent = Main
    })

    window.TabHolder = TabHolder

    local TabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = TabHolder
    })

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = TabHolder
    })

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(
            0,
            0,
            0,
            TabLayout.AbsoluteContentSize.Y + 20
        )
    end)

    --// CONTENT

    local Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -210, 1, -65),
        Position = UDim2.new(0, 210, 0, 65),
        BackgroundTransparency = 1,
        Parent = Main
    })

    window.Content = Content
    window.Tabs = {}
    window.Minimized = false

    return window
end

--// =========================================
--// TABS
--// =========================================

function Window:CreateTab(name)
    local tab = setmetatable({}, Tab)

    --// BUTTON

    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = "   " .. tostring(name),
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TabHolder
    })

    local BtnCorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Button
    })

    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.ElementHover
        }, 0.15)
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.Element
        }, 0.15)
    end)

    --// PAGE

    local Page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        Visible = false,
        CanvasSize = UDim2.new(0,0,0,0),
        Parent = self.Content
    })

    local Padding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = Page
    })

    local Layout = Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        Parent = Page
    })

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 20
        )
    end)

    Button.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
        end

        Page.Visible = true
    end)

    tab.Page = Page

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        Page.Visible = true
    end

    return tab
end

--// =========================================
--// LABEL
--// =========================================

function Tab:CreateLabel(text)
    local Label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Page
    })

    return Label
end

--// =========================================
--// BUTTON
--// =========================================

function Tab:CreateButton(config)
    config = config or {}

    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = config.Name or "Button",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 17,
        Parent = self.Page
    })

    local Corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Button
    })

    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.Accent
        }, 0.2)
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.Element
        }, 0.2)
    end)

    Button.MouseButton1Click:Connect(function()
        if config.Callback then
            pcall(config.Callback)
        end
    end)

    return Button
end

--// =========================================
--// TOGGLE
--// =========================================

function Tab:CreateToggle(config)
    config = config or {}

    local State = config.Default or false

    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.Page
    })

    local Label = Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder
    })

    local Toggle = Create("TextButton", {
        Size = UDim2.new(0, 55, 0, 28),
        Position = UDim2.new(1, -60, 0.5, -14),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Text = "",
        Parent = Holder
    })

    local ToggleCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Toggle
    })

    local Circle = Create("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 3, 0.5, -11),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        Parent = Toggle
    })

    local CircleCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Circle
    })

    local function Update()
        if State then
            Tween(Toggle, {
                BackgroundColor3 = Theme.Accent
            }, 0.25)

            Tween(Circle, {
                Position = UDim2.new(1, -25, 0.5, -11)
            }, 0.25)
        else
            Tween(Toggle, {
                BackgroundColor3 = Theme.Element
            }, 0.25)

            Tween(Circle, {
                Position = UDim2.new(0, 3, 0.5, -11)
            }, 0.25)
        end
    end

    Toggle.MouseButton1Click:Connect(function()
        State = not State

        Update()

        if config.Callback then
            pcall(config.Callback, State)
        end
    end)

    Update()

    return Toggle
end

--// =========================================
--// SLIDER
--// =========================================

function Tab:CreateSlider(config)
    config = config or {}

    local Min = config.Min or 0
    local Max = config.Max or 100
    local Default = config.Default or Min

    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 75),
        BackgroundTransparency = 1,
        Parent = self.Page
    })

    local Label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = config.Name or "Slider",
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder
    })

    local ValueLabel = Create("TextLabel", {
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(Default),
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        Parent = Holder
    })

    local Bar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Parent = Holder
    })

    local BarCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Bar
    })

    local Fill = Create("Frame", {
        Size = UDim2.new((Default - Min)/(Max - Min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = Bar
    })

    local FillCorner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Fill
    })

    local Dragging = false

    local function Set(input)
        local ratio = math.clamp(
            (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0,
            1
        )

        Fill.Size = UDim2.new(ratio, 0, 1, 0)

        local value = math.floor(Min + ((Max - Min) * ratio))

        ValueLabel.Text = tostring(value)

        if config.Callback then
            pcall(config.Callback, value)
        end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            Set(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Set(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    return Holder
end

--// =========================================
--// NOTIFICATIONS
--// =========================================

function Window:Notify(config)
    config = config or {}

    local Gui = PlayerGui:FindFirstChild("ZempNotifications")

    if not Gui then
        Gui = Create("ScreenGui", {
            Name = "ZempNotifications",
            ResetOnSpawn = false,
            Parent = PlayerGui
        })
    end

    local Notification = Create("Frame", {
        Size = UDim2.new(0, 320, 0, 90),
        Position = UDim2.new(1, 340, 1, -110),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = Gui
    })

    local Corner = Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Notification
    })

    local Stroke = Create("UIStroke", {
        Color = Theme.Stroke,
        Parent = Notification
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })

    local Content = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1,
        Text = config.Content or "",
        TextWrapped = true,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = Notification
    })

    Tween(Notification, {
        Position = UDim2.new(1, -340, 1, -110)
    }, 0.4)

    task.delay(config.Duration or 4, function()
        Tween(Notification, {
            Position = UDim2.new(1, 340, 1, -110)
        }, 0.4)

        task.wait(0.45)

        Notification:Destroy()
    end)
end

--// =========================================
--// WINDOW FUNCTIONS
--// =========================================

function Window:Minimize()
    self.Minimized = not self.Minimized

    Tween(self.Main, {
        Size = self.Minimized
            and UDim2.new(0, 780, 0, 65)
            or UDim2.new(0, 780, 0, 540)
    }, 0.35)
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Zemp
