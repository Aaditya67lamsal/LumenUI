--[[
    Lumen UI Library
    Original • Modern • Clean
    Made from scratch
]]

local Lumen = {
    Version = "1.2.0",
    Flags = {},
    Open = true
}

local Services = {
    Tween = game:GetService("TweenService"),
    UIS = game:GetService("UserInputService"),
    Http = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
    Players = game:GetService("Players"),
    Run = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer

-- Themes
local Themes = {
    Midnight = {
        Bg = Color3.fromRGB(13, 13, 17),
        Side = Color3.fromRGB(18, 18, 24),
        Card = Color3.fromRGB(24, 24, 32),
        Hover = Color3.fromRGB(32, 32, 42),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(240, 240, 250),
        Dim = Color3.fromRGB(140, 140, 160),
        Stroke = Color3.fromRGB(40, 40, 55)
    },
    Ocean = {
        Bg = Color3.fromRGB(10, 16, 24),
        Side = Color3.fromRGB(14, 22, 34),
        Card = Color3.fromRGB(20, 30, 44),
        Hover = Color3.fromRGB(28, 40, 56),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(230, 240, 250),
        Dim = Color3.fromRGB(120, 150, 180),
        Stroke = Color3.fromRGB(35, 55, 75)
    },
    Ember = {
        Bg = Color3.fromRGB(18, 12, 12),
        Side = Color3.fromRGB(26, 16, 16),
        Card = Color3.fromRGB(36, 22, 22),
        Hover = Color3.fromRGB(48, 30, 30),
        Accent = Color3.fromRGB(249, 115, 22),
        Text = Color3.fromRGB(250, 240, 235),
        Dim = Color3.fromRGB(170, 130, 120),
        Stroke = Color3.fromRGB(60, 40, 35)
    },
    Violet = {
        Bg = Color3.fromRGB(15, 12, 22),
        Side = Color3.fromRGB(22, 18, 32),
        Card = Color3.fromRGB(30, 24, 42),
        Hover = Color3.fromRGB(40, 32, 55),
        Accent = Color3.fromRGB(168, 85, 247),
        Text = Color3.fromRGB(240, 230, 255),
        Dim = Color3.fromRGB(150, 130, 180),
        Stroke = Color3.fromRGB(50, 40, 70)
    },
    Forest = {
        Bg = Color3.fromRGB(10, 16, 14),
        Side = Color3.fromRGB(14, 22, 19),
        Card = Color3.fromRGB(20, 30, 26),
        Hover = Color3.fromRGB(28, 40, 34),
        Accent = Color3.fromRGB(34, 197, 94),
        Text = Color3.fromRGB(230, 250, 240),
        Dim = Color3.fromRGB(120, 160, 140),
        Stroke = Color3.fromRGB(35, 55, 45)
    }
}

local Theme = Themes.Midnight

-- Utils
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

local function Tween(obj, time, goal, style)
    local t = Services.Tween:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint), goal)
    t:Play()
    return t
end

local function Protect(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = Services.CoreGui
    else
        gui.Parent = Services.CoreGui
    end
end

local function Drag(frame, handle)
    local dragging, start, startPos, input
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            input = i
        end
    end)
    Services.UIS.InputChanged:Connect(function(i)
        if i == input and dragging then
            local delta = i.Position - start
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Notification System
local NotifContainer
function Lumen:Notify(title, content, duration)
    duration = duration or 4
    if not NotifContainer then
        NotifContainer = Create("Frame", {
            Size = UDim2.new(0, 300, 1, -40),
            Position = UDim2.new(1, -320, 0, 20),
            BackgroundTransparency = 1,
            Parent = nil
        })
        Protect(NotifContainer)
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = NotifContainer
        })
    end

    local n = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Theme.Card,
        Parent = NotifContainer
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = n})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = n})

    local bar = Create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = n
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = bar})

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 16, 0, 10),
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
        Position = UDim2.new(0, 16, 0, 32),
        BackgroundTransparency = 1,
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Theme.Dim,
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

-- Main Create
function Lumen:Create(config)
    config = config or {}
    local title = config.Title or "Lumen"
    local subtitle = config.Subtitle or ""
    local themeName = config.Theme or "Midnight"
    local keybind = config.Keybind or "RightControl"
    local configSettings = config.Config or {Enabled = false}

    Theme = Themes[themeName] or Themes.Midnight

    local Screen = Create("ScreenGui", {
        Name = "Lumen",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    Protect(Screen)

    -- Main Window
    local Main = Create("Frame", {
        Size = UDim2.new(0, 620, 0, 440),
        Position = UDim2.new(0.5, -310, 0.5, -220),
        BackgroundColor3 = Theme.Bg,
        Parent = Screen
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Main})
    Create("UIStroke", {Color = Theme.Stroke, Thickness = 1.2, Parent = Main})

    -- Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 160, 1, 0),
        BackgroundColor3 = Theme.Side,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Sidebar})

    local Logo = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 12),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })
    if subtitle ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 18),
            Position = UDim2.new(0, 10, 0, 40),
            BackgroundTransparency = 1,
            Text = subtitle,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = Theme.Dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Sidebar
        })
    end

    local TabList = Create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -80),
        Position = UDim2.new(0, 6, 0, 70),
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

    -- Content Area
    local Content = Create("Frame", {
        Size = UDim2.new(1, -170, 1, -20),
        Position = UDim2.new(0, 170, 0, 10),
        BackgroundTransparency = 1,
        Parent = Main
    })

    -- Title bar drag
    local TopBar = Create("Frame", {
        Size = UDim2.new(1, -170, 0, 40),
        Position = UDim2.new(0, 170, 0, 0),
        BackgroundTransparency = 1,
        Parent = Main
    })
    Drag(Main, TopBar)

    -- Close / Minimize
    local Close = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -38, 0, 8),
        BackgroundColor3 = Color3.fromRGB(239, 68, 68),
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.new(1, 1, 1),
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Close})
    Close.MouseButton1Click:Connect(function()
        Screen:Destroy()
    end)

    local Minimize = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -72, 0, 8),
        BackgroundColor3 = Theme.Card,
        Text = "–",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        Parent = Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Minimize})

    local Open = true
    Minimize.MouseButton1Click:Connect(function()
        Open = not Open
        Main.Visible = Open
    end)

    -- Keybind toggle
    local keyEnum = Enum.KeyCode[keybind] or Enum.KeyCode.RightControl
    Services.UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == keyEnum then
            Open = not Open
            Main.Visible = Open
        end
    end)

    -- Mobile reopen button
    local MobileBtn = Create("TextButton", {
        Size = UDim2.new(0, 48, 0, 48),
        Position = UDim2.new(0, 20, 0.5, -24),
        BackgroundColor3 = Theme.Accent,
        Text = "L",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Color3.new(1, 1, 1),
        Visible = false,
        Parent = Screen
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MobileBtn})
    MobileBtn.MouseButton1Click:Connect(function()
        Open = true
        Main.Visible = true
        MobileBtn.Visible = false
    end)

    Minimize.MouseButton1Click:Connect(function()
        if not Open then
            MobileBtn.Visible = true
        end
    end)

    local Window = {}
    local Tabs = {}
    local CurrentTab = nil

    function Window:Tab(name, icon)
        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Theme.Card,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabBtn})

        local Icon = nil
        if icon then
            Icon = Create("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 12, 0.5, -10),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = Theme.Dim,
                Parent = TabBtn
            })
        end

        local TabText = Create("TextLabel", {
            Size = UDim2.new(1, icon and -45 or -20, 1, 0),
            Position = UDim2.new(0, icon and 40 or 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Theme.Dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })

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
                Tween(CurrentTab.Btn, 0.2, {BackgroundColor3 = Theme.Card})
                CurrentTab.Text.TextColor3 = Theme.Dim
                if CurrentTab.Icon then CurrentTab.Icon.ImageColor3 = Theme.Dim end
            end
            Page.Visible = true
            Tween(TabBtn, 0.2, {BackgroundColor3 = Theme.Accent})
            TabText.TextColor3 = Color3.new(1, 1, 1)
            if Icon then Icon.ImageColor3 = Color3.new(1, 1, 1) end
            CurrentTab = {Page = Page, Btn = TabBtn, Text = TabText, Icon = Icon}
        end

        TabBtn.MouseButton1Click:Connect(Select)

        if not CurrentTab then
            Select()
        end

        local Tab = {}

        function Tab:Group(name)
            local GroupFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Card,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Page
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = GroupFrame})
            Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = GroupFrame})

            local Header = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                Parent = GroupFrame
            })

            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 12, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                Parent = Header
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 36, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Header
            })

            local Container = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 40),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = GroupFrame
            })
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = Container
            })
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 12),
                Parent = Container
            })

            local Opened = true
            Header.MouseButton1Click:Connect(function()
                Opened = not Opened
                Container.Visible = Opened
                Arrow.Text = Opened and "▼" or "▶"
            end)

            local Group = {}

            function Group:Button(text, callback)
                local Btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Accent,
                    Text = text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = Color3.new(1, 1, 1),
                    AutoButtonColor = false,
                    Parent = Container
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Btn})

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.Accent:Lerp(Color3.new(1,1,1), 0.15)})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Theme.Accent})
                end)
                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                return Btn
            end

            function Group:Switch(text, default, callback)
                local value = default or false
                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Parent = Container
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })

                local Track = Create("Frame", {
                    Size = UDim2.new(0, 42, 0, 22),
                    Position = UDim2.new(1, -48, 0.5, -11),
                    BackgroundColor3 = value and Theme.Accent or Theme.Stroke,
                    Parent = Frame
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})

                local Circle = Create("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
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
                    Tween(Track, 0.2, {BackgroundColor3 = value and Theme.Accent or Theme.Stroke})
                    Tween(Circle, 0.2, {Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
                    if callback then callback(value) end
                end)
                return {Set = function(v)
                    value = v
                    Track.BackgroundColor3 = value and Theme.Accent or Theme.Stroke
                    Circle.Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                end}
            end

            function Group:Slider(text, min, max, default, callback)
                local value = default or min
                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    Parent = Container
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -50, 0, 18),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                local Val = Create("TextLabel", {
                    Size = UDim2.new(0, 50, 0, 18),
                    Position = UDim2.new(1, -50, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(value),
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = Theme.Accent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Frame
                })

                local Bar = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 32),
                    BackgroundColor3 = Theme.Stroke,
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
                Services.UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                Services.UIS.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        local pct = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * pct + 0.5)
                        Fill.Size = UDim2.new(pct, 0, 1, 0)
                        Val.Text = tostring(value)
                        if callback then callback(value) end
                    end
                end)
            end

            function Group:Dropdown(text, options, default, callback)
                local selected = default or options[1]
                local open = false

                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Hover,
                    Parent = Container
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. selected,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })

                local Arrow = Create("TextLabel", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextColor3 = Theme.Dim,
                    Parent = Frame
                })

                local DropFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 4),
                    BackgroundColor3 = Theme.Card,
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Frame
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = DropFrame})
                Create("UIStroke", {Color = Theme.Stroke, Parent = DropFrame})
                Create("UIListLayout", {Parent = DropFrame})

                for _, opt in ipairs(options) do
                    local Opt = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundTransparency = 1,
                        Text = "  " .. opt,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = DropFrame
                    })
                    Opt.MouseButton1Click:Connect(function()
                        selected = opt
                        Label.Text = text .. ": " .. selected
                        open = false
                        DropFrame.Visible = false
                        DropFrame.Size = UDim2.new(1, 0, 0, 0)
                        if callback then callback(selected) end
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
                    DropFrame.Visible = open
                    DropFrame.Size = open and UDim2.new(1, 0, 0, #options * 30) or UDim2.new(1, 0, 0, 0)
                end)
            end

            function Group:Input(text, placeholder, callback)
                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.Hover,
                    Parent = Container
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})

                local Box = Create("TextBox", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText = placeholder or "Type here...",
                    Text = "",
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    PlaceholderColor3 = Theme.Dim,
                    ClearTextOnFocus = false,
                    Parent = Frame
                })
                Box.FocusLost:Connect(function(enter)
                    if callback then callback(Box.Text) end
                end)
            end

            function Group:Keybind(text, default, callback)
                local current = default or "None"
                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Parent = Container
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -90, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                local Btn = Create("TextButton", {
                    Size = UDim2.new(0, 80, 0, 26),
                    Position = UDim2.new(1, -85, 0.5, -13),
                    BackgroundColor3 = Theme.Hover,
                    Text = current,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 12,
                    TextColor3 = Theme.Text,
                    Parent = Frame
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})

                local listening = false
                Btn.MouseButton1Click:Connect(function()
                    listening = true
                    Btn.Text = "..."
                end)
                Services.UIS.InputBegan:Connect(function(input, gpe)
                    if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                        current = input.KeyCode.Name
                        Btn.Text = current
                        listening = false
                        if callback then callback(current) end
                    end
                end)
            end

            function Group:Label(text)
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextColor3 = Theme.Dim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Container
                })
            end

            function Group:Paragraph(title, content)
                local Frame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = Container
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = title,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = content,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Theme.Dim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = Frame
                })
            end

            return Group
        end

        return Tab
    end

    return Window
end

return Lumen
