-- ╔══════════════════════════════════════════════════════════════════╗
-- ║          OBELUS UI  ·  v2 — Subtab Edition                      ║
-- ║  Full library with real subtab system built in                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- Variables
    local uis            = game:GetService("UserInputService")
    local players        = game:GetService("Players")
    local ws             = game:GetService("Workspace")
    local rs             = game:GetService("ReplicatedStorage")
    local http_service   = game:GetService("HttpService")
    local gui_service    = game:GetService("GuiService")
    local lighting       = game:GetService("Lighting")
    local run            = game:GetService("RunService")
    local stats          = game:GetService("Stats")
    local coregui        = game.Players.LocalPlayer.PlayerGui
    local debris         = game:GetService("Debris")
    local tween_service  = game:GetService("TweenService")
    local sound_service  = game:GetService("SoundService")

    local vec2       = Vector2.new
    local vec3       = Vector3.new
    local dim2       = UDim2.new
    local dim        = UDim.new
    local rect       = Rect.new
    local cfr        = CFrame.new
    local empty_cfr  = cfr()
    local angle      = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color  = Color3.new
    local rgb    = Color3.fromRGB
    local hex    = Color3.fromHex
    local hsv    = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera     = ws.CurrentCamera
    local lp         = players.LocalPlayer
    local mouse      = lp:GetMouse()
    local gui_offset = gui_service:GetGuiInset().Y

    local max    = math.max
    local floor  = math.floor
    local min    = math.min
    local abs    = math.abs
    local noise  = math.noise
    local rad    = math.rad
    local random = math.random
    local sin    = math.sin
    local pi     = math.pi
    local tan    = math.tan
    local atan2  = math.atan2
    local clamp  = math.clamp

    local insert = table.insert
    local find   = table.find
    local remove = table.remove
    local concat = table.concat
--

-- Library init
    if getgenv().library then
        library:unloadMenu()
    end

    getgenv().library = {
        directory    = "obels",
        folders      = { "/fonts", "/configs" },
        flags        = {},
        config_flags = {},
        connections  = {},
        notifications = { notifs = {}, offset = 0 },
        playerlist_data = { players = {}, player = {} },
        colorpicker_open = false,
        gui = nil,
    }

    -- Default theme — black/white body, light blue accent
    local themes = {
        preset = {
            ["accent"]       = rgb(135, 200, 240),   -- light ice-blue
            ["accent2"]      = rgb(100, 170, 210),
            ["background"]   = rgb(12, 12, 12),
            ["section_bg"]   = rgb(19, 19, 19),
            ["border"]       = rgb(45, 45, 45),
            ["text"]         = rgb(180, 180, 180),
            ["text_dim"]     = rgb(120, 120, 120),
        },
        utility = {
            ["accent"] = {
                ["BackgroundColor3"]      = {},
                ["TextColor3"]            = {},
                ["ImageColor3"]           = {},
                ["ScrollBarImageColor3"]  = {},
            },
        },
    }

    local keys = {
        [Enum.KeyCode.LeftShift]          = "LS",
        [Enum.KeyCode.RightShift]         = "RS",
        [Enum.KeyCode.LeftControl]        = "LC",
        [Enum.KeyCode.RightControl]       = "RC",
        [Enum.KeyCode.Insert]             = "INS",
        [Enum.KeyCode.Backspace]          = "BS",
        [Enum.KeyCode.Return]             = "Ent",
        [Enum.KeyCode.LeftAlt]            = "LA",
        [Enum.KeyCode.RightAlt]           = "RA",
        [Enum.KeyCode.CapsLock]           = "CAPS",
        [Enum.KeyCode.One]                = "1",
        [Enum.KeyCode.Two]                = "2",
        [Enum.KeyCode.Three]              = "3",
        [Enum.KeyCode.Four]               = "4",
        [Enum.KeyCode.Five]               = "5",
        [Enum.KeyCode.Six]                = "6",
        [Enum.KeyCode.Seven]              = "7",
        [Enum.KeyCode.Eight]              = "8",
        [Enum.KeyCode.Nine]               = "9",
        [Enum.KeyCode.Zero]               = "0",
        [Enum.KeyCode.KeypadOne]          = "Num1",
        [Enum.KeyCode.KeypadTwo]          = "Num2",
        [Enum.KeyCode.KeypadThree]        = "Num3",
        [Enum.KeyCode.KeypadFour]         = "Num4",
        [Enum.KeyCode.KeypadFive]         = "Num5",
        [Enum.KeyCode.KeypadSix]          = "Num6",
        [Enum.KeyCode.KeypadSeven]        = "Num7",
        [Enum.KeyCode.KeypadEight]        = "Num8",
        [Enum.KeyCode.KeypadNine]         = "Num9",
        [Enum.KeyCode.KeypadZero]         = "Num0",
        [Enum.KeyCode.Minus]              = "-",
        [Enum.KeyCode.Equals]             = "=",
        [Enum.KeyCode.Tilde]              = "~",
        [Enum.KeyCode.LeftBracket]        = "[",
        [Enum.KeyCode.RightBracket]       = "]",
        [Enum.KeyCode.Semicolon]          = ";",
        [Enum.KeyCode.Quote]              = "'",
        [Enum.KeyCode.BackSlash]          = "\\",
        [Enum.KeyCode.Comma]              = ",",
        [Enum.KeyCode.Period]             = ".",
        [Enum.KeyCode.Slash]              = "/",
        [Enum.KeyCode.Asterisk]           = "*",
        [Enum.KeyCode.Plus]               = "+",
        [Enum.KeyCode.Backquote]          = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape]             = "ESC",
        [Enum.KeyCode.Space]              = "SPC",
    }

    library.__index = library

    for _, path in next, library.folders do
        makefolder(library.directory .. path)
    end

    local flags        = library.flags
    local config_flags = library.config_flags

    if not LPH_OBFUSCATED then
        getfenv().LPH_NO_VIRTUALIZE = function(...) return (...) end
    end

    -- Font importing
        if not isfile(library.directory .. "/fonts/main.ttf") then
            writefile(library.directory .. "/fonts/main.ttf",
                game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"))
        end

        local tahoma = {
            name  = "SmallestPixel7",
            faces = {{
                name    = "Regular",
                weight  = 400,
                style   = "normal",
                assetId = getcustomasset(library.directory .. "/fonts/main.ttf")
            }}
        }

        if not isfile(library.directory .. "/fonts/main_encoded.ttf") then
            writefile(library.directory .. "/fonts/main_encoded.ttf",
                http_service:JSONEncode(tahoma))
        end

        library.font = Font.new(
            getcustomasset(library.directory .. "/fonts/main_encoded.ttf"),
            Enum.FontWeight.Regular)
    --

-- ══════════════════════════════════════════════════════════════════════
-- Library utility functions
-- ══════════════════════════════════════════════════════════════════════

    function library:tween(obj, properties)
        tween_service:Create(obj,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            properties):Play()
    end

    function library:closeCurrentElement(cfg)
        local path = library.current_element_open
        if path and path ~= cfg then
            path.setVisible(false)
            path.open = false
        end
    end

    function library:makeResizable(frame)
        local Frame = Instance.new("TextButton")
        Frame.Position        = dim2(1, -10, 1, -10)
        Frame.BorderColor3    = rgb(0, 0, 0)
        Frame.Size            = dim2(0, 10, 0, 10)
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = rgb(255, 255, 255)
        Frame.Parent          = frame
        Frame.BackgroundTransparency = 1
        Frame.Text            = ""

        local resizing, start_size, start = false, nil, nil
        local og_size = frame.Size

        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing   = true
                start      = input.Position
                start_size = frame.Size
            end
        end)
        Frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        library:connection(uis.InputChanged, function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local vx, vy = camera.ViewportSize.X, camera.ViewportSize.Y
                frame.Size = dim2(
                    start_size.X.Scale,
                    math.clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, vx),
                    start_size.Y.Scale,
                    math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, vy))
            end
        end)
    end

    function library:mouseInFrame(obj)
        local ap = obj.AbsolutePosition; local as = obj.AbsoluteSize
        return mouse.X >= ap.X and mouse.X <= ap.X + as.X
           and mouse.Y >= ap.Y and mouse.Y <= ap.Y + as.Y
    end

    library.lerp = LPH_NO_VIRTUALIZE(function(s, f, t)
        t = t or 1/8
        return s * (1 - t) + f * t
    end)

    function library:draggify(frame)
        local dragging, start, start_pos = false, nil, nil
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging  = true
                start     = input.Position
                start_pos = frame.Position
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        library:connection(uis.InputChanged, function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local vx, vy = camera.ViewportSize.X, camera.ViewportSize.Y
                frame.Position = dim2(0,
                    clamp(start_pos.X.Offset + (input.Position.X - start.X), 0, vx - frame.Size.X.Offset),
                    0,
                    clamp(start_pos.Y.Offset + (input.Position.Y - start.Y), 0, vy - frame.Size.Y.Offset))
            end
        end)
    end

    function library:convertEnum(enum)
        local parts = {}
        for p in string.gmatch(enum, "[%w_]+") do insert(parts, p) end
        local e = Enum
        for i = 2, #parts do e = e[parts[i]] end
        return e
    end

    local config_holder
    function library:configListUpdate()
        if not config_holder then return end
        local list = {}
        for _, file in next, listfiles(library.directory .. "/configs") do
            local name = file:gsub(library.directory .. "\\configs\\", ""):gsub(".cfg", "")
            list[#list + 1] = name
        end
        config_holder.refresh_options(list)
    end

    function library:getConfig()
        local Config = {}
        for _, v in flags do
            if type(v) == "table" and v.key then
                Config[_] = { active = v.active, mode = v.mode, key = tostring(v.key) }
            elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                Config[_] = { Transparency = v["Transparency"], Color = v["Color"]:ToHex() }
            else
                Config[_] = v
            end
        end
        return http_service:JSONEncode(Config)
    end

    function library:loadConfig(config_json)
        local config = http_service:JSONDecode(config_json)
        for _, v in next, config do
            local fn = library.config_flags[_]
            if fn then
                if type(v) == "table" and not v["active"] then
                    fn(hex(v["Color"]), v["Transparency"])
                elseif type(v) == "table" and v["active"] then
                    fn(v)
                else
                    fn(v)
                end
            end
        end
    end

    function library:round(number, float)
        local m = 1 / (float or 1)
        return floor(number * m + 0.5) / m
    end

    function library:applyTheme(instance, theme, property)
        if themes.utility[theme] and themes.utility[theme][property] then
            insert(themes.utility[theme][property], instance)
        end
    end

    function library:updateTheme(theme, clr)
        if not themes.utility[theme] then return end
        for prop, objects in next, themes.utility[theme] do
            for _, obj in next, objects do
                pcall(function() obj[prop] = clr end)
            end
        end
        themes.preset[theme] = clr
    end

    function library:connection(signal, callback)
        local conn = signal:Connect(callback)
        insert(library.connections, conn)
        return conn
    end

    function library:applyStroke(parent)
        local s = library:create("UIStroke", {
            Parent = parent,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = rgb(30, 30, 30),
        })
    end

    function library:create(instance, options)
        local ins = Instance.new(instance)
        for prop, val in next, options do
            ins[prop] = val
        end
        return ins
    end

    function library:unloadMenu()
        if library.gui then library.gui:Destroy() end
        for _, conn in next, library.connections do
            conn:Disconnect()
        end
        getgenv().library = nil
    end

-- ══════════════════════════════════════════════════════════════════════
-- ColorPicker
-- ══════════════════════════════════════════════════════════════════════

    function library:initializeColorPicker(options)
        local cfg = {
            name     = options.name     or "Color",
            flag     = options.flag     or tostring(2^789),
            color    = options.color    or color(1,1,1),
            alpha    = options.alpha    or 1,
            callback = options.callback or function() end,
            open     = false,
        }

        flags[cfg.flag] = {
            animation      = "None",
            animationSpeed = 0.2,
            color1 = { rgb(255,255,255), 0 },
            color2 = { rgb(255,0,255),   0 },
        }
        local flagDirectory = flags[cfg.flag]

        local draggingSaturation, draggingHue, draggingAlpha = false, false, false

        local OUTLINE = library:create("Frame", {
            Parent             = library.gui,
            Visible            = false,
            Position           = dim2(0,120,0,228),
            BorderColor3       = rgb(0,0,0),
            Size               = dim2(0,150,0,150),
            BorderSizePixel    = 0,
            BackgroundColor3   = rgb(1,1,1),
            ZIndex             = 999,
        })
        library:draggify(OUTLINE)
        library:makeResizable(OUTLINE)
        cfg.outline = OUTLINE

        local inline = library:create("Frame", {
            Parent = OUTLINE, Position = dim2(0,1,0,1), BorderSizePixel = 0,
            Size = dim2(1,-2,1,-2), BackgroundColor3 = rgb(45,45,45), BorderColor3 = rgb(0,0,0),
        })
        local INSTANCE_HOLDERS = library:create("Frame", {
            Parent = inline, Position = dim2(0,1,0,1), BorderSizePixel = 0,
            Size = dim2(1,-2,1,-2), BackgroundColor3 = rgb(12,12,12), BorderColor3 = rgb(0,0,0),
        })

        local h, s, v = color(1,1,1):ToHSV()
        local a = 0

        local colorpicker_picker = library:create("Frame", {
            Parent = INSTANCE_HOLDERS, Visible = true,
            BackgroundTransparency = 1, Position = dim2(0,0,0,20),
            Size = dim2(1,0,1,-26), BorderSizePixel = 0,
            BorderColor3 = rgb(0,0,0), BackgroundColor3 = rgb(255,255,255),
        })
        local outline_cp = library:create("Frame", {
            Parent = colorpicker_picker, Position = dim2(0,6,0,6),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-62,1,-5),
            BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local inline_cp = library:create("Frame", {
            Parent = outline_cp, Position = dim2(0,1,0,1),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-2,1,-2),
            BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local background_cp = library:create("Frame", {
            Parent = inline_cp, Position = dim2(0,1,0,1),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-2,1,-2),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local dragging_sat_val = library:create("Frame", {
            Parent = background_cp, Size = dim2(0,2,0,2),
            BorderColor3 = rgb(0,0,0), ZIndex = 3,
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIStroke", { Parent = dragging_sat_val, LineJoinMode = Enum.LineJoinMode.Miter })
        local sat = library:create("TextButton", {
            Parent = background_cp, Size = dim2(1,0,1,0), Text = "",
            AutoButtonColor = false, BorderColor3 = rgb(0,0,0), ZIndex = 2,
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,183,0),
        })
        library:create("UIGradient", {
            Parent = sat, Rotation = 270,
            Transparency = numseq{numkey(0,0), numkey(1,1)},
            Color = rgbseq{rgbkey(0,rgb(0,0,0)), rgbkey(1,rgb(0,0,0))},
        })
        local val = library:create("TextButton", {
            Parent = background_cp, Text = "", AutoButtonColor = false, Rotation = 180,
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,1,0),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,183,0),
        })
        library:create("UIGradient", { Parent = val, Transparency = numseq{numkey(0,0), numkey(1,1)} })

        local hue = library:create("TextButton", {
            Parent = colorpicker_picker, Text = "", AutoButtonColor = false,
            AnchorPoint = vec2(1,0), Position = dim2(1,-32,0,6),
            BorderColor3 = rgb(0,0,0), Size = dim2(0,16,1,-5),
            BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local hue_inline = library:create("Frame", {
            Parent = hue, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local hue_bg = library:create("Frame", {
            Parent = hue_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIGradient", {
            Parent = hue_bg, Rotation = 270,
            Color = rgbseq{rgbkey(0,rgb(255,0,0)), rgbkey(0.17,rgb(255,255,0)), rgbkey(0.33,rgb(0,255,0)), rgbkey(0.5,rgb(0,255,255)), rgbkey(0.67,rgb(0,0,255)), rgbkey(0.83,rgb(255,0,255)), rgbkey(1,rgb(255,0,0))},
        })
        local hue_picker = library:create("Frame", {
            Parent = hue_bg, BorderMode = Enum.BorderMode.Inset,
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,0,4), BackgroundColor3 = rgb(255,255,255),
        })

        local alpha_btn = library:create("TextButton", {
            Parent = colorpicker_picker, Text = "", AutoButtonColor = false,
            AnchorPoint = vec2(1,0), Position = dim2(1,-8,0,6),
            BorderColor3 = rgb(0,0,0), Size = dim2(0,16,1,-5),
            BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local alpha_inline = library:create("Frame", {
            Parent = alpha_btn, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local alpha_drag = library:create("Frame", {
            Parent = alpha_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(255,183,0),
        })
        local alpha_picker = library:create("Frame", {
            Parent = alpha_drag, BorderMode = Enum.BorderMode.Inset,
            BorderColor3 = rgb(0,0,0), ZIndex = 2, Size = dim2(1,0,0,4),
            BackgroundColor3 = rgb(255,255,255),
        })
        local alphaind = library:create("ImageLabel", {
            Parent = alpha_drag, ScaleType = Enum.ScaleType.Tile,
            BorderColor3 = rgb(0,0,0), Image = "rbxassetid://18274452449",
            BackgroundTransparency = 1, Size = dim2(1,0,1,0),
            TileSize = dim2(0,6,0,6), BorderSizePixel = 0, BackgroundColor3 = rgb(255,183,0),
        })
        library:create("UIGradient", { Parent = alphaind, Rotation = 90, Transparency = numseq{numkey(0,0), numkey(1,1)} })

        local text_holder_cp = library:create("Frame", {
            Parent = INSTANCE_HOLDERS, BackgroundTransparency = 1,
            Position = dim2(0,0,0,5), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,0,0,12), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = text_holder_cp, Padding = dim(0,10),
            FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
        })
        local colorpicker_tab_btn = library:create("TextButton", {
            Parent = text_holder_cp, FontFace = library.font,
            TextColor3 = themes.preset.accent, BorderColor3 = rgb(0,0,0),
            Text = "color", AnchorPoint = vec2(1,0), BackgroundTransparency = 1,
            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 12, BackgroundColor3 = rgb(255,255,255),
        }); library:applyTheme(colorpicker_tab_btn, "accent", "TextColor3")
        library:create("UIPadding", { Parent = text_holder_cp, PaddingLeft = dim(0,10) })

        function cfg.updateColor()
            local mpos = uis:GetMouseLocation()
            if draggingSaturation then
                s = clamp((vec2(mpos.X, mpos.Y - gui_offset) - val.AbsolutePosition).X / val.AbsoluteSize.X, 0, 1)
                v = 1 - clamp((vec2(mpos.X, mpos.Y - gui_offset) - sat.AbsolutePosition).Y / sat.AbsoluteSize.Y, 0, 1)
            elseif draggingHue then
                h = clamp(1 - (vec2(mpos.X, mpos.Y - gui_offset) - hue.AbsolutePosition).Y / hue.AbsoluteSize.Y, 0, 1)
            elseif draggingAlpha then
                a = clamp((vec2(mpos.X, mpos.Y - gui_offset) - alpha_btn.AbsolutePosition).Y / alpha_btn.AbsoluteSize.Y, 0, 1)
            end
            cfg.set(nil, nil)
        end

        function cfg.setVisible(bool)
            OUTLINE.Visible = bool
            if bool then
                library:closeCurrentElement(cfg)
                library.current_element_open = cfg
            end
        end

        function cfg.set(clr, alpha)
            if clr then h, s, v = clr:ToHSV() end
            if alpha then a = alpha end
            local C = hsv(h, s, v)

            local hv = 1 - h; local ho = (hv < 1) and 0 or -4
            hue_picker.Position = dim2(0,0,hv,ho)

            local ao = (a < 1) and 0 or -4
            alpha_picker.Position = dim2(0,0,a,ao)
            alpha_drag.BackgroundColor3 = C

            local so = (s < 1) and 0 or -3; local vo = (1-v < 1) and 0 or -3
            dragging_sat_val.Position = dim2(s,so,1-v,vo)
            val.BackgroundColor3 = hsv(h,1,1)
            sat.BackgroundColor3 = hsv(h,1,1)

            options.alphaPath.ImageTransparency = a
            options.colorPath.BackgroundColor3  = C

            cfg.callback(C, a)
            flags[cfg.flag] = { Color = C, Transparency = a }
        end

        cfg.set(cfg.color, cfg.alpha)
        library.config_flags[cfg.flag] = cfg.set

        alpha_btn.MouseButton1Down:Connect(function() draggingAlpha = true end)
        hue.MouseButton1Down:Connect(function() draggingHue = true end)
        sat.MouseButton1Down:Connect(function() draggingSaturation = true end)

        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSaturation = false; draggingHue = false; draggingAlpha = false
            end
        end)
        uis.InputChanged:Connect(function(input)
            if (draggingSaturation or draggingHue or draggingAlpha)
            and input.UserInputType == Enum.UserInputType.MouseMovement then
                cfg.updateColor()
            end
        end)

        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- KeyPicker (standalone)
-- ══════════════════════════════════════════════════════════════════════

    function library:keyPicker(options)
        local cfg = {
            name     = options.name     or "Key",
            flag     = options.flag     or tostring(2^789),
            color    = options.color    or color(1,1,1),
            alpha    = options.alpha    or 1,
            ignore   = options.ignore   or false,
            callback = options.callback or function() end,
            open     = false,
        }
        -- (mirrors initializeColorPicker but without animations tab for brevity)
        -- In practice the keybind display is handled by addKeyBind directly.
        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Window
-- ══════════════════════════════════════════════════════════════════════

    function library:window(properties)
        local cfg = {
            name             = properties.name or properties.Name
                               or os.date('<font color="rgb(135,200,240)">obelus</font> | %b %d %Y'),
            size             = properties.size or properties.Size or dim2(0, 540, 0, 580),
            selected_tab     = nil,
            is_closing_menu  = false,
        }

        library.gui = library:create("ScreenGui", {
            Parent           = coregui,
            Enabled          = true,
            ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset   = true,
        })

        local outline = library:create("Frame", {
            Parent           = library.gui,
            Position         = dim2(0.5, -(cfg.size.X.Offset/2), 0.5, -(cfg.size.Y.Offset/2)),
            BorderColor3     = rgb(0,0,0),
            Size             = cfg.size,
            BorderSizePixel  = 0,
            BackgroundColor3 = rgb(0,0,0),
        })
        outline.Position = dim_offset(outline.AbsolutePosition.X, outline.AbsolutePosition.Y)

        library:draggify(outline)
        library:makeResizable(outline)

        local inline = library:create("Frame", {
            Parent = outline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(48,48,48),
        })
        local background = library:create("Frame", {
            Parent = inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = themes.preset.background,
        })

        local title_holder = library:create("Frame", {
            Parent = background, BackgroundTransparency = 1,
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,0,29),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local ui_title = library:create("TextLabel", {
            Parent = title_holder, FontFace = library.font,
            TextColor3 = rgb(135,135,135), BorderColor3 = rgb(0,0,0),
            Text = cfg.name, Size = dim2(1,0,0,24),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0, RichText = true, TextSize = 12,
            BackgroundColor3 = rgb(255,255,255),
        })
        local UIPadding_title = library:create("UIPadding", {
            Parent = ui_title, PaddingLeft = dim(0,8),
        })
        local accent_line = library:create("Frame", {
            Parent = title_holder, Position = dim2(0,0,1,-2),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,0,2),
            BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent,
        }); library:applyTheme(accent_line, "accent", "BackgroundColor3")

        cfg["tab_holder"] = library:create("Frame", {
            Parent = background, Position = dim2(0,0,0,29),
            BackgroundTransparency = 1, BorderColor3 = rgb(0,0,0),
            Size = dim2(1,0,0,30), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = cfg["tab_holder"], FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local tab_sep = library:create("Frame", {
            Parent = background, Position = dim2(0,0,0,59),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,0,1),
            BorderSizePixel = 0, BackgroundColor3 = rgb(30,30,30),
        })

        local page_holder_outline = library:create("Frame", {
            Parent = background, Position = dim2(0,0,0,60),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,0,1,-60),
            BorderSizePixel = 0, BackgroundColor3 = rgb(0,0,0),
        })
        local page_inline = library:create("Frame", {
            Parent = page_holder_outline, Position = dim2(0,1,0,1),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-2,1,-2),
            BorderSizePixel = 0, BackgroundColor3 = rgb(51,51,51),
        })
        cfg["page_holder"] = library:create("Frame", {
            Parent = page_inline, Position = dim2(0,1,0,1),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-2,1,-2),
            BorderSizePixel = 0, BackgroundColor3 = rgb(13,13,13),
        })

        -- Show/hide animation
        local old_data, text_data, image_data, scroll_data = {}, {}, {}, {}

        function cfg.toggle_menu(bool)
            if cfg.is_closing_menu then return end
            cfg.is_closing_menu = true
            if bool then
                for el, t in next, old_data   do library:tween(el, {BackgroundTransparency = t}) end
                for el, t in next, text_data  do library:tween(el, {TextTransparency = t}) end
                for el, t in next, image_data do library:tween(el, {ImageTransparency = t}) end
                for el, t in next, scroll_data do library:tween(el, {ScrollBarImageTransparency = t}) end
            else
                for _, el in next, library.gui:GetDescendants() do
                    if not el:IsA("GuiObject") then continue end
                    old_data[el] = el.BackgroundTransparency
                    library:tween(el, {BackgroundTransparency = 1})
                    if el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox") then
                        text_data[el] = el.TextTransparency
                        library:tween(el, {TextTransparency = 1})
                    end
                    if el:IsA("ImageLabel") or el:IsA("ImageButton") then
                        image_data[el] = el.ImageTransparency
                        library:tween(el, {ImageTransparency = 1})
                    end
                    if el:IsA("ScrollingFrame") then
                        scroll_data[el] = el.ScrollBarImageTransparency
                        library:tween(el, {ScrollBarImageTransparency = 1})
                    end
                end
            end
            task.delay(0.25, function() cfg.is_closing_menu = false end)
        end

        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Tab
-- ══════════════════════════════════════════════════════════════════════

    function library:tab(properties)
        local cfg = {
            name              = properties.name or "tab",
            subtab_initialized = false,
            active_subtab_cfg  = nil,
            subtabs            = {},
        }

        local outline = library:create("TextButton", {
            Parent = self.tab_holder, FontFace = library.font,
            TextColor3 = rgb(0,0,0), BorderColor3 = rgb(0,0,0), Text = "",
            AutoButtonColor = false, Size = dim2(0,0,0,30),
            BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = rgb(0,0,0),
        })
        local tab_inline = library:create("Frame", {
            Parent = outline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(41,41,41),
        })
        local tab_bg = library:create("Frame", {
            Parent = tab_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local gradient = library:create("UIGradient", {
            Parent = tab_bg, Rotation = 90,
            Color = rgbseq{rgbkey(0, rgb(41,41,41)), rgbkey(1, rgb(16,16,16))},
        })
        local text = library:create("TextLabel", {
            Parent = tab_bg, FontFace = library.font,
            TextColor3 = rgb(140,140,140), BorderColor3 = rgb(0,0,0),
            Text = cfg.name, BackgroundTransparency = 1,
            Position = dim2(0,0,0,-1), Size = dim2(1,0,1,0),
            BorderSizePixel = 0, TextSize = 12, BackgroundColor3 = rgb(255,255,255),
        })
        library:applyTheme(text, "accent", "TextColor3")

        local UIPadding_tab = library:create("UIPadding", {
            Parent = tab_bg, PaddingLeft = dim(0,10), PaddingRight = dim(0,10),
        })

        cfg["page"] = library:create("Frame", {
            Parent = self.page_holder, Visible = false,
            Position = dim2(0,0,0,0), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,0,1,0), BorderSizePixel = 0, BackgroundColor3 = rgb(13,13,13),
        })

        -- Default layout for non-subtab tabs (horizontal columns)
        local defaultLayout = library:create("UIListLayout", {
            Parent = cfg["page"], FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = dim(0,11), SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalFlex = Enum.UIFlexAlignment.Fill,
        })
        local defaultPad = library:create("UIPadding", {
            Parent = cfg["page"], PaddingTop = dim(0,11), PaddingBottom = dim(0,11),
            PaddingRight = dim(0,11), PaddingLeft = dim(0,11),
        })
        cfg._defaultLayout = defaultLayout
        cfg._defaultPad    = defaultPad

        function cfg.open_tab()
            library:closeCurrentElement()
            if self.selected_tab then
                self.selected_tab[1].TextColor3 = rgb(140,140,140)
                self.selected_tab[2].Visible = false
                self.selected_tab[3].Color = rgbseq{rgbkey(0,rgb(41,41,41)), rgbkey(1,rgb(16,16,16))}
                self.selected_tab = nil
            end
            text.TextColor3     = themes.preset.accent
            cfg["page"].Visible = true
            gradient.Color = rgbseq{rgbkey(0,rgb(41,41,41)), rgbkey(1,rgb(25,25,25))}
            self.selected_tab = {text, cfg["page"], gradient}
        end

        outline.MouseButton1Down:Connect(function() cfg.open_tab() end)
        if not self.selected_tab then cfg.open_tab() end

        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- SUBTAB SYSTEM  ← new addition
-- ══════════════════════════════════════════════════════════════════════

    function library:subtab(properties)
        local cfg = {
            name = properties.name or "subtab",
        }

        -- First subtab on this tab: build the subtab infrastructure
        if not self.subtab_initialized then
            self.subtab_initialized = true

            -- Remove default horizontal layout (it conflicts with the bar+content split)
            if self._defaultLayout then self._defaultLayout:Destroy(); self._defaultLayout = nil end
            if self._defaultPad    then self._defaultPad:Destroy();    self._defaultPad    = nil end

            -- Subtab button bar (top strip)
            self._subtab_bar = library:create("Frame", {
                Parent           = self.page,
                Position         = dim2(0,0,0,0),
                Size             = dim2(1,0,0,22),
                BackgroundColor3 = rgb(16,16,16),
                BorderSizePixel  = 0,
                BorderColor3     = rgb(0,0,0),
            })
            library:create("UIListLayout", {
                Parent          = self._subtab_bar,
                FillDirection   = Enum.FillDirection.Horizontal,
                SortOrder       = Enum.SortOrder.LayoutOrder,
                Padding         = dim(0,1),
            })
            library:create("UIPadding", {
                Parent      = self._subtab_bar,
                PaddingLeft = dim(0,6),
                PaddingTop  = dim(0,5),
            })

            -- Thin accent separator below bar
            self._subtab_sep = library:create("Frame", {
                Parent           = self.page,
                Position         = dim2(0,0,0,22),
                Size             = dim2(1,0,0,1),
                BackgroundColor3 = themes.preset.accent,
                BorderSizePixel  = 0,
            }); library:applyTheme(self._subtab_sep, "accent", "BackgroundColor3")

            -- Content area (fills the rest)
            self._subtab_content = library:create("Frame", {
                Parent           = self.page,
                Position         = dim2(0,0,0,23),
                Size             = dim2(1,0,1,-23),
                BackgroundTransparency = 1,
                BorderSizePixel  = 0,
                BackgroundColor3 = rgb(13,13,13),
            })
        end

        -- Create the subtab button
        local btn_outline = library:create("TextButton", {
            Parent           = self._subtab_bar,
            Text             = "",
            AutoButtonColor  = false,
            Size             = dim2(0,0,1,0),
            AutomaticSize    = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(16,16,16),
            BorderSizePixel  = 0,
            BorderColor3     = rgb(0,0,0),
        })
        local btn_text = library:create("TextLabel", {
            Parent           = btn_outline,
            FontFace         = library.font,
            Text             = cfg.name,
            TextSize         = 11,
            TextColor3       = themes.preset.text_dim or rgb(110,110,110),
            BackgroundTransparency = 1,
            Size             = dim2(1,0,1,0),
            BorderSizePixel  = 0,
            BackgroundColor3 = rgb(16,16,16),
        })
        library:create("UIPadding", {
            Parent       = btn_outline,
            PaddingLeft  = dim(0,8),
            PaddingRight = dim(0,8),
        })

        -- Create this subtab's content page
        local subtab_page = library:create("Frame", {
            Parent           = self._subtab_content,
            Visible          = false,
            Size             = dim2(1,0,1,0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            BackgroundColor3 = rgb(13,13,13),
        })
        library:create("UIListLayout", {
            Parent            = subtab_page,
            FillDirection     = Enum.FillDirection.Horizontal,
            HorizontalFlex    = Enum.UIFlexAlignment.Fill,
            Padding           = dim(0,11),
            SortOrder         = Enum.SortOrder.LayoutOrder,
            VerticalFlex      = Enum.UIFlexAlignment.Fill,
        })
        library:create("UIPadding", {
            Parent        = subtab_page,
            PaddingTop    = dim(0,8),
            PaddingBottom = dim(0,8),
            PaddingRight  = dim(0,8),
            PaddingLeft   = dim(0,8),
        })

        cfg.page       = subtab_page
        cfg._btn_text  = btn_text
        cfg._btn_outline = btn_outline

        local tabSelf = self

        function cfg.open_subtab()
            -- Close previous
            if tabSelf.active_subtab_cfg then
                tabSelf.active_subtab_cfg.page.Visible = false
                tabSelf.active_subtab_cfg._btn_text.TextColor3 = themes.preset.text_dim or rgb(110,110,110)
            end
            -- Open this
            subtab_page.Visible     = true
            btn_text.TextColor3     = themes.preset.accent
            tabSelf.active_subtab_cfg = cfg
        end

        btn_outline.MouseButton1Down:Connect(function() cfg.open_subtab() end)

        -- Auto-select first subtab
        if not self.active_subtab_cfg then
            cfg.open_subtab()
        end

        insert(self.subtabs, cfg)
        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Column
-- ══════════════════════════════════════════════════════════════════════

    function library:column(properties)
        local cfg = {
            fill = properties.fill or properties.Fill or false,
        }
        cfg["column"] = library:create("Frame", {
            Parent           = self.page,
            BackgroundTransparency = 1,
            BorderColor3     = rgb(0,0,0),
            Size             = dim2(0,100,0,100),
            BorderSizePixel  = 0,
            BackgroundColor3 = rgb(12,12,12),
        })
        library:create("UIListLayout", {
            Parent        = cfg["column"],
            Padding       = dim(0,12),
            SortOrder     = Enum.SortOrder.LayoutOrder,
            VerticalFlex  = cfg.fill and Enum.UIFlexAlignment.Fill or Enum.UIFlexAlignment.None,
        })
        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Section
-- ══════════════════════════════════════════════════════════════════════

    function library:section(properties)
        local cfg = {
            name = properties.name or properties.Name or "section",
            size = properties.size or properties.Size or dim2(1,0,1,-12),
        }

        local outline = library:create("Frame", {
            Parent           = self.column,
            BorderColor3     = rgb(0,0,0),
            Size             = self.fill and dim2(1,0,0,0) or cfg.size,
            BorderSizePixel  = 0,
            BackgroundColor3 = rgb(12,12,12),
        })
        local inline = library:create("Frame", {
            Parent = outline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local background = library:create("Frame", {
            Parent = inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(19,19,19),
        })
        local scrollbar_fill = library:create("Frame", {
            Parent = background, Visible = false, Size = dim2(0,5,1,0),
            Position = dim2(1,-5,0,0), BorderColor3 = rgb(0,0,0), ZIndex = 4,
            BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local shadow = library:create("Frame", {
            Parent = background, Size = dim2(1,-5,0,21), Position = dim2(0,0,1,-21),
            BorderColor3 = rgb(0,0,0), ZIndex = 999, BorderSizePixel = 0,
            BackgroundColor3 = rgb(19,19,19),
        })
        library:create("UIGradient", { Parent = shadow, Rotation = -90, Transparency = numseq{numkey(0,0), numkey(1,1)} })

        local elements_scroll = library:create("ScrollingFrame", {
            Parent = background, ScrollBarImageColor3 = rgb(65,65,65), Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4,
            BorderColor3 = rgb(0,0,0), BackgroundTransparency = 1,
            Size = dim2(1,0,1,0), BackgroundColor3 = rgb(255,255,255),
            ZIndex = 5, BorderSizePixel = 0, CanvasSize = dim2(0,0,0,0),
        })
        cfg["elements"] = library:create("Frame", {
            Parent = elements_scroll, Position = dim2(0,8,0,16),
            BorderColor3 = rgb(0,0,0), Size = dim2(1,-16,0,0),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = cfg["elements"], SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = dim(0,3),
        })
        local empty_space = library:create("Frame", {
            Parent = cfg["elements"], LayoutOrder = 9999999,
            BackgroundTransparency = 1, BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,50), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })

        local section_title = library:create("TextLabel", {
            Parent = outline, FontFace = library.font,
            TextColor3 = rgb(205,205,205), BorderColor3 = rgb(0,0,0),
            Text = cfg.name, AutomaticSize = Enum.AutomaticSize.XY,
            AnchorPoint = vec2(0,0.5), Position = dim2(0,14,0,3),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0, ZIndex = 2, TextSize = 12,
            BackgroundColor3 = rgb(19,19,19),
        })
        local section_filler = library:create("Frame", {
            Parent = outline, AnchorPoint = vec2(0,0.5),
            Position = dim2(0,13,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0, section_title.TextBounds.X, 0, 3),
            BorderSizePixel = 0, BackgroundColor3 = rgb(19,19,19),
        })

        elements_scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
            scrollbar_fill.Visible = elements_scroll.AbsoluteCanvasSize.Y > background.AbsoluteSize.Y
        end)

        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Elements
-- ══════════════════════════════════════════════════════════════════════

    function library:addToggle(options)
        local cfg = {
            name     = options.name     or "Toggle",
            flag     = options.flag     or tostring(random(1,9999999)),
            default  = options.default  or false,
            folding  = options.folding  or false,
            callback = options.callback or function() end,
        }

        local toggle = library:create("TextLabel", {
            Parent = self.background or self.elements,
            FontFace = library.font, TextColor3 = rgb(151,151,151),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        cfg["right_components"] = library:create("Frame", {
            Parent = toggle, Position = dim2(1,0,0,-1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,12), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = cfg["right_components"], VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = dim(0,4), SortOrder = Enum.SortOrder.LayoutOrder,
        })
        library:create("UIPadding", { Parent = toggle })
        local left_components = library:create("Frame", {
            Parent = toggle, BackgroundTransparency = 1,
            Position = dim2(0,3,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,14), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", { Parent = left_components, Padding = dim(0,5), FillDirection = Enum.FillDirection.Horizontal })
        library:create("UIPadding", { Parent = left_components, PaddingBottom = dim(0,5) })

        local toggle_button = library:create("TextButton", {
            Parent = left_components, Text = "", Position = dim2(0,0,0,2),
            BorderColor3 = rgb(0,0,0), Size = dim2(0,8,0,8),
            BorderSizePixel = 0, BackgroundColor3 = rgb(2,2,2),
            LayoutOrder = -1, AutoButtonColor = false,
        })
        local tb_inline = library:create("Frame", {
            Parent = toggle_button, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(63,63,63),
        })
        library:create("UIGradient", {
            Parent = tb_inline, Rotation = 90,
            Color = rgbseq{rgbkey(0,rgb(232,232,232)), rgbkey(1,rgb(162,162,162))},
        })
        local accent = library:create("Frame", {
            Parent = tb_inline, Visible = false, BorderColor3 = rgb(0,0,0),
            Size = dim2(1,0,1,0), BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent,
        }); library:applyTheme(accent, "accent", "BackgroundColor3")
        library:create("UIGradient", {
            Parent = accent, Rotation = 90,
            Color = rgbseq{rgbkey(0,rgb(255,255,255)), rgbkey(1,rgb(109,109,109))},
        })

        local text_btn = library:create("TextButton", {
            Parent = left_components, FontFace = library.font,
            TextColor3 = rgb(180,180,180), BorderColor3 = rgb(0,0,0),
            Text = cfg.name, BackgroundTransparency = 1,
            Size = dim2(0,0,1,-1), BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X, TextSize = 12,
            BackgroundColor3 = rgb(255,255,255),
        })

        -- Folding children holder
        if cfg.folding then
            cfg["background"] = library:create("Frame", {
                Parent = toggle, BackgroundTransparency = 1,
                Position = dim2(0,14,1,3), BorderColor3 = rgb(0,0,0),
                Size = dim2(1,-14,0,0), BorderSizePixel = 0,
                BackgroundColor3 = rgb(255,255,255), Visible = false,
            })
            library:create("UIListLayout", {
                Parent = cfg["background"], Padding = dim(0,3),
                SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical,
            })
        end

        local enabled = cfg.default
        function cfg.set(val)
            enabled = val
            accent.Visible = val
            flags[cfg.flag] = val
            cfg.callback(val)
            if cfg.folding and cfg["background"] then
                cfg["background"].Visible = val
            end
        end

        cfg.set(cfg.default)
        library.config_flags[cfg.flag] = cfg.set

        toggle_button.MouseButton1Down:Connect(function() cfg.set(not enabled) end)
        text_btn.MouseButton1Down:Connect(function() cfg.set(not enabled) end)

        return setmetatable(cfg, library)
    end

    function library:addSlider(options)
        local cfg = {
            name      = options.name,
            suffix    = options.suffix    or "",
            flag      = options.flag      or tostring(2^789),
            callback  = options.callback  or function() end,
            min       = options.min       or options.minimum or 0,
            max       = options.max       or options.maximum or 100,
            intervals = options.interval  or options.decimal or 1,
            default   = options.default   or 10,
            value     = options.default   or 10,
            ignore    = options.ignore    or false,
            dragging  = false,
        }

        local slider = library:create("TextLabel", {
            Parent = self.elements or self.background or self.colorpickerElements,
            FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        local bottom_components = library:create("Frame", {
            Parent = slider, Position = dim2(0,15,0,cfg.name and 13 or 0),
            BorderColor3 = rgb(0,0,0),
            Size = dim2(1, self.background and 2 or -6, 0, 0),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local slider_dragger = library:create("TextButton", {
            Parent = bottom_components, AutoButtonColor = false, Text = "",
            Position = dim2(0,0,0,2), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-27,1,8), BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local bg = library:create("Frame", {
            Parent = slider_dragger, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local fill = library:create("Frame", {
            Parent = bg, BorderColor3 = rgb(0,0,0), Size = dim2(0,0,1,0),
            BorderSizePixel = 0, BackgroundColor3 = themes.preset.accent,
        }); library:applyTheme(fill, "accent", "BackgroundColor3")
        library:create("UIGradient", {
            Parent = fill, Rotation = 90,
            Color = rgbseq{rgbkey(0,rgb(232,232,232)), rgbkey(1,rgb(162,162,162))},
        })
        local text_slider = library:create("TextLabel", {
            Parent = fill, FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "0", AnchorPoint = vec2(0,0),
            BackgroundTransparency = 1, Position = dim2(1,0,0,0),
            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY, TextSize = 12,
            BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIGradient", {
            Parent = bg, Rotation = 90,
            Color = rgbseq{rgbkey(0,rgb(63,63,63)), rgbkey(1,rgb(42,42,42))},
        })
        library:create("UIListLayout", {
            Parent = bottom_components, SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = dim(0,3), FillDirection = Enum.FillDirection.Vertical,
        })
        library:create("UIPadding", { Parent = slider, PaddingLeft = dim(0,1) })

        if cfg.name then
            local lc = library:create("Frame", {
                Parent = slider, BackgroundTransparency = 1,
                Position = dim2(0,16,0,1), BorderColor3 = rgb(0,0,0),
                Size = dim2(0,0,0,14), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
            })
            library:create("TextLabel", {
                Parent = lc, FontFace = library.font, TextColor3 = rgb(180,180,180),
                BorderColor3 = rgb(0,0,0), Text = cfg.name, BackgroundTransparency = 1,
                Size = dim2(0,0,1,-1), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12, BackgroundColor3 = rgb(255,255,255),
            })
            library:create("UIListLayout", { Parent = lc, Padding = dim(0,5), FillDirection = Enum.FillDirection.Horizontal })
            library:create("UIPadding", { Parent = lc, PaddingBottom = dim(0,6) })
        end

        function cfg.set(value)
            cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)
            fill.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
            text_slider.Text = tostring(cfg.value) .. cfg.suffix
            flags[cfg.flag]  = cfg.value
            cfg.callback(cfg.value)
        end

        cfg.set(cfg.default)
        config_flags[cfg.flag] = cfg.set

        slider_dragger.MouseButton1Down:Connect(function() cfg.dragging = true end)
        library:connection(uis.InputChanged, function(input)
            if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local sx = (input.Position.X - slider_dragger.AbsolutePosition.X) / slider_dragger.AbsoluteSize.X
                cfg.set(((cfg.max - cfg.min) * sx) + cfg.min)
            end
        end)
        library:connection(uis.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then cfg.dragging = false end
        end)

        return setmetatable(cfg, library)
    end

    function library:addDropdown(options)
        local cfg = {
            name             = options.name,
            flag             = options.flag     or tostring(random(1,9999999)),
            items            = options.items    or {"1","2","3"},
            callback         = options.callback or function() end,
            multi            = options.multi    or false,
            open             = false,
            option_instances = {},
            multi_items      = {},
            ignore           = options.ignore   or false,
        }
        cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1]
        flags[cfg.flag] = {}

        local dropdown_path = library:create("TextLabel", {
            Parent = self.background or self.elements or self.colorpickerElements,
            FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        cfg["right_components"] = library:create("Frame", {
            Parent = dropdown_path, Position = dim2(1,0,0,-1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,12), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = cfg["right_components"], VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = dim(0,4), SortOrder = Enum.SortOrder.LayoutOrder,
        })
        local bottom_components = library:create("Frame", {
            Parent = dropdown_path, Position = dim2(0,15,0,cfg.name and 11 or 0),
            BorderColor3 = rgb(0,0,0),
            Size = dim2(1, self.background and 2 or -6, 0, 0),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local dropdown = library:create("TextButton", {
            Parent = bottom_components, AutoButtonColor = false, Text = "",
            Position = dim2(0,0,0,2), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-27,1,20), BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local d_inline = library:create("Frame", {
            Parent = dropdown, Position = dim2(0,0,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-1,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local d_bg = library:create("Frame", {
            Parent = d_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(25,25,25),
        })
        local arrow = library:create("ImageLabel", {
            Parent = d_bg, Image = "rbxassetid://116204929609664",
            Position = dim2(1,-13,0,7), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,5,0,3), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
            BackgroundTransparency = 1,
        })
        local d_text = library:create("TextLabel", {
            Parent = d_bg, FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "...",
            Size = dim2(1,0,1,0), BackgroundTransparency = 1,
            Position = dim2(0,7,0,-1), BorderSizePixel = 0,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, BackgroundColor3 = rgb(255,255,255),
        })
        if cfg.name then
            local lc = library:create("Frame", {
                Parent = dropdown_path, BackgroundTransparency = 1,
                Position = dim2(0,16,0,1), BorderColor3 = rgb(0,0,0),
                Size = dim2(0,0,0,14), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
            })
            library:create("TextLabel", {
                Parent = lc, FontFace = library.font, TextColor3 = rgb(180,180,180),
                Text = cfg.name, BackgroundTransparency = 1,
                Size = dim2(0,0,1,-1), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12, BackgroundColor3 = rgb(255,255,255), BorderColor3 = rgb(0,0,0),
            })
            library:create("UIListLayout", { Parent = lc, Padding = dim(0,5), FillDirection = Enum.FillDirection.Horizontal })
            library:create("UIPadding", { Parent = lc, PaddingBottom = dim(0,6) })
        end
        library:create("UIPadding", { Parent = dropdown, PaddingLeft = dim(0,1) })

        -- Dropdown holder (floating)
        local dropdown_holder = library:create("Frame", {
            Parent = library.gui, Size = dim2(0,161,0,0),
            Position = dim2(0,100,0,200), BorderColor3 = rgb(0,0,0),
            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(1,1,1), Visible = false, ZIndex = 999,
        })
        local dh_inline = library:create("Frame", {
            Parent = dropdown_holder, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local text_holder = library:create("Frame", {
            Parent = dh_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(25,25,25),
        })
        library:create("UIPadding", {
            Parent = text_holder, PaddingTop = dim(0,2), PaddingBottom = dim(0,7), PaddingLeft = dim(0,7),
        })
        library:create("UIListLayout", { Parent = text_holder, Padding = dim(0,5), SortOrder = Enum.SortOrder.LayoutOrder })

        function cfg.renderOption(optText)
            local opt = library:create("TextButton", {
                Parent = text_holder, FontFace = library.font,
                TextColor3 = rgb(180,180,180), BorderColor3 = rgb(0,0,0),
                Text = optText, Size = dim2(0,0,0,-1),
                BackgroundTransparency = 1, Position = dim2(0,6,0,-1),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 12, BackgroundColor3 = rgb(255,255,255),
            }); library:applyTheme(opt, "accent", "TextColor3")
            return opt
        end

        function cfg.setVisible(bool)
            dropdown_holder.Visible = bool
            arrow.Rotation = bool and 180 or 0
            if bool then
                library:closeCurrentElement(cfg)
                library.current_element_open = cfg
                local abs_pos = dropdown.AbsolutePosition
                dropdown_holder.Position = dim_offset(abs_pos.X, abs_pos.Y + dropdown.AbsoluteSize.Y + 2)
                dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, 0)
            end
        end

        function cfg.set(value)
            local selected = {}
            local isTable = type(value) == "table"
            for _, opt in next, cfg.option_instances do
                if opt.Text == value or (isTable and find(value, opt.Text)) then
                    insert(selected, opt.Text)
                    cfg.multi_items = selected
                    opt.TextColor3 = themes.preset.accent
                else
                    opt.TextColor3 = rgb(160,160,160)
                end
            end
            d_text.Text = isTable and concat(selected, ", ") or (selected[1] or "...")
            flags[cfg.flag] = isTable and selected or selected[1]
            cfg.callback(flags[cfg.flag])
        end

        function cfg.refresh_options(list)
            for _, opt in next, cfg.option_instances do opt:Destroy() end
            cfg.option_instances = {}
            for _, opt in next, list do
                local INST = cfg.renderOption(opt)
                insert(cfg.option_instances, INST)
                INST.MouseButton1Down:Connect(function()
                    if cfg.multi then
                        local already = find(cfg.multi_items, opt)
                        if already then remove(cfg.multi_items, already)
                        else insert(cfg.multi_items, opt) end
                        cfg.set(cfg.multi_items)
                    else
                        cfg.set(opt)
                        cfg.setVisible(false)
                    end
                end)
            end
        end

        cfg.refresh_options(cfg.items)
        cfg.set(cfg.default)
        config_flags[cfg.flag] = cfg.set

        dropdown.MouseButton1Down:Connect(function()
            cfg.setVisible(not cfg.open)
            cfg.open = not cfg.open
        end)

        return setmetatable(cfg, library)
    end

    function library:addColorPicker(options)
        local cfg = {
            name     = options.name     or "Color",
            flag     = options.flag     or tostring(random(1,9999999)),
            color    = options.color    or color(1,1,1),
            alpha    = options.alpha    or 1,
            callback = options.callback or function() end,
        }

        local outline_cp = library:create("Frame", {
            Parent = self.right_components or self.elements,
            BorderColor3 = rgb(0,0,0), Size = dim2(0,9,0,9),
            BorderSizePixel = 0, BackgroundColor3 = rgb(0,0,0),
            LayoutOrder = 1,
        })
        local alpha_bg = library:create("ImageLabel", {
            Parent = outline_cp, ScaleType = Enum.ScaleType.Tile,
            Image = "rbxassetid://18274452449", BackgroundTransparency = 1,
            Size = dim2(1,-2,1,-2), Position = dim2(0,1,0,1),
            TileSize = dim2(0,6,0,6), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local color_display = library:create("Frame", {
            Parent = outline_cp, Size = dim2(1,-2,1,-2), Position = dim2(0,1,0,1),
            BorderSizePixel = 0, BackgroundColor3 = cfg.color,
        })

        local picker = library:initializeColorPicker({
            name      = cfg.name,
            flag      = cfg.flag,
            color     = cfg.color,
            alpha     = cfg.alpha,
            colorPath = color_display,
            alphaPath = alpha_bg,
            callback  = function(c, a)
                color_display.BackgroundColor3 = c
                cfg.callback(c, a)
            end,
        })

        outline_cp.MouseButton1Down:Connect(function()
            picker.setVisible(not picker.outline.Visible)
        end)

        return setmetatable(cfg, library)
    end

    function library:addKeyBind(options)
        local cfg = {
            flag         = options.flag     or "KEYBIND_" .. tostring(random(1,9999999)),
            callback     = options.callback or function() end,
            open         = false,
            binding      = nil,
            name         = options.name,
            ignore_key   = options.ignore   or false,
            key          = options.key      or nil,
            mode         = options.mode     or "toggle",
            active       = options.default  or false,
        }
        flags[cfg.flag] = {}

        local outline_kb = library:create("TextButton", {
            Parent = self.right_components or self.elements,
            Text = "", AutoButtonColor = false, BorderColor3 = rgb(0,0,0),
            BackgroundTransparency = 1, SelectionOrder = -1,
            Size = dim2(0,0,0,9), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(255,255,255),
        })
        local text_label = library:create("TextLabel", {
            Parent = outline_kb, FontFace = library.font,
            TextColor3 = rgb(180,180,180), BorderColor3 = rgb(0,0,0),
            Text = "[ ... ]", Size = dim2(1,0,1,0),
            Position = dim2(0,0,0,-1), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X, TextSize = 12,
            BackgroundColor3 = rgb(255,255,255),
        })

        function cfg.set_mode(mode)
            cfg.mode = mode
            if mode == "always" then cfg.set(true)
            elseif mode == "hold" then cfg.set(false) end
            flags[cfg.flag]["mode"] = mode
        end

        function cfg.set(input)
            if type(input) == "boolean" then
                local v = (cfg.mode == "always") and true or input
                cfg.active = v
                cfg.callback(v)
            elseif tostring(input):find("Enum") then
                input = input.Name == "Escape" and "..." or input
                cfg.key = input
                cfg.callback(cfg.active or false)
            elseif type(input) == "table" then
                if input.key then
                    input.key = type(input.key) == "string" and input.key ~= "..." and library:convertEnum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "..." or input.key
                    cfg.key = input.key
                end
                if input.mode then cfg.mode = input.mode end
                if input.active ~= nil then cfg.active = input.active end
            end

            flags[cfg.flag] = { mode = cfg.mode, key = cfg.key, active = cfg.active }

            local keyStr = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum%.","")) or "..."
            local cleanStr = keyStr:gsub("KeyCode%.",""):gsub("UserInputType%.","")
            text_label.Text = "[" .. string.lower(cleanStr) .. "]"

            -- Update keybind list if it has a name
            if cfg.name and library.keybind_list then
                library.keybind_list:updateEntry(cfg.name, cleanStr, cfg.active)
            end
        end

        outline_kb.MouseButton1Down:Connect(function()
            task.wait()
            text_label.Text = "[ ... ]"
            cfg.binding = library:connection(uis.InputBegan, function(keycode)
                cfg.set(keycode.KeyCode)
                cfg.binding:Disconnect(); cfg.binding = nil
            end)
        end)

        library:connection(uis.InputBegan, function(input, gameProc)
            if not gameProc and input.KeyCode == cfg.key then
                if cfg.mode == "toggle" then cfg.active = not cfg.active; cfg.set(cfg.active)
                elseif cfg.mode == "hold" then cfg.set(true) end
            end
        end)
        library:connection(uis.InputEnded, function(input, gameProc)
            if gameProc then return end
            local k = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
            if k == cfg.key and cfg.mode == "hold" then cfg.set(false) end
        end)

        cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
        config_flags[cfg.flag] = cfg.set

        return setmetatable(cfg, library)
    end

    function library:addButton(options)
        local cfg = {
            name     = options.name     or "Button",
            callback = options.callback or function() end,
        }

        local btn_outline = library:create("Frame", {
            Parent = self.elements, BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-8,0,20), BorderSizePixel = 0, BackgroundColor3 = rgb(0,0,0),
        })
        local btn_inline = library:create("Frame", {
            Parent = btn_outline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local btn_bg = library:create("TextButton", {
            Parent = btn_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(22,22,22),
            Text = cfg.name, FontFace = library.font, TextSize = 12,
            TextColor3 = rgb(180,180,180), AutoButtonColor = false,
        })

        btn_bg.MouseButton1Down:Connect(function() cfg.callback() end)

        return setmetatable(cfg, library)
    end

    function library:addLabel(options)
        local cfg = {
            name = options.name or "Label",
        }
        local label = library:create("TextLabel", {
            Parent = self.background or self.elements,
            FontFace = library.font, TextColor3 = rgb(151,151,151),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        cfg["right_components"] = library:create("Frame", {
            Parent = label, Position = dim2(1,0,0,-1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,12), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", {
            Parent = cfg["right_components"], VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = dim(0,4), SortOrder = Enum.SortOrder.LayoutOrder,
        })
        local lc = library:create("Frame", {
            Parent = label, BackgroundTransparency = 1,
            Position = dim2(0,3,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,14), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", { Parent = lc, Padding = dim(0,5), FillDirection = Enum.FillDirection.Horizontal })
        library:create("UIPadding", { Parent = lc, PaddingBottom = dim(0,5) })
        library:create("TextButton", {
            Parent = lc, FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = cfg.name, BackgroundTransparency = 1,
            Size = dim2(0,0,1,-1), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12, BackgroundColor3 = rgb(255,255,255),
        })

        return setmetatable(cfg, library)
    end

    function library:addTextBox(options)
        local cfg = {
            name        = options.name        or "TextBox",
            placeholder = options.placeholder or "type here...",
            default     = options.default,
            flag        = options.flag        or "flag",
            callback    = options.callback    or function() end,
        }

        local holder = library:create("TextLabel", {
            Parent = self.background or self.elements,
            FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        local bc = library:create("Frame", {
            Parent = holder, Position = dim2(0,14,0,13), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-6,0,0), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local tb_frame = library:create("Frame", {
            Parent = bc, Position = dim2(0,-1,0,2), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-27,1,20), BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local tb_inline = library:create("Frame", {
            Parent = tb_frame, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local tb_bg = library:create("Frame", {
            Parent = tb_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(19,19,19),
        })
        local textbox = library:create("TextBox", {
            Parent = tb_bg, FontFace = library.font, TextTruncate = Enum.TextTruncate.AtEnd,
            TextSize = 12, Size = dim2(1,-6,1,0), RichText = true,
            TextColor3 = rgb(178,178,178), BorderColor3 = rgb(0,0,0),
            Text = cfg.default or "", CursorPosition = -1,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            Position = dim2(0,6,0,0), BorderSizePixel = 0,
            PlaceholderText = cfg.placeholder, PlaceholderColor3 = rgb(100,100,100),
            BackgroundColor3 = rgb(255,255,255),
        })
        library:create("UIListLayout", { Parent = bc, SortOrder = Enum.SortOrder.LayoutOrder })
        library:create("UIPadding", { Parent = holder, PaddingLeft = dim(0,1) })

        local lc = library:create("Frame", {
            Parent = holder, BackgroundTransparency = 1,
            Position = dim2(0,16,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(0,0,0,14), BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        library:create("TextLabel", {
            Parent = lc, FontFace = library.font, TextColor3 = rgb(180,180,180),
            Text = cfg.name, BackgroundTransparency = 1, Size = dim2(0,0,1,-1),
            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12, BackgroundColor3 = rgb(255,255,255), BorderColor3 = rgb(0,0,0),
        })
        library:create("UIListLayout", { Parent = lc, Padding = dim(0,5), FillDirection = Enum.FillDirection.Horizontal })
        library:create("UIPadding", { Parent = lc, PaddingBottom = dim(0,6) })

        function cfg.set(text)
            flags[cfg.flag] = text
            textbox.Text = text
            cfg.callback(text)
        end
        if cfg.default then cfg.set(cfg.default) end
        textbox:GetPropertyChangedSignal("Text"):Connect(function() cfg.set(textbox.Text) end)

        return setmetatable(cfg, library)
    end

    function library:addList(options)
        local cfg = {
            callback         = options and options.callback or function() end,
            name             = options.name,
            scale            = options.size  or 100,
            items            = options.items or {},
            option_instances = {},
            current_instance = nil,
            flag             = options.flag  or "flag",
        }
        flags[cfg.flag] = {}

        local list_path = library:create("TextLabel", {
            Parent = self.background or self.elements,
            FontFace = library.font, TextColor3 = rgb(180,180,180),
            BorderColor3 = rgb(0,0,0), Text = "", ZIndex = 2,
            Size = dim2(1,-8,0,12), BorderSizePixel = 0,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y, TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = 11, BackgroundColor3 = rgb(255,255,255),
        })
        local bc = library:create("Frame", {
            Parent = list_path, Position = dim2(0,15,0,cfg.name and 11 or 0),
            BorderColor3 = rgb(0,0,0),
            Size = dim2(1, self.background and 2 or -6, 0, 0),
            BorderSizePixel = 0, BackgroundColor3 = rgb(255,255,255),
        })
        local list_btn = library:create("TextButton", {
            Parent = bc, AutoButtonColor = false, Text = "",
            Position = dim2(0,0,0,2), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-27,0,cfg.scale), BorderSizePixel = 0, BackgroundColor3 = rgb(1,1,1),
        })
        local l_inline = library:create("Frame", {
            Parent = list_btn, Position = dim2(0,0,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-1,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local l_bg = library:create("Frame", {
            Parent = l_inline, Position = dim2(0,1,0,1), BorderColor3 = rgb(0,0,0),
            Size = dim2(1,-2,1,-2), BorderSizePixel = 0, BackgroundColor3 = rgb(25,25,25),
        })
        local scroll_fill = library:create("Frame", {
            Parent = l_bg, Visible = false, Size = dim2(0,5,1,0), Position = dim2(1,-5,0,0),
            BorderColor3 = rgb(0,0,0), ZIndex = 4, BorderSizePixel = 0, BackgroundColor3 = rgb(45,45,45),
        })
        local sf = library:create("ScrollingFrame", {
            Parent = l_bg, Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4, BackgroundTransparency = 1, ScrollBarImageColor3 = rgb(65,65,65),
            Size = dim2(1,0,1,0), BackgroundColor3 = rgb(255,255,255), BorderColor3 = rgb(0,0,0),
            BorderSizePixel = 0, CanvasSize = dim2(0,0,0,0), ZIndex = 999,
        })
        library:create("UIPadding", { Parent = sf, PaddingLeft = dim(0,5), PaddingBottom = dim(0,5), PaddingTop = dim(0,5), PaddingRight = dim(0,5) })
        library:create("UIListLayout", { Parent = sf, Padding = dim(0,5), FillDirection = Enum.FillDirection.Vertical })

        function cfg.refresh_options(list)
            for _, opt in next, cfg.option_instances do opt:Destroy() end
            cfg.option_instances = {}
            for _, item in next, list do
                local opt = library:create("TextButton", {
                    Parent = sf, FontFace = library.font,
                    TextColor3 = rgb(180,180,180), BorderColor3 = rgb(0,0,0),
                    Text = item, Size = dim2(1,0,0,12),
                    BackgroundTransparency = 1, BorderSizePixel = 0, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, BackgroundColor3 = rgb(255,255,255),
                })
                opt.MouseButton1Down:Connect(function()
                    if cfg.current_instance then
                        cfg.current_instance.TextColor3 = rgb(180,180,180)
                    end
                    opt.TextColor3 = themes.preset.accent
                    cfg.current_instance = opt
                    flags[cfg.flag] = item
                    cfg.callback(item)
                end)
                insert(cfg.option_instances, opt)
            end
        end

        cfg.refresh_options(cfg.items)
        sf:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
            scroll_fill.Visible = sf.AbsoluteCanvasSize.Y > l_bg.AbsoluteSize.Y
        end)

        return setmetatable(cfg, library)
    end

-- ══════════════════════════════════════════════════════════════════════
-- Watermark & Keybind List (Drawing-based)
-- ══════════════════════════════════════════════════════════════════════

    local watermarkEnabled  = true
    local keybindListEnabled = true
    local keybindEntries    = {}   -- {name, key, active}
    local watermarkDrawings = {}
    local keybindDrawings   = {}

    function library:createWatermark(text)
        local wm = Drawing.new("Text")
        wm.Text      = text
        wm.Size      = 13
        wm.Color     = themes.preset.accent
        wm.Outline   = true
        wm.OutlineColor = rgb(0,0,0)
        wm.Position  = vec2(8, 8)
        wm.Visible   = true
        wm.Font      = Drawing.Fonts.Monospace
        watermarkDrawings.text = wm

        local bg = Drawing.new("Square")
        bg.Size      = vec2(wm.TextBounds.X + 8, wm.TextBounds.Y + 4)
        bg.Position  = vec2(4, 4)
        bg.Color     = rgb(10,10,10)
        bg.Transparency = 0.55
        bg.Filled    = true
        bg.Visible   = true
        watermarkDrawings.bg = bg

        local border = Drawing.new("Square")
        border.Size        = bg.Size + vec2(2,2)
        border.Position    = bg.Position - vec2(1,1)
        border.Color       = themes.preset.accent
        border.Transparency = 0.7
        border.Filled      = false
        border.Thickness   = 1
        border.Visible     = true
        watermarkDrawings.border = border

        run.RenderStepped:Connect(function()
            if not watermarkEnabled then
                wm.Visible = false; bg.Visible = false; border.Visible = false
                return
            end
            wm.Color = themes.preset.accent
            border.Color = themes.preset.accent
            local tw = wm.TextBounds
            bg.Size     = vec2(tw.X + 10, tw.Y + 6)
            border.Size = bg.Size + vec2(2,2)
            wm.Visible     = true
            bg.Visible     = true
            border.Visible = true
        end)
    end

    function library:createKeybindList()
        local ENTRY_H  = 14
        local PADDING  = 4
        local X_START  = 8
        local Y_START  = 30

        library.keybind_list = {
            entries = {},
        }

        function library.keybind_list:updateEntry(name, key, active)
            for _, e in ipairs(self.entries) do
                if e.name == name then
                    e.key    = key
                    e.active = active
                    return
                end
            end
            insert(self.entries, { name = name, key = key, active = active })
        end

        run.RenderStepped:Connect(function()
            -- Clear all previous drawings
            for _, d in ipairs(keybindDrawings) do pcall(function() d:Remove() end) end
            keybindDrawings = {}

            if not keybindListEnabled then return end

            local visibleEntries = {}
            for _, e in ipairs(library.keybind_list.entries) do
                if e.key and tostring(e.key) ~= "Enums" and tostring(e.key) ~= "nil" then
                    insert(visibleEntries, e)
                end
            end

            if #visibleEntries == 0 then return end

            local maxW = 0
            local tempTexts = {}
            for _, e in ipairs(visibleEntries) do
                local str = (e.active and "[ON] " or "[OFF] ") .. e.name .. " — " .. tostring(e.key)
                insert(tempTexts, str)
            end

            local bg = Drawing.new("Square")
            bg.Filled       = true
            bg.Color        = rgb(10,10,10)
            bg.Transparency = 0.55
            bg.Position     = vec2(X_START - 2, Y_START - 2)
            bg.Size         = vec2(120, #visibleEntries * (ENTRY_H + PADDING) + 4)
            bg.Visible      = true
            insert(keybindDrawings, bg)

            for i, e in ipairs(visibleEntries) do
                local keyStr = tostring(e.key):gsub("Enum%.KeyCode%.",""):gsub("Enum%.UserInputType%.","")
                local str = e.name .. ": " .. keyStr
                local d = Drawing.new("Text")
                d.Text     = str
                d.Size     = 12
                d.Color    = e.active and themes.preset.accent or rgb(140,140,140)
                d.Outline  = true
                d.OutlineColor = rgb(0,0,0)
                d.Position = vec2(X_START, Y_START + (i-1)*(ENTRY_H + PADDING))
                d.Visible  = true
                d.Font     = Drawing.Fonts.Monospace
                insert(keybindDrawings, d)
                if d.TextBounds.X > maxW then maxW = d.TextBounds.X end
            end

            bg.Size = vec2(maxW + 10, #visibleEntries * (ENTRY_H + PADDING) + 6)
        end)
    end

    function library:setWatermarkVisible(bool)
        watermarkEnabled = bool
    end

    function library:setKeybindListVisible(bool)
        keybindListEnabled = bool
    end

-- ══════════════════════════════════════════════════════════════════════
-- Notifications
-- ══════════════════════════════════════════════════════════════════════

    local notifications = {}

    function notifications:create_notification(options)
        local name = options.name or "Notification"
        local ntf = Drawing.new("Text")
        ntf.Text     = "[ obelus ] " .. name
        ntf.Size     = 13
        ntf.Color    = themes.preset.accent
        ntf.Outline  = true
        ntf.OutlineColor = rgb(0,0,0)
        ntf.Position = vec2(camera.ViewportSize.X/2 - 80, camera.ViewportSize.Y - 60)
        ntf.Visible  = true
        ntf.Font     = Drawing.Fonts.Monospace

        task.delay(3, function()
            for i = 0, 10 do
                ntf.Transparency = 1 - (i/10)
                task.wait(0.05)
            end
            ntf:Remove()
        end)
    end

    return library, notifications, themes
