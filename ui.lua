--

--

    local FetchService = setmetatable({}, {
        __index = function(_, service)
            return game:GetService(service)
        end
    })

    --

    --> Extra Function(s)
        local SafeCall = function(Func, ...)
            local Args, Old = table.pack(...), getthreadidentity()

            setthreadidentity(2);
            local Success, Result = xpcall(
                Func,
                debug.traceback,
                table.unpack(Args, 
                    1, 
                Args.n)
            );

            setthreadidentity(Old);

            return Success, Result
        end;

    --

    -- Constants;
        local Workspace, Players, InputService, RunService = FetchService['Workspace'], FetchService['Players'], FetchService['UserInputService'], FetchService['RunService'];
        local Stats = FetchService['Stats'];
        local CoreGui = cloneref and cloneref(FetchService['CoreGui']) or FetchService['CoreGui'];

        local TextService = FetchService['TextService'];
        local TweenService = FetchService['TweenService'];
        local HttpService = FetchService['HttpService'];
        local GuiService = FetchService['GuiService'];
        
        local Camera = Workspace.CurrentCamera;
        local LocalPlayer = Players.LocalPlayer;
        local Mouse = InputService:GetMouseLocation() or LocalPlayer:GetMouse();
        
        local SetMetaTbl = setmetatable;
        -- DataType
        local Vec2, Vec3, Dim, Dim2 = Vector2.new, Vector3.new, UDim.new, UDim2.new;
        local Dim2FromOffset, Dim2FromScale = UDim2.fromOffset, UDim2.fromScale;
        local NewColor3, Rgb, Hex, Hsv = Color3.new, Color3.fromRGB, Color3.fromHex, Color3.fromHSV;
        local ColorSeq = ColorSequence.new
        local ColorKey = ColorSequenceKeypoint.new
        
        local NumSeq = NumberSequence.new
        local NumKey = NumberSequenceKeypoint.new

        local StringFmt = string.format;
        local StringGsub = string.gsub;
        local StringLower = string.lower;

        -- TaskType
        local Delay, Spawn, Wait = task.delay, task.spawn, task.wait;
        
        local NewInstance = Instance.new;
        -- TableType
        local Insert, Find, Remove, Clear = table.insert, table.find, table.remove, table.clear;
        local Create, Move, Sort = table.create, table.move, table.sort;
        
        --MathType
        local Abs, Floor, Ceil, Round = math.abs, math.floor, math.ceil, math.round;
        local Sin, Cos, Tan, Asin, Acos, Atan2 = math.sin, math.cos, math.tan, math.asin, math.acos, math.atan2;
        local Sqrt, Pow, Rad, Deg = math.sqrt, math.pow, math.rad, math.deg;
        local Clamp, Lerp, Random = math.clamp, math.lerp, math.random;
        
        local Minimum, Maximum = math.min, math.max;
        local function ToHSV(col)
            local r, g, b = col.R, col.G, col.B
            local maxc = Maximum(r, g, b)
            local minc = Minimum(r, g, b)
            local v = maxc
            local d = maxc - minc
            local s = 0
            if maxc > 0 then s = d / maxc end

            local h = 0
            if d ~= 0 then
                if maxc == r then
                    h = (g - b) / d
                    if g < b then h = h + 6 end
                elseif maxc == g then
                    h = (b - r) / d + 2
                else
                    h = (r - g) / d + 4
                end
                h = h / 6
            end

            return h, s, v
        end

        --

        -- Library
        getgenv()['Library'] = {
            Directory = 'Home',
            Folders = {
                '/Assets',
                '/Assets/Icons',
                '/Assets/Images',
                '/Assets/Fonts',
                '/Configs',
                '/Themes';
            },

            -- Flags
            Flags = { },
            ConfigFlags = { },

            Connections = { },
            Threads = { },
            Notifications = {
                ['Active'] = { };
                ['Queue'] = { };
            };

            OpenElement = { },
            ThemeObjects = { },
            ThemeCallbacks = { },
            CurrentTheme = nil,
            Dragging = false,
            Elements = { },

            Easing = {
                Style = Enum.EasingStyle.Sine,
                Direction = Enum.EasingDirection.Out,
                Speed = 0.5;
            };
        };

        local Fonts = { }; do
            function RegisterFont(Name, Weight, Style, Asset)
                if not isfile(Asset.Id) then
                    writefile(Asset.Id, Asset.Font)
                end

                if isfile(Name .. ".font") then
                    delfile(Name .. ".font")
                end

                local Data = {
                    name = Name,
                    faces = {
                        {
                            name = "Normal",
                            weight = Weight,
                            style = Style,
                            assetId = getcustomasset(Asset.Id),
                        },
                    },
                }

                writefile(Name .. ".font", HttpService:JSONEncode(Data))

                return getcustomasset(Name .. ".font");
            end
            
            local Verdana = RegisterFont("Verawdawdawdwaddana", 400, "Normal", {
                Id = "Verdanawdawdwada.ttf",
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"),
            })

            Library.Font = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        end
        
    local Themes = {
    ['Preset'] = {
        ['Accent'] = Rgb(88, 166, 255),

        ['Borders'] = {
            ['Outline'] = Rgb(5, 8, 12),
            ['Inline']  = Rgb(58, 67, 82),
        },

        ['Background'] = Rgb(22, 25, 32),

        ['Text'] = {
            ['Main']       = Rgb(225, 230, 240),
            ['Unselected'] = Rgb(145, 152, 165),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(40, 45, 56)),
                ColorKey(1, Rgb(24, 27, 35)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(40, 45, 56)),
                ColorKey(1, Rgb(24, 27, 35)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(52, 58, 72)),
                ColorKey(1, Rgb(31, 35, 44)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(88, 166, 255)),
                ColorKey(1, Rgb(45, 110, 210)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(36, 40, 50)),
                ColorKey(1, Rgb(28, 31, 39)),
            }),
        },
    },

    ['Orange'] = {
        ['Accent'] = Rgb(221, 168, 93),

        ['Borders'] = {
            ['Outline'] = Rgb(0, 0, 0),
            ['Inline']  = Rgb(79, 82, 87),
        },

        ['Background'] = Rgb(32, 33, 37),

        ['Text'] = {
            ['Main']       = Rgb(214, 217, 224),
            ['Unselected'] = Rgb(175, 175, 175),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(45, 48, 55)),
                ColorKey(1, Rgb(32, 33, 37)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(45, 48, 55)),
                ColorKey(1, Rgb(32, 33, 37)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(45, 48, 55)),
                ColorKey(1, Rgb(32, 33, 37)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(221, 168, 93)),
                ColorKey(1, Rgb(121, 92, 51)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(45, 48, 55)),
                ColorKey(1, Rgb(45, 48, 53)),
            }),
        },
    },

    ['Dark'] = {
        ['Accent'] = Rgb(170, 170, 170),

        ['Borders'] = {
            ['Outline'] = Rgb(8, 8, 8),
            ['Inline']  = Rgb(45, 45, 45),
        },

        ['Background'] = Rgb(18, 18, 18),

        ['Text'] = {
            ['Main']       = Rgb(235, 235, 235),
            ['Unselected'] = Rgb(145, 145, 145),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(34, 34, 34)),
                ColorKey(1, Rgb(18, 18, 18)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(34, 34, 34)),
                ColorKey(1, Rgb(18, 18, 18)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(48, 48, 48)),
                ColorKey(1, Rgb(28, 28, 28)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(170, 170, 170)),
                ColorKey(1, Rgb(110, 110, 110)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(28, 28, 28)),
                ColorKey(1, Rgb(20, 20, 20)),
            }),
        },
    },

    ['Purple'] = {
        ['Accent'] = Rgb(170, 110, 255),

        ['Borders'] = {
            ['Outline'] = Rgb(12, 8, 18),
            ['Inline']  = Rgb(82, 58, 110),
        },

        ['Background'] = Rgb(24, 20, 32),

        ['Text'] = {
            ['Main']       = Rgb(235, 225, 245),
            ['Unselected'] = Rgb(165, 150, 180),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(52, 40, 72)),
                ColorKey(1, Rgb(30, 24, 42)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(52, 40, 72)),
                ColorKey(1, Rgb(30, 24, 42)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(70, 55, 95)),
                ColorKey(1, Rgb(42, 34, 58)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(170, 110, 255)),
                ColorKey(1, Rgb(110, 70, 210)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(42, 34, 58)),
                ColorKey(1, Rgb(30, 24, 42)),
            }),
        },
    },

    ['Crimson'] = {
        ['Accent'] = Rgb(255, 85, 115),

        ['Borders'] = {
            ['Outline'] = Rgb(18, 5, 8),
            ['Inline']  = Rgb(110, 58, 68),
        },

        ['Background'] = Rgb(30, 18, 22),

        ['Text'] = {
            ['Main']       = Rgb(245, 225, 230),
            ['Unselected'] = Rgb(180, 145, 152),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(68, 40, 48)),
                ColorKey(1, Rgb(38, 22, 28)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(68, 40, 48)),
                ColorKey(1, Rgb(38, 22, 28)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(88, 52, 62)),
                ColorKey(1, Rgb(50, 30, 36)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(255, 85, 115)),
                ColorKey(1, Rgb(210, 45, 85)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(50, 30, 36)),
                ColorKey(1, Rgb(36, 22, 26)),
            }),
        },
    },

    ['Emerald'] = {
        ['Accent'] = Rgb(75, 220, 145),

        ['Borders'] = {
            ['Outline'] = Rgb(6, 12, 8),
            ['Inline']  = Rgb(52, 95, 72),
        },

        ['Background'] = Rgb(18, 28, 22),

        ['Text'] = {
            ['Main']       = Rgb(225, 245, 232),
            ['Unselected'] = Rgb(145, 175, 155),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(38, 58, 48)),
                ColorKey(1, Rgb(22, 34, 28)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(38, 58, 48)),
                ColorKey(1, Rgb(22, 34, 28)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(50, 75, 62)),
                ColorKey(1, Rgb(28, 42, 34)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(75, 220, 145)),
                ColorKey(1, Rgb(45, 170, 110)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(30, 44, 36)),
                ColorKey(1, Rgb(22, 32, 26)),
            }),
        },
    },

    ['TokyoNight'] = {
        ['Accent'] = Rgb(122, 162, 247),

        ['Borders'] = {
            ['Outline'] = Rgb(12, 14, 20),
            ['Inline'] = Rgb(65, 72, 104),
        },

        ['Background'] = Rgb(26, 27, 38),

        ['Text'] = {
            ['Main'] = Rgb(192, 202, 245),
            ['Unselected'] = Rgb(122, 134, 179),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(44, 49, 68)),
                ColorKey(1, Rgb(26, 27, 38)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(44, 49, 68)),
                ColorKey(1, Rgb(26, 27, 38)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(58, 65, 90)),
                ColorKey(1, Rgb(36, 40, 56)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(122, 162, 247)),
                ColorKey(1, Rgb(80, 120, 210)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(34, 38, 52)),
                ColorKey(1, Rgb(26, 27, 38)),
            }),
        },
    },

    ['RosePine'] = {
        ['Accent'] = Rgb(235, 188, 186),

        ['Borders'] = {
            ['Outline'] = Rgb(18, 18, 26),
            ['Inline'] = Rgb(82, 74, 96),
        },

        ['Background'] = Rgb(25, 23, 36),

        ['Text'] = {
            ['Main'] = Rgb(224, 222, 244),
            ['Unselected'] = Rgb(144, 140, 170),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(48, 44, 66)),
                ColorKey(1, Rgb(25, 23, 36)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(48, 44, 66)),
                ColorKey(1, Rgb(25, 23, 36)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(62, 58, 84)),
                ColorKey(1, Rgb(38, 34, 52)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(235, 188, 186)),
                ColorKey(1, Rgb(191, 140, 148)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(40, 36, 54)),
                ColorKey(1, Rgb(28, 26, 40)),
            }),
        },
    },

    ['Gruvbox'] = {
        ['Accent'] = Rgb(250, 189, 47),

        ['Borders'] = {
            ['Outline'] = Rgb(20, 18, 16),
            ['Inline'] = Rgb(92, 80, 66),
        },

        ['Background'] = Rgb(40, 40, 40),

        ['Text'] = {
            ['Main'] = Rgb(235, 219, 178),
            ['Unselected'] = Rgb(168, 153, 132),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(60, 56, 54)),
                ColorKey(1, Rgb(40, 40, 40)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(60, 56, 54)),
                ColorKey(1, Rgb(40, 40, 40)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(80, 73, 69)),
                ColorKey(1, Rgb(50, 48, 47)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(250, 189, 47)),
                ColorKey(1, Rgb(215, 153, 33)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(50, 48, 47)),
                ColorKey(1, Rgb(40, 40, 40)),
            }),
        },
    },
    ['Catppuccin'] = {
        ['Accent'] = Rgb(203, 166, 247),

        ['Borders'] = {
            ['Outline'] = Rgb(17, 17, 27),
            ['Inline'] = Rgb(88, 91, 112),
        },

        ['Background'] = Rgb(30, 30, 46),

        ['Text'] = {
            ['Main'] = Rgb(205, 214, 244),
            ['Unselected'] = Rgb(166, 173, 200),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(49, 50, 68)),
                ColorKey(1, Rgb(30, 30, 46)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(49, 50, 68)),
                ColorKey(1, Rgb(30, 30, 46)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(69, 71, 90)),
                ColorKey(1, Rgb(49, 50, 68)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(203, 166, 247)),
                ColorKey(1, Rgb(180, 140, 230)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(49, 50, 68)),
                ColorKey(1, Rgb(36, 39, 58)),
            }),
        },
    },

    ['Nord'] = {
        ['Accent'] = Rgb(136, 192, 208),

        ['Borders'] = {
            ['Outline'] = Rgb(25, 32, 44),
            ['Inline'] = Rgb(76, 86, 106),
        },

        ['Background'] = Rgb(46, 52, 64),

        ['Text'] = {
            ['Main'] = Rgb(236, 239, 244),
            ['Unselected'] = Rgb(143, 152, 165),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(67, 76, 94)),
                ColorKey(1, Rgb(46, 52, 64)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(67, 76, 94)),
                ColorKey(1, Rgb(46, 52, 64)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(76, 86, 106)),
                ColorKey(1, Rgb(59, 66, 82)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(136, 192, 208)),
                ColorKey(1, Rgb(94, 129, 172)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(59, 66, 82)),
                ColorKey(1, Rgb(46, 52, 64)),
            }),
        },
    },

    ['OneDark'] = {
        ['Accent'] = Rgb(97, 175, 239),

        ['Borders'] = {
            ['Outline'] = Rgb(18, 20, 25),
            ['Inline'] = Rgb(78, 85, 102),
        },

        ['Background'] = Rgb(40, 44, 52),

        ['Text'] = {
            ['Main'] = Rgb(220, 223, 228),
            ['Unselected'] = Rgb(140, 146, 161),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(58, 63, 74)),
                ColorKey(1, Rgb(40, 44, 52)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(58, 63, 74)),
                ColorKey(1, Rgb(40, 44, 52)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(72, 78, 92)),
                ColorKey(1, Rgb(52, 56, 66)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(97, 175, 239)),
                ColorKey(1, Rgb(70, 140, 210)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(52, 56, 66)),
                ColorKey(1, Rgb(40, 44, 52)),
            }),
        },
    },

    ['Everforest'] = {
        ['Accent'] = Rgb(163, 190, 140),

        ['Borders'] = {
            ['Outline'] = Rgb(28, 32, 24),
            ['Inline'] = Rgb(92, 106, 82),
        },

        ['Background'] = Rgb(45, 53, 38),

        ['Text'] = {
            ['Main'] = Rgb(211, 198, 170),
            ['Unselected'] = Rgb(150, 145, 125),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(62, 72, 54)),
                ColorKey(1, Rgb(45, 53, 38)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(62, 72, 54)),
                ColorKey(1, Rgb(45, 53, 38)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(78, 88, 68)),
                ColorKey(1, Rgb(56, 64, 48)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(163, 190, 140)),
                ColorKey(1, Rgb(122, 150, 100)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(56, 64, 48)),
                ColorKey(1, Rgb(45, 53, 38)),
            }),
        },
    },

    ['Carbon'] = {
        ['Accent'] = Rgb(120, 120, 120),

        ['Borders'] = {
            ['Outline'] = Rgb(10, 10, 10),
            ['Inline'] = Rgb(58, 58, 58),
        },

        ['Background'] = Rgb(22, 22, 22),

        ['Text'] = {
            ['Main'] = Rgb(240, 240, 240),
            ['Unselected'] = Rgb(150, 150, 150),
        },

        ['Gradients'] = {
            ['Tab'] = ColorSeq({
                ColorKey(0, Rgb(40, 40, 40)),
                ColorKey(1, Rgb(22, 22, 22)),
            }),

            ['Base'] = ColorSeq({
                ColorKey(0, Rgb(40, 40, 40)),
                ColorKey(1, Rgb(22, 22, 22)),
            }),

            ['ElementBase'] = ColorSeq({
                ColorKey(0, Rgb(58, 58, 58)),
                ColorKey(1, Rgb(34, 34, 34)),
            }),

            ['ElementActive'] = ColorSeq({
                ColorKey(0, Rgb(120, 120, 120)),
                ColorKey(1, Rgb(85, 85, 85)),
            }),

            ['Container'] = ColorSeq({
                ColorKey(0, Rgb(32, 32, 32)),
                ColorKey(1, Rgb(22, 22, 22)),
            }),
        },
    },
        ['Utility'] = {},

        ['Gradients'] = {
            ['Active']   = {},
            ['Inactive'] = {},
        },
    };

        Library.CurrentTheme = Themes.Preset

        for Theme, Color in Themes do
            Themes.Utility[Theme] = {
                BackgroundColor3 = {},
                TextColor3 = {},
                ImageColor3 = {},
                ScrollBarImageColor3 = {},
                Color = {}
            }
        end
        local Keys = {
            [Enum.KeyCode.LeftShift] = "LS",
            [Enum.KeyCode.RightShift] = "RS",
            [Enum.KeyCode.LeftControl] = "LCTL",
            [Enum.KeyCode.RightControl] = "RCTL",
            [Enum.KeyCode.Insert] = "INST",
            [Enum.KeyCode.Backspace] = "BS",
            [Enum.KeyCode.Return] = "RETU",
            [Enum.KeyCode.LeftAlt] = "LALT",
            [Enum.KeyCode.RightAlt] = "RALT",
            [Enum.KeyCode.CapsLock] = "CAPS",
            [Enum.KeyCode.One] = "1",
            [Enum.KeyCode.Two] = "2",
            [Enum.KeyCode.Three] = "3",
            [Enum.KeyCode.Four] = "4",
            [Enum.KeyCode.Five] = "5",
            [Enum.KeyCode.Six] = "6",
            [Enum.KeyCode.Seven] = "7",
            [Enum.KeyCode.Eight] = "8",
            [Enum.KeyCode.Nine] = "9",
            [Enum.KeyCode.Zero] = "0",
            [Enum.KeyCode.KeypadOne] = "Num1",
            [Enum.KeyCode.KeypadTwo] = "Num2",
            [Enum.KeyCode.KeypadThree] = "Num3",
            [Enum.KeyCode.KeypadFour] = "Num4",
            [Enum.KeyCode.KeypadFive] = "Num5",
            [Enum.KeyCode.KeypadSix] = "Num6",
            [Enum.KeyCode.KeypadSeven] = "Num7",
            [Enum.KeyCode.KeypadEight] = "Num8",
            [Enum.KeyCode.KeypadNine] = "Num9",
            [Enum.KeyCode.KeypadZero] = "Num0",
            [Enum.KeyCode.Minus] = "-",
            [Enum.KeyCode.Equals] = "=",
            [Enum.KeyCode.Tilde] = "~",
            [Enum.KeyCode.LeftBracket] = "[",
            [Enum.KeyCode.RightBracket] = "]",
            [Enum.KeyCode.RightParenthesis] = ")",
            [Enum.KeyCode.LeftParenthesis] = "(",
            [Enum.KeyCode.Semicolon] = ",",
            [Enum.KeyCode.Quote] = "'",
            [Enum.KeyCode.BackSlash] = "\\",
            [Enum.KeyCode.Comma] = ",",
            [Enum.KeyCode.Period] = ".",
            [Enum.KeyCode.Slash] = "/",
            [Enum.KeyCode.Asterisk] = "*",
            [Enum.KeyCode.Plus] = "+",
            [Enum.KeyCode.Period] = ".",
            [Enum.KeyCode.Backquote] = "`",
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
            [Enum.KeyCode.Escape] = "ESC",
            [Enum.KeyCode.Space] = "SPC",
        };

        Library.__index = Library;

        function Library:MakeFlag(parent, base)
            Library.FlagCounter = (Library.FlagCounter or 0) + 1
            local Id = Library.FlagCounter
            
            base = base or 'flag'
            if parent and parent.Name then
                return parent.Name .. '_' .. base .. '_' .. Id
            end
            return base .. '_' .. Id
        end

        if not isfolder(Library.Directory) then
            makefolder(Library.Directory)
        end

        for _, Folder in Library.Folders do
            local Path = Library.Directory .. Folder;
            if not isfolder(Path) then
                makefolder(Path)
            end
        end

        local Flags, ConfigFlags = Library.Flags, Library.ConfigFlags

        --

        -- Library Functions
        function Library:Tween(Object, Properties, Info)
            Info = Info or TweenInfo.new(
                Library.Easing.Speed,
                Library.Easing.Style,
                Library.Easing.Direction
            );

            local Tween = TweenService:Create(Object, Info, Properties);
            Tween:Play();

            return Tween;
        end

        function Library:IsHovering(Object)
            local MousePos = InputService:GetMouseLocation();
            local Position, Size = Object.AbsolutePosition, Object.AbsoluteSize;
            return MousePos.X >= Position.X and MousePos.X <= Position.X + Size.X and MousePos.Y >= Position.Y and MousePos.Y <= Position.Y + Size.Y;
        end

        function Library:Draggify(Object, Target)

            Target = Target or Object

            local Dragging = false
            local DragStart
            local StartPos

            Object.Active = true

            Library:Connect(InputService.InputBegan, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                if Library.ActiveDrag and Library.ActiveDrag ~= Object then
                    return
                end

                if Library.InputFocused then
                    return
                end

                if not Library:IsHovering(Object) then
                    return
                end

                Dragging = true
                Library.ActiveDrag = Object

                DragStart = InputService:GetMouseLocation()
                StartPos = Target.Position

                --print("ActiveDrag:", Library.ActiveDrag)
            end)

            Library:Connect(InputService.InputChanged, function(Input)
                if not Dragging then
                    return
                end

                if Library.ActiveDrag ~= Object then
                    return
                end
                
                if Library.InputFocused then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if not DragStart or not StartPos then
                        return
                    end
                    
                    local Delta = InputService:GetMouseLocation() - DragStart

                    Target.Position = Dim2(
                        StartPos.X.Scale,
                        StartPos.X.Offset + Delta.X,
                        StartPos.Y.Scale,
                        StartPos.Y.Offset + Delta.Y
                    )
                end
            end)

            Library:Connect(InputService.InputEnded, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end
                Library.ActiveDrag = nil
                Dragging = false
            end)

            
        end
        function Library:Resizify(Object, Min, Max)

            local Resizing = false;
            local StartMouse;
            local StartSize;

            local Handle = Library:Create("TextButton", {
                Parent = Object,
                AnchorPoint = Vec2(1, 1),
                Position = Dim2(1, 0, 1, 0),
                Size = Dim2FromOffset(16, 16),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 999999;
            })

            Library:Connect(Handle.MouseButton1Down, function()
                if Library.ActiveDrag then return end

                Resizing = true
                Library.ActiveDrag = Handle

                StartMouse = InputService:GetMouseLocation()
                StartSize = Vec2(
                    Object.Size.X.Offset,
                    Object.Size.Y.Offset
                )

            end)

            Library:Connect(InputService.InputChanged, function(Input)
                if not Resizing then return end
                if Library.ActiveDrag ~= Handle then return end
                if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

                local Delta = InputService:GetMouseLocation() - StartMouse

                Object.Size = Dim2FromOffset(
                    Clamp(StartSize.X + Delta.X, Min.X, Max.X),
                    Clamp(StartSize.Y + Delta.Y, Min.Y, Max.Y)
                )
            end)

            Library:Connect(InputService.InputEnded, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                if Library.ActiveDrag == Handle then
                    Library.ActiveDrag = nil
                end

                Resizing = false
            end)
        end
        function Library:Round(Number, Float)
            local Multiplier = 10 ^ (Float or 0);
            return Random(Number * Multiplier) / Multiplier;
        end 

        function Library:Convert(String)
            return tostring(String):lower():gsub("%s+", "");
        end

        function Library:Lerp(a, b, t)
            return a + (b - a) * t;
        end

        function Library:ToHex(Hex)
            Hex = Hex:gsub("#", "");
            return Rgb(
                tonumber(Hex:sub(1, 2), 16) or 255,
                tonumber(Hex:sub(3, 4), 16) or 255,
                tonumber(Hex:sub(5, 6), 16) or 255
            )
        end

        function Library:FromHex(Color)
            return StringFmt("#%02X%02X%02X", Color.R * 255, Color.G * 255, Color.B * 255);
        end

        function Library:Connect(Signal, Callback)
            local Connection = Signal:Connect(Callback);
            Insert(Library.Connections, Connection);
            return Connection;
        end


        function Library:Create(class, properties)
            local Obj = NewInstance(class);
            
            for Property, Value in properties do
                SafeCall(function()
                    Obj[Property] = Value;
                end)
            end

            return Obj;
        end
        
        --


        --

        -- Configs

        function Library:SetFlag(Flag, Value)
            Library.Flags[Flag] = Value
            Library.ConfigFlags[Flag] = Value
        end

        function Library:GetConfig()
            local Config = {}

            for Flag, Value in next, Library.ConfigFlags do
                local Type = typeof(Value)

                if Type == "Color3" then
                    Config[Flag] = {
                        Type = "Color3",
                        Value = {
                            Value.R,
                            Value.G,
                            Value.B
                        }
                    }

                elseif Type == "ColorSequence" then
                    local Points = {}

                    for _, Point in next, Value.Keypoints do
                        Insert(Points, {
                            Time = Point.Time,
                            Value = {
                                Point.Value.R,
                                Point.Value.G,
                                Point.Value.B
                            }
                        })
                    end

                    Config[Flag] = {
                        Type = "ColorSequence",
                        Value = Points
                    }

                elseif Type == "EnumItem" then
                    Config[Flag] = {
                        Type = "EnumItem",
                        Value = Value.Name
                    }

                else
                    Config[Flag] = Value
                end
            end

            return Config
        end

        function Library:SaveConfig(Name)
            local ConfigDir = Library.Directory .. "/Configs"

            if not isfolder(ConfigDir) then
                makefolder(ConfigDir)
            end

            local Path = ConfigDir .. "/" .. Name .. ".json"

            local Encoded = HttpService:JSONEncode(
                Library:GetConfig()
            )

            writefile(Path, Encoded)

            print("saved config:", Name)
        end

        function Library:LoadConfig(Name)
            local Path = Library.Directory .. "/Configs" .. "/" .. Name .. ".json"

            if not isfile(Path) then
                warn("config not found:", Name)
                return
            end

            local Success, Decoded = SafeCall(function()
                return HttpService:JSONDecode(readfile(Path))
            end)

            if not Success then
                warn("failed to decode config:", Name)
                return
            end

            for Flag, Value in next, Decoded do
                local Element = Library.Elements[Flag]

                if not Element or not Element.Set then
                    continue
                end

                local ValueType = typeof(Value) == "table" and Value.Type

                if ValueType == "Color3" then
                    local C = Value.Value

                    Value = NewColor3(
                        C[1],
                        C[2],
                        C[3]
                    )

                elseif ValueType == "ColorSequence" then
                    local Keypoints = {}

                    for _, Point in next, Value.Value do
                        Insert(Keypoints,
                            ColorKey(
                                Point.Time,
                                NewColor3(
                                    Point.Value[1],
                                    Point.Value[2],
                                    Point.Value[3]
                                )
                            )
                        )
                    end

                    Value = ColorSeq(Keypoints)

                elseif ValueType == "EnumItem" then
                    Value = Enum.KeyCode[Value.Value]
                        or Enum.UserInputType[Value.Value]
                        or Enum.KeyCode.Unknown
                end

                Element:Set(Value, true)
                if Element.Flag == "selected_theme" then
                    SafeCall(function()
                        Library:SetTheme(Value)
                    end)
                end
            end

            print("loaded config:", Name)
        end

        --

        -- Themes
        function Library:GetThemeValue(Path)
            local Current = Library.CurrentTheme

            for _, Value in Path do
                if Current == nil then
                    return nil
                end

                Current = Current[Value]
            end

            return Current
        end

        function Library:RegisterThemeCallback(Callback)
            if type(Callback) == 'function' then
                Insert(self.ThemeCallbacks, Callback)
            end
        end
        
        function Library:Themeify(Object, Property, Path)
            if not Object then
                return nil
            end

            local Entry = {
                Object = Object,
                Property = Property,
                Path = Path
            }

            Insert(self.ThemeObjects, Entry)

            local Value = self:GetThemeValue(Path)

            if Value ~= nil then
                Object[Property] = Value
            end

            return Object
        end

        -- Library:Themeify(Instance, 'Preset', 'Background')
        
        function Library:RefreshTheme()
            for Index, Entry in next, self.ThemeObjects do
                local Object = Entry.Object

                if not Object or not Object.Parent then
                    Remove(self.ThemeObjects, Index)
                    continue
                end

                local Value = self:GetThemeValue(Entry.Path)

                if Value ~= nil then
                    Object[Entry.Property] = Value
                end
            end

            for _, Callback in next, self.ThemeCallbacks do
                if type(Callback) == 'function' then
                    SafeCall(Callback)
                end
            end
        end

        function Library:SetTheme(Name)
            local Theme = Themes[Name]

            if not Theme then
                --warn("theme dont exist, ", Name)
                return
            end

            Library.CurrentTheme = Theme
            Library:RefreshTheme()
        end

        function Library:Unload()
            for _, Connection in Library['Connections'] do
                Connection:Disconnect();
            end
            Clear(Library['Connections']);

            if Library['Threads'] then
                for _, thread in Library['Threads'] do
                    task.cancel(thread);
                end
                Clear(Library['Threads']);
            end

            if Library['Holder'] then
                Library['Holder']:Destroy();
            end

            if Library['Extras'] then
                Library['Extras']:Destroy();
            end

            Library = nil;
        end

        --

        --  Library ->

        function Library:Window(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'Home',
                Size = (params.Size or params.size) or Dim2(0, 510, 0, 550),

                TabMeta;
                Items = { };
            };

            Library.Holder = Library.Holder or Library:Create("ScreenGui", {
                Name = '\0',
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                Parent = LocalPlayer.PlayerGui or CoreGui;
            });

            Library.Extras = Library.Extras or Library:Create('ScreenGui', {
                Name = '\0',
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                Parent = LocalPlayer.PlayerGui or CoreGui;
            });

            local Items = Cfg.Items; do

                Items['Window'] = Library:Create( "Frame", {
                    Parent = Library.Holder;
                    Name = "\0";
                    Position = Dim2(0, 0, 0, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Cfg.Size or Dim2(0, 510, 0, 550);
                    BorderSizePixel = 0;
                    Visible = true;
                    BackgroundTransparency = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Window'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Window'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});
                
                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Window'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Top'] = Library:Create( 'Frame', {
                    Parent = Items['Window'];
                    Name = "\0";
                    Position = Dim2(0, 0, 0, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });
            
                Items['Title'] = Library:Create( 'TextLabel', {
                    Parent = Items['Top'];
                    Name = "\0";
                    Position = Dim2(0, 6, 0, 5);
                    Size = Dim2(1, -12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    FontFace = Library.Font;
                    TextSize = 12;
                    Text = Cfg.Name;
                }); Library:Themeify(Items['Title'], 'TextColor3', {'Accent'});
                
                Items['Container'] = Library:Create( 'Frame', {
                    Parent = Items['Window'];
                    Name = "\0";
                    AnchorPoint = Vec2(0.5, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Position = Dim2(0.5, 0, 0, 44);
                    Size = Dim2(1, -12, 1, -50);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Items['ContainerGradient'] = Library:Create( 'UIGradient', {
                    Parent = Items['Container'];
                    Color = Library.CurrentTheme.Gradients.Container or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(45, 48, 53))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['ContainerGradient'], 'Color', {'Gradients', 'Container'});

                Items['ContainerOutline'] = Library:Create( 'UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['ContainerOutline'], 'Color', {'Borders', 'Outline'});
                
                Items['ContainerInline'] = Library:Create( 'UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['ContainerInline'], 'Color', {'Borders', 'Inline'});

                Library:Create('UIPadding', {
                    Parent = Items['Container'];
                    PaddingTop = Dim(0, 2);
                    PaddingLeft = Dim(0, 2);
                });

                Library:Create('UIListLayout', {
                    Parent = Items['Container'];
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill;
                });

                --

                -- Tabs
                Items['Tabs'] = Library:Create( 'Frame', {
                    BorderColor3 = Rgb(0, 0, 0);
                    Parent = Items['Window'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 6, 0, 18);
                    Size = Dim2(1, -12, 0, 25);
                    ZIndex = 2;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Library:Create('UIListLayout', {
                    Parent = Items['Tabs'];
                    Padding = Dim(0, 1);
                    VerticalAlignment = Enum.VerticalAlignment.Bottom;
                    FillDirection = Enum.FillDirection.Horizontal;
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                Library:Create('UIPadding', {
                    Parent = Items['Tabs'];
                    PaddingBottom = Dim(0, 1);
                    PaddingRight = Dim(0, 1);
                });
                
            end
            -- Functions
            function Cfg:Visible(Value)
                if Value then
                    Items['Window'].Visible = true;
                else
                    Items['Window'].Visible = false;
                end
            end

            function Cfg:ChangeTitle(String)
                Items['Title'].Text = String or Cfg.Name;
            end
            

            --

            -- Extras
            Library:Draggify(Items['Window']);
            Library:Resizify(
                Items['Window'],
                Vec2(510, 550),
                Vec2(1000, 1000)
            );

            Cfg.Items = Items;
            Cfg.Tabs = Items.Tabs;

            return SetMetaTbl(Cfg, Library);
        end

        function Library:Keypicker(Colorpicker)
            local Cfg = {
                Colorpicker = Colorpicker,
                Open = false,
                Hue = 0,
                Sat = 0,
                Val = 1,
                Alpha = 1,
                Color = Colorpicker.Default or Rgb(255,255,255),
                Value = Colorpicker.Default or Rgb(255,255,255),
                Callback = Colorpicker.Callback or function() end,
                Rainbow = Colorpicker.Rainbow,
                Holding = { Box = false, Hue = false, Alpha = false },
                Items = {},
                Connections = {},
            }

            local Items = Cfg.Items do
                Items['Picker'] = Library:Create('Frame', {
                    Parent = Library.Extras;
                    Name = "\0";
                    Visible = false;
                    Position = Dim2(0, 0, 0, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 216, 0, 212);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Picker'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Picker'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['PickerGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Picker'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['PickerGradient'], 'Color', {'Gradients', 'Base'});

                Items['Holder'] = Library:Create('Frame', {
                    Parent = Items['Picker'];
                    Name = "\0";
                    Position = Dim2(0, 8, 0, 8);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, -16, 1, -16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Themes.Preset.Background;
                }); Library:Themeify(Items['Holder'], 'BackgroundColor3', {'Background'});

                Items['HolderInline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['HolderInline'], 'Color', {'Borders', 'Inline'});

                Items['Accent'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Position = Dim2(0, 0, 0, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Accent;
                }); Library:Themeify(Items['Accent'], 'BackgroundColor3', {'Accent'});

                Items['Box'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    BackgroundTransparency = 0;
                    Position = Dim2(0, 8, 0, 10);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 148, 0, 148);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 0, 4);
                });

                Items['BoxOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Box'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['BoxOutline'], 'Color', {'Borders', 'Outline'});

                Items['BoxDragger'] = Library:Create('Frame', {
                    Parent = Items['Box'];
                    Size = Dim2(0, 2, 0, 2);
                    Name = "\0";
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    ZIndex = 4;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['BoxDraggerOutline'] = Library:Create('UIStroke', {
                    Parent = Items['BoxDragger'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['BoxDraggerOutline'], 'Color', {'Borders', 'Inline'});

                Items['GradientSat'] = Library:Create('ImageLabel', {
                    Parent = Items['Box'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = Dim2(1, 0, 1, 0);
                    Image = "rbxassetid://130624743341203";
                    ZIndex = 2;
                });

                Items['GradientVal'] = Library:Create('ImageLabel', {
                    Parent = Items['Box'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = Dim2(1, 2, 1, 0);
                    Position = Dim2(0, -1, 0, 0);
                    Image = "rbxassetid://96192970265863";
                    ZIndex = 3;
                });

                Items['Misc'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 8, 0, 166);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, -16, 0, 18);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = Items['Misc'];
                    Padding = Dim(0, 8);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });

                Items['Hex'] = Library:Create('Frame', {
                    Parent = Items['Misc'];
                    Size = Dim2(0, 46, 0, 18);
                    Name = "\0";
                    BorderColor3 = Rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['HexOutline'] = Library:Create('UIStroke', {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    Name = "\0";
                    Color = Themes.Preset.Borders.Inline;
                    Parent = Items['Hex'];
                }); Library:Themeify(Items['HexOutline'], 'Color', {'Borders', 'Inline'});

                Items['HexText'] = Library:Create('TextBox', {
                    FontFace = Library.Font;
                    TextColor3 = Themes.Preset.Text.Unselected;
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = "#FFFFFF";
                    Parent = Items['Hex'];
                    Name = "\0";
                    AnchorPoint = Vec2(0.5, 0.5);
                    Size = Dim2(0, 0, 0, 12);
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    ClearTextOnFocus = false;
                    TextEditable = true;
                    BackgroundColor3 = Rgb(255, 255, 255);
                }); Library:Themeify(Items['HexText'], 'TextColor3', {'Text', 'Unselected'});

                Items['HexGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Hex'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['HexGradient'], 'Color', {'Gradients', 'Base'});

                Items['Rgb'] = Library:Create('Frame', {
                    Parent = Items['Misc'];
                    Size = Dim2(0, 46, 0, 18);
                    Name = "\0";
                    BorderColor3 = Rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['RgbGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Rgb'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['RgbGradient'], 'Color', {'Gradients', 'Base'});

                Items['RgbOutline'] = Library:Create('UIStroke', {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    Name = "\0";
                    Color = Themes.Preset.Borders.Inline;
                    Parent = Items['Rgb'];
                }); Library:Themeify(Items['RgbOutline'], 'Color', {'Borders', 'Inline'});

                Items['RgbText'] = Library:Create('TextBox', {
                    FontFace = Library.Font;
                    TextColor3 = Themes.Preset.Text.Unselected;
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = "255, 255, 255";
                    Parent = Items['Rgb'];
                    Name = "\0";
                    AnchorPoint = Vec2(0.5, 0.5);
                    Size = Dim2(0, 0, 0, 12);
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    ClearTextOnFocus = false;
                    TextEditable = true;
                    BackgroundColor3 = Rgb(255, 255, 255);
                }); Library:Themeify(Items['RgbText'], 'TextColor3', {'Text', 'Unselected'});

                Items['Hue'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    BackgroundTransparency = 0;
                    Position = Dim2(0, 164, 0, 10);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 10, 0, 148);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['HueGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Hue'];
                    Name = "\0";
                    Color = ColorSeq({
                        ColorKey(0, Rgb(255, 0, 4)),
                        ColorKey(0.17, Rgb(255, 255, 0)),
                        ColorKey(0.34, Rgb(0, 255, 8)),
                        ColorKey(0.51, Rgb(0, 255, 255)),
                        ColorKey(0.68, Rgb(0, 8, 255)),
                        ColorKey(0.85, Rgb(255, 0, 251)),
                        ColorKey(1, Rgb(255, 0, 4))
                    });
                    Rotation = 90;
                });

                Items['HueOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Hue'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['HueOutline'], 'Color', {'Borders', 'Outline'});

                Items['HueDragger'] = Library:Create('Frame', {
                    Name = "\0";
                    Parent = Items['Hue'];
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 1);
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BorderSizePixel = 0;
                    ZIndex = 1;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Create('UIStroke', {
                    Parent = Items['HueDragger'];
                    Name = "\0";
                    Color = Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                });

                Items['Alpha'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Position = Dim2(0, 182, 0, 10);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 10, 0, 148);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['AlphaOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Alpha'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['AlphaOutline'], 'Color', {'Borders', 'Outline'});

                Items['AlphaDragger'] = Library:Create('Frame', {
                    Name = "\0";
                    Parent = Items['Alpha'];
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    Position = Dim2(0.5, 0, 0.5, 0);
                    ZIndex = 3;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Create('UIStroke', {
                    Parent = Items['AlphaDragger'];
                    Name = "\0";
                    Color = Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                });

                Items['Checkers'] = Library:Create('ImageLabel', {
                    ScaleType = Enum.ScaleType.Tile;
                    BorderColor3 = Rgb(0, 0, 0);
                    Parent = Items['Alpha'];
                    Name = "\0";
                    Size = Dim2(1, 0, 1, 0);
                    Image = "rbxassetid://155451930";
                    TileSize = Dim2(0, 10, 0, 10);
                    SliceScale = 0.5;
                    BackgroundColor3 = Rgb(255, 255, 255);
                    BorderSizePixel = 0;
                    SliceCenter = Rect.new(Vec2(5, 5), Vec2(5, 10));
                });

                Items['AlphaColor'] = Library:Create('Frame', {
                    Name = "\0";
                    Parent = Items['Alpha'];
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['ColorTransparency'] = Library:Create('UIGradient', {
                    Parent = Items['AlphaColor'];
                    Name = "\0";
                    Rotation = 90;
                    Transparency = NumSeq({NumKey(0, 0), NumKey(1, 1)});
                });

                Items['BoxDragger'].AnchorPoint = Vec2(0.5, 0.5)
                Items['HueDragger'].AnchorPoint = Vec2(0.5, 0.5)
                Items['AlphaDragger'].AnchorPoint = Vec2(0.5, 0.5)
            end

            Items['HexText'].Focused:Connect(function()
                Library.ActiveDrag = nil
                Library.InputFocused = true
            end)

            Items['HexText'].FocusLost:Connect(function(EnterPressed)
                Library.InputFocused = false
                if not EnterPressed then return end

                local Text = Items['HexText'].Text:gsub("#", ""):upper()
                if #Text ~= 6 then return end

                local Success, Result = SafeCall(function()
                    return Color3.fromHex(Text)
                end)

                if not Success or not Result then return end
                Cfg:SetColor(Result, Cfg.Alpha)
            end)

            Items['RgbText'].Focused:Connect(function()
                Library.ActiveDrag = nil
                Library.InputFocused = true
            end)

            Items['RgbText'].FocusLost:Connect(function(EnterPressed)
                Library.InputFocused = false
                if not EnterPressed then return end

                local Text = Items['RgbText'].Text
                local Values = {}

                for Value in Text:gmatch("%d+") do
                    Insert(Values, tonumber(Value))
                end

                if #Values ~= 3 then return end

                local R = Clamp(Values[1], 0, 255)
                local G = Clamp(Values[2], 0, 255)
                local B = Clamp(Values[3], 0, 255)

                Items['RgbText'].Text = string.format("%s, %s, %s", R, G, B)
                Items['HexText'].Text = string.format("#%02X%02X%02X", R, G, B)

                Cfg:SetColor(Rgb(R, G, B), Cfg.Alpha)
            end)

            function Cfg:SetColor(Color, Alpha)
                if not (typeof(Color) == "Color3") then
                    Color = Rgb(255, 255, 255)
                end

                self.Color = Color
                self.Alpha = Alpha or self.Alpha

                local H, S, V = Color:ToHSV()

                self.Hue = H
                self.Sat = S
                self.Val = V

                local R = Floor(Color.R * 255)
                local G = Floor(Color.G * 255)
                local B = Floor(Color.B * 255)

                Items['Box'].BackgroundColor3 = Hsv(self.Hue, 1, 1)
                Items['AlphaColor'].BackgroundColor3 = Color

                Items['BoxDragger'].Position = Dim2FromScale(1 - self.Sat, 1 - self.Val)
                Items['HueDragger'].Position = Dim2FromScale(0.5, self.Hue)
                Items['AlphaDragger'].Position = Dim2FromScale(0.5, 1 - self.Alpha)

                Items['HexText'].Text = string.format("#%02X%02X%02X", R, G, B)
                Items['RgbText'].Text = string.format("%s, %s, %s", R, G, B)

                self.Value = Color

                local Bind = self.Colorpicker
                    and self.Colorpicker.Items
                    and self.Colorpicker.Items['Gradient']

                if Bind then
                    Bind.Color = ColorSeq({
                        ColorKey(0, Color),
                        ColorKey(1, Rgb(32, 33, 37))
                    })
                    Bind.Transparency = NumSeq({
                        NumKey(0, 1 - self.Alpha),
                        NumKey(1, 1 - self.Alpha)
                    })
                end

                self.Callback(Color, self.Alpha)
            end

            function Cfg:UpdateBox(Input)
                local AbsPos = Items['Box'].AbsolutePosition
                local AbsSize = Items['Box'].AbsoluteSize

                    local X = Clamp((Input.Position.X - AbsPos.X) / AbsSize.X, 0, 1)
                    local Y = Clamp((Input.Position.Y - AbsPos.Y) / AbsSize.Y, 0, 1)

                    self.Sat = 1 - X
                    self.Val = 1 - Y

                    Items['BoxDragger'].Position = Dim2FromScale(X, Y)

                    Items['Box'].BackgroundColor3 = Hsv(self.Hue, 1, 1)

                    local Color = Hsv(self.Hue, self.Sat, self.Val)
                    self:SetColor(Color, self.Alpha)
                end

                function Cfg:UpdateHue(Input)
                    local AbsPos = Items['Hue'].AbsolutePosition
                    local AbsSize = Items['Hue'].AbsoluteSize

                    local Y = Clamp((Input.Position.Y - AbsPos.Y) / AbsSize.Y, 0, 1)

                    self.Hue = Y

                    Items['HueDragger'].Position = Dim2FromScale(0.5, Y)
                    Items['Box'].BackgroundColor3 = Hsv(self.Hue, 1, 1)

                    local Color = Hsv(self.Hue, self.Sat, self.Val)
                    self:SetColor(Color, self.Alpha)
                end

                function Cfg:UpdateAlpha(Input)
                    local AbsPos = Items['Alpha'].AbsolutePosition
                    local AbsSize = Items['Alpha'].AbsoluteSize

                    local Y = Clamp((Input.Position.Y - AbsPos.Y) / AbsSize.Y, 0, 1)

                    self.Alpha = 1 - Y

                    Items['AlphaDragger'].Position = Dim2FromScale(0.5, Y)
                    self:SetColor(self.Color, self.Alpha)
                end

            Items['Box'].InputBegan:Connect(function(Input)
                if not (Input.UserInputType == Enum.UserInputType.MouseButton1) then return end
                Library.ActiveDrag = Items['Picker']
                Cfg.Holding.Box = true
                Cfg:UpdateBox(Input)
            end)

            Items['Hue'].InputBegan:Connect(function(Input)
                if not (Input.UserInputType == Enum.UserInputType.MouseButton1) then return end
                Library.ActiveDrag = Items['Picker']
                Cfg.Holding.Hue = true
                Cfg:UpdateHue(Input)
            end)

            Items['Alpha'].InputBegan:Connect(function(Input)
                if not (Input.UserInputType == Enum.UserInputType.MouseButton1) then return end
                Library.ActiveDrag = Items['Picker']
                Cfg.Holding.Alpha = true
                Cfg:UpdateAlpha(Input)
            end)

            InputService.InputEnded:Connect(function(Input)
                if not (Input.UserInputType == Enum.UserInputType.MouseButton1) then return end
                Cfg.Holding.Box = false
                Cfg.Holding.Hue = false
                Cfg.Holding.Alpha = false
            end)

            InputService.InputChanged:Connect(function(Input)
                if not (Input.UserInputType == Enum.UserInputType.MouseMovement) then return end

                if Cfg.Holding.Box then Cfg:UpdateBox(Input) end
                if Cfg.Holding.Hue then Cfg:UpdateHue(Input) end
                if Cfg.Holding.Alpha then Cfg:UpdateAlpha(Input) end
            end)

            Cfg:SetColor(Colorpicker.Default or Rgb(255, 255, 255), Cfg.Alpha)

            return Cfg
        end

        function Library:Dock(params)
            local Cfg = {
                Buttons = params.Buttons or {};
                Items = {};
            };

            local Items = Cfg.Items; do
                Items['Dock'] = Library:Create('Frame', {
                    Parent = Library.Holder;
                    Name = "\0";
                    AnchorPoint = Vec2(0.5, 0);
                    Position = Dim2(0.5, 0, 0.01, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 140, 0, 50);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Dock'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Dock'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Dock'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Container'] = Library:Create('Frame', {
                    Parent = Items['Dock'];
                    Name = "\0";
                    Position = Dim2(0, 7, 0, 7);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, -14, 1, -14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Background;
                }); Library:Themeify(Items['Container'], 'BackgroundColor3', {'Background'});

                Items['ContainerOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline;
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['ContainerOutline'], 'Color', {'Borders', 'Inline'});

                Items['Accent'] = Library:Create('Frame', {
                    Name = "\0";
                    Parent = Items['Container'];
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Accent;
                }); Library:Themeify(Items['Accent'], 'BackgroundColor3', {'Accent'});
                
                Items['Holder'] = Library:Create('Frame', {
                    Parent = Items['Container'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 0, 0, 2);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                })

                Library:Create('UIListLayout', {
                    Parent = Items['Holder'];

                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    VerticalAlignment = Enum.VerticalAlignment.Center;

                    Padding = Dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })
                
            end

            Cfg.ButtonInstances = {}

            function Cfg:Button(params)
                local ButtonCfg = {
                    Icon = params.Icon or params.Image or "",
                    Toggle = params.Toggle or false,
                    Enabled = params.Default or false,
                    Callback = params.Callback or function() end,

                    Items = {}
                }

                local ButtonItems = ButtonCfg.Items

                ButtonItems['Icon'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 24, 0, 24);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                })

                ButtonItems['Outer'] = Library:Create('UIStroke', {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    Color = Library.CurrentTheme.Borders.Inline;
                    Parent = ButtonItems['Icon'];
                })

                Library:Themeify(
                    ButtonItems['Outer'],
                    'Color',
                    {'Borders', 'Inline'}
                )

                ButtonItems['Gradient'] = Library:Create('UIGradient', {
                    Rotation = 90;
                    Parent = ButtonItems['Icon'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 38))
                    });
                }); Library:Themeify(ButtonItems['Gradient'], 'Color', {'Gradients', 'Base'});

                ButtonItems['Image'] = Library:Create('ImageButton', {
                    Parent = ButtonItems['Icon'];

                    Image = ButtonCfg.Icon,

                    AnchorPoint = Vec2(0.5, 0.5);
                    Position = Dim2(0.5, 0, 0.5, 0);
                    Size = Dim2(1, -8, 1, -10);

                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;

                    ScaleType = Enum.ScaleType.Fit;
                    ResampleMode = Enum.ResamplerMode.Pixelated;

                    ImageColor3 = ButtonCfg.Enabled
                        and (Library.CurrentTheme.Accent or Rgb(221,168,93))
                        or (Library.CurrentTheme.Text.Unselected);
                })

                local function Set(State)
                    ButtonCfg.Enabled = State

                    Library:Tween(ButtonItems['Image'], {
                        ImageColor3 = State
                            and (Library.CurrentTheme.Accent or Rgb(221,168,93))
                            or (Library.CurrentTheme.Text.Main or Rgb(214,217,224))
                    })

                    ButtonCfg.Callback(State)
                end

                Library:Connect(ButtonItems['Image'].MouseButton1Click, function()
                    if ButtonCfg.Toggle then
                        Set(not ButtonCfg.Enabled)
                    else
                        ButtonCfg.Callback()
                    end
                end)

                Library:Connect(ButtonItems['Image'].MouseEnter, function()
                    if ButtonCfg.Enabled then
                        return
                    end

                    Library:Tween(ButtonItems['Image'], {
                        ImageColor3 = Library.CurrentTheme.Accent or Rgb(221,168,93)
                    })
                end)

                Library:Connect(ButtonItems['Image'].MouseLeave, function()
                    if ButtonCfg.Enabled then
                        return
                    end

                    Library:Tween(ButtonItems['Image'], {
                        ImageColor3 = Library.CurrentTheme.Text.Unselected;
                    })
                end)

                if ButtonCfg.Enabled then
                    Set(true)
                end

                Insert(Cfg.ButtonInstances, ButtonCfg)

                return ButtonCfg
            end

            for _, Button in next, Cfg.Buttons do
                Cfg:Button(Button)
            end

            Library:RegisterThemeCallback(function()
                for _, ButtonCfg in next, Cfg.ButtonInstances do
                    ButtonCfg.Items['Image'].ImageColor3 = ButtonCfg.Enabled
                        and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                        or (Library.CurrentTheme.Text.Unselected)
                end
            end)
            --

            -- Extras

            return SetMetaTbl(Cfg, Library);
        end

        function Library:Watermark(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'Watermark',
                Modules = (params.Modules or params.modules) or { },

                Items = { };
            };

            local Items = Cfg.Items; do

                Items['WatermarkContainer'] = Library:Create('Frame', {
                    Parent = Library.Extras;
                    Name = "\0";
                    Position = Dim2(0.0077770426869392395, 0, 0.900876522064209, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 260, 0, 36);
                    --AutomaticSize = Enum.AutomaticSize.X;
                    BorderSizePixel = 0;
                    Active = true;
                    BackgroundTransparency = 1;
                    BackgroundColor3 = Rgb(255, 255, 255);
                })
                Library:Draggify(Items['WatermarkContainer'])

                Items['Watermark'] = Library:Create('Frame', {
                    Parent = Items['WatermarkContainer'];
                    Name = "\0";
                    Position = Dim2(0.0077770426869392395, 0, 0.900876522064209, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 250, 0, 26);
                    --AutomaticSize = Enum.AutomaticSize.X;
                    BorderSizePixel = 0;
                    Active = true;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });



                Items['Gradient'] = Library:Create('UIGradient', {
                    Rotation = 90;
                    Parent = Items['Watermark'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Watermark'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Watermark'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Container'] = Library:Create('Frame', {
                    Parent = Items['Watermark'];
                    Name = "\0";
                    Position = Dim2(0, 4, 0, 4);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, -8, 1, -8);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Background;
                }); Library:Themeify(Items['Container'], 'BackgroundColor3', {'Background'});


                Items['ContainerInline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['ContainerInline'], 'Color', {'Borders', 'Inline'});

                Items['Accent'] = Library:Create('Frame', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Position = Dim2(0, 1, 0, 1);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, -2, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Accent;
                }); Library:Themeify(Items['Accent'], 'BackgroundColor3', {'Accent'});

                Items['Holder'] = Library:Create('Frame', {
                    BorderColor3 = Rgb(0, 0, 0);
                    AnchorPoint = Vec2(0.5, 0.5);
                    Parent = Items['Container'];
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0.5, 0);
                    Name = "\0";
                    Active = true;
                    Size = Dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Draggify(Items['Holder'], Items['Watermark'])

                Library:Create('UIListLayout', {
                    Parent = Items['Holder'];
                    Padding = Dim(0, 2);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal;
                })

                Library:Create('UIPadding', {
                    Parent = Items['Holder'];
                    PaddingLeft = Dim(0, 4);
                    PaddingRight = Dim(0, 4);
                });
                
                Items['Name'] = Library:Create('TextLabel', {
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main;
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items['Holder'];
                    Name = "\0";
                    AnchorPoint = Vec2(0, 0.5);
                    Size = Dim2(0, 0, 0, 12);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    LayoutOrder = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = Rgb(255, 255, 255);
                }); Library:Themeify(Items['Name'], 'TextColor3', {'Text', 'Main'});

                Items['Separator'] = Library:Create('TextLabel', {
                    FontFace = Library.Font;
                    Text = " | ";
                    Parent = Items['Holder'];
                    AnchorPoint = Vec2(0, 0.5);
                    Size = Dim2(0, 0, 0, 12);
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    LayoutOrder = 1;
                    TextColor3 = Library.CurrentTheme.Text.Main;
                }); Library:Themeify(Items['Separator'], 'TextColor3', {'Text', 'Main'});

                Items['Labels'] = { }; 
                Items['Separators'] = { }; 
                do

                    for Index, Module in Cfg.Modules do
                        local Label = Library:Create('TextLabel', {
                            FontFace = Library.Font;
                            TextColor3 = Library.CurrentTheme.Text.Main;
                            Text = "";
                            Parent = Items['Holder'];
                            AnchorPoint = Vec2(0, 0.5);
                            Size = Dim2(0, 0, 0, 12);
                            BackgroundTransparency = 1;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            Size = Dim2(0, 0, 0, 12);
                            TextSize = 12;
                            LayoutOrder = Index * 2;
                            Active = false;
                            Selectable = false;
                        }); Library:Themeify(Label, 'TextColor3', {'Text', 'Main'});

                        Insert(Items['Labels'], Label);

                        if Index < #Cfg.Modules then
                            local Seperator = Library:Create('TextLabel', {
                                FontFace = Library.Font;
                                Text = " | ";
                                Parent = Items['Holder'];
                                AnchorPoint = Vec2(0, 0.5);
                                Size = Dim2(0, 0, 0, 12);
                                BackgroundTransparency = 1;
                                AutomaticSize = Enum.AutomaticSize.X;
                                TextSize = 12;
                                Active = false;
                                Selectable = false;
                                LayoutOrder = Index * 2 + 1;
                                TextColor3 = Library.CurrentTheme.Text.Main;
                            }); Library:Themeify(Seperator, 'TextColor3', {'Text', 'Main'});
                            Insert(Items['Separators'], Seperator)

                        end
                    end

                end
                
            end

            local CurrentFps = 0
            local Frames = 0
            local Last = tick()

            Library:Connect(RunService.RenderStepped, function()
                Frames += 1

                local now = tick()
                if now - Last >= 1 then
                    CurrentFps = Frames
                    Frames = 0
                    Last = now
                end
            end)
            function Cfg:GetFps()
                return "FPS: " .. tostring(CurrentFps)
            end

            function Cfg:GetPing()
                local ServerStats = Stats:FindFirstChild("Network")
        and Stats.Network:FindFirstChild("ServerStatsItem")
                if ServerStats then
                    local ping = ServerStats:FindFirstChild("Data Ping")
                    if ping then
                        return "Ping: " .. Floor(ping:GetValue()) .. "ms"
                    end
                end

                return "Ping: 0"
            end

            function Cfg:GetTime()
                return os.date("%H:%M:%S")
            end
            function Cfg:Resolve(Module)
                if Module.Type == 'Text' then
                    return Module.Value

                elseif Module.Type == 'Fps' then
                    return self:GetFps()

                elseif Module.Type == 'Ping' then
                    return self:GetPing()

                elseif Module.Type == 'Time' then
                    return self:GetTime()

                elseif Module.Type == 'Custom' then
                    return Module.Value or ''
                end

                return ''
            end
            
            local WatermarkThread = task.spawn(function()
                while task.wait(0.1) do
                    for Index, Module in Cfg.Modules do
                        local Label = Items['Labels'][Index]

                        if Label then
                            Label.Text = Cfg:Resolve(Module) or ""
                        end
                    end
                end
            end)
            Insert(Library.Threads, WatermarkThread)
            
            return SetMetaTbl(Cfg, Library);
        end
        
        function Library:Tab(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'tab',
                Items = { };
            };

            local Items = Cfg.Items; do

                Items['Button'] = Library:Create( 'TextButton', {
                    Parent = self['Tabs'];
                    Name = "\0";
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 0, 0, 18);
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    BackgroundColor3 = Rgb(255, 255, 255);
                    BackgroundTransparency = 1;
                    Text = '',
                });

                Items['ButtonGradient'] = Library:Create( 'UIGradient', {
                    Parent = Items['Button'];
                    Color = Library.CurrentTheme.Gradients.Tab or ColorSeq({
                        ColorKey(0, Rgb(46, 49, 54)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = -90;
                }); Library:Themeify(Items['ButtonGradient'], 'Color', {'Gradients', 'Tab'});
                
                Items['Title']  = Library:Create( 'TextLabel', {
                    Parent = Items['Button'];
                    Name = "\0";
                    Position = Dim2FromOffset(0, 0);
                    Size = Dim2FromScale(1, 1);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextColor3 = Library.CurrentTheme.Text.Unselected or Rgb(175, 175, 175);
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    FontFace = Library.Font;
                    TextSize = 12;
                    Text = Cfg.Name;
                }); Library:Themeify(Items['Title'], 'TextColor3', {'Text', 'Unselected'});
            
                Items.Button.Size = Dim2FromOffset(
                    Items.Title.TextBounds.X + 6, 18)

                Library:Create( 'UIPadding', {
                    Parent = Items['Button'];
                    PaddingTop = Dim(0, 1);
                })

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Button'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});
                
                Items['Line'] = Library:Create( 'Frame', {
                    Parent = Items['Button'];
                    Name = "\0";
                    Size = Dim2(1, -2, 0, 4);
                    Visible = false;
                    Position = Dim2(0, 1, 1, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    ZIndex = 4;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Gradients.Tab.Keypoints[1].Value;
                }); Library:Themeify(Items['Line'], 'BackgroundColor3', {'Gradients', 'Tab', 'Keypoints', 1, 'Value'});

                Items['Page'] = Library:Create('ScrollingFrame', {
                    Parent = self.Items['Container'];
                    Name = "\0";
                    Visible = false;
                    BorderSizePixel = 0;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    CanvasSize = Dim2();
                    ClipsDescendants = true;
                    ScrollBarThickness = 0;
                    ScrollingDirection = Enum.ScrollingDirection.Y;
                    Size = Dim2FromScale(1,1);
                    BackgroundTransparency = 1;
                    BottomImage = "";
                    MidImage = "";
                    TopImage = "";
                    BackgroundColor3 = Rgb(1,1,1);
                });

                Items['ContainerGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Page'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = -90;
                }); Library:Themeify(Items['ContainerGradient'], 'Color', {'Gradients', 'Base'});

                Items['Left'] = Library:Create( 'Frame', {
                    Parent = Items['Page'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = Dim2(0.5, -4, 1, 0);
                    Position = Dim2(0, 0, 0, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Items['Right'] = Library:Create( 'Frame', {
                    Parent = Items['Page'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0.5, -4, 1, 0);
                    Position = Dim2(0.5, 4, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                for Index, Item in { Items['Left'], Items['Right'] } do

                    Library:Create( 'UIListLayout', {
                        Parent = Item;
                        Padding = Dim(0, 8);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill
                    });

                    if Item == Items['Left'] then
                        Library:Create('UIPadding', {
                            Parent = Item;
                            PaddingTop = Dim(0, 8);
                            PaddingLeft = Dim(0, 6);
                        })
                    else
                        Library:Create('UIPadding', {
                            Parent = Item;
                            PaddingTop = Dim(0, 8);
                            PaddingRight = Dim(0, 8);
                        })
                    end

                end

                Items['Inner'] = Library:Create( 'Frame', {
                    Parent = Items['Button'];
                    Name = "\0";
                    BorderColor3 = Rgb(0, 0, 0);
                    AnchorPoint = Vec2(0.5, 0);
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0, 0);
                    Size = Dim2(1, -2, 1, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(1, 1, 1);
                }); 

                Items['Inline'] = Library:Create( 'UIStroke', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Enabled = false;
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Accent'] = Library:Create( 'Frame', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Visible = false;
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Accent or Rgb(255, 255, 255);
                }); Library:Themeify(Items['Accent'], 'BackgroundColor3', {'Accent'});
                
            end
            --

            -- Functions
            local function UpdateCanvas()
                local LeftSize = Items.Left.AbsoluteSize.Y
                local RightSize = Items.Right.AbsoluteSize.Y

                Items.Page.CanvasSize = Dim2(
                    0,
                    0,
                    0,
                    math.max(LeftSize, RightSize) + 8
                )
            end

            Items.Left:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCanvas)
            Items.Right:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCanvas)

            task.defer(UpdateCanvas)

            function Cfg.OpenTab()
                local Current = self.TabMeta

                local function Toggle(Tab, State)
                    if not Tab or not Tab.Button then
                        return
                    end

                    Tab.Button.Size = State and Dim2FromOffset(Tab.Title.TextBounds.X + 6, 18) or Dim2FromOffset(Tab.Title.TextBounds.X + 4, 18)
                    Tab.Button.BackgroundTransparency = State and 0 or 1

                    for _, v in { Tab.Line, Tab.Accent, Tab.Page } do
                        v.Visible = State
                    end

                    for _, v in { Tab.Outline, Tab.Inline, Tab.ButtonGradient } do
                        v.Enabled = State
                    end

                    Library:Tween(Tab.Title, {
                        TextColor3 = State
                            and Library.CurrentTheme.Accent
                            or Library.CurrentTheme.Text.Unselected
                    })
                end

                Toggle(Current, false)

                self.TabMeta = Items
                Toggle(Items, true)
            end
            

            Library:Connect(Items.Button.MouseButton1Click, function()
                Cfg.OpenTab();
            end)

                Library:RegisterThemeCallback(function()
                    local Selected = (self.TabMeta == Items)

                    Items.Title.TextColor3 = Selected
                        and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                        or (Library.CurrentTheme.Text.Unselected or Rgb(175, 175, 175))
                end)

            Library:Connect(Items.Button.MouseEnter, function()
                if self.TabMeta ~= Cfg.Items then
                    Library:Tween(Items['Title'], { TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93) })
                end
            end)

            Library:Connect(Items.Button.MouseLeave, function()
                if self.TabMeta ~= Cfg.Items then
                    Library:Tween(Items['Title'], { TextColor3 = Library.CurrentTheme.Text.Unselected or Rgb(175, 175, 175) })
                end
            end)

            if not self.TabMeta then
                Cfg.OpenTab()
            end

            return SetMetaTbl(Cfg, Library);
        end

        function Library:Section(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'section',
                Side = (params.Side or params.side) or 'left',
                Collapsed = (params.Collapsed ~= nil) and params.Collapsed or false,
                Clickable = (params.Clickable ~= nil) and params.Clickable or true,
                
                OpenSize;
                Items = { };
            };

            local Items = Cfg.Items; do

                Items['Section'] = Library:Create('Frame', {
                    Parent = Cfg.Side:lower() == 'left' and self.Items.Left or self.Items.Right;
                    Name = "\0";
                    ClipsDescendants = false;
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Library.CurrentTheme.Background or Rgb(32, 33, 37);
                }); Library:Themeify(Items['Section'], 'BackgroundColor3', {'Background'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Section'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Section'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Line'] = Library:Create('Frame', {
                    Parent = Items['Section'];
                    Size = Dim2(0, 52, 0, 2);
                    Name = "\0";
                    Position = Dim2(0, 4, 0, -1);
                    BorderColor3 = Rgb(0, 0, 0);
                    ZIndex = 2;
                    BackgroundTransparency = 0;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Background or Rgb(32, 33, 37);
                }); Library:Themeify(Items['Line'], 'BackgroundColor3', {'Background'});

                Items['Title'] = Library:Create('TextLabel', {
                    Parent = Items['Line'];
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Name = "\0";
                    AnchorPoint = Vec2(0.5, 0);
                    Size = Dim2(0, 0, 0, 12);
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0, -7);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Hover = Library:Create("TextButton", {
                    Parent = Items['Section'];
                    Name = "\0";
                    BackgroundTransparency = 1,
                    Size = Items['Line'].Size,
                    Position = Items['Line'].Position,
                    Text = "",
                    ZIndex = Items['Title'].ZIndex + 1,
                    AutoButtonColor = false
                })

                Items['Line'].Size = Dim2(0, Items['Title'].TextBounds.X + 7, 0, 2)

                Items['Container'] = Library:Create('Frame', {
                    BorderColor3 = Rgb(0, 0, 0);
                    Parent = Items['Section'];
                    Name = "\0";
                    BackgroundTransparency = 1;

                    Position = Dim2(0, 1, 0, 2);
                    Size = Dim2(1, -2, 0, 0);

                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Library:Create('UIListLayout', {
                    Parent = Items['Container'];
                    Padding = Dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                Library:Create('UIPadding', {
                    Parent = Items['Container'];

                    PaddingTop = Dim(0, 7);
                    PaddingBottom = Dim(0, 8);

                    PaddingLeft = Dim(0, 7);
                    PaddingRight = Dim(0, 7);
                });

            end
            --

            -- Functions
            function Cfg:Collapse()
                if Cfg.Collapsed then
                    return
                end

                Cfg.Collapsed = true

                Items.Container.Visible = false

                Items.Section.Size = Dim2(1,0,0,15)
            end

            function Cfg:Expand()
                if not Cfg.Collapsed then
                    return
                end

                Cfg.Collapsed = false

                Items.Container.Visible = true

                Items.Section.Size = Dim2(1,0,0,0)
            end

            --

            -- Extras

            if Hover then

                Library:Connect(Hover.MouseEnter, function()
                    Library:Tween(Items['Title'], { TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93) })
                end)

                Library:Connect(Hover.MouseLeave, function()
                    Library:Tween(Items['Title'], { TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224) })
                end)

                Library:Connect(Hover.InputBegan, function(Input)
                    if not Cfg.Clickable then
                        return
                    end

                    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        if not Cfg.Collapsed then
                            Cfg:Collapse()
                        end
                    end

                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Cfg.Collapsed then
                            Cfg:Expand()
                        end
                    end
                end)

            end

            return SetMetaTbl(Cfg, Library)
        end

        function Library:SubSection(params)
            local Cfg = {
                Names = (params.Names or params.names) or { },
                Count = (params.Count or params.count) or 2,

                Sections = { },
                Items = { };
            };

            local Items = Cfg.Items; do
                Items['SubSectionContainer'] = Library:Create('Frame', {
                    Parent = self.Items['Container'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = Dim2(1, 0, 0, 0);
                    LayoutOrder = 0;
                    BorderColor3 = Rgb(0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                });

                Library:Create('UIPadding', {
                    Parent = Items['SubSectionContainer'];
                    PaddingTop = Dim(0, 1);
                })

                Library:Create('UIListLayout', {
                    Parent = Items['SubSectionContainer'];
                    Padding = Dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });

                
                Items['Holder'] = Library:Create('Frame', {
                    Parent = Items['SubSectionContainer'];
                    Name = "\0";
                    LayoutOrder = 0;
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 0, 0, 1);
                    BackgroundColor3 = Rgb(1, 1, 1);
                });

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                
                Library:Create('UIListLayout', {
                    Parent = Items['Holder'];
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Padding = Dim(0, -2);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Items['Pages'] = Library:Create('Frame', {
                    Parent = Items['SubSectionContainer'];
                    Name = "\0";
                    BackgroundTransparency = 0;
                    Size = Dim2(1, 0, 0, 160);
                    --AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['PageGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Pages'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = -90;
                }); Library:Themeify(Items['PageGradient'], 'Color', {'Gradients', 'Base'});

                Items['PageOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Pages'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['PageOutline'], 'Color', {'Borders', 'Outline'});

                Items['PagesInline'] = Library:Create('UIStroke', {
                    Parent = Items['Pages'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['PagesInline'], 'Color', {'Borders', 'Inline'});
                
                for Index = 1, Cfg.Count do

                    local Section = {
                        Name = Cfg.Names[Index] or "Section " .. tostring(Index),
                        Parent = Cfg,
                        Items = { };
                    };

                    function Section:Hide()
                        self.Items['Page'].Visible = false
                        self.Items['Accent'].Visible = false

                        self.Items['ButtonGradient'].Rotation = -90

                        Library:Tween(self.Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Text.Deselected or Rgb(175, 175, 175)
                        })
                    end;

                    function Section:Show()

                        for _, Sec in self.Parent.Sections do
                            if Sec ~= self then
                                Sec:Hide()
                            end
                        end

                        self.Items['Page'].Visible = true
                        self.Items['Accent'].Visible = true

                        self.Items['ButtonGradient'].Rotation = 90

                        Library:Tween(self.Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93)
                        })
                    end

                    local SectionItems = Section.Items; do
                        SectionItems['Button'] = Library:Create('TextButton', {
                            Parent = Items['Holder'];
                            Name = "\0";
                            Text = "";
                            AutoButtonColor = false;
                            BackgroundTransparency = 0;
                            BorderColor3 = Rgb(0, 0, 0);
                            BorderSizePixel = 0;
                            Size = Dim2(1, 0, 1, 0);
                            ZIndex = 1;
                            BackgroundColor3 = Rgb(255, 255, 255);
                        });
                        SectionItems['ButtonGradient'] = Library:Create('UIGradient', {
                            Parent = SectionItems['Button'];
                            Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                                ColorKey(0, Rgb(45, 48, 55)),
                                ColorKey(1, Rgb(32, 33, 37))
                            });
                            Rotation = -90;
                        }); Library:Themeify(SectionItems['ButtonGradient'], 'Color', {'Gradients', 'Base'});   
                        
                        SectionItems['ButtonInline'] = Library:Create('UIStroke', {
                            Parent = SectionItems['Button'];
                            Name = "\0";
                            Color = Library.CurrentTheme.Borders.Inline;
                            Thickness = 1;
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                            LineJoinMode = Enum.LineJoinMode.Miter;
                            BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                        }); Library:Themeify(SectionItems['ButtonInline'], 'Color', {'Borders', 'Inline'});

                        SectionItems['Text'] = Library:Create('TextLabel', {
                            Parent = SectionItems['Button'];
                            BackgroundTransparency = 1;
                            Size = Dim2(1, 0, 1, 0);
                            Position = Dim2(0.5, -1, 0.5, 0);
                            AnchorPoint = Vec2(0.5, 0.5);
                            FontFace = Library.Font;
                            Text = Section.Name;
                            TextSize = 12;
                            TextColor3 = Library.CurrentTheme.Text.Deselected or Rgb(175, 175, 175);
                        }); Library:Themeify(SectionItems['Text'], 'TextColor3', {'Text', 'Deselected'});

                        SectionItems['Accent'] = Library:Create('Frame', {
                            Parent = SectionItems['Button'];
                            Name = "\0";
                            Visible = false;
                            BorderSizePixel = 0;
                            Position = Dim2(0, 1, 0, 1);
                            Size = Dim2(1, -2, 0, 2);
                            BackgroundColor3 = Library.CurrentTheme.Accent;
                        }); Library:Themeify(SectionItems['Accent'], 'BackgroundColor3', {'Accent'});

                        SectionItems['Page'] = Library:Create('Frame', {
                            Parent = Items['Pages'];
                            Name = "\0";
                            Visible = false;
                            BackgroundTransparency = 1;
                            Size = Dim2(1, -16, 1, 0);
                            Position = Dim2(0, 8, 0, 8);
                            BackgroundColor3 = Library.CurrentTheme.Background;
                            --AutomaticSize = Enum.AutomaticSize.Y;
                        }); Library:Themeify(SectionItems['Page'], 'BackgroundColor3', {'Background'});

                        Library:Create('UIPadding', {
                            Parent = SectionItems['Page'];
                           --PaddingTop = Dim(0, 7);
                            --PaddingBottom = Dim(0, -8);
                        })
                        SectionItems['Container'] = Library:Create('Frame', {
                            Parent = SectionItems['Page'];
                            Name = "\0";
                            BackgroundTransparency = 0;
                            Size = Dim2(1, 0, 0, 144);
                            BackgroundColor3 = Library.CurrentTheme.Background;
                            --AutomaticSize = Enum.AutomaticSize.Y;
                        }); Library:Themeify(SectionItems['Container'], 'BackgroundColor3', {'Background'});
                        

                        SectionItems['ContainerOutline'] = Library:Create('UIStroke', {
                            Parent = SectionItems['Container'];
                            Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                            Thickness = 1;
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                            LineJoinMode = Enum.LineJoinMode.Miter;
                        }); Library:Themeify(SectionItems['ContainerOutline'], 'Color', {'Borders', 'Outline'});

                        SectionItems['ContainerInline'] = Library:Create('UIStroke', {
                            Parent = SectionItems['Container'];
                            Color = Library.CurrentTheme.Borders.Inline or Rgb(79, 82, 87);
                            Thickness = 1;
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                            LineJoinMode = Enum.LineJoinMode.Miter;
                            BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                        }); Library:Themeify(SectionItems['ContainerInline'], 'Color', {'Borders', 'Inline'});

                        Library:Create('UIListLayout', {
                            Parent = SectionItems['Container'];
                            Padding = Dim(0, 6);
                            SortOrder = Enum.SortOrder.LayoutOrder;
                        });

                        Library:Create('UIPadding', {
                            Parent = SectionItems['Container'];
                            PaddingTop = Dim(0, 7);
                            PaddingBottom = Dim(0, 7);

                            PaddingLeft = Dim(0, 7);
                            PaddingRight = Dim(0, 7);
                        })

                        
                        Library:Connect(SectionItems['Button'].MouseButton1Click, function()
                            Section:Show()
                        end);

                        if Index == 1 then
                            SectionItems['Page'].Visible = true;
                            SectionItems['Accent'].Visible = true;
                            SectionItems['ButtonGradient'].Rotation = 90;
                            SectionItems['Text'].TextColor3 = Library.CurrentTheme.Accent;
                        end

                        Library:RegisterThemeCallback(function()
                            if SectionItems['Page'].Visible then
                                SectionItems['Text'].TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93)
                            else
                                SectionItems['Text'].TextColor3 = Library.CurrentTheme.Text.Deselected or Rgb(175, 175, 175)
                            end
                        end)
                    end

                -- Extras
                Library:Connect(SectionItems['Button'].MouseEnter, function()
                    Library:Tween(SectionItems['Text'], { TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93) })
                end)

                Library:Connect(SectionItems['Button'].MouseLeave, function()
                    if SectionItems['Page'].Visible then
                        return
                    end

                    Library:Tween(SectionItems['Text'], { TextColor3 = Library.CurrentTheme.Text.Deselected or Rgb(175, 175, 175) })
                end)

                Cfg.Sections[Index] = SetMetaTbl(Section, Library)
                

            end
            --
            end

            -- Extras

            function Cfg:Show()

            end
            function Cfg:Hide()

            end

            return unpack(Cfg.Sections)
        end

        function Library:Toggle(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'toggle',
                Callback = (params.Callback or params.callback) or function() end,
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'toggle'),
                Enabled = (params.Enabled ~= nil or params.enabled ~= nil) and (params.Enabled or params.enabled) or false,
                Clickable = (params.Clickable ~= nil or params.clickable ~= nil) and (params.Clickable or params.clickable) or true,

                Items = { };
            };

            local Items = Cfg.Items; do
                Items['Toggle'] = Library:Create('TextButton', {
                    Parent = self.Items['Container'];
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 11);
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Text = '';
                });

                Items['Content'] = Library:Create('Frame', {
                    Parent = Items['Toggle'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = Dim2(1, 0, 1, 0);
                    Position = Dim2(0, 0, 0, 0);
                });

                Items['KeybindAnchor'] = Library:Create('Frame', {
                    Parent = Items['Content'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = Dim2(0, 0, 0, 10);
                    AutomaticSize = Enum.AutomaticSize.X;
                    AnchorPoint = Vec2(1, 0.5);
                    Position = Dim2(1, 0, 0.5, 0);
                });

                Items['Holder'] = Library:Create('Frame', {
                    Parent = Items['Content'];
                    Name = "\0";
                    Position = Dim2(0, 0, 0, 1);
                    Size = Dim2(0, 10, 0, 10);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Button'] = Library:Create('TextButton', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Size = Dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Text = '';
                });
                
                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Holder'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'ElementBase'});

                Items['Text'] = Library:Create('TextLabel', {
                    Parent = Items['Content'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 17, 0, -2);
                    AnchorPoint = Vec2(0, 0);
                    Size = Dim2(0, 0, 0, 12);
                    AutomaticSize = Enum.AutomaticSize.X;
                    FontFace = Library.Font;
                    Text = Cfg.Name;
                    TextSize = 12;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'});


                Hover = Library:Create('TextButton', {
                    Parent = Items['Text'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = Dim2FromScale(1, 1);
                    Position = Dim2(0, 0, 0, 0);
                    BorderSizePixel = 0;
                    BorderColor3 = Rgb(0, 0, 0);
                    BackgroundColor3 = Rgb(1, 1, 1);
                    Text = '';
                    AutoButtonColor = false;
                });
            end
            --

            -- Extras
            Library:Connect(Hover.MouseEnter, function()
                if not Cfg.Clickable then
                    return
                end

                Library:Tween(Items['Text'], { TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93) })
            end)

            Library:Connect(Hover.MouseLeave, function()
                if not Cfg.Clickable then
                    return
                end

                Library:Tween(Items['Text'], { TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224) })
            end)

            --

            --

            --Flags[Cfg.Flag] = Cfg.Enabled;

            function Cfg:Set(State, SkipCallback)
                State = not not State

                if Cfg.Enabled == State then
                    return
                end

                Cfg.Enabled = State

                Library:SetFlag(Cfg.Flag, State)

                Items['Gradient'].Color = State
                    and (
                        Library.CurrentTheme.Gradients.ElementActive
                        or ColorSeq({
                            ColorKey(0, Rgb(221, 168, 93)),
                            ColorKey(1, Rgb(121, 92, 51))
                        })
                    )
                    or (
                        Library.CurrentTheme.Gradients.ElementBase
                        or ColorSeq({
                            ColorKey(0, Rgb(45, 48, 55)),
                            ColorKey(1, Rgb(32, 33, 37))
                        })
                    )

                if not SkipCallback then
                    Cfg.Callback(State)
                end
                if Cfg.KeybindObject then
                    Cfg.KeybindObject.Active = Cfg.Enabled
                    if type(Cfg.KeybindObject.Callback) == 'function' then
                        SafeCall(Cfg.KeybindObject.Callback, Cfg.Enabled)
                    end
                end
            end

            Library:RegisterThemeCallback(function()
                if not Items['Gradient'] then
                    return
                end

                Items['Gradient'].Color = Cfg.Enabled
                    and (
                        Library.CurrentTheme.Gradients.ElementActive
                        or ColorSeq({
                            ColorKey(0, Rgb(221, 168, 93)),
                            ColorKey(1, Rgb(121, 92, 51))
                        })
                    )
                    or (
                        Library.CurrentTheme.Gradients.ElementBase
                        or ColorSeq({
                            ColorKey(0, Rgb(45, 48, 55)),
                            ColorKey(1, Rgb(32, 33, 37))
                        })
                    )
            end)

            function Cfg:Toggle()
                Cfg:Set(not Cfg.Enabled);
            end
            
            Library:Connect(Items['Button'].MouseButton1Click, function()
                Cfg:Toggle();
            end)
            
            if Hover and Cfg.Clickable then
                Library:Connect(Hover.MouseButton1Click, function()
                    Cfg:Toggle();
                end)
            end

            Library.Elements[Cfg.Flag] = Cfg
            Cfg:Set(Cfg.Enabled)

            return SetMetaTbl(Cfg, Library)
        end

        function Library:Slider(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'slider',
                Suffix = (params.suffix or params.Suffix) or '%',
                Callback = (params.Callback or params.callback) or function() end,
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, params.Name and Library:Convert(params.Name) or 'slider'),
                Format = (params.Format or params.format) or "Value",

                -- Number Stuff
                Min = (params.Min or params.min) or 0,
                Max = (params.Max or params.max) or 100,
                Decimals = (params.Decimals or params.decimals) or 0,

                Default = (params.Default or params.default) or 0,
                Value = (params.Default or params.default) or 0,

                Increment = (params.Increment or params.increment) or 1,

                -- Override
                Dragging = false;
                Hovering = false;
                
                Items = { };
            };

            local Items = Cfg.Items; do
                Items['Slider'] = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Name = '\0';
                    Color = Rgb(255, 255, 255);
                    Size = Dim2(1, 0, 0, 26);
                    BorderSizePixel = 0;
                    Visible = true;
                    Parent = self.Items['Container'];
                });

                Items['Holder'] = Library:Create('Frame', {
                    BorderColor3 = Rgb(0, 0, 0);
                    AnchorPoint = Vec2(0, 1);
                    Name = "\0";
                    LayoutOrder = 1;
                    Position = Dim2(0, 0, 1, 0);
                    Parent = Items['Slider'];
                    BackgroundTransparency = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                    Size = Dim2(1, 0, 0, 10);
                    BorderSizePixel = 0;
                })

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Holder'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'ElementBase'});
                
                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Text'] = Library:Create("TextLabel", {
                    LayoutOrder = 0;
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items['Slider'];
                    AnchorPoint = Vec2(0, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                    Size = Dim2(1, 0, 0, 12);
                    Position = Dim2(0, 0, 0, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'});

                Library:Create('UIPadding', {
                    Parent = Items['Text'];
                    PaddingLeft = Dim(0, -1);
                    PaddingTop = Dim(0, -4)
                })
                Items['Value'] = Library:Create( "TextLabel" , {
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = "0" .. Cfg.Suffix;
                    Parent = Items['Holder'];
                    AnchorPoint = Vec2(0.5, 0.5);
                    Name = "\0";
                    ZIndex = 2;
                    BackgroundTransparency = 1;
                    Position = Dim2(0.5, 0, 0.5, -1);
                    Size = Dim2(0, 26, 0, 12);
                    BorderSizePixel = 0;
                    TextSize = 12;
                    BackgroundColor3 = Rgb(0, 0, 0);
                }); Library:Themeify(Items['Value'], 'TextColor3', {'Text', 'Main'});

                Items['Fill'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Position = Dim2(0, 1, 0, 1);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(0, 0, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                    ClipsDescendants = true;
                });

                Items['FillGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Fill'];
                    Rotation = 90;
                    Color = Library.CurrentTheme.Gradients.ElementActive or ColorSeq({
                        ColorKey(0, Rgb(221, 168, 93)),
                        ColorKey(1, Rgb(121, 92, 51));
                    });
                }); Library:Themeify(Items['FillGradient'], 'Color', {'Gradients', 'ElementActive'});
                
            end
            --

            --
            function Cfg:Refresh()
                local Percent = (Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min)

                Items.Fill.Size = Dim2(Percent, 0, 1, -2)

                local Fmt = "%." .. Cfg.Decimals .. "f"

                if Cfg.Format:lower() == "value" then
                    Items.Value.Text = StringFmt(Fmt, Cfg.Value) .. Cfg.Suffix

                elseif Cfg.Format:lower() == "value/max" then
                    Items.Value.Text = StringFmt(Fmt .. " / " .. Fmt, Cfg.Value, Cfg.Max) .. Cfg.Suffix

                elseif Cfg.Format:lower() == "value/minmax" then
                    Items.Value.Text = StringFmt(Fmt .. " / " .. Fmt .. " / " .. Fmt, Cfg.Value, Cfg.Min, Cfg.Max) .. Cfg.Suffix

                elseif Cfg.Format:lower() == "percent" then
                    local Value = Percent * 100
                    Items.Value.Text = StringFmt("%.2f%%", Value)
                end
            end

            function Cfg:Set(Value)
                Value = Clamp(Value, Cfg.Min, Cfg.Max)

                if Cfg.Increment > 0 then
                    Value = Round((Value - Cfg.Min) / Cfg.Increment) * Cfg.Increment + Cfg.Min
                end

                Value = tonumber(string.format('%.' .. Cfg.Decimals .. 'f', Value))

                Cfg.Value = Value

                Cfg.Refresh()
                
                Cfg.Callback(Value)
                --Flags[Cfg.Flag] = Value
                --ConfigFlags[self.Flag] = Value
                Library:SetFlag(Cfg.Flag, Value)
            end

            function Cfg:SetPercent(Percent)
                Percent = Clamp(Percent, 0, 1)
                local Value = Cfg.Min + (Cfg.Max - Cfg.Min) * Percent
                Cfg:Set(Value)
            end

            --

            --
            Library:Connect(Items.Holder.InputBegan, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                if Library.ActiveDrag then return end

                Library.ActiveDrag = Items.Holder

                local Percentage = Clamp(
                    (InputService:GetMouseLocation().X - Items.Holder.AbsolutePosition.X)
                    / Items.Holder.AbsoluteSize.X,
                    0,
                    1
                )

                Cfg:SetPercent(Percentage)
            end)

            Library:Connect(InputService.InputChanged, function(Input)
                if Library.ActiveDrag ~= Items.Holder then return end

                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    local Percentage = Clamp(
                        (InputService:GetMouseLocation().X - Items.Holder.AbsolutePosition.X)
                        / Items.Holder.AbsoluteSize.X,
                        0,
                        1
                    )

                    Cfg:SetPercent(Percentage)
                end
            end)

            Library:Connect(InputService.InputEnded, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                if Library.ActiveDrag == Items.Holder then
                    Library.ActiveDrag = nil
                end

            end)

            Cfg:Set(Cfg.Default);

            Library.Elements[Cfg.Flag] = Cfg

            return SetMetaTbl(Cfg, Library)
        end

        function Library:Button(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'button',
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'button'),
                Callback = (params.Callback or params.callback) or function() end,

                Buttons = params.Buttons;
                Items = { };
            };
            if not Cfg.Buttons then
                Cfg.Buttons = {
                    {
                        Name = Cfg.Name or "button",
                        Flag = Cfg.Flag or "button",
                        Callback = Cfg.Callback or function() end
                    }
                }
            end
            local Items = Cfg.Items; do
                Items['Holder'] = Library:Create('Frame', {
                    Parent = self.Items['Container'];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Parent = Items['Holder'];
                    Padding = Dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    VerticalFlex = Enum.UIFlexAlignment.Fill;
                });

                for Index, ButtonCfg in Cfg.Buttons do

                    local ButtonItems = { };

                    ButtonItems['Button'] = Library:Create('TextButton', {
                        Text = "";
                        AutoButtonColor = false;
                        Parent = Items['Holder'];
                        Name = "\0";
                        Size = Dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Rgb(255, 255, 255);
                    });

                    ButtonItems['Outline'] = Library:Create('UIStroke', {
                        Parent = ButtonItems['Button'];
                        Name = "\0";
                        Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                        Thickness = 1;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        LineJoinMode = Enum.LineJoinMode.Miter;
                    }); 
                    
                    Library:Themeify(
                        ButtonItems['Outline'],
                        'Color',
                        {'Borders', 'Outline'}
                    );

                    ButtonItems['Inline'] = Library:Create('UIStroke', {
                        Parent = ButtonItems['Button'];
                        Name = "\0";
                        Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                        Thickness = 1;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        LineJoinMode = Enum.LineJoinMode.Miter;
                        BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                    }); 
                    
                    Library:Themeify(
                        ButtonItems['Inline'],
                        'Color',
                        {'Borders', 'Inline'}
                    );

                    ButtonItems['Gradient'] = Library:Create('UIGradient', {
                        Parent = ButtonItems['Button'];
                        Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                            ColorKey(0, Rgb(45, 48, 55)),
                            ColorKey(1, Rgb(32, 33, 37))
                        });
                        Rotation = 90;
                    }); 
                    
                    Library:Themeify(
                        ButtonItems['Gradient'],
                        'Color',
                        {'Gradients', 'Base'}
                    );

                    ButtonItems['Text'] = Library:Create('TextLabel', {
                        Parent = ButtonItems['Button'];
                        BackgroundTransparency = 1;
                        Size = Dim2(1, 0, 0, 12);
                        FontFace = Library.Font;
                        Position = Dim2(0.5, 0, 0.5, -1);
                        AnchorPoint = Vec2(0.5, 0.5);
                        Text = ButtonCfg.Name or "button";
                        TextSize = 12;
                        TextColor3 = Library.CurrentTheme.Text.Main;
                        BackgroundColor3 = Rgb(255, 255, 255);
                    }); 
                    
                    Library:Themeify(
                        ButtonItems['Text'],
                        'TextColor3',
                        {'Text', 'Main'}
                    );

                    Library:Connect(ButtonItems['Button'].MouseButton1Click, function()

                        Flags[ButtonCfg.Flag or ButtonCfg.Name] = true

                        (ButtonCfg.Callback or function() end)()

                        task.defer(function()
                            Flags[ButtonCfg.Flag or ButtonCfg.Name] = false
                        end)

                    end)

                    Library:Connect(ButtonItems['Button'].MouseEnter, function()
                        Library:Tween(ButtonItems['Text'], {
                            TextColor3 = Library.CurrentTheme.Accent
                        })
                    end)

                    Library:Connect(ButtonItems['Button'].MouseLeave, function()
                        Library:Tween(ButtonItems['Text'], {
                            TextColor3 = Library.CurrentTheme.Text.Main
                        })
                    end)

                    Items[Index] = ButtonItems
                end

            end
            return SetMetaTbl(Cfg, Library)
        end

        
        function Library:Dropdown(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'dropdown',
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'dropdown'),
                Callback = (params.Callback or params.callback) or function() end,
                Options = params.Options or params.options or { "Option1", "Option2", "Option3" },
                MultiSelect = (params.MultiSelect ~= nil or params.multiselect ~= nil) and (params.MultiSelect or params.multiselect) or false,
                Default = params.Default or params.default or nil;

                Open = false,
                Value = nil,
                Selected = {},
                
                OptionInstances = { };
                Items = { };
            };

            local Items = Cfg.Items; do
                Items['Dropdown'] = Library:Create('Frame', {
                    BorderColor3 = Rgb(0, 0, 0);
                    Parent = self.Items['Container'];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    ZIndex = 8888;
                    Size = Dim2(1, 0, 0, 30);
                    BorderSizePixel = 0;
                    --AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Library:Create('UIListLayout', {
                    Parent = Items['Dropdown'];
                    Padding = Dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });

                Library:Create('UIPadding', {
                    Parent = Items['Dropdown'];
                    PaddingTop = Dim(0, -3);
                    PaddingBottom = Dim(0, 3);
                }
                )

                Items['Holder'] = Library:Create('TextButton', {
                    LayoutOrder = 1;
                    Parent = Items['Dropdown'];
                    Name = "\0";
                    AutoButtonColor = false;
                    Text = '';
                    Position = Dim2(0, 0, 0, 27);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 15);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Holder'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'ElementBase'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Icon'] = Library:Create('TextButton', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Size = Dim2(0, 0, 0, 12);
                    BorderSizePixel = 0;
                    Position = Dim2(1, -4, 0, 0);
                    AnchorPoint = Vec2(1, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Text = '+';
                    FontFace = Library.Font;
                    TextSize = 12;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                }); Library:Themeify(Items['Icon'], 'TextColor3', {'Text', 'Main'});

                Items['Text'] = Library:Create('TextLabel', {
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items['Dropdown'];
                    LayoutOrder = 0;
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 12);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = Rgb(255, 255, 255);
                }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'});

                Items['Hover'] = Library:Create('TextButton', {
                    Parent = Items['Text'];
                    Name = "\0";
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AutoButtonColor = false;
                    Text = "";
                    Size = Dim2(0, Items['Text'].TextBounds.X, 1, 0);
                    Position = Dim2(0,0,0,0);
                }) do

                    Items['Hover'].MouseEnter:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Accent
                        })
                    end)

                    Items['Hover'].MouseLeave:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Text.Main
                        })
                    end)
                end

                Library:Create('UIPadding', {
                    Parent = Items['Text'];
                    PaddingLeft = Dim(0, -1);
                });
                
                Items['Value'] = Library:Create('TextLabel', {
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main;
                    BorderColor3 = Rgb(0, 0, 0);
                    Text = "";
                    Parent = Items['Holder'];
                    Name = "\0";
                    AnchorPoint = Vec2(0, 0.5);
                    Size = Dim2(0, 26, 0, 12);
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 4, 0.5, -2);
                    BorderSizePixel = 0;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 12;
                    BackgroundColor3 = Rgb(255, 255, 255);
                }) Library:Themeify(Items['Value'], 'TextColor3', {'Text', 'Main'});

                Items['Container'] = Library:Create('ScrollingFrame', {
                    Visible = false;
                    Parent = Items['Holder'];

                    AnchorPoint = Vec2(0, 0);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;

                    ScrollBarThickness = 0;
                    ScrollBarImageTransparency = 1;

                    ClipsDescendants = true;

                    ZIndex = 9999;

                    Name = "\0";
                    Position = Dim2(0,0,1,4);

                    Size = Dim2(1, 0, 0, 0);

                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255,255,255);
                });

                Library:Create('UISizeConstraint', {
                    Parent = Items['Container'];
                    MaxSize = Vec2(9999, 140);
                });

                Library:Create('UIListLayout', {
                    Parent = Items['Container'];
                    Padding = Dim(0, 2);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    --VerticalFlex = Enum.UIFlexAlignment.Fill;
                });

                Library:Create('UIPadding', {
                    Parent = Items['Container'];
                    PaddingTop = Dim(0, 4);
                    PaddingLeft = Dim(0, 4);
                    PaddingRight = Dim(0, 4);
                    PaddingBottom = Dim(0, 4);
                });

                Items['ContainerGradient'] = Library:Create('UIGradient', {
                    Parent = Items['Container'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = -90;
                }); Library:Themeify(Items['ContainerGradient'], 'Color', {'Gradients', 'ElementBase'});

                Items['ContainerOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['ContainerOutline'], 'Color', {'Borders', 'Outline'});

                Items['ContainerInline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['ContainerInline'], 'Color', {'Borders', 'Inline'});

            end

                local Layout = Items['Container']:FindFirstChildWhichIsA('UIListLayout')

                local MAX_HEIGHT = 140

                local function GetContentHeight()
                    return Layout.AbsoluteContentSize.Y + 8
                end

                local function UpdateDropdown()
                    if not Cfg.Open then
                        return
                    end

                    local Holder = Items['Holder']
                    local Container = Items['Container']

                    local HolderPos = Holder.AbsolutePosition
                    local HolderSize = Holder.AbsoluteSize

                    local Overlay = Library.Extras
                    local OverlayPos = Overlay.AbsolutePosition
                    local OverlaySize = Overlay.AbsoluteSize

                    local RelativeX = HolderPos.X - OverlayPos.X
                    local RelativeY = HolderPos.Y - OverlayPos.Y

                    local ContentHeight = math.clamp(GetContentHeight(), 0, MAX_HEIGHT)

                    local SpaceBelow = OverlaySize.Y - (RelativeY + HolderSize.Y)
                    local OpenUpwards = SpaceBelow < ContentHeight + 10

                    Container.Parent = Overlay

                    Container.Size = Dim2FromOffset(
                        HolderSize.X,
                        ContentHeight
                    )

                    if OpenUpwards then
                        Container.Position = Dim2FromOffset(
                            RelativeX,
                            RelativeY - ContentHeight - 2
                        )
                    else
                        Container.Position = Dim2FromOffset(
                            RelativeX,
                            RelativeY + HolderSize.Y + 2
                        )
                    end

                    Container.CanvasSize = Dim2(0,0,0,GetContentHeight())
                end

                Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateDropdown)

                Items['Holder']:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdateDropdown)
                Items['Holder']:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateDropdown)

                function Cfg:Set(Value, SkipCallback)
                    if Cfg.MultiSelect then
                        Cfg.Selected[Value] = not Cfg.Selected[Value]
                        
                        local Selected = {}

                        for Option, State in next, Cfg.Selected do
                            local Button = Cfg.OptionInstances[Option]

                            if Button then
                                Library:Tween(Button, {
                                    TextColor3 = State
                                        and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                                        or (Library.CurrentTheme.Text.Main or Rgb(214, 217, 224))
                                })
                            end

                            if State then
                                Insert(Selected, Option)
                            end
                        end

                        Items['Value'].Text = #Selected > 0
                            and table.concat(Selected, ", ")
                            or Cfg.Name

                        Library:SetFlag(Cfg.Flag, Cfg.Selected)

                        if not SkipCallback then
                            Cfg.Callback(Selected)
                        end
                    else
                        Cfg.Value = Value

                        for Option, Button in Cfg.OptionInstances do
                            if Button then
                                Library:Tween(Button, {
                                    TextColor3 = Option == Value
                                        and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                                        or (Library.CurrentTheme.Text.Main or Rgb(214, 217, 224))
                                })
                            end
                        end

                        Items['Value'].Text = Value

                        Library:SetFlag(Cfg.Flag, Value)
                        
                        if not SkipCallback then
                            Cfg.Callback(Value)
                            Cfg:Hide()
                        end
                    end
                end
                
                Library.Elements[Cfg.Flag] = Cfg

                function Cfg:Show()
                    Cfg.Open = true

                    Items['Container'].Visible = true
                    Items['Icon'].Text = "-"

                    UpdateDropdown()

                    Library:Tween(Items['Container'], {
                        Size = Dim2FromOffset(
                            Items['Holder'].AbsoluteSize.X,
                            math.clamp(GetContentHeight(), 0, MAX_HEIGHT)
                        )
                    }, TweenInfo.new(
                        0.22,
                        Enum.EasingStyle.Exponential,
                        Enum.EasingDirection.Out
                    ))
                end

                function Cfg:Hide()
                    Cfg.Open = false

                    Items['Icon'].Text = "+"

                    Library:Tween(Items['Container'], {
                        Size = Dim2FromOffset(
                            Items['Holder'].AbsoluteSize.X,
                            0
                        )
                    }, TweenInfo.new(
                        0.18,
                        Enum.EasingStyle.Exponential,
                        Enum.EasingDirection.Out
                    ))

                    task.delay(0.18, function()
                        if not Cfg.Open then
                            Items['Container'].Visible = false
                        end
                    end)
                end

                Items['Holder']:GetPropertyChangedSignal('AbsolutePosition'):Connect(UpdateDropdown)
                Items['Holder']:GetPropertyChangedSignal('AbsoluteSize'):Connect(UpdateDropdown)

                for _, Option in next, Cfg.Options do
                    local Button = Library:Create('TextButton', {
                        Parent = Items['Container'];
                        Size = Dim2(1, 0, 0, 12);
                        BorderSizePixel = 0;
                        AutoButtonColor = false;
                        Text = Option;
                        FontFace = Library.Font;
                        TextSize = 12;
                        ZIndex = 10000;
                        BackgroundTransparency = 1;
                        TextColor3 = Library.CurrentTheme.Text.Main;
                        BackgroundColor3 = Rgb(35,35,35);
                    });

                    Cfg.OptionInstances[Option] = Button
                    
                    Library:Themeify(Button, 'TextColor3', {'Text', 'Main'});

                    Library:Connect(Button.MouseButton1Click, function()
                        Cfg:Set(Option)
                    end)

                    Library:Connect(Button.MouseEnter, function()
                        local Selected = Cfg.MultiSelect and Cfg.Selected[Option]
                            or Cfg.Value == Option

                        if Selected then
                            return
                        end

                        Library:Tween(Button, {
                            TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93)
                        });
                    end)

                    Library:Connect(Button.MouseLeave, function()
                        local Selected = Cfg.MultiSelect and Cfg.Selected[Option]
                            or Cfg.Value == Option

                        Library:Tween(Button, {
                            TextColor3 = Selected
                                and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                                or (Library.CurrentTheme.Text.Main or Rgb(214, 217, 224))
                        });
                    end)
                end


                Library:Connect(Items['Holder'].MouseButton1Click, function()
                    if Cfg.Open then
                        Cfg:Hide()
                    else
                        Cfg:Show()
                    end
                end)

                if Cfg.Default then
                    Cfg:Set(Cfg.Default)
                end

                Library:RegisterThemeCallback(function()
                    for Option, Button in next, Cfg.OptionInstances do
                        if Button then
                            local IsSelected = Cfg.MultiSelect and Cfg.Selected[Option]
                                or Cfg.Value == Option

                            Button.TextColor3 = IsSelected
                                and (Library.CurrentTheme.Accent or Rgb(221, 168, 93))
                                or (Library.CurrentTheme.Text.Main or Rgb(214, 217, 224))
                        end
                    end
                end)

            --

            -- Extras

            function Cfg:Refresh(Options)
                Cfg.Options = Options
                Cfg.OptionInstances = {}

                for _, Child in next, Items['Container']:GetChildren() do
                    if Child:IsA("TextButton") then
                        Child:Destroy()
                    end
                end

                for _, Option in next, Options do
                    local Button = Library:Create('TextButton', {
                        Parent = Items['Container'];
                        Size = Dim2(1, 0, 0, 12);
                        BorderSizePixel = 0;
                        AutoButtonColor = false;
                        Text = Option;
                        FontFace = Library.Font;
                        TextSize = 12;
                        BackgroundTransparency = 1;
                        TextColor3 = Library.CurrentTheme.Text.Main;
                    })

                    Cfg.OptionInstances[Option] = Button

                    Library:Themeify(Button, 'TextColor3', {'Text', 'Main'})

                    Library:Connect(Button.MouseButton1Click, function()
                        Cfg:Set(Option)
                    end)

                    Library:Connect(Button.MouseEnter, function()
                        local Selected = Cfg.MultiSelect and Cfg.Selected[Option]
                            or Cfg.Value == Option

                        if Selected then
                            return
                        end

                        Library:Tween(Button, {
                            TextColor3 = Library.CurrentTheme.Accent
                        })
                    end)

                    Library:Connect(Button.MouseLeave, function()
                        local Selected = Cfg.MultiSelect and Cfg.Selected[Option]
                            or Cfg.Value == Option

                        Library:Tween(Button, {
                            TextColor3 = Selected
                                and Library.CurrentTheme.Accent
                                or Library.CurrentTheme.Text.Main
                        })
                    end)
                end

                UpdateDropdown()
            end
            return SetMetaTbl(Cfg, Library)
        end

        function Library:Keybind(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'keybind',
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'keybind'),
                Callback = (params.Callback or params.callback) or function() end,
                Key = (params.Key or params.key) or Enum.KeyCode.Unknown,
                Mode = (params.Mode or params.mode) or "Hold",

                -->
                BindedToToggle = false;
                ToggleObject = nil;
                -->

                Listening = false;
                Active = false;

                Items = { };
            };
            
            if self.Items and self.Items.Content then
                Cfg.BindedToToggle = true
                Cfg.ToggleObject = selfs
                self.KeybindObject = Cfg
            end

            local Parent = Cfg.BindedToToggle
                and self.Items.Content
                or self.Items.Container

            local Items = Cfg.Items; do

                Items['Holder'] = Library:Create('Frame', {
                    Parent = Parent;
                    Name = "\0";
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255,255,255);
                    Size = Dim2FromOffset(0, 12);
                    AnchorPoint = Vec2(1, 0);
                    Position = Dim2(1, 0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                });

                if not Cfg.BindedToToggle then

                    Items['Container'] = Library:Create('Frame', {
                        Parent = self.Items['Container'];
                        Name = "\0";
                        BorderSizePixel = 0;
                        BackgroundColor3 = Rgb(255,255,255);
                        Size = Dim2(1, 0, 0, 13);
                        BackgroundTransparency = 1;
                        Position = Dim2(0, 0, 0, 0);
                    });

                    Items['Holder'].Parent = Items['Container'];
                    
                    Items['Text'] = Library:Create('TextLabel', {
                        Parent = Items['Container'];
                        BackgroundTransparency = 1;
                        Size = Dim2(0, 0, 0, 12);
                        FontFace = Library.Font;
                        Position = Dim2(0, -1, 0, 0);
                        AnchorPoint = Vec2(0, 0);
                        Text = Cfg.Name;
                        TextSize = 12;
                        TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                        BackgroundColor3 = Rgb(255, 255, 255);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        Visible = not Cfg.BindedToToggle;
                    }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'});
                    
                    Items['Hover'] = Library:Create('TextButton', {
                        Parent = Items['Text'];
                        Name = "\0";
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        AutoButtonColor = false;
                        Text = "";
                        Size = Dim2(0, Items['Text'].TextBounds.X, 1, 0); -- match text width
                        Position = Dim2(0,0,0,0);
                    });
                    --

                    -- Extras


                    Items['Hover'].MouseEnter:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93)
                        });
                    end)

                    Items['Hover'].MouseLeave:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224)
                        });
                    end)

                end

                Items['Padding'] = Library:Create('UIPadding', {
                    Parent = Items['Holder'],
                    PaddingLeft = Dim(0, 5),
                    PaddingRight = Dim(0, 4)
                })

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Holder'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(45, 48, 55)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'});

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Holder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Items['Button'] = Library:Create('TextButton', {
                    Parent = Items['Holder'];
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                    Text = Cfg.Key.Name;
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.X;
                    Size = Dim2(0, 0, 1, 0);
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    Position = Dim2(0.5, 0, 0.5, 0);
                    AnchorPoint = Vec2(0.5, 0.5);
                    TextSize = 12;
                    BorderSizePixel = 0;
                }); 

                Library:Create('UIPadding', {
                    Parent = Items['Button'];
                    PaddingBottom = Dim(0,2);
                });
                
            end 

            local function ToggleToggle(Toggle)
                Cfg.Active = Toggle;

                if Cfg.BindedToToggle and Cfg.ToggleObject and Cfg.ToggleObject.Set then
                    Cfg.ToggleObject:Set(Toggle)
                end

                Cfg.Callback(Toggle);
            end
            
            function Cfg:GetKey(v)
                v = v or Cfg.Key
                return Keys[v] or v.Name
            end

            function Cfg:Update()
                local Text = Cfg.Listening and "..." or Cfg:GetKey(Cfg.Key)

                Items.Button.Text = Text

                task.wait()

                local Size = Items.Button.TextBounds.X
                local Padding = Clamp(Floor(Size * 0.5), 3, 8)

                Items.Padding.PaddingLeft = Dim(0, Padding)
                Items.Padding.PaddingRight = Dim(0, Padding)
            end

            function Cfg:Set(Key, SkipCallback)
                if typeof(Key) == "string" then
                    Key = Enum.KeyCode[Key] or Enum.KeyCode.Unknown
                elseif typeof(Key) == "table" and Key.Name then
                    Key = Enum.KeyCode[Key.Name] or Enum.KeyCode.Unknown
                end

                Key = Key or Enum.KeyCode.Unknown

                Cfg.Key = Key

                Library:SetFlag(Cfg.Flag, Key)

                Cfg:Update()

                if not SkipCallback then
                    Cfg.Callback(Key)
                end
            end

            Library:Connect(Items.Button.MouseButton1Click, function()
                if Cfg.Listening then
                    return
                end

                Cfg.Listening = true;
                Cfg:Update();

                local Connection;
                Connection = Library:Connect(InputService.InputBegan, function(Input, GameProcessed)
                    if GameProcessed then
                        return
                    end

                    if Input.UserInputType ~= Enum.UserInputType.Keyboard then
                        return
                    end

                    Cfg.Key = Input.KeyCode;
                    --Library.Flags[Cfg.Flag] = Cfg.Key;
                    Library:SetFlag(Cfg.Flag, Cfg.Key)

                    Cfg.Listening = false
                    Cfg:Update()

                    Connection:Disconnect();
                end)
            end)

            Library:Connect(InputService.InputBegan, function(Input, GameProcessed)
                if GameProcessed then
                    return
                end

                local Pressed = Input.KeyCode;

                if Pressed ~= Cfg.Key then
                    return
                end

                if Cfg.Mode == "Hold" then
                    ToggleToggle(true);

                elseif Cfg.Mode == "Toggle" then
                    ToggleToggle(not Cfg.Active);

                elseif Cfg.Mode == "Always" then
                    ToggleToggle(true);
                end
            end)

            Library:Connect(InputService.InputEnded, function(Input, GameProcessed)
                if GameProcessed then
                    return
                end

                if Input.KeyCode ~= Cfg.Key then
                    return
                end

                if Cfg.Mode == "Hold" then
                    ToggleToggle(false);
                end
            end)

            Cfg:Set(Cfg.Key)
            Library.Elements[Cfg.Flag] = Cfg

            --

            -- Extras
            return SetMetaTbl(Cfg, Library)
        end

        function Library:Colorpicker(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'colorpicker',
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'colorpicker'),

                Callback = (params.Callback or params.callback) or function() end,

                Default = params.Default or params.default or Rgb(255,255,255),

                Transparency = params.Transparency or params.transparency or false,
                Alpha = params.Alpha or params.alpha or 1,

                Rainbow = params.Rainbow or params.rainbow or false,

                Open = false,

                Color = nil,
                Value = nil,

                Items = {},
                --
                BindedToToggle = false;
                ToggleObject = nil;
                --
                Editable = params.Editable ~= false,
                CopyOnClick = params.CopyOnClick or false,
                Connections = {};
            };
            
            if self.Items and self.Items.Content then
                Cfg.BindedToToggle = true
                Cfg.ToggleObject = self
            end

            local Parent = Cfg.BindedToToggle
                and self.Items.Content
                or self.Items.Container

            local Items = Cfg.Items; do

                Items['Colorpicker'] = Library:Create('Frame', {
                    Parent = Parent;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = Dim2(1, 0, 0, 12);
                    ZIndex = 1;
                });

                if not Cfg.BindedToToggle then

                    Items['Container'] = Library:Create('Frame', {
                        Parent = self.Items['Container'];
                        Name = "\0";
                        BorderSizePixel = 0;
                        BackgroundColor3 = Rgb(255,255,255);
                        Size = Dim2(1, 0, 0, 13);
                        BackgroundTransparency = 1;
                        Position = Dim2(0, 0, 0, 0);
                    });

                    Items['Colorpicker'].Parent = Items['Container'];
                    
                    Items['Text'] = Library:Create('TextLabel', {
                        Parent = Items['Container'];
                        BackgroundTransparency = 1;
                        Size = Dim2(0, 0, 0, 12);
                        FontFace = Library.Font;
                        Position = Dim2(0, -1, 0, 0);
                        AnchorPoint = Vec2(0, 0);
                        Text = Cfg.Name;
                        TextSize = 12;
                        TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224);
                        BackgroundColor3 = Rgb(255, 255, 255);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        Visible = not Cfg.BindedToToggle;
                    }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'});
                    
                    Items['Hover'] = Library:Create('TextButton', {
                        Parent = Items['Text']; -- inside text label
                        Name = "\0";
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        AutoButtonColor = false;
                        Text = "";
                        Size = Dim2(0, Items['Text'].TextBounds.X, 1, 0); -- match text width
                        Position = Dim2(0,0,0,0);
                    });
                    --

                    -- Extras


                    Items['Hover'].MouseEnter:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Accent or Rgb(221, 168, 93)
                        });
                    end)

                    Items['Hover'].MouseLeave:Connect(function()
                        Library:Tween(Items['Text'], {
                            TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214, 217, 224)
                        });
                    end)

                end

                Items['Bind'] = Library:Create('TextButton', {
                    Parent = Items['Colorpicker'];
                    Name = "\0";
                    Text = "";
                    AnchorPoint = Vec2(1, 0.5),
                    Position = Dim2(1,0, 0.5, 0),
                    BorderColor3 = Rgb(0, 0, 0);
                    ZIndex = 2;
                    Size = Dim2(0, 22, 0, 11);
                    AutoButtonColor = false;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Bind'];
                    Color =  ColorSeq({
                        ColorKey(0, Cfg.Default or Rgb(255, 0, 0)),
                        ColorKey(1, Rgb(32, 33, 37))
                    });
                    Rotation = 90;
                });
                
                Library:RegisterThemeCallback(function()
                    if Items['Gradient'] and Items['Bind'] and Items['Bind'].Parent then
                        Items['Gradient'].Color = ColorSeq({
                            ColorKey(0, Cfg.Color or Cfg.Default or Rgb(255, 0, 0)),
                            ColorKey(1, Library.CurrentTheme.Background or Rgb(32, 33, 37))
                        });
                    end
                end);

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Bind'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Bind'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'});

                Library.Elements[Cfg.Flag] = Cfg

            end
            --

            -- Funcs

            Cfg.Keypicker = Library:Keypicker({
                Default = Cfg.Default,
                Callback = Cfg.Callback,

                Editable = Cfg.Editable,
                CopyOnClick = Cfg.CopyOnClick,

                Rainbow = Cfg.Rainbow
            });

            --

            -- Extras
            local Picker = Cfg.Keypicker

            Picker.Colorpicker = Cfg

            Picker.Callback = function(Color, Alpha)
                Cfg:Set(Color, Alpha)
            end

            function Cfg:Set(Color, Alpha)
                self.Color = Color
                self.Value = Color
                self.Alpha = Alpha or self.Alpha

                self.Items['Gradient'].Color = ColorSeq({
                    ColorKey(0, Color),
                    ColorKey(1, Library.CurrentTheme.Background or Rgb(32, 33, 37))
                })

                if typeof(Color) == "Color3" then
                    self.Callback(Color, self.Alpha)
                end
                                
                if self.Flag then
                    ConfigFlags[self.Flag] = Color
                    Flags[self.Flag] = Color
                end
            end

            function Cfg:UpdatePickerPosition()
                local Picker = self.Keypicker.Items['Picker']
                local Bind = self.Items['Bind']
                
                local PickerSize = Picker.AbsoluteSize
                local BindPos = Bind.AbsolutePosition
                local BindSize = Bind.AbsoluteSize

                local PickerX = BindPos.X + BindSize.X + 6;
                local PickerY = BindPos.Y + BindSize.Y + 6;

                Picker.Position = Dim2FromOffset(PickerX, PickerY)
            end

            function Cfg:OpenPicker()
                local Picker = self.Keypicker.Items['Picker']

                self.Open = not self.Open

                Picker.Visible = self.Open

                if self.Open then
                    self:UpdatePickerPosition()

                    self.Keypicker:SetColor(
                        self.Color or self.Default,
                        self.Alpha
                    )
                end
            end

            Cfg.Keypicker.Callback = function(Color, Alpha)
                Cfg:Set(Color, Alpha)
            end

            Cfg.Items['Bind'].MouseButton1Click:Connect(function()
                Cfg:OpenPicker()
            end)

            Cfg.Items['Bind']:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                if Cfg.Open then
                    Cfg:UpdatePickerPosition()
                end
            end)

            Cfg.Items['Bind']:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
                if Cfg.Open then
                    Cfg:UpdatePickerPosition()
                end
            end)

            InputService.InputBegan:Connect(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                if not Cfg.Open then
                    return
                end

            end)

            Cfg:Set(Cfg.Default, Cfg.Alpha)

            return SetMetaTbl(Cfg, Library)
        end

        function Library:Separator(params)
            local Cfg = {
                Name = (params.Name or params.name) or '',
                Items = {},
            }

            local Items = Cfg.Items; do

                Items['Holder'] = Library:Create('Frame', {
                    Parent           = self.Items['Container'];
                    Name             = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    Size             = Dim2(1, 0, 0, 2);
                });
                
                Items['Separator'] = Library:Create('Frame', {
                    AnchorPoint = Vec2(0.5, 0.5);
                    Parent = Items['Holder'];
                    Name = "\0";
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BorderColor3 = Rgb(0, 0, 0);
                    Size = Dim2(1, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                })

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent          = Items['Separator'],
                    Name            = "\0",
                    Color           = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0),
                    Thickness       = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode    = Enum.LineJoinMode.Miter,
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'})

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent               = Items['Separator'],
                    Name                 = "\0",
                    Color                = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0),
                    Thickness            = 1,
                    ApplyStrokeMode      = Enum.ApplyStrokeMode.Border,
                    LineJoinMode         = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'})

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent   = Items['Separator'],
                    Color    = Library.CurrentTheme.Gradients.Base or ColorSeq({ ColorKey(0, Rgb(45, 48, 55)), ColorKey(1, Rgb(32, 33, 37)) }),
                    Rotation = 90,
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'})

                if Cfg.Name ~= '' then
                    Items['Holder'].Size = Dim2(1, 0, 0, 7)
                    
                    Items['Text'] = Library:Create('TextLabel', {
                        FontFace = Library.Font;
                        TextColor3 = Themes.Preset.Text.Main;
                        BorderColor3 = Rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Parent = Items['Holder'];
                        Position = Dim2(0.5, 0, 0, 0);
                        AnchorPoint = Vec2(0.5, 0);
                        Size = Dim2(0, 0, 0, 12);
                        Name = "\0";
                        TextXAlignment = Enum.TextXAlignment.Center;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 12;
                        BackgroundColor3 = Themes.Preset.Background;
                    }); Library:Themeify(Items['Text'], 'TextColor3', {'Text', 'Main'}); Library:Themeify(Items['Text'], 'BackgroundColor3', {'Background'})
                    
                    Library:Create('UIPadding', {
                        Parent = Items['Text'];
                        PaddingLeft = Dim(0, 6);
                        PaddingBottom = Dim(0, 8);
                        PaddingRight = Dim(0, 6);
                    });
                end
            end

            return SetMetaTbl(Cfg, Library)
        end

        function Library:Textbox(params)
            local Cfg = {
                Name = (params.Name or params.name) or 'textbox',
                Flag = (params.Flag or params.flag) or Library:MakeFlag(self, 'textbox'),
                Callback = (params.Callback or params.callback) or function() end,
                Default = params.Default or params.default or "",
                Placeholder = params.Placeholder or params.placeholder or "Type here...",
                Items = { };
            }

            local Items = Cfg.Items; do
                Items['Textbox'] = Library:Create('Frame', {
                    Parent = self.Items['Container'];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Size = Dim2(1, 0, 0, 32);
                });

                Items['Holder'] = Library:Create('TextButton', {
                    Parent = Items['Textbox'];
                    Name = "\0";
                    BackgroundColor3 = Rgb(255,255,255);
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    Text = "";
                    BackgroundTransparency = 1;
                    Size = Dim2(1,0,1,0);
                });

                Items['Text'] = Library:Create('TextLabel', {
                    Parent = Items['Textbox'];
                    FontFace = Library.Font;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214,217,224);
                    Text = Cfg.Name;
                    Size = Dim2(1, 0, 0, 12);
                    BackgroundTransparency = 1;
                    Position = Dim2(0, 0, 0, -3);
                    AnchorPoint = Vec2(0, 0);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 12;
                    Name = "\0";
                }); Library:Themeify(Items['Text'], 'TextColor3', {'Text','Main'});

                Library:Create('UIPadding', {
                    Parent = Items['Text'];
                    PaddingLeft = Dim(0, -1);
                });

                Items['Hover'] = Library:Create('TextButton', {
                    Parent = Items['Text'];
                    Name = "\0";
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255,255,255);
                    Size = Dim2(0, Items['Text'].TextBounds.X, 1, 0);
                    Position = Dim2(0,0,0,0);
                    AutoButtonColor = false;
                    BackgroundTransparency = 1;
                    Text = "";
                });
                
                Items['InputBackground'] = Library:Create('Frame', {
                    Parent = Items['Holder'];
                    Size = Dim2(1,0,0,16);
                    BackgroundTransparency = 0;
                    BorderSizePixel = 0;
                    Position = Dim2(0, 0, 1, -1); 
                    AnchorPoint = Vec2(0,1);
                    BackgroundColor3 = Rgb(255, 255, 255);
                });

                Items['Input'] = Library:Create('TextBox', {
                    Parent = Items['InputBackground'];
                    BackgroundTransparency = 1;
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214,217,224);
                    FontFace = Library.Font;
                    TextSize = 12;
                    Text = Cfg.Default;
                    PlaceholderText = Cfg.Placeholder;
                    PlaceholderColor3 = Library.CurrentTheme.Text.Main;
                    Size = Dim2(1,-2, 1,-2);
                    Position = Dim2(0,0,0,0);
                    BackgroundColor = Rgb(1, 1, 1);
                    ClearTextOnFocus = false;
                    TextXAlignment = Enum.TextXAlignment.Left;
                }); Library:Themeify(Items['Input'], 'TextColor3', {'Text','Main'});
                Library:Themeify(Items['Input'], 'PlaceholderColor3', {'Text','Main'});

                Library:Create('UIPadding', {
                    Parent = Items['Input'];
                    PaddingLeft = Dim(0, 4);
                })

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['InputBackground'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(45,48,55)),
                        ColorKey(1, Rgb(32,33,37))
                    });
                    Rotation = 90;
                }); Library:Themeify(Items['Gradient'], 'Color', {'Gradients','ElementBase'});

                                
                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['InputBackground'];
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0,0,0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                }); Library:Themeify(Items['Outline'], 'Color', {'Borders','Outline'});

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['InputBackground'];
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0,0,0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }); Library:Themeify(Items['Inline'], 'Color', {'Borders','Inline'});
            end
            --

            -- Extras
            Items['Input'].Focused:Connect(function()
                Library.ActiveDrag = nil;
                Library.InputFocused = true
            end)

            Items['Input'].FocusLost:Connect(function(Enter)
                Library.InputFocused = false
                Library:SetFlag(Cfg.Flag, Items['Input'].Text)
                Library.Elements[Cfg.Flag] = Cfg
                if Enter then
                    Cfg.Callback(Items['Input'].Text);
                end
            end)

            Items['Hover'].MouseEnter:Connect(function()
                Library:Tween(Items['Text'], {
                    TextColor3 = Library.CurrentTheme.Accent or Rgb(221,168,93)
                });
            end)

            Items['Hover'].MouseLeave:Connect(function()
                Library:Tween(Items['Text'], {
                    TextColor3 = Library.CurrentTheme.Text.Main or Rgb(214,217,224)
                });
            end)

            function Cfg:Set(Value)
                Items['Input'].Text = tostring(Value)
                Library:SetFlag(Cfg.Flag, Items['Input'].Text)
                Cfg.Callback(Items['Input'].Text)
            end

            Library.Elements[Cfg.Flag] = Cfg

            return SetMetaTbl(Cfg, Library)
        end

        function Library:KeybindList(params)
            params = params or {}

            local Cfg = {
                Items = {},
                EntryInstances = {},
            }

            local Items = Cfg.Items do

                Items['Container'] = Library:Create('Frame', {
                    Parent = Library.Extras;
                    Name = "\0";
                    Position = Dim2(0, 200, 0, 300);
                    Size = Dim2(0, 180, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                })

                Items['Gradient'] = Library:Create('UIGradient', {
                    Parent = Items['Container'];
                    Color = Library.CurrentTheme.Gradients.Base or ColorSeq({
                        ColorKey(0, Rgb(40, 45, 56)),
                        ColorKey(1, Rgb(24, 27, 35)),
                    });
                    Rotation = 90;
                }) Library:Themeify(Items['Gradient'], 'Color', {'Gradients', 'Base'})

                Items['Outline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                }) Library:Themeify(Items['Outline'], 'Color', {'Borders', 'Outline'})

                Items['Inline'] = Library:Create('UIStroke', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }) Library:Themeify(Items['Inline'], 'Color', {'Borders', 'Inline'})

                Items['Inner'] = Library:Create('Frame', {
                    Parent = Items['Container'];
                    Name = "\0";
                    Position = Dim2(0, 4, 0, 4);
                    Size = Dim2(1, -8, 1, -8);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Background;
                }) Library:Themeify(Items['Inner'], 'BackgroundColor3', {'Background'})

                Items['InnerOutline'] = Library:Create('UIStroke', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                }) Library:Themeify(Items['InnerOutline'], 'Color', {'Borders', 'Inline'})

                Items['Accent'] = Library:Create('Frame', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = Library.CurrentTheme.Accent;
                }) Library:Themeify(Items['Accent'], 'BackgroundColor3', {'Accent'})

                Items['TitleHolder'] = Library:Create('Frame', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 18);
                    Position = Dim2(0, 0, 0, 2);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                })

                Items['Title'] = Library:Create('TextLabel', {
                    Parent = Items['TitleHolder'];
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 12);
                    AnchorPoint = Vec2(0.5, 0.5);
                    Position = Dim2(0.5, 0, 0.5, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = 'Keybind List';
                    TextSize = 12;
                    TextColor3 = Library.CurrentTheme.Accent;
                    TextXAlignment = Enum.TextXAlignment.Center;
                }) Library:Themeify(Items['Title'], 'TextColor3', {'Accent'})

                Items['EntriesHolder'] = Library:Create('Frame', {
                    Parent = Items['Inner'];
                    Name = "\0";
                    Position = Dim2(0, 0, 0, 20);
                    Size = Dim2(1, 0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                })

                Library:Create('UIListLayout', {
                    Parent = Items['EntriesHolder'];
                    Padding = Dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })

                Library:Create('UIPadding', {
                    Parent = Items['EntriesHolder'];
                    PaddingLeft = Dim(0, 6);
                    PaddingRight = Dim(0, 6);
                    PaddingBottom = Dim(0, 6);
                })

            end

            Library:Draggify(Items['Container'])

            Library.KeybindListInstance = Cfg

            function Cfg:AddEntry(KeybindCfg)
                local EntryItems = {}

                EntryItems['Row'] = Library:Create('Frame', {
                    Parent = Items['EntriesHolder'];
                    Name = "\0";
                    Size = Dim2(1, 0, 0, 12);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                })

                Library:Create('UIListLayout', {
                    Parent = EntryItems['Row'];
                    FillDirection = Enum.FillDirection.Horizontal;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                    Padding = Dim(0, 3);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })

                EntryItems['Arrow'] = Library:Create('TextLabel', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 6, 0, 12);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = '>';
                    TextSize = 12;
                    LayoutOrder = 0;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextColor3 = KeybindCfg.Active
                        and Library.CurrentTheme.Accent
                        or Library.CurrentTheme.Text.Unselected;
                })

                EntryItems['Name'] = Library:Create('TextLabel', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 0, 0, 12);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = KeybindCfg.Name;
                    TextSize = 12;
                    LayoutOrder = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextColor3 = KeybindCfg.Active
                        and Library.CurrentTheme.Accent
                        or Library.CurrentTheme.Text.Unselected;
                })

                EntryItems['Sep1'] = Library:Create('TextLabel', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 4, 0, 12);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = '|';
                    TextSize = 12;
                    LayoutOrder = 2;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextColor3 = Library.CurrentTheme.Text.Unselected;
                }) Library:Themeify(EntryItems['Sep1'], 'TextColor3', {'Text', 'Unselected'})

                EntryItems['KeyHolder'] = Library:Create('Frame', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 0, 0, 12);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BorderSizePixel = 0;
                    BackgroundColor3 = Rgb(255, 255, 255);
                    LayoutOrder = 3;
                })

                Library:Create('UIGradient', {
                    Parent = EntryItems['KeyHolder'];
                    Color = Library.CurrentTheme.Gradients.ElementBase or ColorSeq({
                        ColorKey(0, Rgb(52, 58, 72)),
                        ColorKey(1, Rgb(31, 35, 44)),
                    });
                    Rotation = 90;
                })

                Library:Create('UIStroke', {
                    Parent = EntryItems['KeyHolder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Outline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                })

                Library:Create('UIStroke', {
                    Parent = EntryItems['KeyHolder'];
                    Name = "\0";
                    Color = Library.CurrentTheme.Borders.Inline or Rgb(0, 0, 0);
                    Thickness = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    BorderStrokePosition = Enum.BorderStrokePosition.Inner;
                })

                Library:Create('UIPadding', {
                    Parent = EntryItems['KeyHolder'];
                    PaddingLeft = Dim(0, 3);
                    PaddingRight = Dim(0, 3);
                })

                EntryItems['KeyLabel'] = Library:Create('TextLabel', {
                    Parent = EntryItems['KeyHolder'];
                    Name = "\0";
                    Size = Dim2(0, 0, 1, 0);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = '[' .. (KeybindCfg:GetKey(KeybindCfg.Key) or 'NONE') .. ']';
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextColor3 = Library.CurrentTheme.Text.Unselected;
                }) Library:Themeify(EntryItems['KeyLabel'], 'TextColor3', {'Text', 'Unselected'})

                EntryItems['Sep2'] = Library:Create('TextLabel', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 4, 0, 12);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = '|';
                    TextSize = 12;
                    LayoutOrder = 4;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextColor3 = Library.CurrentTheme.Text.Unselected;
                }) Library:Themeify(EntryItems['Sep2'], 'TextColor3', {'Text', 'Unselected'})

                EntryItems['Mode'] = Library:Create('TextLabel', {
                    Parent = EntryItems['Row'];
                    Name = "\0";
                    Size = Dim2(0, 0, 0, 12);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    FontFace = Library.Font;
                    Text = '(' .. (KeybindCfg.Mode or 'Toggle'):lower() .. ')';
                    TextSize = 12;
                    LayoutOrder = 5;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextColor3 = Library.CurrentTheme.Text.Unselected;
                }) Library:Themeify(EntryItems['Mode'], 'TextColor3', {'Text', 'Unselected'})

                local function UpdateColors()
                    local IsActive = KeybindCfg.Active
                    local AccentColor = Library.CurrentTheme.Accent
                    local UnselectedColor = Library.CurrentTheme.Text.Unselected

                    local TargetColor = IsActive and AccentColor or UnselectedColor

                    Library:Tween(EntryItems['Arrow'], { TextColor3 = TargetColor })
                    Library:Tween(EntryItems['Name'], { TextColor3 = TargetColor })
                end

                local function UpdateKey()
                    EntryItems['KeyLabel'].Text = '[' .. (KeybindCfg:GetKey(KeybindCfg.Key) or 'NONE') .. ']'
                end

                Insert(Cfg.EntryInstances, {
                    KeybindCfg = KeybindCfg,
                    EntryItems = EntryItems,
                    UpdateColors = UpdateColors,
                    UpdateKey = UpdateKey,
                })

                Library:RegisterThemeCallback(function()
                    UpdateColors()
                end)

                Library:Connect(RunService.Heartbeat, function()
                    UpdateColors()
                    UpdateKey()
                end)

                return EntryItems
            end

            return SetMetaTbl(Cfg, Library)
        end
    --
    local Window = Library:Window({
        Name = "Home",
        Size = Dim2(0, 510, 0, 550)
    })

    local Combat = Window:Tab({Name = "combat"})
    local Visuals = Window:Tab({Name = "visual"})
    local Misc = Window:Tab({Name = "miscellaneous"})
    local Skins = Window:Tab({Name = "skins"})
    local Theme = Window:Tab({Name = "theme"})

    local function Cb(Name)
        return function(v)
            print(Name, v)
        end
    end

    local function Toggle(Sec, Name, Func)
        return Sec:Toggle({
            Name = Name,
            Callback = Func or Cb(Name)
        })
    end

    local function Slider(Sec, Name, Min, Max, Default, Suffix)
        return Sec:Slider({
            Name = Name,
            Min = Min,
            Max = Max,
            Default = Default,
            Suffix = Suffix or "",
            Callback = Cb(Name)
        })
    end

    local Aimbot = Combat:Section({Name = "aimbot", Side = "left"})
    local Silent = Combat:Section({Name = "silent aim", Side = "right"})
    local Trigger = Combat:Section({Name = "triggerbot", Side = "left"})
    local AntiAim = Combat:Section({Name = "anti-aim", Side = "right"})

    local Bot = Toggle(Aimbot, "enabled")
    Bot:Keybind({
        Name = 'Aimbot Bind',
        Key = Enum.KeyCode.E,
        Mode = 'Toggle';
    });

    Aimbot:Separator({});
    Aimbot:Separator({Name = "separator"});

    Silent:Textbox({
        Name = "Username",
        Flag = "username",
        Default = "Player123",
        Placeholder = "Enter your username...",
        Callback = function(value)
            print("Textbox value:", value)
        end
    })
    Library:Dock({
        Buttons = {
            {
                Icon = "rbxassetid://111911305350051",
                Toggle = true,
                Default = true,

                Callback = function(State)
                    Window:Visible(State)
                end
            },

            {
                Icon = "rbxassetid://111911305350051",

                Callback = function()
                    print("clicked")
                end
            },

            {
                Icon = "rbxassetid://111911305350051",
                Toggle = true,

                Callback = function(State)
                    Blur.Enabled = State
                end
            },

            
            {
                Icon = "rbxassetid://111911305350051",
                Toggle = true,

                Callback = function(State)
                    Blur.Enabled = State
                end
            }
        }
    })
    --[[
        Can Be inside Toggle or Section (self);
    ]]

    Aimbot:Keybind({
        Name = 'Keybind',
        Key = Enum.KeyCode.E,
        Mode = 'Hold',

        Callback = function()
            print('Active Held')
        end
    })

    Aimbot:Dropdown({
        Name = "target selection",
        Options = {"closest to crosshair", "closest to player", "lowest health", "highest threat"},
        Callback = Cb("target selection"),
        Default = "closest to crosshair"

    })

    Aimbot:Button({
        Buttons = {
            {
                Name = "add friend",
                Callback = function()
                    print("friend added")
                end
            },
            {
                Name = "remove friend",
                Callback = function()
                    print("friend removed")
                end
            }, 
            {
                Name = "clear friends",
                Callback = function()
                    print("friends cleared")
                end;
            }
        },
        Count = 3;
    })

    local Test = Toggle(Aimbot, "visible fov")
    Aimbot:Colorpicker({
        Name = 'picker',
        Default = Rgb(255, 0, 0),
        Callback = function(color)
            print("Color selected:", color)
        end,
        Flag = "fov color";
    })
    Test:Colorpicker({
        Name = 'picker',
        Default = Rgb(255, 0, 0),
        Callback = function(color)
            print("Color selected:", color)
        end,
        Flag = "fov color";
    })
    Toggle(Aimbot, "smoothing")
    Toggle(Aimbot, "prediction")
    Toggle(Aimbot, "visibility check")

    Slider(Aimbot, "fov", 0, 180, 90, "°")
    Slider(Aimbot, "smoothness", 0, 100, 50, "%")

    Toggle(Silent, "enabled")
    Toggle(Silent, "wall check")
    Toggle(Silent, "team check")

    Slider(Silent, "distance", 0, 500, 100, "m")
    Slider(Silent, "hit chance", 0, 100, 75, "%")

    Toggle(Trigger, "enabled")
    Toggle(Trigger, "magnet")
    Toggle(Trigger, "burst fire")

    Slider(Trigger, "delay", 0, 500, 50, "ms")

    Toggle(AntiAim, "enabled")
    Toggle(AntiAim, "jitter")
    Toggle(AntiAim, "fake lag")

    Slider(AntiAim, "spin speed", 0, 100, 25, "°/s")

    local ESP = Visuals:Section({Name = "esp", Side = "left"})
    local Glow = Visuals:Section({Name = "glow", Side = "right"})
    local Chams = Visuals:Section({Name = "chams", Side = "left"})
    local World = Visuals:Section({Name = "world", Side = "right"})

    Toggle(ESP, "enabled")
    Toggle(ESP, "boxes")
    Toggle(ESP, "names")
    Toggle(ESP, "skeletons")

    Slider(ESP, "distance", 0, 1000, 500, "m")

    Toggle(Glow, "enabled")
    Slider(Glow, "brightness", 0, 100, 50, "%")

    Toggle(Chams, "enabled")
    Toggle(Chams, "visible only")
    Toggle(Chams, "through walls")

    Slider(Chams, "transparency", 0, 100, 75, "%")

    Toggle(World, "ambient lighting")
    Toggle(World, "fog remover")
    Toggle(World, "time changer")

    local General = Misc:Section({Name = "general", Side = "left"})
    local Perf = Misc:Section({Name = "performance", Side = "right"})
    local Move = Misc:Section({Name = "movement", Side = "left"})
    local Util = Misc:Section({Name = "utilities", Side = "right"})

    Toggle(General, "auto unload")

    Toggle(Perf, "benchmark mode")
    Slider(Perf, "fps cap", 30, 240, 60, "fps")

    Toggle(Move, "bunny hop")
    Toggle(Move, "auto strafe")
    Toggle(Move, "no clip")

    Slider(Move, "speed multiplier", 1, 5, 1, "x")

    Toggle(Util, "chat spam")
    Toggle(Util, "auto accept")
    Toggle(Util, "spectator list")

    Slider(Util, "spam delay", 1, 10, 3, "s")

    local Knife = Skins:Section({Name = "knife", Side = "left"})
    local Gloves = Skins:Section({Name = "gloves", Side = "right"})
    local Weapons = Skins:Section({Name = "weapons", Side = "left"})
    local Agents = Skins:Section({Name = "agents", Side = "right"})

    Toggle(Knife, "custom knife")
    Toggle(Knife, "knife animations")

    Slider(Knife, "knife skin", 1, 100, 1)

    Toggle(Gloves, "custom gloves")
    Toggle(Gloves, "glove animations")

    Slider(Gloves, "glove skin", 1, 50, 1)

    Toggle(Weapons, "auto apply")
    Toggle(Weapons, "rarity filter")

    Slider(Weapons, "min rarity", 1, 6, 1)

    Toggle(Agents, "custom agent")
    Toggle(Agents, "agent animations")

    Slider(Agents, "agent model", 1, 20, 1)

    local Colors = Theme:Section({Name = "colors", Side = "left"})
    local Fonts = Theme:Section({Name = "fonts", Side = "right"})
    local Effects = Theme:Section({Name = "effects", Side = "left"})
    local Presets = Theme:Section({Name = "presets", Side = "right"})

    Toggle(Colors, "custom colors")

    Slider(Colors, "hue", 0, 360, 180, "°")
    Slider(Colors, "saturation", 0, 100, 50, "%")
    Slider(Colors, "brightness", 0, 100, 50, "%")

    Toggle(Fonts, "custom font")
    Toggle(Fonts, "bold text")

    Slider(Fonts, "font size", 8, 24, 14, "px")

    Toggle(Effects, "blur effect")
    Toggle(Effects, "shadows")

    Slider(Effects, "blur intensity", 0, 50, 10)

    Toggle(Presets, "auto save")
    Toggle(Presets, "load on startup")

    Slider(Presets, "preset slot", 1, 5, 1)

    local Basic, Advanced, Debug = Aimbot:SubSection({
        Names = {"basic", "advanced", "debug"},
        Count = 3
    })


    Toggle(Basic, "lock on")
    Slider(Basic, "sensitivity", 0, 100, 50, "%")

    Basic:Dropdown({
        Name = 'target bone',
        Options = {"head", "chest", "pelvis", "limbs"},
        Default = "head",
        Callback = Cb("target bone")
    })

    Toggle(Advanced, "advanced tracking")
    Toggle(Advanced, "bone priority")

    Slider(Advanced, "reaction time", 0, 500, 100, "ms")

    Toggle(Debug, "debug mode")
    Slider(Debug, "log level", 0, 5, 1)

    local Standard, Performance = ESP:SubSection({
        Names = {"standard", "performance"},
        Count = 2
    })

    Toggle(Standard, "enhanced rendering")
    Slider(Standard, "quality", 0, 10, 7)

    Toggle(Performance, "low power mode")
    Slider(Performance, "update rate", 10, 120, 60, "Hz")

    local ThemesSec = Theme:Section({
        Name = "themes",
        Side = "right"
    })

    Library:SetTheme("Preset")
    local ThemeOptions = {}

    for Name, Theme in next, Themes do
        if typeof(Theme) == "table"
        and Name ~= "Utility"
        and Name ~= "Gradients" then
            Insert(ThemeOptions, Name)
        end
    end

    Sort(ThemeOptions)

    ThemesSec:Dropdown({
        Name = "theme",
        Flag = "selected_theme",
        Options = ThemeOptions,
        Default = "Preset",
        Callback = function(Value)
            Library:SetTheme(Value)
        end
    })

local ConfigsSec = Theme:Section({
    Name = "configs",
    Side = "right"
})

local function GetSavedConfigs()
    local ConfigDir = Library.Directory .. "/Configs"
    local Configs = {}

    if isfolder(ConfigDir) then
        for _, File in pairs(listfiles(ConfigDir)) do
            if File:sub(-5) == ".json" then
                local Name = File:match("([^\\/]+)%.json$")

                if Name then
                    Insert(Configs, Name)
                end
            end
        end
    end

    Sort(Configs)

    return Configs
end

local ConfigDropdown = ConfigsSec:Dropdown({
    Name = "select config",
    Flag = "selected_config",
    Options = GetSavedConfigs(),
    Default = GetSavedConfigs()[1]
})

local ConfigNameTextbox = ConfigsSec:Textbox({
    Name = "new config name",
    Flag = "config_name",
    Default = "default",

    Callback = function(Value)
        Library.Flags["config_name"] = Value
    end
})

ConfigsSec:Button({
    Name = "save config",

    Callback = function()
        local ConfigName = (
            Library.Flags["config_name"]
            and tostring(Library.Flags["config_name"]):gsub("%s+", "")
        )

        if not ConfigName or ConfigName == "" then
            ConfigName = "default"
        end

        Library:SaveConfig(ConfigName)

        local NewConfigs = GetSavedConfigs()

        ConfigDropdown:Refresh(NewConfigs)
        ConfigDropdown:Set(ConfigName)
    end
})

ConfigsSec:Button({
    Name = "load config",

    Callback = function()
        local ConfigName = Library.Flags["selected_config"]

        if ConfigName and ConfigName ~= "No configs" then
            Library:LoadConfig(ConfigName)
        end
    end
})
