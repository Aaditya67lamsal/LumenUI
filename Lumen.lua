--[[
    Lumen UI Library
    Premium Design • Yellow Accent
    Made to match modern hub style
]]

local Lumen = {
    Version = "2.0.0",
    Flags = {}
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Theme (Yellow Accent)
local Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Sidebar = Color3.fromRGB(20, 20, 24),
    Card = Color3.fromRGB(28, 28, 34),
    CardHover = Color3.fromRGB(35, 35, 42),
    Accent = Color3.fromRGB(245, 166, 35),          -- Yellow/Gold
    AccentDark = Color3.fromRGB(200, 130, 20),
    Text = Color3.fromRGB(240, 240, 245),
    TextDim = Color3.fromRGB(140, 140, 155),
    Stroke = Color3.fromRGB(45, 45, 55),
    Success = Color3.fromRGB(80, 200, 120),
    ToggleOff = Color3.fromRGB(60, 60, 70)
}

--// Utilities
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Tween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint), props)
    t:Play()
    return t
end

local function Protect(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--// Notification
local NotifHolder
function Lumen:Notify(title, content, duration)
    duration = duration or 4
    if not NotifHolder then
        NotifHolder = Create("Frame", {
            Size = UDim2.new(0, 300, 1, -40),
            Position = UDim2.new(1, -320, 0, 20),
            BackgroundTransparency = 1,
            Parent = nil
        })
        Protect(NotifHolder)
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = NotifHolder
        })
    end

    local n = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Theme.Card,
        Parent = NotifHolder
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = n})
    Create("UIStroke", {Color = Theme.Accent, Thickness = 1.2, Parent = n})

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = n
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 14, 0, 32),
        BackgroundTransparency = 1,
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = n
    })

    n.Position = UDim2.new(1, 40, 0, 0)
    Tween(n, 0.35, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(duration, function()
        if n and n.Parent then
            Tween(n, 0.3, {Position = UDim2.new(1, 40, 0, 0)})
            task.wait(0.35)
            n:Destroy()
        end
    end)
end

--// Main Create
function Lumen:Create(config)
    config = config or {}
    local title = config.Title or "LUMEN"
    local subtitle = config.Subtitle or "v1.0"
    local keybind = config.Keybind or "RightControl"

    local Screen = Create("ScreenGui", {
        Name = "LumenUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    Protect(Screen)

    -- Main Window
    local Main = Create("Frame", {
        Size = UDim2.new(0, 720, 0, 480),
        Position = UDim2.new(0.5, -360, 0.5, -240),
        BackgroundColor3 = Theme.Background,
        Parent = Screen
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.2, Parent = Main})

    -- Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Sidebar})

    -- Logo
    local Logo = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })

    local VersionBadge = Create("TextLabel", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(0, 16, 0, 48),
        BackgroundColor3 = Theme.Card,
        Text = subtitle,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Theme.Accent,
        Parent = Sidebar
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = VersionBadge})

    -- Tab List
    local TabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -140),
        Position = UDim2.new(0, 6, 0, 80),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = TabList
    })

    -- Player Badge (Bottom)
    local PlayerBadge = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 1, -60),
        BackgroundColor3 = Theme.Card,
        Parent = Sidebar
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = PlayerBadge})

    Create("TextLabel", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 10, 0.5, -14),
        BackgroundColor3 = Theme.Accent,
        Text = "P1",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.new(0, 0, 0),
        Parent = PlayerBadge
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = PlayerBadge:FindFirstChildOfClass("TextLabel")})

    Create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 18),
        Position = UDim2.new(0, 46, 0, 8),
        BackgroundTransparency = 1,
        Text = LocalPlayer.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = PlayerBadge
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 16),
        Position = UDim2.new(0, 46, 0, 26),
        BackgroundTransparency = 1,
        Text = "Premium",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.Success,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = PlayerBadge
    })

    -- Content Area
    local Content = Create("Frame", {
        Size = UDim2.new(1, -195, 1, -20),
        Position = UDim2.new(0, 190, 0, 10),
        BackgroundTransparency = 1,
        Parent = Main
    })

    -- Top Bar (for dragging)
    local TopBar = Create("Frame", {
        Size = UDim2.new(1, -195, 0, 40),
        Position = UDim2.new(0, 190, 0, 0),
        BackgroundTransparency = 1,
        Parent = Main
    })
    MakeDraggable(Main, TopBar)

    -- Close Button
    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -42, 0, 10),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.new(1, 1, 1),
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
    CloseBtn.MouseButton1Click:Connect(function()
        Screen:Destroy()
    end)

    -- Minimize
    local MinBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -78, 0, 10),
        BackgroundColor3 = Theme.Card,
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MinBtn})

    local isOpen = true
    MinBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Main.Visible = isOpen
    end)

    -- Keybind
    local keyEnum = Enum.KeyCode[keybind] or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == keyEnum then
            isOpen = not isOpen
            Main.Visible = isOpen
        end
    end)

    -- Floating L Button
    local FloatBtn = Create("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(0, 20, 0.5, -26),
        BackgroundColor3 = Theme.Accent,
        Text = "L",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Color3.new(0, 0, 0),
        Visible = false,
        Parent = Screen
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = FloatBtn})
    Create("UIStroke", {Color = Color3.fromRGB(255, 200, 80), Thickness = 2, Parent = FloatBtn})

    FloatBtn.MouseButton1Click:Connect(function()
        isOpen = true
        Main.Visible = true
        FloatBtn.Visible = false
    end)

    MinBtn.MouseButton1Click:Connect(function()
        if not isOpen then
            FloatBtn.Visible = true
        end
    end)

    --// Window Object
    local Window = {}
    local CurrentTab = nil
    local TabCount = 0

    function Window:nTab(options)
        options = options or {}
        local name = options.Name or "Tab"
        TabCount = TabCount + 1
        local tabNumber = TabCount

        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Card,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabBtn})

        local AccentBar = Create("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = Theme.Accent,
            Visible = false,
            Parent = TabBtn
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = AccentBar})

        local TabText = Create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })

        local NumberBadge = Create("TextLabel", {
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -32, 0.5, -11),
            BackgroundColor3 = Theme.Background,
            Text = tostring(tabNumber),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Theme.TextDim,
            Parent = TabBtn
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NumberBadge})

        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, -10, 1, -50),
            Position = UDim2.new(0, 5, 0, 45),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = Content
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            Parent = Page
        })
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 20),
            Parent = Page
        })

        local function Select()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                CurrentTab.Accent.Visible = false
                CurrentTab.Text.TextColor3 = Theme.TextDim
                CurrentTab.Btn.BackgroundColor3 = Theme.Card
                CurrentTab.Number.TextColor3 = Theme.TextDim
            end
            Page.Visible = true
            AccentBar.Visible = true
            TabText.TextColor3 = Theme.Accent
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 32, 18)
            NumberBadge.TextColor3 = Theme.Accent
            CurrentTab = {
                Page = Page,
                Accent = AccentBar,
                Text = TabText,
                Btn = TabBtn,
                Number = NumberBadge
            }
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if not CurrentTab then Select() end

        local Tab = {}

        -- nButton
        function Tab:nButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Accent,
                Text = name,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Color3.new(0, 0, 0),
                AutoButtonColor = false,
                Parent = Page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Btn})

            Btn.MouseEnter:Connect(function()
                Tween(Btn, 0.15, {BackgroundColor3 = Theme.AccentDark})
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, 0.15, {BackgroundColor3 = Theme.Accent})
            end)
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        -- nToggle
        function Tab:nToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            local value = default

            local Frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Card,
                Parent = Page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Frame})

            Create("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Frame
            })

            local Track = Create("Frame", {
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -56, 0.5, -12),
                BackgroundColor3 = value and Theme.Accent or Theme.ToggleOff,
                Parent = Frame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})

            local Circle = Create("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Parent = Track
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Circle})

            local Click = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Frame
            })
            Click.MouseButton1Click:Connect(function()
                value = not value
                Tween(Track, 0.2, {BackgroundColor3 = value and Theme.Accent or Theme.ToggleOff})
                Tween(Circle, 0.2, {Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)})
                callback(value)
            end)

            return {
                Set = function(v)
                    value = v
                    Track.BackgroundColor3 = value and Theme.Accent or Theme.ToggleOff
                    Circle.Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                end
            }
        end

        -- nSlider
        function Tab:nSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            local value = default

            local Frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Theme.Card,
                Parent = Page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Frame})

            Create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 16, 0, 10),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Frame
            })

            local ValLabel = Create("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -70, 0, 10),
                BackgroundTransparency = 1,
                Text = tostring(value),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Frame
            })

            local Bar = Create("Frame", {
                Size = UDim2.new(1, -32, 0, 6),
                Position = UDim2.new(0, 16, 0, 40),
                BackgroundColor3 = Theme.ToggleOff,
                Parent = Frame
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Bar})

            local Fill = Create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                Parent = Bar
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

            local dragging = false
            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    local pct = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * pct + 0.5)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValLabel.Text = tostring(value)
                    callback(value)
                end
            end)
        end

        -- nDropdown
        function Tab:nDropdown(options)
            options = options or {}
            local name = options.Name or "Dropdown"
            local list = options.Options or {"Option 1"}
            local default = options.Default or list[1]
            local callback = options.Callback or function() end
            local selected = default
            local open = false

            local Frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.Card,
                Parent = Page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Frame})

            local Label = Create("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 16, 0, 0),
                BackgroundTransparency = 1,
                Text = name .. ": " .. selected,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Frame
            })

            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -30, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                Parent = Frame
            })

            local Drop = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 6),
                BackgroundColor3 = Theme.Card,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 10,
                Parent = Frame
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Drop})
            Create("UIStroke", {Color = Theme.Stroke, Parent = Drop})
            Create("UIListLayout", {Parent = Drop})

            for _, opt in ipairs(list) do
                local Opt = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Text = "  " .. opt,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = Drop
                })
                Opt.MouseButton1Click:Connect(function()
                    selected = opt
                    Label.Text = name .. ": " .. selected
                    open = false
                    Drop.Visible = false
                    Drop.Size = UDim2.new(1, 0, 0, 0)
                    callback(selected)
                end)
            end

            local Click = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = Frame
            })
            Click.MouseButton1Click:Connect(function()
                open = not open
                Drop.Visible = open
                Drop.Size = open and UDim2.new(1, 0, 0, #list * 34) or UDim2.new(1, 0, 0, 0)
            end)
        end

        -- nLabel
        function Tab:nLabel(options)
            options = options or {}
            local text = options.Text or options.Name or "Label"
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
        end

        return Tab
    end

    return Window
end

return Lumen
