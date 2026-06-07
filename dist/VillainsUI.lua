--[[
    VILLAINS UI LIBRARY v3.0.1 - DARK RED PREMIUM
    Premium Roblox UI Library for Script Hubs

    local VillainsUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/YOUR_USERNAME/VILLAINS-UI-LIBRARY/main/dist/VillainsUI.lua"
    ))()
]]

return (function()
    if not Color3.fromHex then
        function Color3.fromHex(hex)
            hex = string.gsub(hex, "#", "")
            return Color3.new(
                tonumber(string.sub(hex, 1, 2), 16) / 255,
                tonumber(string.sub(hex, 3, 4), 16) / 255,
                tonumber(string.sub(hex, 5, 6), 16) / 255
            )
        end
    end

    local Modules = {}
    local function Import(name)
        return Modules[name]
    end
    Modules["Compat"] = (function()
        local Compat = {}
        
        function Compat.Apply()
        	if not Color3.fromHex then
        		function Color3.fromHex(hex)
        			hex = string.gsub(hex, "#", "")
        			return Color3.new(
        				tonumber(string.sub(hex, 1, 2), 16) / 255,
        				tonumber(string.sub(hex, 3, 4), 16) / 255,
        				tonumber(string.sub(hex, 5, 6), 16) / 255
        			)
        		end
        	end
        end
        
        function Compat.ToHSV(color)
        	if Color3.toHSV then
        		return Color3.toHSV(color)
        	end
        	return color:ToHSV()
        end
        
        function Compat.HttpGet(url)
        	local ok, body = pcall(function()
        		return game:HttpGet(url, true)
        	end)
        	if ok and type(body) == "string" and body ~= "" and not string.find(body, "<!DOCTYPE", 1, true) then
        		return body
        	end
        
        	if syn and syn.request then
        		local res = syn.request({ Url = url, Method = "GET" })
        		if res and res.Body then
        			return res.Body
        		end
        	end
        
        	if http and http.request then
        		local res = http.request({ Url = url, Method = "GET" })
        		if res and res.Body then
        			return res.Body
        		end
        	end
        
        	if request then
        		local res = request({ Url = url, Method = "GET" })
        		if res and res.Body then
        			return res.Body
        		end
        	end
        
        	error("[VillainsUI] HttpGet failed for: " .. tostring(url))
        end
        
        function Compat.LoadString(source, chunkName)
        	local loader = loadstring or load
        	if not loader then
        		error("[VillainsUI] This executor does not support loadstring/load.")
        	end
        	local fn, err = loader(source, chunkName or "VillainsUI")
        	if not fn then
        		error("[VillainsUI] Failed to compile: " .. tostring(err))
        	end
        	return fn
        end
        
        function Compat.SafeCall(fn, ...)
        	local ok, result = pcall(fn, ...)
        	if not ok then
        		warn("[VillainsUI] " .. tostring(result))
        		return nil
        	end
        	return result
        end
        
        Compat.Apply()
        return Compat
    end)()

    Modules["Theme"] = (function()
        local Theme = {}
        
        Theme.Version = "3.0.1"
        Theme.Name = "DarkRed"
        
        Theme.Colors = {
        	Background = Color3.fromHex("#070404"),
        	BackgroundSecondary = Color3.fromHex("#0F0707"),
        	Surface = Color3.fromHex("#160909"),
        	SurfaceHover = Color3.fromHex("#1F0C0C"),
        	SurfaceActive = Color3.fromHex("#2A1010"),
        
        	Primary = Color3.fromHex("#DC143C"),
        	PrimaryLight = Color3.fromHex("#FF2D55"),
        	PrimaryDark = Color3.fromHex("#8B0000"),
        	Accent = Color3.fromHex("#FF0040"),
        	Glow = Color3.fromHex("#FF1A3D"),
        
        	Text = Color3.fromHex("#F5E6E6"),
        	TextSecondary = Color3.fromHex("#B89090"),
        	TextMuted = Color3.fromHex("#7A5555"),
        
        	Success = Color3.fromHex("#2ECC71"),
        	Warning = Color3.fromHex("#F39C12"),
        	Error = Color3.fromHex("#E74C3C"),
        	Info = Color3.fromHex("#3498DB"),
        
        	Border = Color3.fromHex("#DC143C"),
        	BorderMuted = Color3.fromHex("#3D1515"),
        
        	Overlay = Color3.fromHex("#000000"),
        }
        
        Theme.Transparency = {
        	Window = 0.08,
        	Surface = 0.15,
        	Glass = 0.35,
        	Overlay = 0.55,
        }
        
        Theme.CornerRadius = {
        	Small = UDim.new(0, 6),
        	Medium = UDim.new(0, 10),
        	Large = UDim.new(0, 14),
        	Full = UDim.new(1, 0),
        }
        
        Theme.Animation = {
        	Fast = 0.15,
        	Normal = 0.25,
        	Slow = 0.4,
        	Spring = 0.55,
        	Easing = Enum.EasingStyle.Quint,
        	EasingDirection = Enum.EasingDirection.Out,
        	BounceEasing = Enum.EasingStyle.Back,
        }
        
        Theme.Font = {
        	Title = Enum.Font.GothamBold,
        	Body = Enum.Font.GothamMedium,
        	Regular = Enum.Font.Gotham,
        	Mono = Enum.Font.Code,
        }
        Theme.FontFace = nil
        
        Theme.Sizes = {
        	WindowWidth = 580,
        	WindowHeight = 480,
        	SidebarWidth = 200,
        	TopbarHeight = 48,
        	ElementHeight = 42,
        	Padding = 12,
        	Gap = 8,
        }
        
        function Theme.GetGradient(typeName)
        	local colors = Theme.Colors
        	if typeName == "Primary" then
        		return ColorSequence.new({
        			ColorSequenceKeypoint.new(0, colors.PrimaryDark),
        			ColorSequenceKeypoint.new(0.5, colors.Primary),
        			ColorSequenceKeypoint.new(1, colors.PrimaryLight),
        		})
        	elseif typeName == "Glow" then
        		return ColorSequence.new({
        			ColorSequenceKeypoint.new(0, colors.Primary),
        			ColorSequenceKeypoint.new(1, colors.Accent),
        		})
        	elseif typeName == "Dark" then
        		return ColorSequence.new({
        			ColorSequenceKeypoint.new(0, colors.Background),
        			ColorSequenceKeypoint.new(1, colors.Surface),
        		})
        	end
        	return ColorSequence.new(colors.Primary, colors.PrimaryLight)
        end
        return Theme
    end)()

    Modules["Themes"] = (function()
        local BaseTheme = Import("Theme")
        
        local Themes = {}
        
        local function cloneTheme(name, overrides)
        	local t = {}
        	for k, v in pairs(BaseTheme) do
        		if type(v) == "table" and k == "Colors" then
        			t.Colors = {}
        			for ck, cv in pairs(BaseTheme.Colors) do
        				t.Colors[ck] = cv
        			end
        			if overrides.Colors then
        				for ck, cv in pairs(overrides.Colors) do
        					t.Colors[ck] = cv
        				end
        			end
        		elseif type(v) ~= "function" then
        			t[k] = v
        		end
        	end
        	t.Name = name
        	t.GetGradient = BaseTheme.GetGradient
        	return t
        end
        
        Themes.DarkRed = cloneTheme("DarkRed", {})
        
        Themes.BloodMoon = cloneTheme("BloodMoon", {
        	Colors = {
        		Primary = Color3.fromHex("#B80000"),
        		PrimaryLight = Color3.fromHex("#FF3333"),
        		PrimaryDark = Color3.fromHex("#660000"),
        		Accent = Color3.fromHex("#FF0000"),
        		Glow = Color3.fromHex("#CC0000"),
        		Background = Color3.fromHex("#050202"),
        		Surface = Color3.fromHex("#120606"),
        	},
        })
        
        Themes.Crimson = cloneTheme("Crimson", {
        	Colors = {
        		Primary = Color3.fromHex("#E0115F"),
        		PrimaryLight = Color3.fromHex("#FF69B4"),
        		PrimaryDark = Color3.fromHex("#9B1B4A"),
        		Accent = Color3.fromHex("#FF1493"),
        		Glow = Color3.fromHex("#FF0066"),
        		Background = Color3.fromHex("#0A0408"),
        		Surface = Color3.fromHex("#180A12"),
        	},
        })
        
        Themes.Dark = cloneTheme("Dark", {
        	Colors = {
        		Primary = Color3.fromHex("#DC143C"),
        		Background = Color3.fromHex("#0A0A0A"),
        		Surface = Color3.fromHex("#141414"),
        	},
        })
        
        function Themes.Get(name)
        	return Themes[name] or Themes.DarkRed
        end
        
        function Themes.Apply(name)
        	local theme = Themes.Get(name)
        	for k, v in pairs(theme.Colors) do
        		BaseTheme.Colors[k] = v
        	end
        	BaseTheme.Name = theme.Name
        	return theme
        end
        
        function Themes.List()
        	local list = {}
        	for name in pairs(Themes) do
        		if type(Themes[name]) == "table" and Themes[name].Name then
        			table.insert(list, name)
        		end
        	end
        	return list
        end
        return Themes
    end)()

    Modules["Animation"] = (function()
        local TweenService = game:GetService("TweenService")
        
        local Animation = {}
        Animation.ActiveTweens = {}
        
        local function getTheme()
        	return Import("Theme")
        end
        
        function Animation.Cancel(instance)
        	if Animation.ActiveTweens[instance] then
        		for _, tween in ipairs(Animation.ActiveTweens[instance]) do
        			pcall(function()
        				tween:Cancel()
        			end)
        		end
        		Animation.ActiveTweens[instance] = nil
        	end
        end
        
        function Animation.Tween(instance, props, duration, easingStyle, easingDirection, callback)
        	Animation.Cancel(instance)
        
        	local theme = getTheme()
        	local info = TweenInfo.new(
        		duration or theme.Animation.Normal,
        		easingStyle or theme.Animation.Easing,
        		easingDirection or theme.Animation.EasingDirection
        	)
        
        	local tween = TweenService:Create(instance, info, props)
        	Animation.ActiveTweens[instance] = { tween }
        
        	if callback then
        		tween.Completed:Connect(function(state)
        			if state == Enum.PlaybackState.Completed then
        				callback()
        			end
        		end)
        	end
        
        	tween:Play()
        	return tween
        end
        
        function Animation.Spring(instance, props, callback)
        	return Animation.Tween(
        		instance,
        		props,
        		getTheme().Animation.Spring,
        		getTheme().Animation.BounceEasing,
        		Enum.EasingDirection.Out,
        		callback
        	)
        end
        
        function Animation.FadeIn(instance, duration, callback)
        	local props = {}
        	if instance:IsA("GuiObject") then
        		props.BackgroundTransparency = instance:GetAttribute("_TargetTransparency") or 0
        	end
        	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
        		props.TextTransparency = 0
        	end
        	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
        		props.ImageTransparency = 0
        	end
        	return Animation.Tween(instance, props, duration, nil, nil, callback)
        end
        
        function Animation.FadeOut(instance, duration, callback)
        	local props = {}
        	if instance:IsA("GuiObject") then
        		props.BackgroundTransparency = 1
        	end
        	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
        		props.TextTransparency = 1
        	end
        	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
        		props.ImageTransparency = 1
        	end
        	return Animation.Tween(instance, props, duration, nil, nil, callback)
        end
        
        function Animation.ScaleIn(instance, duration, callback)
        	local original = instance:GetAttribute("_OriginalSize") or instance.Size
        	instance:SetAttribute("_OriginalSize", original)
        	instance.Size = UDim2.new(original.X.Scale * 0.92, original.X.Offset, original.Y.Scale * 0.92, original.Y.Offset)
        
        	if instance:IsA("GuiObject") then
        		instance.BackgroundTransparency = 1
        	end
        
        	Animation.Tween(instance, {
        		Size = original,
        		BackgroundTransparency = instance:GetAttribute("_TargetTransparency") or 0,
        	}, duration or getTheme().Animation.Normal, getTheme().Animation.BounceEasing, Enum.EasingDirection.Out, callback)
        end
        
        function Animation.SlideIn(instance, fromOffset, duration, callback)
        	local original = instance.Position
        	instance.Position = UDim2.new(
        		original.X.Scale,
        		original.X.Offset + fromOffset,
        		original.Y.Scale,
        		original.Y.Offset
        	)
        	return Animation.Tween(instance, { Position = original }, duration, nil, nil, callback)
        end
        
        function Animation.Pulse(instance, color, duration)
        	local stroke = instance:FindFirstChildOfClass("UIStroke")
        	if not stroke then
        		return
        	end
        
        	local original = stroke.Color
        	local theme = getTheme()
        	Animation.Tween(stroke, { Color = color or theme.Colors.Glow }, duration or 0.2)
        	task.delay(duration or 0.2, function()
        		if stroke.Parent then
        			Animation.Tween(stroke, { Color = original }, duration or 0.2)
        		end
        	end)
        end
        
        function Animation.Shimmer(frame)
        	local theme = getTheme()
        	local shimmer = Instance.new("Frame")
        	shimmer.Name = "Shimmer"
        	shimmer.Size = UDim2.new(0.3, 0, 1, 0)
        	shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
        	shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
        	shimmer.BackgroundTransparency = 0.85
        	shimmer.BorderSizePixel = 0
        	shimmer.ZIndex = frame.ZIndex + 1
        	shimmer.Parent = frame
        
        	local gradient = Instance.new("UIGradient")
        	gradient.Transparency = NumberSequence.new({
        		NumberSequenceKeypoint.new(0, 1),
        		NumberSequenceKeypoint.new(0.5, 0.6),
        		NumberSequenceKeypoint.new(1, 1),
        	})
        	gradient.Rotation = 25
        	gradient.Parent = shimmer
        
        	local tween = TweenService:Create(shimmer, TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        		Position = UDim2.new(1.3, 0, 0, 0),
        	})
        	tween:Play()
        	return shimmer, tween
        end
        
        function Animation.StaggerIn(instances, delay, duration)
        	delay = delay or 0.04
        	duration = duration or getTheme().Animation.Normal
        	for i, inst in ipairs(instances) do
        		task.delay((i - 1) * delay, function()
        			if inst.Parent then
        				inst.BackgroundTransparency = 1
        				Animation.FadeIn(inst, duration)
        			end
        		end)
        	end
        end
        
        function Animation.GlowPulse(instance, color, theme)
        	theme = theme or getTheme()
        	local stroke = instance:FindFirstChildOfClass("UIStroke")
        	if not stroke then
        		return
        	end
        	local original = stroke.Color
        	task.spawn(function()
        		while instance.Parent do
        			Animation.Tween(stroke, { Color = color or theme.Colors.Glow, Transparency = 0.1 }, 0.9)
        			task.wait(0.9)
        			Animation.Tween(stroke, { Color = original, Transparency = 0.5 }, 0.9)
        			task.wait(0.9)
        		end
        	end)
        end
        
        function Animation.Bounce(instance, scale)
        	scale = scale or 1.05
        	local original = instance.Size
        	Animation.Tween(instance, {
        		Size = UDim2.new(original.X.Scale * scale, original.X.Offset, original.Y.Scale * scale, original.Y.Offset),
        	}, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out, function()
        		Animation.Tween(instance, { Size = original }, 0.15)
        	end)
        end
        return Animation
    end)()

    Modules["Icons"] = (function()
        local Icons = {}
        
        Icons.Cache = {}
        Icons.BaseUrl = "https://raw.githubusercontent.com/Footagesus/Icons/main/icons/"
        Icons.FallbackEmoji = {
        	["lucide:home"] = "🏠",
        	["lucide:settings"] = "⚙",
        	["lucide:user"] = "👤",
        	["lucide:star"] = "⭐",
        	["lucide:heart"] = "❤",
        	["lucide:shield"] = "🛡",
        	["lucide:sword"] = "⚔",
        	["lucide:info"] = "ℹ",
        	["lucide:bell"] = "🔔",
        	["lucide:lock"] = "🔒",
        }
        
        function Icons.Parse(icon)
        	if not icon or icon == "" then
        		return nil, "none"
        	end
        
        	if string.find(icon, "rbxassetid://") or string.find(icon, "http") then
        		return icon, "image"
        	end
        
        	if string.find(icon, ":") then
        		local collection, name = icon:match("^([^:]+):(.+)$")
        		if collection and name then
        			return icon, "sprite", collection, name
        		end
        	end
        
        	return icon, "emoji"
        end
        
        function Icons.GetUrl(collection, name)
        	return Icons.BaseUrl .. collection .. "/" .. name .. ".png"
        end
        
        function Icons.Resolve(icon, callback)
        	local parsed, kind, collection, name = Icons.Parse(icon)
        
        	if kind == "emoji" then
        		if callback then
        			callback(parsed, "emoji")
        		end
        		return parsed, "emoji"
        	end
        
        	if kind == "image" then
        		if callback then
        			callback(parsed, "image")
        		end
        		return parsed, "image"
        	end
        
        	local cacheKey = icon
        	if Icons.Cache[cacheKey] then
        		if callback then
        			callback(Icons.Cache[cacheKey], "image")
        		end
        		return Icons.Cache[cacheKey], "image"
        	end
        
        	local url = Icons.GetUrl(collection, name)
        
        	task.spawn(function()
        		local ok, assetId = pcall(function()
        			if getcustomasset then
        				local path = "VillainsUI/icons/" .. collection .. "_" .. name .. ".png"
        				if not isfolder("VillainsUI/icons") then
        					makefolder("VillainsUI/icons")
        				end
        				if not isfile(path) then
        					writefile(path, game:HttpGet(url))
        				end
        				return getcustomasset(path)
        			end
        			return url
        		end)
        
        		if ok and assetId then
        			Icons.Cache[cacheKey] = assetId
        			if callback then
        				callback(assetId, "image")
        			end
        		else
        			local fallback = Icons.FallbackEmoji[icon] or "◆"
        			if callback then
        				callback(fallback, "emoji")
        			end
        		end
        	end)
        
        	return Icons.FallbackEmoji[icon] or "◆", "emoji"
        end
        return Icons
    end)()

    Modules["Creator"] = (function()
        local Theme = Import("Theme")
        
        local Creator = {}
        
        local function getParent()
        	local ok, result = pcall(function()
        		if gethui then
        			return gethui()
        		end
        		return nil
        	end)
        	if ok and result then
        		return result
        	end
        	return game:GetService("CoreGui")
        end
        
        Creator.ScreenGui = nil
        Creator.ProtectGui = protectgui or protect_gui or function(gui)
        	pcall(function()
        		if syn and syn.protect_gui then
        			syn.protect_gui(gui)
        		elseif gethui then
        			-- already parented to gethui
        		end
        	end)
        end
        
        function Creator.GetScreenGui()
        	if Creator.ScreenGui and Creator.ScreenGui.Parent then
        		return Creator.ScreenGui
        	end
        
        	local gui = Instance.new("ScreenGui")
        	gui.Name = "VillainsUI"
        	gui.ResetOnSpawn = false
        	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        	gui.IgnoreGuiInset = true
        
        	Creator.ProtectGui(gui)
        	gui.Parent = getParent()
        	Creator.ScreenGui = gui
        	return gui
        end
        
        function Creator.New(className, props)
        	local instance = Instance.new(className)
        	for key, value in pairs(props or {}) do
        		if key ~= "Parent" then
        			if key == "CornerRadius" and instance:IsA("GuiObject") then
        				local corner = Instance.new("UICorner")
        				corner.CornerRadius = value
        				corner.Parent = instance
        			elseif key == "Stroke" then
        				local stroke = Instance.new("UIStroke")
        				for sk, sv in pairs(value) do
        					stroke[sk] = sv
        				end
        				stroke.Parent = instance
        			elseif key == "Padding" then
        				local padding = Instance.new("UIPadding")
        				for pk, pv in pairs(value) do
        					padding[pk] = pv
        				end
        				padding.Parent = instance
        			elseif key == "Gradient" then
        				local gradient = Instance.new("UIGradient")
        				for gk, gv in pairs(value) do
        					gradient[gk] = gv
        				end
        				gradient.Parent = instance
        			elseif key == "ListLayout" then
        				local layout = Instance.new("UIListLayout")
        				for lk, lv in pairs(value) do
        					layout[lk] = lv
        				end
        				layout.Parent = instance
        			elseif key == "AspectRatio" then
        				local aspect = Instance.new("UIAspectRatioConstraint")
        				for ak, av in pairs(value) do
        					aspect[ak] = av
        				end
        				aspect.Parent = instance
        			else
        				instance[key] = value
        			end
        		end
        	end
        	if props and props.Parent then
        		instance.Parent = props.Parent
        	end
        	return instance
        end
        
        function Creator.Text(props)
        	local fontFace = props.FontFace or Theme.FontFace
        	return Creator.New("TextLabel", {
        		BackgroundTransparency = 1,
        		Font = fontFace and Enum.Font.Unknown or (props.Font or Theme.Font.Body),
        		FontFace = fontFace,
        		TextColor3 = Theme.Colors.Text,
        		TextSize = 14,
        		TextXAlignment = Enum.TextXAlignment.Left,
        		TextYAlignment = Enum.TextYAlignment.Center,
        		RichText = true,
        		Parent = props.Parent,
        		Size = props.Size or UDim2.new(1, 0, 0, 20),
        		Position = props.Position,
        		Text = props.Text or "",
        		Name = props.Name or "Text",
        		TextTransparency = props.TextTransparency or 0,
        		FontFace = props.FontFace,
        	})
        end
        
        function Creator.Button(props)
        	local theme = Theme
        	local button = Creator.New("TextButton", {
        		Name = props.Name or "Button",
        		Parent = props.Parent,
        		Size = props.Size or UDim2.new(1, 0, 0, theme.Sizes.ElementHeight),
        		BackgroundColor3 = props.Color or theme.Colors.Surface,
        		BackgroundTransparency = props.Transparency or theme.Transparency.Surface,
        		Text = "",
        		AutoButtonColor = false,
        		CornerRadius = props.CornerRadius or theme.CornerRadius.Medium,
        		Stroke = props.Stroke or {
        			Color = theme.Colors.BorderMuted,
        			Thickness = 1,
        			Transparency = 0.5,
        		},
        	})
        
        	local label = Creator.Text({
        		Parent = button,
        		Size = UDim2.new(1, -24, 1, 0),
        		Position = UDim2.new(0, 12, 0, 0),
        		Text = props.Title or "Button",
        		TextXAlignment = props.Justify == "Center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
        	})
        
        	if props.Icon and props.Icon ~= "" then
        		label.Position = UDim2.new(0, 36, 0, 0)
        		label.Size = UDim2.new(1, -48, 1, 0)
        		Creator.New("TextLabel", {
        			Parent = button,
        			BackgroundTransparency = 1,
        			Size = UDim2.new(0, 20, 0, 20),
        			Position = UDim2.new(0, 12, 0.5, -10),
        			Text = props.Icon,
        			TextSize = 16,
        			TextColor3 = props.IconColor or theme.Colors.Primary,
        		})
        	end
        
        	return button, label
        end
        
        function Creator.Icon(icon, parent, size, color)
        	if not icon or icon == "" then
        		return nil
        	end
        
        	local Icons = require(script.Parent.Icons)
        	local parsed, kind = Icons.Parse(icon)
        
        	if kind == "image" then
        		return Creator.New("ImageLabel", {
        			Parent = parent,
        			BackgroundTransparency = 1,
        			Size = size or UDim2.new(0, 20, 0, 20),
        			Image = parsed,
        			ImageColor3 = color or Theme.Colors.Primary,
        		})
        	end
        
        	if kind == "sprite" then
        		local holder = Creator.New("ImageLabel", {
        			Parent = parent,
        			BackgroundTransparency = 1,
        			Size = size or UDim2.new(0, 20, 0, 20),
        			Image = "",
        			ImageColor3 = color or Theme.Colors.Primary,
        		})
        
        		Icons.Resolve(icon, function(resolved, resolvedKind)
        			if not holder.Parent then
        				return
        			end
        			if resolvedKind == "image" then
        				holder.Image = resolved
        			else
        				holder:Destroy()
        				Creator.New("TextLabel", {
        					Parent = parent,
        					BackgroundTransparency = 1,
        					Size = size or UDim2.new(0, 20, 0, 20),
        					Text = resolved,
        					TextSize = (size and size.Y.Offset) or 18,
        					TextColor3 = color or Theme.Colors.Primary,
        				})
        			end
        		end)
        
        		return holder
        	end
        
        	return Creator.New("TextLabel", {
        		Parent = parent,
        		BackgroundTransparency = 1,
        		Size = size or UDim2.new(0, 20, 0, 20),
        		Text = parsed,
        		TextSize = (size and size.Y.Offset) or 18,
        		TextColor3 = color or Theme.Colors.Primary,
        	})
        end
        
        function Creator.AddPremiumGlow(frame, theme)
        	theme = theme or Theme
        	local glow = Creator.New("Frame", {
        		Name = "PremiumGlow",
        		Parent = frame,
        		Size = UDim2.new(1, 4, 1, 4),
        		Position = UDim2.new(0, -2, 0, -2),
        		BackgroundTransparency = 1,
        		ZIndex = frame.ZIndex - 1,
        		CornerRadius = theme.CornerRadius.Large,
        		Stroke = {
        			Color = theme.Colors.Glow,
        			Thickness = 2,
        			Transparency = 0.7,
        		},
        	})
        	task.spawn(function()
        		while glow.Parent do
        			Import("Animation").Tween(glow:FindFirstChildOfClass("UIStroke"), { Transparency = 0.4 }, 1.2)
        			task.wait(1.2)
        			Import("Animation").Tween(glow:FindFirstChildOfClass("UIStroke"), { Transparency = 0.85 }, 1.2)
        			task.wait(1.2)
        		end
        	end)
        	return glow
        end
        
        function Creator.AddHoverEffect(gui, hoverColor, normalColor, normalTransparency, hoverTransparency)
        	local theme = Theme
        	normalColor = normalColor or theme.Colors.Surface
        	hoverColor = hoverColor or theme.Colors.SurfaceHover
        	normalTransparency = normalTransparency or theme.Transparency.Surface
        	hoverTransparency = hoverTransparency or 0.05
        
        	gui.MouseEnter:Connect(function()
        		Import("Animation").Tween(gui, {
        			BackgroundColor3 = hoverColor,
        			BackgroundTransparency = hoverTransparency,
        		}, theme.Animation.Fast)
        	end)
        
        	gui.MouseLeave:Connect(function()
        		Import("Animation").Tween(gui, {
        			BackgroundColor3 = normalColor,
        			BackgroundTransparency = normalTransparency,
        		}, theme.Animation.Fast)
        	end)
        end
        
        function Creator.AddRipple(button)
        	local theme = Theme
        	button.ClipsDescendants = true
        
        	button.MouseButton1Down:Connect(function()
        		local ripple = Creator.New("Frame", {
        			Parent = button,
        			BackgroundColor3 = theme.Colors.Primary,
        			BackgroundTransparency = 0.7,
        			Size = UDim2.new(0, 0, 0, 0),
        			Position = UDim2.new(0.5, 0, 0.5, 0),
        			AnchorPoint = Vector2.new(0.5, 0.5),
        			CornerRadius = Theme.CornerRadius.Full,
        			ZIndex = 10,
        		})
        
        		Import("Animation").Tween(ripple, {
        			Size = UDim2.new(2, 0, 2, 0),
        			BackgroundTransparency = 1,
        		}, 0.4, nil, nil, function()
        			ripple:Destroy()
        		end)
        	end)
        end
        
        function Creator.MakeDraggable(frame, handle)
        	local UserInputService = game:GetService("UserInputService")
        	local dragging = false
        	local dragStart, startPos
        
        	local dragHandle = handle or frame
        
        	dragHandle.InputBegan:Connect(function(input)
        		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        			dragging = true
        			dragStart = input.Position
        			startPos = frame.Position
        		end
        	end)
        
        	UserInputService.InputChanged:Connect(function(input)
        		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        			local delta = input.Position - dragStart
        			frame.Position = UDim2.new(
        				startPos.X.Scale,
        				startPos.X.Offset + delta.X,
        				startPos.Y.Scale,
        				startPos.Y.Offset + delta.Y
        			)
        		end
        	end)
        
        	UserInputService.InputEnded:Connect(function(input)
        		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        			dragging = false
        		end
        	end)
        end
        return Creator
    end)()

    Modules["Paint"] = (function()
        local RunService = game:GetService("RunService")
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")
        
        local Paint = {}
        Paint.Instances = {}
        
        local function getCamera()
        	local cam = Workspace.CurrentCamera
        	if not cam then
        		Workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
        		cam = Workspace.CurrentCamera
        	end
        	return cam
        end
        
        function Paint.Create(parentGui, enabled)
        	local acrylic = {
        		Enabled = enabled ~= false,
        		Frame = nil,
        		Model = nil,
        		Blur = nil,
        		Connection = nil,
        	}
        
        	local frame = Instance.new("Frame")
        	frame.Name = "AcrylicLayer"
        	frame.Size = UDim2.fromScale(1, 1)
        	frame.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
        	frame.BackgroundTransparency = 0.65
        	frame.BorderSizePixel = 0
        	frame.ZIndex = 0
        	frame.Parent = parentGui
        
        	local gradient = Instance.new("UIGradient")
        	gradient.Rotation = 135
        	gradient.Color = ColorSequence.new({
        		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 8, 8)),
        		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 4, 4)),
        		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 2, 2)),
        	})
        	gradient.Transparency = NumberSequence.new({
        		NumberSequenceKeypoint.new(0, 0.55),
        		NumberSequenceKeypoint.new(1, 0.75),
        	})
        	gradient.Parent = frame
        
        	acrylic.Frame = frame
        
        	local blur = Lighting:FindFirstChild("_VillainsAcrylicDOF")
        	if not blur then
        		blur = Instance.new("DepthOfFieldEffect")
        		blur.Name = "_VillainsAcrylicDOF"
        		blur.FarIntensity = 0
        		blur.NearIntensity = 1
        		blur.FocusDistance = 0.05
        		blur.InFocusRadius = 50
        		blur.Enabled = false
        		blur.Parent = Lighting
        	end
        	acrylic.Blur = blur
        
        	local model = Instance.new("Model")
        	model.Name = "_VillainsAcrylicModel"
        
        	local part = Instance.new("Part")
        	part.Name = "AcrylicPart"
        	part.Anchored = true
        	part.CanCollide = false
        	part.CanQuery = false
        	part.CanTouch = false
        	part.CastShadow = false
        	part.Size = Vector3.new(1, 1, 1)
        	part.Material = Enum.Material.Glass
        	part.Transparency = 1
        	part.Parent = model
        	model.Parent = Workspace
        	acrylic.Model = part
        
        	local function updatePart()
        		local cam = getCamera()
        		if not cam or not part.Parent then
        			return
        		end
        		part.CFrame = cam.CFrame * CFrame.new(0, 0, -8)
        	end
        
        	acrylic.Connection = RunService.RenderStepped:Connect(updatePart)
        
        	function acrylic.SetVisibility(visible)
        		if blur then
        			blur.Enabled = visible and acrylic.Enabled
        		end
        		if part then
        			part.Transparency = visible and 0.98 or 1
        		end
        		if frame then
        			frame.Visible = visible
        		end
        	end
        
        	function acrylic.Enable()
        		acrylic.Enabled = true
        		acrylic.SetVisibility(true)
        	end
        
        	function acrylic.Disable()
        		acrylic.Enabled = false
        		acrylic.SetVisibility(false)
        	end
        
        	function acrylic.Destroy()
        		if acrylic.Connection then
        			acrylic.Connection:Disconnect()
        		end
        		if model then
        			model:Destroy()
        		end
        		if frame then
        			frame:Destroy()
        		end
        		if blur and blur.Name == "_VillainsAcrylicDOF" then
        			blur.Enabled = false
        		end
        	end
        
        	if enabled then
        		acrylic.Enable()
        	else
        		acrylic.Disable()
        	end
        
        	table.insert(Paint.Instances, acrylic)
        	return acrylic
        end
        return Paint
    end)()

    Modules["Luarmor"] = (function()
        local Luarmor = {}
        
        function Luarmor.New(scriptId, discord)
        	local HttpService = game:GetService("HttpService")
        	local APIURL = "https://sdkapi-public.luarmor.net/library.lua"
        	local API = loadstring(
        		game.HttpGetAsync and game:HttpGetAsync(APIURL) or HttpService:GetAsync(APIURL)
        	)()
        	local copy = setclipboard or toclipboard or function() end
        	API.script_id = scriptId
        
        	return {
        		Verify = function(key)
        			local status = API.check_key(key)
        			if status.code == "KEY_VALID" then
        				return true, "Key valid!"
        			elseif status.code == "KEY_HWID_LOCKED" then
        				return false, "Key linked to different HWID."
        			elseif status.code == "KEY_INCORRECT" then
        				return false, "Key is wrong or deleted!"
        			end
        			return false, "Key check failed: " .. (status.message or status.code)
        		end,
        		Copy = function()
        			copy(tostring(discord or ""))
        		end,
        	}
        end
        return Luarmor
    end)()

    Modules["Platoboost"] = (function()
        local Platoboost = {}
        
        function Platoboost.New(serviceId, secret)
        	local HttpService = game:GetService("HttpService")
        	local copy = setclipboard or toclipboard or function() end
        	local baseUrl = "https://platoboost.com"
        
        	return {
        		Verify = function(key)
        			local ok, result = pcall(function()
        				local url = string.format("%s/api/public/validate?service=%s&key=%s", baseUrl, tostring(serviceId), HttpService:UrlEncode(key))
        				local res = game.HttpGetAsync and game:HttpGetAsync(url) or HttpService:GetAsync(url)
        				local data = HttpService:JSONDecode(res)
        				if data and (data.success or data.valid) then
        					return true, "Key valid!"
        				end
        				return false, data and (data.message or data.error) or "Invalid key"
        			end)
        			if ok then
        				return result
        			end
        			return false, "Validation failed"
        		end,
        		Copy = function()
        			copy(string.format("%s/a/%s", baseUrl, tostring(serviceId)))
        		end,
        	}
        end
        return Platoboost
    end)()

    Modules["PandaDevelopment"] = (function()
        local PandaDevelopment = {}
        
        function PandaDevelopment.New(serviceId)
        	local HttpService = game:GetService("HttpService")
        	local copy = setclipboard or toclipboard or function() end
        
        	return {
        		Verify = function(key)
        			local ok, result = pcall(function()
        				local url = string.format("https://pandadevelopment.net/v2_validation?key=%s&service=%s", HttpService:UrlEncode(key), HttpService:UrlEncode(tostring(serviceId)))
        				local res = game.HttpGetAsync and game:HttpGetAsync(url) or HttpService:GetAsync(url)
        				local data = HttpService:JSONDecode(res)
        				if data and (data.valid or data.success) then
        					return true, "Key valid!"
        				end
        				return false, data and (data.message or data.error) or "Invalid key"
        			end)
        			if ok then return result end
        			return false, "Validation failed"
        		end,
        		Copy = function()
        			copy(string.format("https://pandadevelopment.net/getkey?service=%s", tostring(serviceId)))
        		end,
        	}
        end
        return PandaDevelopment
    end)()

    Modules["JunkieDevelopment"] = (function()
        local JunkieDevelopment = {}
        
        function JunkieDevelopment.New(args)
        	args = args or {}
        	local serviceId = args.ServiceId or args.HubId or ""
        	local apiKey = args.ApiKey or args.Key or ""
        
        	local service = {
        		Name = "Junkie Development",
        		ServiceId = serviceId,
        		ApiKey = apiKey,
        	}
        
        	function service:Verify(key)
        		if not key or key == "" then
        			return false, "Key is empty"
        		end
        
        		local ok, result = pcall(function()
        			local url = string.format(
        				"https://api.jnkie.com/v1/verify?hub=%s&key=%s",
        				serviceId,
        				key
        			)
        			local response = game:HttpGet(url, true)
        			if response then
        				local decoded = game:GetService("HttpService"):JSONDecode(response)
        				if decoded and (decoded.valid == true or decoded.success == true) then
        					return true, key
        				end
        				return false, decoded.message or "Invalid key"
        			end
        			return false, "Verification failed"
        		end)
        
        		if ok then
        			return result
        		end
        		return false, "Service unavailable"
        	end
        
        	function service:Copy()
        		if setclipboard then
        			setclipboard("https://jnkie.com/hub/" .. tostring(serviceId))
        		end
        	end
        
        	return service
        end
        return JunkieDevelopment
    end)()

    Modules["Services"] = (function()
        local Services = {
        	platoboost = {
        		Name = "Platoboost",
        		Icon = "🔑",
        		Args = { "ServiceId", "Secret" },
        		New = Import("Platoboost").New,
        	},
        	pandadevelopment = {
        		Name = "Panda Development",
        		Icon = "🐼",
        		Args = { "ServiceId" },
        		New = Import("PandaDevelopment").New,
        	},
        	luarmor = {
        		Name = "Luarmor",
        		Icon = "🛡",
        		Args = { "ScriptId", "Discord" },
        		New = Import("Luarmor").New,
        	},
        	junkie = {
        		Name = "Junkie Development",
        		Icon = "🔐",
        		Args = { "ServiceId", "ApiKey" },
        		New = Import("JunkieDevelopment").New,
        	},
        	junkiedevelopment = {
        		Name = "Junkie Development",
        		Icon = "🔐",
        		Args = { "ServiceId", "ApiKey" },
        		New = Import("JunkieDevelopment").New,
        	},
        }
        return Services
    end)()

    Modules["Tooltip"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        
        local Tooltip = {}
        Tooltip.Active = nil
        
        function Tooltip.Attach(gui, text, theme)
        	if not text or text == "" then
        		return
        	end
        
        	theme = theme or Theme
        	local tip
        
        	local function show()
        		if Tooltip.Active then
        			Tooltip.Active:Destroy()
        		end
        
        		tip = Creator.New("Frame", {
        			Name = "VillainsTooltip",
        			Parent = Creator.GetScreenGui(),
        			Size = UDim2.fromOffset(0, 28),
        			AutomaticSize = Enum.AutomaticSize.X,
        			BackgroundColor3 = theme.Colors.PrimaryDark,
        			BackgroundTransparency = 0.05,
        			ZIndex = 200,
        			CornerRadius = theme.CornerRadius.Small,
        			Stroke = { Color = theme.Colors.Primary, Thickness = 1, Transparency = 0.35 },
        			Padding = { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) },
        		})
        
        		Creator.New("TextLabel", {
        			Parent = tip,
        			BackgroundTransparency = 1,
        			Size = UDim2.new(0, 0, 1, 0),
        			AutomaticSize = Enum.AutomaticSize.X,
        			Text = text,
        			TextColor3 = theme.Colors.Text,
        			Font = theme.Font.Regular,
        			TextSize = 12,
        		})
        
        		local pos = gui.AbsolutePosition
        		local size = gui.AbsoluteSize
        		tip.Position = UDim2.fromOffset(pos.X + size.X / 2 - 40, pos.Y - 34)
        		tip.BackgroundTransparency = 1
        
        		Tooltip.Active = tip
        		Animation.Tween(tip, { BackgroundTransparency = 0.05 }, theme.Animation.Fast)
        	end
        
        	local function hide()
        		if tip then
        			Animation.FadeOut(tip, theme.Animation.Fast, function()
        				if tip then
        					tip:Destroy()
        				end
        				if Tooltip.Active == tip then
        					Tooltip.Active = nil
        				end
        			end)
        			tip = nil
        		end
        	end
        
        	gui.MouseEnter:Connect(show)
        	gui.MouseLeave:Connect(hide)
        end
        return Tooltip
    end)()

    Modules["Elements"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        local Tooltip = Import("Tooltip")
        local Compat = Import("Compat")
        
        local Elements = {}
        
        local function attachTooltip(gui, config, theme)
        	local tip = config.Tooltip or (config.IsTooltip and config.Desc)
        	if tip then
        		Tooltip.Attach(gui, tip, theme)
        	end
        end
        
        local function addDescLabel(parent, config, theme, yOffset)
        	if not config.Desc then
        		return yOffset
        	end
        	Creator.Text({
        		Parent = parent,
        		Text = config.Desc,
        		TextSize = 11,
        		TextColor3 = theme.Colors.TextMuted,
        		Size = UDim2.new(1, -24, 0, 14),
        		Position = UDim2.new(0, 12, 0, yOffset),
        	})
        	return yOffset + 16
        end
        
        function Elements.CreateButton(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        
        	local button, label = Creator.Button({
        		Parent = parent,
        		Title = config.Title or "Button",
        		Icon = config.Icon,
        		Color = config.Color or theme.Colors.Surface,
        		Justify = config.Justify,
        	})
        
        	Creator.AddHoverEffect(button, config.HoverColor or theme.Colors.SurfaceHover)
        	Creator.AddRipple(button)
        	attachTooltip(button, config, theme)
        
        	local element = { __type = "Button" }
        
        	function element:SetTitle(title)
        		label.Text = title
        	end
        
        	button.MouseButton1Click:Connect(function()
        		Animation.Pulse(button:FindFirstChildOfClass("UIStroke") or button)
        		if config.Callback then
        			config.Callback()
        		end
        	end)
        
        	return element
        end
        
        function Elements.CreateToggle(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local value = config.Default or false
        	local extraH = config.Desc and 16 or 0
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight + extraH),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Toggle",
        		Size = UDim2.new(1, -60, 0, 20),
        		Position = UDim2.new(0, 12, 0, extraH > 0 and 6 or 11),
        	})
        	addDescLabel(row, config, theme, 24)
        
        	local switch = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(0, 44, 0, 24),
        		Position = UDim2.new(1, -56, 0.5, -12),
        		BackgroundColor3 = value and theme.Colors.Primary or theme.Colors.BackgroundSecondary,
        		Text = "",
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Full,
        	})
        
        	local knob = Creator.New("Frame", {
        		Parent = switch,
        		Size = UDim2.new(0, 18, 0, 18),
        		Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        		BackgroundColor3 = Color3.new(1, 1, 1),
        		CornerRadius = theme.CornerRadius.Full,
        	})
        
        	local element = { Value = value, __type = "Toggle" }
        
        	local function update(state, animate)
        		element.Value = state
        		local targetColor = state and theme.Colors.Primary or theme.Colors.BackgroundSecondary
        		local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        		if animate then
        			Animation.Tween(switch, { BackgroundColor3 = targetColor }, theme.Animation.Fast)
        			Animation.Spring(knob, { Position = targetPos })
        		else
        			switch.BackgroundColor3 = targetColor
        			knob.Position = targetPos
        		end
        	end
        
        	switch.MouseButton1Click:Connect(function()
        		update(not element.Value, true)
        		if config.Callback then
        			config.Callback(element.Value)
        		end
        	end)
        
        	function element:SetValue(v)
        		update(v, true)
        	end
        
        	Creator.AddHoverEffect(row)
        	attachTooltip(row, config, theme)
        	return element
        end
        
        function Elements.CreateCheckbox(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local value = config.Default or false
        	local extraH = config.Desc and 16 or 0
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight + extraH),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Checkbox",
        		Size = UDim2.new(1, -60, 0, 20),
        		Position = UDim2.new(0, 12, 0, extraH > 0 and 6 or 11),
        	})
        	addDescLabel(row, config, theme, 24)
        
        	local box = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(0, 22, 0, 22),
        		Position = UDim2.new(1, -36, 0.5, -11),
        		BackgroundColor3 = value and theme.Colors.Primary or theme.Colors.BackgroundSecondary,
        		Text = value and "✓" or "",
        		TextColor3 = Color3.new(1, 1, 1),
        		Font = theme.Font.Title,
        		TextSize = 14,
        		AutoButtonColor = false,
        		CornerRadius = UDim.new(0, 5),
        		Stroke = { Color = theme.Colors.Primary, Thickness = 1, Transparency = value and 0.2 or 0.6 },
        	})
        
        	local element = { Value = value, __type = "Checkbox" }
        
        	local function update(state, animate)
        		element.Value = state
        		box.Text = state and "✓" or ""
        		local target = state and theme.Colors.Primary or theme.Colors.BackgroundSecondary
        		if animate then
        			Animation.Spring(box, { BackgroundColor3 = target })
        			if state then Animation.Bounce(box, 1.08) end
        		else
        			box.BackgroundColor3 = target
        		end
        	end
        
        	box.MouseButton1Click:Connect(function()
        		update(not element.Value, true)
        		if config.Callback then config.Callback(element.Value) end
        	end)
        
        	function element:SetValue(v)
        		update(v, true)
        	end
        
        	attachTooltip(row, config, theme)
        	return element
        end
        
        function Elements.CreateSlider(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        
        	local min = config.Min or 0
        	local max = config.Max or 100
        	local value = config.Default or min
        	local decimals = config.Decimals or 0
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight + 16),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Slider",
        		Size = UDim2.new(0.7, 0, 0, 20),
        		Position = UDim2.new(0, 12, 0, 8),
        	})
        
        	local valueLabel = Creator.Text({
        		Parent = row,
        		Text = tostring(value),
        		Size = UDim2.new(0.3, -12, 0, 20),
        		Position = UDim2.new(0.7, 0, 0, 8),
        		TextXAlignment = Enum.TextXAlignment.Right,
        		TextColor3 = theme.Colors.Primary,
        	})
        
        	local track = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(1, -24, 0, 6),
        		Position = UDim2.new(0, 12, 0, 36),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		Text = "",
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Full,
        	})
        
        	local fill = Creator.New("Frame", {
        		Parent = track,
        		Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        		BackgroundColor3 = theme.Colors.Primary,
        		BorderSizePixel = 0,
        		CornerRadius = theme.CornerRadius.Full,
        		Gradient = { Color = theme.GetGradient("Glow") },
        	})
        
        	local thumb = Creator.New("Frame", {
        		Parent = track,
        		Size = UDim2.new(0, 14, 0, 14),
        		Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
        		BackgroundColor3 = Color3.new(1, 1, 1),
        		CornerRadius = theme.CornerRadius.Full,
        		ZIndex = 2,
        		Stroke = { Color = theme.Colors.Primary, Thickness = 2, Transparency = 0.2 },
        	})
        
        	local element = { Value = value, __type = "Slider" }
        	local dragging = false
        
        	local function formatNumber(num)
        		if decimals > 0 then
        			return string.format("%." .. decimals .. "f", num)
        		end
        		return tostring(math.floor(num + 0.5))
        	end
        
        	local function setValue(num, fire)
        		num = math.clamp(num, min, max)
        		element.Value = num
        		local alpha = (num - min) / (max - min)
        		fill.Size = UDim2.new(alpha, 0, 1, 0)
        		thumb.Position = UDim2.new(alpha, -7, 0.5, -7)
        		valueLabel.Text = formatNumber(num)
        		if fire and config.Callback then
        			config.Callback(num)
        		end
        	end
        
        	local UserInputService = game:GetService("UserInputService")
        
        	local function updateFromInput(input)
        		local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        		setValue(min + (max - min) * rel, true)
        	end
        
        	track.InputBegan:Connect(function(input)
        		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        			dragging = true
        			updateFromInput(input)
        		end
        	end)
        
        	UserInputService.InputChanged:Connect(function(input)
        		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        			updateFromInput(input)
        		end
        	end)
        
        	UserInputService.InputEnded:Connect(function(input)
        		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        			dragging = false
        		end
        	end)
        
        	function element:SetValue(v)
        		setValue(v, false)
        	end
        
        	return element
        end
        
        function Elements.CreateInput(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight + 8),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	if config.Title then
        		Creator.Text({
        			Parent = row,
        			Text = config.Title,
        			Size = UDim2.new(1, -24, 0, 16),
        			Position = UDim2.new(0, 12, 0, 6),
        			TextSize = 12,
        			TextColor3 = theme.Colors.TextSecondary,
        		})
        	end
        
        	local box = Creator.New("TextBox", {
        		Parent = row,
        		Size = UDim2.new(1, -24, 0, 28),
        		Position = UDim2.new(0, 12, 0, config.Title and 24 or 8),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.2,
        		Text = config.Default or "",
        		PlaceholderText = config.Placeholder or "Enter text...",
        		PlaceholderColor3 = theme.Colors.TextMuted,
        		TextColor3 = theme.Colors.Text,
        		Font = theme.Font.Regular,
        		TextSize = 14,
        		ClearTextOnFocus = false,
        		CornerRadius = theme.CornerRadius.Small,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.7 },
        	})
        
        	local element = { Value = config.Default or "", __type = "Input" }
        
        	box:GetPropertyChangedSignal("Text"):Connect(function()
        		element.Value = box.Text
        		if config.Callback then
        			config.Callback(box.Text)
        		end
        	end)
        
        	box.Focused:Connect(function()
        		Animation.Tween(box:FindFirstChildOfClass("UIStroke"), { Color = theme.Colors.Primary, Transparency = 0.2 }, theme.Animation.Fast)
        	end)
        
        	box.FocusLost:Connect(function()
        		Animation.Tween(box:FindFirstChildOfClass("UIStroke"), { Color = theme.Colors.BorderMuted, Transparency = 0.7 }, theme.Animation.Fast)
        		if config.FinishedCallback then
        			config.FinishedCallback(box.Text)
        		end
        	end)
        
        	function element:SetValue(v)
        		box.Text = v
        		element.Value = v
        	end
        
        	return element
        end
        
        function Elements.CreateDropdown(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local options = config.Options or { "Option 1", "Option 2" }
        	local selected = config.Default or options[1]
        	local open = false
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		ClipsDescendants = false,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Dropdown",
        		Size = UDim2.new(0.45, 0, 1, 0),
        		Position = UDim2.new(0, 12, 0, 0),
        	})
        
        	local dropdownBtn = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(0.45, 0, 0, 30),
        		Position = UDim2.new(0.52, 0, 0.5, -15),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		Text = selected,
        		TextColor3 = theme.Colors.Text,
        		Font = theme.Font.Regular,
        		TextSize = 13,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Small,
        	})
        
        	local list = Creator.New("ScrollingFrame", {
        		Parent = row,
        		Size = UDim2.new(0.45, 0, 0, 0),
        		Position = UDim2.new(0.52, 0, 1, 4),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.05,
        		BorderSizePixel = 0,
        		Visible = false,
        		AutomaticCanvasSize = Enum.AutomaticSize.Y,
        		ScrollBarThickness = 3,
        		ScrollBarImageColor3 = theme.Colors.Primary,
        		CornerRadius = theme.CornerRadius.Small,
        		Stroke = { Color = theme.Colors.Primary, Thickness = 1, Transparency = 0.5 },
        		ZIndex = 20,
        		ListLayout = { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) },
        	})
        
        	local element = { Value = selected, __type = "Dropdown" }
        
        	local function closeDropdown()
        		open = false
        		list.Visible = false
        	end
        
        	dropdownBtn.MouseButton1Click:Connect(function()
        		open = not open
        		list.Visible = open
        		if open then
        			list.Size = UDim2.new(0.45, 0, 0, math.min(#options * 32, 160))
        		end
        	end)
        
        	for _, option in ipairs(options) do
        		local optBtn = Creator.New("TextButton", {
        			Parent = list,
        			Size = UDim2.new(1, 0, 0, 30),
        			BackgroundColor3 = theme.Colors.Surface,
        			BackgroundTransparency = 0.5,
        			Text = option,
        			TextColor3 = theme.Colors.Text,
        			Font = theme.Font.Regular,
        			TextSize = 13,
        			AutoButtonColor = false,
        		})
        
        		optBtn.MouseButton1Click:Connect(function()
        			selected = option
        			element.Value = option
        			dropdownBtn.Text = option
        			closeDropdown()
        			if config.Callback then
        				config.Callback(option)
        			end
        		end)
        
        		Creator.AddHoverEffect(optBtn, theme.Colors.SurfaceHover)
        	end
        
        	function element:SetValue(v)
        		selected = v
        		element.Value = v
        		dropdownBtn.Text = v
        	end
        
        	return element
        end
        
        function Elements.CreateKeybind(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local key = config.Default or Enum.KeyCode.RightControl
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Keybind",
        		Size = UDim2.new(0.6, 0, 1, 0),
        		Position = UDim2.new(0, 12, 0, 0),
        	})
        
        	local bindBtn = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(0, 80, 0, 28),
        		Position = UDim2.new(1, -92, 0.5, -14),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		Text = key.Name,
        		TextColor3 = theme.Colors.Primary,
        		Font = theme.Font.Mono,
        		TextSize = 12,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Small,
        	})
        
        	local element = { Value = key, __type = "Keybind" }
        	local listening = false
        
        	function element:SetValue(v)
        		key = v
        		element.Value = v
        		bindBtn.Text = v.Name
        	end
        
        	bindBtn.MouseButton1Click:Connect(function()
        		listening = true
        		bindBtn.Text = "..."
        		Animation.Tween(bindBtn, { BackgroundColor3 = theme.Colors.Primary }, theme.Animation.Fast)
        	end)
        
        	game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        		if not listening then
        			return
        		end
        		if input.UserInputType == Enum.UserInputType.Keyboard then
        			key = input.KeyCode
        			element.Value = key
        			bindBtn.Text = key.Name
        			listening = false
        			Animation.Tween(bindBtn, { BackgroundColor3 = theme.Colors.BackgroundSecondary }, theme.Animation.Fast)
        			if config.Callback then
        				config.Callback(key)
        			end
        		end
        	end)
        
        	return element
        end
        
        function Elements.CreateParagraph(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        
        	local frame = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        	})
        
        	if config.Title then
        		Creator.Text({
        			Parent = frame,
        			Text = config.Title,
        			Font = theme.Font.Title,
        			TextSize = config.TextSize or 16,
        			Size = UDim2.new(1, 0, 0, 22),
        		})
        	end
        
        	if config.Content then
        		Creator.Text({
        			Parent = frame,
        			Text = config.Content,
        			TextSize = 14,
        			TextColor3 = theme.Colors.TextSecondary,
        			TextTransparency = config.TextTransparency or 0.1,
        			TextWrapped = true,
        			Size = UDim2.new(1, 0, 0, 0),
        			AutomaticSize = Enum.AutomaticSize.Y,
        			Position = config.Title and UDim2.new(0, 0, 0, 26) or UDim2.new(),
        		})
        	end
        
        	return {}
        end
        
        function Elements.CreateDivider(parent, config, theme)
        	theme = theme or Theme
        	return Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 1),
        		BackgroundColor3 = theme.Colors.BorderMuted,
        		BackgroundTransparency = 0.4,
        		BorderSizePixel = 0,
        	})
        end
        
        function Elements.CreateSpace(parent, config)
        	config = config or {}
        	return Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, (config.Columns or 1) * 8),
        		BackgroundTransparency = 1,
        	})
        end
        
        function Elements.CreateColorpicker(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local color = config.Default or config.Color or theme.Colors.Primary
        	local transparency = config.Transparency or config.Alpha or 0
        	local h, s, v = Compat.ToHSV(color)
        
        	local row = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = theme.Transparency.Surface,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        	})
        
        	Creator.Text({
        		Parent = row,
        		Text = config.Title or "Color",
        		Size = UDim2.new(0.6, 0, 1, 0),
        		Position = UDim2.new(0, 12, 0, 0),
        	})
        
        	local preview = Creator.New("TextButton", {
        		Parent = row,
        		Size = UDim2.new(0, 36, 0, 28),
        		Position = UDim2.new(1, -48, 0.5, -14),
        		BackgroundColor3 = color,
        		BackgroundTransparency = transparency,
        		Text = "",
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Small,
        		Stroke = { Color = theme.Colors.Primary, Thickness = 1, Transparency = 0.35 },
        	})
        
        	local pickerOpen = false
        	local pickerFrame
        	local element = { Value = color, Transparency = transparency, __type = "Colorpicker" }
        
        	local function applyColor(newColor, newTransparency, fire)
        		color = newColor
        		transparency = newTransparency or transparency
        		element.Value = color
        		element.Transparency = transparency
        		preview.BackgroundColor3 = color
        		preview.BackgroundTransparency = transparency
        		if fire and config.Callback then
        			config.Callback(color, transparency)
        		end
        	end
        
        	function element:SetValue(c, t)
        		h, s, v = Compat.ToHSV(c)
        		applyColor(c, t or transparency, false)
        	end
        
        	function element:Update(c, t)
        		element:SetValue(c, t)
        	end
        
        	local UserInputService = game:GetService("UserInputService")
        
        	preview.MouseButton1Click:Connect(function()
        		if pickerOpen and pickerFrame then
        			pickerFrame:Destroy()
        			pickerOpen = false
        			return
        		end
        		pickerOpen = true
        
        		pickerFrame = Creator.New("Frame", {
        			Parent = Creator.GetScreenGui(),
        			Size = UDim2.fromOffset(240, config.Transparency and 220 or 200),
        			Position = UDim2.fromOffset(preview.AbsolutePosition.X - 180, preview.AbsolutePosition.Y + 36),
        			BackgroundColor3 = theme.Colors.BackgroundSecondary,
        			CornerRadius = theme.CornerRadius.Medium,
        			Stroke = { Color = theme.Colors.Primary, Thickness = 1.5, Transparency = 0.25 },
        			ZIndex = 60,
        			Padding = { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) },
        		})
        		pickerFrame.BackgroundTransparency = 1
        		Animation.ScaleIn(pickerFrame, theme.Animation.Fast)
        
        		local svBox = Creator.New("TextButton", {
        			Parent = pickerFrame,
        			Size = UDim2.fromOffset(160, 140),
        			Position = UDim2.fromOffset(0, 0),
        			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        			Text = "",
        			AutoButtonColor = false,
        			CornerRadius = theme.CornerRadius.Small,
        			ZIndex = 61,
        		})
        
        		local whiteGrad = Instance.new("UIGradient")
        		whiteGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
        		whiteGrad.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
        		whiteGrad.Parent = svBox
        
        		local blackGrad = Instance.new("Frame")
        		blackGrad.Size = UDim2.fromScale(1, 1)
        		blackGrad.BackgroundTransparency = 1
        		blackGrad.Parent = svBox
        		local blackG = Instance.new("UIGradient")
        		blackG.Rotation = 90
        		blackG.Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0))
        		blackG.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
        		blackG.Parent = blackGrad
        
        		local svCursor = Creator.New("Frame", {
        			Parent = svBox,
        			Size = UDim2.fromOffset(12, 12),
        			Position = UDim2.new(s, -6, 1 - v, -6),
        			BackgroundColor3 = color,
        			CornerRadius = theme.CornerRadius.Full,
        			ZIndex = 62,
        			Stroke = { Color = Color3.new(1, 1, 1), Thickness = 2, Transparency = 0.1 },
        		})
        
        		local hueBar = Creator.New("TextButton", {
        			Parent = pickerFrame,
        			Size = UDim2.fromOffset(18, 140),
        			Position = UDim2.fromOffset(170, 0),
        			BackgroundColor3 = Color3.new(1, 1, 1),
        			Text = "",
        			AutoButtonColor = false,
        			CornerRadius = theme.CornerRadius.Small,
        			ZIndex = 61,
        		})
        		local hueGrad = Instance.new("UIGradient")
        		hueGrad.Rotation = 90
        		hueGrad.Color = ColorSequence.new({
        			ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        			ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
        			ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
        			ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        			ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
        			ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        			ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
        		})
        		hueGrad.Parent = hueBar
        
        		local hueCursor = Creator.New("Frame", {
        			Parent = hueBar,
        			Size = UDim2.new(1, 4, 0, 4),
        			Position = UDim2.new(0, -2, h, -2),
        			BackgroundColor3 = Color3.new(1, 1, 1),
        			ZIndex = 62,
        			Stroke = { Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.4 },
        		})
        
        		local function refreshFromHSV(fire)
        			local newColor = Color3.fromHSV(h, s, v)
        			svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        			svCursor.Position = UDim2.new(s, -6, 1 - v, -6)
        			svCursor.BackgroundColor3 = newColor
        			hueCursor.Position = UDim2.new(0, -2, h, -2)
        			applyColor(newColor, transparency, fire)
        		end
        
        		local draggingSV, draggingHue = false, false
        
        		local function updateSV(input)
        			local relX = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
        			local relY = math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
        			s = relX
        			v = 1 - relY
        			refreshFromHSV(true)
        		end
        
        		svBox.InputBegan:Connect(function(input)
        			if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true updateSV(input) end
        		end)
        		hueBar.InputBegan:Connect(function(input)
        			if input.UserInputType == Enum.UserInputType.MouseButton1 then
        				draggingHue = true
        				local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
        				h = relY
        				refreshFromHSV(true)
        			end
        		end)
        		UserInputService.InputChanged:Connect(function(input)
        			if draggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then updateSV(input) end
        			if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
        				local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
        				h = relY
        				refreshFromHSV(true)
        			end
        		end)
        		UserInputService.InputEnded:Connect(function(input)
        			if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false draggingHue = false end
        		end)
        
        		if config.Transparency then
        			local alphaTrack = Creator.New("Frame", {
        				Parent = pickerFrame,
        				Size = UDim2.new(1, 0, 0, 8),
        				Position = UDim2.new(0, 0, 0, 152),
        				BackgroundColor3 = theme.Colors.BackgroundSecondary,
        				CornerRadius = theme.CornerRadius.Full,
        				ZIndex = 61,
        			})
        			local alphaFill = Creator.New("Frame", {
        				Parent = alphaTrack,
        				Size = UDim2.new(1 - transparency, 0, 1, 0),
        				BackgroundColor3 = color,
        				CornerRadius = theme.CornerRadius.Full,
        				ZIndex = 62,
        			})
        			alphaTrack.InputBegan:Connect(function(input)
        				if input.UserInputType == Enum.UserInputType.MouseButton1 then
        					local rel = math.clamp((input.Position.X - alphaTrack.AbsolutePosition.X) / alphaTrack.AbsoluteSize.X, 0, 1)
        					transparency = 1 - rel
        					alphaFill.Size = UDim2.new(rel, 0, 1, 0)
        					applyColor(color, transparency, true)
        				end
        			end)
        		end
        	end)
        
        	attachTooltip(row, config, theme)
        	return element
        end
        
        function Elements.CreateCode(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        
        	local frame = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.2,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.6 },
        		Padding = { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) },
        	})
        
        	local codeLabel = Creator.New("TextLabel", {
        		Parent = frame,
        		BackgroundTransparency = 1,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		Text = config.Code or "-- code here",
        		Font = theme.Font.Mono,
        		TextSize = 13,
        		TextColor3 = theme.Colors.PrimaryLight,
        		TextXAlignment = Enum.TextXAlignment.Left,
        		TextWrapped = true,
        	})
        
        	if config.Title then
        		Creator.Text({
        			Parent = parent,
        			Text = config.Title,
        			Font = theme.Font.Title,
        			TextSize = 13,
        			TextColor3 = theme.Colors.Primary,
        			Size = UDim2.new(1, 0, 0, 18),
        		})
        		frame.Position = UDim2.new(0, 0, 0, 22)
        	end
        
        	local copyBtn = Creator.New("TextButton", {
        		Parent = frame,
        		Size = UDim2.new(0, 60, 0, 24),
        		Position = UDim2.new(1, -68, 0, 4),
        		BackgroundColor3 = theme.Colors.PrimaryDark,
        		Text = "Copy",
        		TextColor3 = theme.Colors.Text,
        		Font = theme.Font.Body,
        		TextSize = 11,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Small,
        	})
        	copyBtn.MouseButton1Click:Connect(function()
        		if setclipboard then setclipboard(config.Code or "") end
        	end)
        
        	return { __type = "Code" }
        end
        
        function Elements.CreateImage(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local aspect = config.AspectRatio or "16:9"
        	local w, h = aspect:match("(%d+):(%d+)")
        	w, h = tonumber(w) or 16, tonumber(h) or 9
        
        	local frame = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        	})
        
        	local img = Creator.New("ImageLabel", {
        		Parent = frame,
        		Size = UDim2.new(1, 0, 0, config.Height or 160),
        		BackgroundTransparency = 1,
        		Image = config.Image or "",
        		ScaleType = Enum.ScaleType.Crop,
        		CornerRadius = UDim.new(0, config.Radius or 10),
        		AspectRatio = { AspectRatio = w / h, AspectType = Enum.AspectType.ScaleWithParentSize, DominantAxis = Enum.DominantAxis.Width },
        	})
        
        	return { __type = "Image", Frame = img }
        end
        
        function Elements.CreateGroup(parent, config, theme, bindFn)
        	config = config or {}
        	theme = theme or Theme
        
        	local groupFrame = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = 0.3,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.5 },
        		Padding = { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) },
        		ListLayout = { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, theme.Sizes.Gap) },
        	})
        
        	local groupObj = {}
        	if bindFn then bindFn(groupObj, groupFrame, theme) end
        	return groupObj
        end
        
        function Elements.CreateHStack(parent, config, theme, bindFn)
        	config = config or {}
        	theme = theme or Theme
        
        	local stack = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, config.Height or theme.Sizes.ElementHeight),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Horizontal,
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, config.Gap or 8),
        			HorizontalAlignment = config.Align or Enum.HorizontalAlignment.Left,
        		},
        	})
        
        	local stackObj = {}
        	if bindFn then bindFn(stackObj, stack, theme) end
        	return stackObj
        end
        
        function Elements.CreateVStack(parent, config, theme, bindFn)
        	config = config or {}
        	theme = theme or Theme
        
        	local stack = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Vertical,
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, config.Gap or 8),
        		},
        	})
        
        	local stackObj = {}
        	if bindFn then bindFn(stackObj, stack, theme) end
        	return stackObj
        end
        
        function Elements.CreateViewport(parent, config, theme)
        	config = config or {}
        	theme = theme or Theme
        	local height = config.Height or 180
        
        	local frame = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, height + (config.Title and 22 or 0)),
        		BackgroundTransparency = 1,
        	})
        
        	if config.Title then
        		Creator.Text({
        			Parent = frame,
        			Text = config.Title,
        			Font = theme.Font.Title,
        			TextSize = 13,
        			TextColor3 = theme.Colors.Primary,
        			Size = UDim2.new(1, 0, 0, 18),
        		})
        	end
        
        	local holder = Creator.New("Frame", {
        		Parent = frame,
        		Size = UDim2.new(1, 0, 0, height),
        		Position = UDim2.new(0, 0, 0, config.Title and 22 or 0),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.1,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.Primary, Thickness = 1, Transparency = 0.55 },
        		ClipsDescendants = true,
        	})
        
        	local viewport = Instance.new("ViewportFrame")
        	viewport.Size = UDim2.fromScale(1, 1)
        	viewport.BackgroundTransparency = 1
        	viewport.Ambient = Color3.fromRGB(180, 80, 80)
        	viewport.LightColor = Color3.fromRGB(255, 200, 200)
        	viewport.LightDirection = Vector3.new(-1, -1, -1)
        	viewport.Parent = holder
        
        	local worldModel = Instance.new("WorldModel")
        	worldModel.Parent = viewport
        
        	local element = { Viewport = viewport, WorldModel = worldModel, __type = "Viewport" }
        
        	if config.Model then
        		config.Model.Parent = worldModel
        	elseif config.Callback then
        		config.Callback(viewport, worldModel)
        	end
        
        	attachTooltip(holder, config, theme)
        	return element
        end
        return Elements
    end)()

    Modules["Localization"] = (function()
        local Localization = {}
        Localization.__index = Localization
        
        function Localization.New(config)
        	local self = setmetatable({}, Localization)
        	self.Enabled = config.Enabled ~= false
        	self.Prefix = config.Prefix or "loc:"
        	self.DefaultLanguage = config.DefaultLanguage or "en"
        	self.CurrentLanguage = self.DefaultLanguage
        	self.Translations = config.Translations or {}
        	return self
        end
        
        function Localization:SetLanguage(lang)
        	if self.Translations[lang] then
        		self.CurrentLanguage = lang
        		return true
        	end
        	return false
        end
        
        function Localization:Get(key, fallback)
        	if not self.Enabled then
        		return fallback or key
        	end
        	if type(key) == "string" and string.sub(key, 1, #self.Prefix) == self.Prefix then
        		key = string.sub(key, #self.Prefix + 1)
        	end
        	local lang = self.Translations[self.CurrentLanguage]
        	if lang and lang[key] then
        		return lang[key]
        	end
        	local default = self.Translations[self.DefaultLanguage]
        	if default and default[key] then
        		return default[key]
        	end
        	return fallback or key
        end
        
        function Localization:Translate(text)
        	if not self.Enabled or type(text) ~= "string" then
        		return text
        	end
        	if string.sub(text, 1, #self.Prefix) == self.Prefix then
        		return self:Get(text, text)
        	end
        	return text
        end
        return Localization
    end)()

    Modules["Config"] = (function()
        local HttpService = game:GetService("HttpService")
        local RunService = game:GetService("RunService")
        
        local ConfigManager = {
        	Folder = nil,
        	Path = nil,
        	Configs = {},
        	Parser = {
        		Toggle = {
        			Save = function(obj) return { __type = "Toggle", value = obj.Value } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
        		},
        		Checkbox = {
        			Save = function(obj) return { __type = "Checkbox", value = obj.Value } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
        		},
        		Slider = {
        			Save = function(obj) return { __type = "Slider", value = obj.Value } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(tonumber(data.value)) end end,
        		},
        		Input = {
        			Save = function(obj) return { __type = "Input", value = obj.Value } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
        		},
        		Dropdown = {
        			Save = function(obj) return { __type = "Dropdown", value = obj.Value } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
        		},
        		Keybind = {
        			Save = function(obj) return { __type = "Keybind", value = tostring(obj.Value) } end,
        			Load = function(el, data)
        				if el.SetValue then
        					local ok, key = pcall(function() return Enum.KeyCode[data.value] end)
        					if ok and key then el:SetValue(key) end
        				end
        			end,
        		},
        		Colorpicker = {
        			Save = function(obj) return { __type = "Colorpicker", value = obj.Value:ToHex() } end,
        			Load = function(el, data) if el.SetValue then el:SetValue(Color3.fromHex(data.value)) end end,
        		},
        	},
        }
        
        local WindowRef = nil
        
        function ConfigManager:Init(window)
        	if RunService:IsStudio() or not writefile then
        		warn("[VillainsUI.Config] Config system unavailable in Studio.")
        		return false
        	end
        	if not window.Folder and not window.Config then
        		warn("[VillainsUI.Config] Window Folder not specified.")
        		return false
        	end
        	WindowRef = window
        	local folder = (window.Config and window.Config.Folder) or window.Folder or "VillainsUI"
        	ConfigManager.Folder = folder
        	ConfigManager.Path = "VillainsUI/" .. folder .. "/config/"
        	if not isfolder("VillainsUI") then makefolder("VillainsUI") end
        	if not isfolder("VillainsUI/" .. folder) then makefolder("VillainsUI/" .. folder) end
        	if not isfolder(ConfigManager.Path) then makefolder(ConfigManager.Path) end
        	return ConfigManager
        end
        
        function ConfigManager:CreateConfig(name, autoload)
        	if not name then return false, "No config name" end
        
        	local ConfigModule = {
        		Path = ConfigManager.Path .. name .. ".json",
        		Elements = {},
        		CustomData = {},
        		AutoLoad = autoload or false,
        		Version = 1.0,
        	}
        
        	function ConfigModule:Register(flag, element)
        		ConfigModule.Elements[flag] = element
        	end
        
        	function ConfigModule:Set(key, value)
        		ConfigModule.CustomData[key] = value
        	end
        
        	function ConfigModule:Get(key)
        		return ConfigModule.CustomData[key]
        	end
        
        	function ConfigModule:Save()
        		if WindowRef and WindowRef.PendingFlags then
        			for flag, el in pairs(WindowRef.PendingFlags) do
        				ConfigModule:Register(flag, el)
        			end
        		end
        		local saveData = {
        			__version = ConfigModule.Version,
        			__elements = {},
        			__autoload = ConfigModule.AutoLoad,
        			__custom = ConfigModule.CustomData,
        		}
        		for flagName, element in pairs(ConfigModule.Elements) do
        			local t = element.__type
        			if ConfigManager.Parser[t] then
        				saveData.__elements[tostring(flagName)] = ConfigManager.Parser[t].Save(element)
        			end
        		end
        		writefile(ConfigModule.Path, HttpService:JSONEncode(saveData))
        		return saveData
        	end
        
        	function ConfigModule:Load()
        		if not isfile(ConfigModule.Path) then return false, "Config not found" end
        		local ok, data = pcall(function()
        			return HttpService:JSONDecode(readfile(ConfigModule.Path))
        		end)
        		if not ok then return false, "Parse error" end
        		if WindowRef and WindowRef.PendingFlags then
        			for flag, el in pairs(WindowRef.PendingFlags) do
        				ConfigModule:Register(flag, el)
        			end
        		end
        		for flagName, elData in pairs(data.__elements or {}) do
        			local el = ConfigModule.Elements[flagName]
        			if el and ConfigManager.Parser[elData.__type] then
        				task.spawn(function()
        					ConfigManager.Parser[elData.__type].Load(el, elData)
        				end)
        			end
        		end
        		ConfigModule.CustomData = data.__custom or {}
        		return ConfigModule.CustomData
        	end
        
        	function ConfigModule:Delete()
        		if isfile(ConfigModule.Path) then
        			delfile(ConfigModule.Path)
        		end
        		ConfigManager.Configs[name] = nil
        		return true
        	end
        
        	ConfigManager.Configs[name] = ConfigModule
        	if WindowRef then WindowRef.CurrentConfig = ConfigModule end
        
        	if autoload and isfile(ConfigModule.Path) then
        		task.spawn(function()
        			task.wait(0.5)
        			pcall(function() ConfigModule:Load() end)
        		end)
        	end
        
        	return ConfigModule
        end
        
        function ConfigManager:Config(name, autoload)
        	return ConfigManager:CreateConfig(name, autoload)
        end
        
        function ConfigManager:AllConfigs()
        	if not listfiles then return {} end
        	local files = {}
        	for _, file in ipairs(listfiles(ConfigManager.Path)) do
        		local n = file:match("([^\\/]+)%.json$")
        		if n then table.insert(files, n) end
        	end
        	return files
        end
        return ConfigManager
    end)()

    Modules["Notification"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        
        local Notification = {}
        Notification.Active = {}
        
        function Notification.Init(VillainsUI)
        	Notification.VillainsUI = VillainsUI
        	Notification.Container = Creator.New("Frame", {
        		Name = "Notifications",
        		Parent = Creator.GetScreenGui(),
        		Size = UDim2.new(0, 320, 1, 0),
        		Position = UDim2.new(1, -340, 0, 20),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 10),
        			VerticalAlignment = Enum.VerticalAlignment.Top,
        			HorizontalAlignment = Enum.HorizontalAlignment.Right,
        		},
        	})
        	return Notification
        end
        
        function Notification.Create(config)
        	config = config or {}
        	local theme = Theme
        	local duration = config.Duration or 4
        
        	local frame = Creator.New("Frame", {
        		Name = "Notification",
        		Parent = Notification.Container,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = 0.05,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = {
        			Color = config.Type == "Error" and theme.Colors.Error
        				or config.Type == "Success" and theme.Colors.Success
        				or config.Type == "Warning" and theme.Colors.Warning
        				or theme.Colors.Primary,
        			Thickness = 1.5,
        			Transparency = 0.3,
        		},
        		ClipsDescendants = true,
        	})
        
        	local accent = Creator.New("Frame", {
        		Parent = frame,
        		Size = UDim2.new(0, 4, 1, 0),
        		BackgroundColor3 = config.Type == "Error" and theme.Colors.Error
        			or config.Type == "Success" and theme.Colors.Success
        			or config.Type == "Warning" and theme.Colors.Warning
        			or theme.Colors.Primary,
        		BorderSizePixel = 0,
        	})
        
        	local content = Creator.New("Frame", {
        		Parent = frame,
        		Size = UDim2.new(1, -4, 0, 0),
        		Position = UDim2.new(0, 4, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        		Padding = {
        			PaddingTop = UDim.new(0, 12),
        			PaddingBottom = UDim.new(0, 12),
        			PaddingLeft = UDim.new(0, 14),
        			PaddingRight = UDim.new(0, 14),
        		},
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 4),
        		},
        	})
        
        	if config.Icon then
        		Creator.Icon(config.Icon, content, UDim2.new(0, 18, 0, 18))
        	end
        
        	Creator.Text({
        		Parent = content,
        		Text = config.Title or "Notification",
        		Font = theme.Font.Title,
        		TextSize = 15,
        		TextColor3 = theme.Colors.Text,
        		Size = UDim2.new(1, 0, 0, 18),
        	})
        
        	if config.Content then
        		Creator.Text({
        			Parent = content,
        			Text = config.Content,
        			TextSize = 13,
        			TextColor3 = theme.Colors.TextSecondary,
        			TextTransparency = 0.15,
        			Size = UDim2.new(1, 0, 0, 0),
        			AutomaticSize = Enum.AutomaticSize.Y,
        			TextWrapped = true,
        		})
        	end
        
        	frame.BackgroundTransparency = 1
        	frame.Position = UDim2.new(1, 50, 0, 0)
        
        	Animation.Tween(frame, {
        		Position = UDim2.new(0, 0, 0, 0),
        		BackgroundTransparency = 0.05,
        	}, theme.Animation.Normal, theme.Animation.BounceEasing)
        
        	table.insert(Notification.Active, frame)
        
        	task.delay(duration, function()
        		if frame.Parent then
        			Animation.Tween(frame, {
        				Position = UDim2.new(1, 50, 0, 0),
        				BackgroundTransparency = 1,
        			}, theme.Animation.Normal, nil, nil, function()
        				frame:Destroy()
        			end)
        		end
        	end)
        
        	return frame
        end
        return Notification
    end)()

    Modules["Popup"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        
        local Popup = {}
        
        function Popup.Create(VillainsUI, config)
        	config = config or {}
        	local theme = Theme
        
        	local overlay = Creator.New("TextButton", {
        		Name = "PopupOverlay",
        		Parent = Creator.GetScreenGui(),
        		Size = UDim2.fromScale(1, 1),
        		BackgroundColor3 = theme.Colors.Overlay,
        		BackgroundTransparency = 1,
        		Text = "",
        		AutoButtonColor = false,
        		ZIndex = 100,
        	})
        
        	local modal = Creator.New("Frame", {
        		Name = "Popup",
        		Parent = overlay,
        		Size = UDim2.fromOffset(400, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		Position = UDim2.fromScale(0.5, 0.5),
        		AnchorPoint = Vector2.new(0.5, 0.5),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.05,
        		CornerRadius = theme.CornerRadius.Large,
        		Stroke = {
        			Color = theme.Colors.Primary,
        			Thickness = 1.5,
        			Transparency = 0.4,
        		},
        		ZIndex = 101,
        		Padding = {
        			PaddingTop = UDim.new(0, 20),
        			PaddingBottom = UDim.new(0, 20),
        			PaddingLeft = UDim.new(0, 24),
        			PaddingRight = UDim.new(0, 24),
        		},
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 12),
        		},
        	})
        
        	local glow = Creator.New("Frame", {
        		Parent = modal,
        		Size = UDim2.new(1, 20, 1, 20),
        		Position = UDim2.new(0.5, 0, 0.5, 0),
        		AnchorPoint = Vector2.new(0.5, 0.5),
        		BackgroundTransparency = 1,
        		ZIndex = 100,
        		Stroke = {
        			Color = theme.Colors.Glow,
        			Thickness = 2,
        			Transparency = 0.7,
        		},
        		CornerRadius = theme.CornerRadius.Large,
        	})
        
        	local header = Creator.New("Frame", {
        		Parent = modal,
        		Size = UDim2.new(1, 0, 0, 32),
        		BackgroundTransparency = 1,
        	})
        
        	if config.Icon then
        		Creator.Icon(config.Icon, header, UDim2.new(0, 24, 0, 24), theme.Colors.Primary)
        	end
        
        	Creator.Text({
        		Parent = header,
        		Text = config.Title or "Popup",
        		Font = theme.Font.Title,
        		TextSize = 20,
        		Size = UDim2.new(1, config.Icon and -32 or 0, 1, 0),
        		Position = config.Icon and UDim2.new(0, 32, 0, 0) or UDim2.new(),
        	})
        
        	if config.Content then
        		Creator.Text({
        			Parent = modal,
        			Text = config.Content,
        			TextSize = 14,
        			TextColor3 = theme.Colors.TextSecondary,
        			TextWrapped = true,
        			Size = UDim2.new(1, 0, 0, 0),
        			AutomaticSize = Enum.AutomaticSize.Y,
        		})
        	end
        
        	local buttonRow = Creator.New("Frame", {
        		Parent = modal,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.ElementHeight),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Horizontal,
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 8),
        			HorizontalAlignment = Enum.HorizontalAlignment.Right,
        		},
        	})
        
        	local popupObject = {
        		Overlay = overlay,
        		Modal = modal,
        	}
        
        	function popupObject:Close()
        		Animation.Tween(modal, {
        			Size = UDim2.fromOffset(400, 0),
        			BackgroundTransparency = 1,
        		}, theme.Animation.Fast, nil, nil, function()
        			overlay:Destroy()
        		end)
        		Animation.Tween(overlay, { BackgroundTransparency = 1 }, theme.Animation.Fast)
        	end
        
        	for _, btnConfig in ipairs(config.Buttons or { { Title = "OK", Variant = "Primary" } }) do
        		local isPrimary = btnConfig.Variant == "Primary"
        		local btn, _ = Creator.Button({
        			Parent = buttonRow,
        			Title = btnConfig.Title or "Button",
        			Icon = btnConfig.Icon,
        			Color = isPrimary and theme.Colors.Primary or theme.Colors.Surface,
        			Transparency = isPrimary and 0.1 or theme.Transparency.Surface,
        			Size = UDim2.new(0, 120, 1, 0),
        			Stroke = {
        				Color = isPrimary and theme.Colors.PrimaryLight or theme.Colors.BorderMuted,
        				Thickness = 1,
        				Transparency = 0.3,
        			},
        		})
        
        		Creator.AddHoverEffect(btn, isPrimary and theme.Colors.PrimaryLight or theme.Colors.SurfaceHover)
        		Creator.AddRipple(btn)
        
        		btn.MouseButton1Click:Connect(function()
        			if btnConfig.Callback then
        				btnConfig.Callback()
        			end
        			popupObject:Close()
        		end)
        	end
        
        	modal.Size = UDim2.fromOffset(380, 0)
        	modal.BackgroundTransparency = 1
        	Animation.Tween(overlay, { BackgroundTransparency = theme.Transparency.Overlay }, theme.Animation.Normal)
        	Animation.ScaleIn(modal, theme.Animation.Normal)
        
        	return popupObject
        end
        return Popup
    end)()

    Modules["KeySystem"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        
        local KeySystem = {}
        
        function KeySystem.Open(config, filename, callback, VillainsUI)
        	config = config or {}
        	local ks = config.KeySystem or config
        	local theme = Theme
        	local enteredKey = ""
        	local services = {}
        
        	local overlay = Creator.New("TextButton", {
        		Name = "KeySystemOverlay",
        		Parent = Creator.GetScreenGui(),
        		Size = UDim2.fromScale(1, 1),
        		BackgroundColor3 = theme.Colors.Overlay,
        		BackgroundTransparency = 1,
        		Text = "",
        		AutoButtonColor = false,
        		ZIndex = 200,
        	})
        
        	local modal = Creator.New("Frame", {
        		Parent = overlay,
        		Size = UDim2.fromOffset(420, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		Position = UDim2.fromScale(0.5, 0.5),
        		AnchorPoint = Vector2.new(0.5, 0.5),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.02,
        		CornerRadius = theme.CornerRadius.Large,
        		Stroke = { Color = theme.Colors.Primary, Thickness = 2, Transparency = 0.3 },
        		ZIndex = 201,
        		Padding = {
        			PaddingTop = UDim.new(0, 24),
        			PaddingBottom = UDim.new(0, 24),
        			PaddingLeft = UDim.new(0, 24),
        			PaddingRight = UDim.new(0, 24),
        		},
        		ListLayout = { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 14) },
        	})
        
        	local header = Creator.New("Frame", {
        		Parent = modal,
        		Size = UDim2.new(1, 0, 0, 32),
        		BackgroundTransparency = 1,
        	})
        
        	Creator.Icon(ks.Icon or config.Icon or "🔑", header, UDim2.new(0, 28, 0, 28), theme.Colors.Primary)
        
        	Creator.Text({
        		Parent = header,
        		Text = ks.Title or config.Title or "Key System",
        		Font = theme.Font.Title,
        		TextSize = 20,
        		Size = UDim2.new(1, -40, 1, 0),
        		Position = UDim2.new(0, 36, 0, 0),
        	})
        
        	if ks.Note then
        		Creator.Text({
        			Parent = modal,
        			Text = ks.Note,
        			TextSize = 14,
        			TextColor3 = theme.Colors.TextSecondary,
        			TextWrapped = true,
        			Size = UDim2.new(1, 0, 0, 0),
        			AutomaticSize = Enum.AutomaticSize.Y,
        		})
        	end
        
        	if ks.Thumbnail and ks.Thumbnail.Image then
        		Creator.New("ImageLabel", {
        			Parent = modal,
        			Size = UDim2.new(1, 0, 0, ks.Thumbnail.Height or 120),
        			BackgroundTransparency = 1,
        			Image = ks.Thumbnail.Image,
        			ScaleType = Enum.ScaleType.Crop,
        			CornerRadius = theme.CornerRadius.Medium,
        		})
        	end
        
        	local keyInput = Creator.New("TextBox", {
        		Parent = modal,
        		Size = UDim2.new(1, 0, 0, 42),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = 0.1,
        		PlaceholderText = "Enter your key...",
        		PlaceholderColor3 = theme.Colors.TextMuted,
        		Text = "",
        		TextColor3 = theme.Colors.Text,
        		Font = theme.Font.Regular,
        		TextSize = 14,
        		ClearTextOnFocus = false,
        		CornerRadius = theme.CornerRadius.Medium,
        		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.5 },
        	})
        
        	keyInput:GetPropertyChangedSignal("Text"):Connect(function()
        		enteredKey = keyInput.Text
        	end)
        
        	local btnRow = Creator.New("Frame", {
        		Parent = modal,
        		Size = UDim2.new(1, 0, 0, 42),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Horizontal,
        			HorizontalAlignment = Enum.HorizontalAlignment.Right,
        			Padding = UDim.new(0, 8),
        		},
        	})
        
        	local function closeAndSuccess(key)
        		Animation.Tween(overlay, { BackgroundTransparency = 1 }, theme.Animation.Fast)
        		Animation.Tween(modal, { BackgroundTransparency = 1 }, theme.Animation.Fast, nil, nil, function()
        			overlay:Destroy()
        		end)
        		if ks.SaveKey ~= false and writefile then
        			local folder = config.Folder or "VillainsUI"
        			if not isfolder("VillainsUI") then makefolder("VillainsUI") end
        			if not isfolder("VillainsUI/" .. folder) then makefolder("VillainsUI/" .. folder) end
        			writefile("VillainsUI/" .. folder .. "/" .. filename .. ".key", tostring(key))
        		end
        		task.wait(0.3)
        		callback(true)
        	end
        
        	local function validateKey(key)
        		key = tostring(key or "")
        
        		if ks.KeyValidator then
        			return ks.KeyValidator(key)
        		end
        
        		if not ks.API then
        			if type(ks.Key) == "table" then
        				return table.find(ks.Key, key) ~= nil, key
        			end
        			return tostring(ks.Key) == key, key
        		end
        
        		for _, apiConfig in ipairs(ks.API) do
        			local serviceDef = VillainsUI.Services[apiConfig.Type]
        			if serviceDef then
        				local args = {}
        				for _, argName in ipairs(serviceDef.Args) do
        					table.insert(args, apiConfig[argName])
        				end
        				local service = serviceDef.New(table.unpack(args))
        				table.insert(services, service)
        			end
        		end
        
        		for _, service in ipairs(services) do
        			local ok, msg = service.Verify(key)
        			if ok then return true, msg end
        		end
        		return false, "Invalid key"
        	end
        
        	-- Get Key button (URL)
        	if ks.URL then
        		local getBtn = Creator.New("TextButton", {
        			Parent = btnRow,
        			Size = UDim2.new(0, 100, 1, 0),
        			BackgroundColor3 = theme.Colors.Surface,
        			Text = "Get Key",
        			TextColor3 = theme.Colors.Text,
        			Font = theme.Font.Body,
        			TextSize = 13,
        			AutoButtonColor = false,
        			CornerRadius = theme.CornerRadius.Medium,
        		})
        		getBtn.MouseButton1Click:Connect(function()
        			if setclipboard then setclipboard(ks.URL) end
        			VillainsUI:Notify({ Title = "Key System", Content = "Link copied!", Duration = 3 })
        		end)
        	end
        
        	-- API services dropdown
        	if ks.API then
        		for _, apiConfig in ipairs(ks.API) do
        			local serviceDef = VillainsUI.Services[apiConfig.Type]
        			if serviceDef then
        				local args = {}
        				for _, argName in ipairs(serviceDef.Args) do
        					table.insert(args, apiConfig[argName])
        				end
        				local service = serviceDef.New(table.unpack(args))
        				local svcBtn = Creator.New("TextButton", {
        					Parent = btnRow,
        					Size = UDim2.new(0, 110, 1, 0),
        					BackgroundColor3 = theme.Colors.PrimaryDark,
        					Text = apiConfig.Title or serviceDef.Name,
        					TextColor3 = theme.Colors.Text,
        					Font = theme.Font.Body,
        					TextSize = 12,
        					AutoButtonColor = false,
        					CornerRadius = theme.CornerRadius.Medium,
        				})
        				svcBtn.MouseButton1Click:Connect(function()
        					service.Copy()
        					VillainsUI:Notify({ Title = "Key System", Content = "Link copied!", Duration = 3 })
        				end)
        			end
        		end
        	end
        
        	local exitBtn = Creator.New("TextButton", {
        		Parent = btnRow,
        		Size = UDim2.new(0, 80, 1, 0),
        		BackgroundColor3 = theme.Colors.Surface,
        		Text = "Exit",
        		TextColor3 = theme.Colors.TextSecondary,
        		Font = theme.Font.Body,
        		TextSize = 13,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Medium,
        	})
        	exitBtn.MouseButton1Click:Connect(function()
        		overlay:Destroy()
        		callback(false)
        	end)
        
        	local submitBtn = Creator.New("TextButton", {
        		Parent = btnRow,
        		Size = UDim2.new(0, 100, 1, 0),
        		BackgroundColor3 = theme.Colors.Primary,
        		Text = "Submit",
        		TextColor3 = Color3.new(1, 1, 1),
        		Font = theme.Font.Title,
        		TextSize = 14,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Medium,
        		Gradient = { Color = theme.GetGradient("Glow") },
        	})
        	submitBtn.MouseButton1Click:Connect(function()
        		local ok, msg = validateKey(enteredKey)
        		if ok then
        			closeAndSuccess(enteredKey)
        		else
        			VillainsUI:Notify({
        				Title = "Key System Error",
        				Content = type(msg) == "string" and msg or "Invalid key!",
        				Type = "Error",
        				Duration = 4,
        			})
        		end
        	end)
        
        	Animation.Tween(overlay, { BackgroundTransparency = theme.Transparency.Overlay }, theme.Animation.Normal)
        	Animation.ScaleIn(modal, theme.Animation.Normal)
        end
        
        function KeySystem.CheckAndRun(config, filename, callback, VillainsUI)
        	local ks = config.KeySystem
        	if not ks then
        		callback(true)
        		return
        	end
        
        	local folder = config.Folder or "VillainsUI"
        	local keyPath = "VillainsUI/" .. folder .. "/" .. filename .. ".key"
        
        	local function openKeySystem()
        		KeySystem.Open(config, filename, callback, VillainsUI)
        	end
        
        	if ks.KeyValidator and ks.SaveKey and isfile and isfile(keyPath) then
        		local saved = readfile(keyPath)
        		if ks.KeyValidator(saved) then
        			callback(true)
        			return
        		end
        		openKeySystem()
        		return
        	end
        
        	if not ks.API then
        		if ks.SaveKey and isfile and isfile(keyPath) then
        			local saved = readfile(keyPath)
        			local valid = type(ks.Key) == "table" and table.find(ks.Key, saved) or tostring(ks.Key) == saved
        			if valid then
        				callback(true)
        				return
        			end
        		end
        		openKeySystem()
        		return
        	end
        
        	if isfile and isfile(keyPath) then
        		local saved = readfile(keyPath)
        		local ok = false
        		for _, apiConfig in ipairs(ks.API) do
        			local def = VillainsUI.Services[apiConfig.Type]
        			if def then
        				local args = {}
        				for _, a in ipairs(def.Args) do table.insert(args, apiConfig[a]) end
        				local svc = def.New(table.unpack(args))
        				local valid = svc.Verify(saved)
        				if valid then ok = true break end
        			end
        		end
        		if ok then callback(true) else openKeySystem() end
        	else
        		openKeySystem()
        	end
        end
        return KeySystem
    end)()

    Modules["Window"] = (function()
        local Theme = Import("Theme")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        local Elements = Import("Elements")
        local Paint = require(script.Parent.Parent.Core.Paint)
        
        local Window = {}
        Window.Instances = {}
        
        local function createTabContentHolder(parent, theme)
        	return Creator.New("ScrollingFrame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 1, 0),
        		BackgroundTransparency = 1,
        		BorderSizePixel = 0,
        		ScrollBarThickness = 3,
        		ScrollBarImageColor3 = theme.Colors.Primary,
        		AutomaticCanvasSize = Enum.AutomaticSize.Y,
        		CanvasSize = UDim2.new(),
        		Visible = false,
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, theme.Sizes.Gap),
        		},
        		Padding = {
        			PaddingTop = UDim.new(0, theme.Sizes.Padding),
        			PaddingBottom = UDim.new(0, theme.Sizes.Padding),
        			PaddingLeft = UDim.new(0, theme.Sizes.Padding),
        			PaddingRight = UDim.new(0, theme.Sizes.Padding),
        		},
        	})
        end
        
        local function createSectionHeader(parent, title, theme)
        	local section = Creator.New("Frame", {
        		Parent = parent,
        		Size = UDim2.new(1, 0, 0, 0),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        	})
        
        	Creator.Text({
        		Parent = section,
        		Text = title,
        		Font = theme.Font.Title,
        		TextSize = 13,
        		TextColor3 = theme.Colors.Primary,
        		Size = UDim2.new(1, 0, 0, 18),
        	})
        
        	local holder = Creator.New("Frame", {
        		Parent = section,
        		Size = UDim2.new(1, 0, 0, 0),
        		Position = UDim2.new(0, 0, 0, 22),
        		AutomaticSize = Enum.AutomaticSize.Y,
        		BackgroundTransparency = 1,
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, theme.Sizes.Gap),
        		},
        	})
        
        	return section, holder
        end
        
        local function bindElementMethods(target, holder, theme, windowObj)
        	local function register(el, cfg)
        		if cfg and cfg.Flag and windowObj and windowObj.PendingFlags and el.__type then
        			windowObj.PendingFlags[cfg.Flag] = el
        		end
        		return el
        	end
        
        	local function bindChild(childTarget, childHolder)
        		bindElementMethods(childTarget, childHolder, theme, windowObj)
        	end
        
        	function target:Button(cfg)
        		return register(Elements.CreateButton(holder, cfg, theme), cfg)
        	end
        	function target:Toggle(cfg)
        		return register(Elements.CreateToggle(holder, cfg, theme), cfg)
        	end
        	function target:Slider(cfg)
        		return register(Elements.CreateSlider(holder, cfg, theme), cfg)
        	end
        	function target:Input(cfg)
        		return register(Elements.CreateInput(holder, cfg, theme), cfg)
        	end
        	function target:Dropdown(cfg)
        		return register(Elements.CreateDropdown(holder, cfg, theme), cfg)
        	end
        	function target:Keybind(cfg)
        		return register(Elements.CreateKeybind(holder, cfg, theme), cfg)
        	end
        	function target:Colorpicker(cfg)
        		return register(Elements.CreateColorpicker(holder, cfg, theme), cfg)
        	end
        	function target:Checkbox(cfg)
        		return register(Elements.CreateCheckbox(holder, cfg, theme), cfg)
        	end
        	function target:Viewport(cfg)
        		return Elements.CreateViewport(holder, cfg, theme)
        	end
        	function target:Paragraph(cfg)
        		return Elements.CreateParagraph(holder, cfg, theme)
        	end
        	function target:Code(cfg)
        		return Elements.CreateCode(holder, cfg, theme)
        	end
        	function target:Image(cfg)
        		return Elements.CreateImage(holder, cfg, theme)
        	end
        	function target:Divider(cfg)
        		return Elements.CreateDivider(holder, cfg, theme)
        	end
        	function target:Space(cfg)
        		return Elements.CreateSpace(holder, cfg)
        	end
        	function target:Section(cfg)
        		createSectionHeader(holder, cfg.Title or "Section", theme)
        		return target
        	end
        	function target:Group(cfg)
        		return Elements.CreateGroup(holder, cfg, theme, bindChild)
        	end
        	function target:HStack(cfg)
        		return Elements.CreateHStack(holder, cfg, theme, bindChild)
        	end
        	function target:VStack(cfg)
        		return Elements.CreateVStack(holder, cfg, theme, bindChild)
        	end
        end
        
        function Window.Create(VillainsUI, config)
        	config = config or {}
        	local theme = Theme
        	local size = config.Size or UDim2.fromOffset(theme.Sizes.WindowWidth, theme.Sizes.WindowHeight)
        	local visible = true
        	local originalSize = size
        	local isFullscreen = false
        	local isTransparent = config.Transparent == true
        	local bgTransparency = config.BackgroundImageTransparency or 0.4
        
        	local windowObj = {
        		Tabs = {},
        		Tags = {},
        		TabSections = {},
        		CurrentTab = nil,
        		Visible = true,
        		Config = config,
        		Folder = config.Folder or config.Title or "VillainsUI",
        		PendingFlags = {},
        		CurrentConfig = nil,
        		AcrylicPaint = nil,
        		Transparent = isTransparent,
        	}
        
        	local gui = Creator.GetScreenGui()
        
        	local main = Creator.New("Frame", {
        		Name = "VillainsWindow",
        		Parent = gui,
        		Size = size,
        		Position = UDim2.new(0.5, 0, 0.5, 0),
        		AnchorPoint = Vector2.new(0.5, 0.5),
        		BackgroundColor3 = theme.Colors.Background,
        		BackgroundTransparency = isTransparent and 0.35 or theme.Transparency.Window,
        		CornerRadius = theme.CornerRadius.Large,
        		Stroke = {
        			Color = theme.Colors.Primary,
        			Thickness = 1.5,
        			Transparency = 0.5,
        		},
        		ClipsDescendants = true,
        	})
        
        	Creator.AddPremiumGlow(main, theme)
        
        	local bgHolder = Creator.New("Frame", {
        		Parent = main,
        		Size = UDim2.fromScale(1, 1),
        		BackgroundTransparency = 1,
        		ZIndex = 0,
        		ClipsDescendants = true,
        		CornerRadius = theme.CornerRadius.Large,
        	})
        
        	local function applyBackground(bg)
        		if not bg then return end
        		for _, child in ipairs(bgHolder:GetChildren()) do
        			if child:IsA("ImageLabel") or child:IsA("VideoFrame") or child:IsA("UIGradient") then
        				child:Destroy()
        			end
        		end
        
        		if type(bg) == "table" and bg.Color then
        			local gradFrame = Creator.New("Frame", {
        				Parent = bgHolder,
        				Size = UDim2.fromScale(1, 1),
        				BackgroundColor3 = Color3.new(1, 1, 1),
        				BackgroundTransparency = bgTransparency,
        				BorderSizePixel = 0,
        				ZIndex = 0,
        			})
        			local grad = Instance.new("UIGradient")
        			grad.Color = bg.Color
        			if bg.Transparency then grad.Transparency = bg.Transparency end
        			grad.Rotation = bg.Rotation or 0
        			grad.Parent = gradFrame
        		elseif type(bg) == "string" and string.sub(bg, 1, 6) == "video:" then
        			local video = Instance.new("VideoFrame")
        			video.Size = UDim2.fromScale(1, 1)
        			video.BackgroundTransparency = 1
        			video.Video = string.sub(bg, 7)
        			video.Looped = true
        			video.ZIndex = 0
        			video.Parent = bgHolder
        			pcall(function() video:Play() end)
        		elseif type(bg) == "string" and bg ~= "" then
        			local img = Creator.New("ImageLabel", {
        				Parent = bgHolder,
        				Size = UDim2.fromScale(1, 1),
        				BackgroundTransparency = 1,
        				Image = bg,
        				ScaleType = Enum.ScaleType.Crop,
        				ImageTransparency = bgTransparency,
        				ZIndex = 0,
        			})
        			img.Name = "BackgroundImage"
        		end
        	end
        
        	if config.Background then
        		applyBackground(config.Background)
        	end
        	windowObj.SetBackgroundImage = applyBackground
        
        	local topGlow = Creator.New("Frame", {
        		Parent = main,
        		Size = UDim2.new(1, 0, 0, 3),
        		BackgroundColor3 = theme.Colors.Primary,
        		BorderSizePixel = 0,
        		ZIndex = 5,
        		Gradient = { Color = theme.GetGradient("Glow") },
        	})
        	Animation.Shimmer(topGlow)
        
        	local topbar = Creator.New("Frame", {
        		Parent = main,
        		Size = UDim2.new(1, 0, 0, theme.Sizes.TopbarHeight),
        		Position = UDim2.new(0, 0, 0, 2),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.3,
        		BorderSizePixel = 0,
        	})
        
        	local iconLabel
        	if config.Icon then
        		iconLabel = Creator.Icon(config.Icon, topbar, UDim2.new(0, 28, 0, 28), theme.Colors.Primary)
        		if iconLabel then
        			iconLabel.Position = UDim2.new(0, 14, 0.5, -14)
        		end
        	end
        
        	Creator.Text({
        		Parent = topbar,
        		Text = config.Title or "VILLAINS UI",
        		Font = theme.Font.Title,
        		TextSize = 16,
        		Size = UDim2.new(0.5, 0, 0, 20),
        		Position = UDim2.new(0, config.Icon and 50 or 14, 0, 8),
        	})
        
        	if config.Author then
        		Creator.Text({
        			Parent = topbar,
        			Text = config.Author,
        			TextSize = 11,
        			TextColor3 = theme.Colors.TextSecondary,
        			Size = UDim2.new(0.5, 0, 0, 14),
        			Position = UDim2.new(0, config.Icon and 50 or 14, 0, 28),
        		})
        	end
        
        	if config.User and config.User.Enabled ~= false then
        		local userBtn = Creator.New("TextButton", {
        			Parent = topbar,
        			Size = UDim2.new(0, 32, 0, 32),
        			Position = UDim2.new(1, -118, 0.5, -16),
        			BackgroundColor3 = theme.Colors.PrimaryDark,
        			Text = "👤",
        			TextSize = 16,
        			AutoButtonColor = false,
        			CornerRadius = theme.CornerRadius.Full,
        		})
        		userBtn.MouseButton1Click:Connect(function()
        			if config.User.Callback then config.User.Callback() end
        		end)
        	end
        
        	local controls = Creator.New("Frame", {
        		Parent = topbar,
        		Size = UDim2.new(0, 70, 1, 0),
        		Position = UDim2.new(1, -80, 0, 0),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Horizontal,
        			HorizontalAlignment = Enum.HorizontalAlignment.Right,
        			VerticalAlignment = Enum.VerticalAlignment.Center,
        			Padding = UDim.new(0, 6),
        		},
        	})
        
        	local minimizeBtn = Creator.New("TextButton", {
        		Parent = controls,
        		Size = UDim2.new(0, 28, 0, 28),
        		BackgroundColor3 = theme.Colors.Surface,
        		BackgroundTransparency = 0.5,
        		Text = "—",
        		TextColor3 = theme.Colors.TextSecondary,
        		Font = theme.Font.Title,
        		TextSize = 16,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Full,
        	})
        
        	local closeBtn = Creator.New("TextButton", {
        		Parent = controls,
        		Size = UDim2.new(0, 28, 0, 28),
        		BackgroundColor3 = theme.Colors.PrimaryDark,
        		BackgroundTransparency = 0.3,
        		Text = "×",
        		TextColor3 = theme.Colors.Text,
        		Font = theme.Font.Title,
        		TextSize = 18,
        		AutoButtonColor = false,
        		CornerRadius = theme.CornerRadius.Full,
        	})
        
        	local body = Creator.New("Frame", {
        		Parent = main,
        		Size = UDim2.new(1, 0, 1, -theme.Sizes.TopbarHeight - 2),
        		Position = UDim2.new(0, 0, 0, theme.Sizes.TopbarHeight + 2),
        		BackgroundTransparency = 1,
        	})
        
        	local sidebar = Creator.New("ScrollingFrame", {
        		Parent = body,
        		Size = UDim2.new(0, config.SideBarWidth or theme.Sizes.SidebarWidth, 1, 0),
        		BackgroundColor3 = theme.Colors.BackgroundSecondary,
        		BackgroundTransparency = 0.4,
        		BorderSizePixel = 0,
        		ScrollBarThickness = 0,
        		AutomaticCanvasSize = Enum.AutomaticSize.Y,
        		CanvasSize = UDim2.new(),
        		ListLayout = {
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 4),
        		},
        		Padding = {
        			PaddingTop = UDim.new(0, 8),
        			PaddingBottom = UDim.new(0, 8),
        			PaddingLeft = UDim.new(0, 8),
        			PaddingRight = UDim.new(0, 8),
        		},
        	})
        
        	local searchBox
        	if config.HideSearchBar ~= true then
        		searchBox = Creator.New("TextBox", {
        			Parent = sidebar,
        			Size = UDim2.new(1, -16, 0, 32),
        			BackgroundColor3 = theme.Colors.Surface,
        			BackgroundTransparency = 0.4,
        			PlaceholderText = "Search tabs...",
        			PlaceholderColor3 = theme.Colors.TextMuted,
        			Text = "",
        			TextColor3 = theme.Colors.Text,
        			Font = theme.Font.Regular,
        			TextSize = 12,
        			ClearTextOnFocus = false,
        			CornerRadius = theme.CornerRadius.Small,
        			LayoutOrder = -1,
        			Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.7 },
        		})
        		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        			local q = string.lower(searchBox.Text)
        			for _, tab in ipairs(windowObj.Tabs) do
        				local match = q == "" or string.find(string.lower(tab.Title or ""), q, 1, true)
        				tab.Button.Visible = match ~= nil
        			end
        		end)
        		searchBox.Focused:Connect(function()
        			Animation.Tween(searchBox, { BackgroundTransparency = 0.15 }, theme.Animation.Fast)
        		end)
        		searchBox.FocusLost:Connect(function()
        			Animation.Tween(searchBox, { BackgroundTransparency = 0.4 }, theme.Animation.Fast)
        		end)
        	end
        
        	local contentArea = Creator.New("Frame", {
        		Parent = body,
        		Size = UDim2.new(1, -(config.SideBarWidth or theme.Sizes.SidebarWidth), 1, 0),
        		Position = UDim2.new(0, config.SideBarWidth or theme.Sizes.SidebarWidth, 0, 0),
        		BackgroundTransparency = 1,
        		ClipsDescendants = true,
        	})
        
        	local tagBar = Creator.New("Frame", {
        		Parent = contentArea,
        		Size = UDim2.new(1, -16, 0, 28),
        		Position = UDim2.new(0, 8, 0, 8),
        		BackgroundTransparency = 1,
        		ListLayout = {
        			FillDirection = Enum.FillDirection.Horizontal,
        			SortOrder = Enum.SortOrder.LayoutOrder,
        			Padding = UDim.new(0, 6),
        		},
        	})
        
        	local tabContainer = Creator.New("Frame", {
        		Parent = contentArea,
        		Size = UDim2.new(1, 0, 1, -44),
        		Position = UDim2.new(0, 0, 0, 44),
        		BackgroundTransparency = 1,
        	})
        
        	Creator.MakeDraggable(main, topbar)
        
        	local openButton
        	if config.OpenButton == nil or config.OpenButton.Enabled ~= false then
        		local obConfig = config.OpenButton or {}
        		openButton = Creator.New("TextButton", {
        			Name = "VillainsOpenButton",
        			Parent = gui,
        			Size = UDim2.new(0, 56, 0, 56),
        			Position = UDim2.new(0, 20, 0.5, 0),
        			AnchorPoint = Vector2.new(0, 0.5),
        			BackgroundColor3 = theme.Colors.Primary,
        			BackgroundTransparency = 0.1,
        			Text = obConfig.Title and string.sub(obConfig.Title, 1, 1) or "V",
        			TextColor3 = Color3.new(1, 1, 1),
        			Font = theme.Font.Title,
        			TextSize = 22,
        			AutoButtonColor = false,
        			CornerRadius = obConfig.CornerRadius or theme.CornerRadius.Full,
        			Stroke = {
        				Color = theme.Colors.Glow,
        				Thickness = obConfig.StrokeThickness or 2,
        				Transparency = 0.3,
        			},
        			Gradient = { Color = theme.GetGradient("Glow"), Rotation = 45 },
        		})
        
        		if obConfig.Color then
        			openButton:FindFirstChildOfClass("UIGradient").Color = obConfig.Color
        		end
        
        		Creator.MakeDraggable(openButton)
        
        		openButton.MouseButton1Click:Connect(function()
        			windowObj:Toggle()
        		end)
        
        		task.spawn(function()
        			while openButton.Parent do
        				Animation.Tween(openButton, { BackgroundTransparency = 0.05 }, 0.8)
        				task.wait(0.8)
        				Animation.Tween(openButton, { BackgroundTransparency = 0.2 }, 0.8)
        				task.wait(0.8)
        			end
        		end)
        	end
        
        	function windowObj:Toggle()
        		self:SetVisible(not self.Visible)
        	end
        
        	function windowObj:SetVisible(state)
        		self.Visible = state
        		if state then
        			main.Visible = true
        			Animation.ScaleIn(main, theme.Animation.Normal)
        		else
        			Animation.Tween(main, {
        				Size = UDim2.new(size.X.Scale, size.X.Offset * 0.95, size.Y.Scale, size.Y.Offset * 0.95),
        				BackgroundTransparency = 1,
        			}, theme.Animation.Fast, nil, nil, function()
        				main.Visible = false
        				main.Size = size
        			end)
        		end
        	end
        
        	function windowObj:Destroy()
        		Animation.FadeOut(main, theme.Animation.Normal, function()
        			main:Destroy()
        			if openButton then
        				openButton:Destroy()
        			end
        		end)
        		for i, w in ipairs(Window.Instances) do
        			if w == windowObj then
        				table.remove(Window.Instances, i)
        				break
        			end
        		end
        	end
        
        	function windowObj:Tag(cfg)
        		local tag = Creator.New("Frame", {
        			Parent = tagBar,
        			Size = UDim2.new(0, 0, 0, 24),
        			AutomaticSize = Enum.AutomaticSize.X,
        			BackgroundColor3 = cfg.Color or theme.Colors.PrimaryDark,
        			BackgroundTransparency = 0.2,
        			CornerRadius = theme.CornerRadius.Small,
        			Stroke = cfg.Border and {
        				Color = cfg.Color or theme.Colors.Primary,
        				Thickness = 1,
        				Transparency = 0.4,
        			} or nil,
        			Padding = {
        				PaddingLeft = UDim.new(0, 8),
        				PaddingRight = UDim.new(0, 8),
        			},
        			ListLayout = {
        				FillDirection = Enum.FillDirection.Horizontal,
        				VerticalAlignment = Enum.VerticalAlignment.Center,
        				Padding = UDim.new(0, 4),
        			},
        		})
        
        		if cfg.Icon then
        			Creator.Icon(cfg.Icon, tag, UDim2.new(0, 14, 0, 14))
        		end
        
        		Creator.Text({
        			Parent = tag,
        			Text = cfg.Title or "Tag",
        			TextSize = 11,
        			Size = UDim2.new(0, 0, 0, 24),
        			AutomaticSize = Enum.AutomaticSize.X,
        		})
        
        		table.insert(windowObj.Tags, tag)
        		return tag
        	end
        
        	function windowObj:SelectTab(tabObj)
        		for _, tab in ipairs(windowObj.Tabs) do
        			local active = tab == tabObj
        			tab.Content.Visible = active
        			Animation.Tween(tab.Button, {
        				BackgroundTransparency = active and 0.05 or 0.6,
        				BackgroundColor3 = active and theme.Colors.PrimaryDark or theme.Colors.Surface,
        			}, theme.Animation.Fast)
        
        			local stroke = tab.Button:FindFirstChildOfClass("UIStroke")
        			if stroke then
        				stroke.Color = active and theme.Colors.Primary or theme.Colors.BorderMuted
        				stroke.Transparency = active and 0.2 or 0.7
        			end
        		end
        		windowObj.CurrentTab = tabObj
        
        		if tabObj.Content.Visible then
        			tabObj.Content.Position = UDim2.new(0.02, 0, 0, 0)
        			Animation.Tween(tabObj.Content, { Position = UDim2.new(0, 0, 0, 0) }, theme.Animation.Normal)
        		end
        	end
        
        	function windowObj:Tab(cfg)
        		cfg = cfg or {}
        		local tabObj = {
        			Title = cfg.Title or "Tab",
        			Config = cfg,
        		}
        
        		tabObj.Button = Creator.New("TextButton", {
        			Parent = sidebar,
        			Size = UDim2.new(1, 0, 0, 40),
        			BackgroundColor3 = theme.Colors.Surface,
        			BackgroundTransparency = 0.6,
        			Text = "",
        			AutoButtonColor = false,
        			CornerRadius = theme.CornerRadius.Medium,
        			Stroke = {
        				Color = cfg.Border and (cfg.IconColor or theme.Colors.Primary) or theme.Colors.BorderMuted,
        				Thickness = cfg.Border and 1.5 or 1,
        				Transparency = cfg.Border and 0.25 or 0.7,
        			},
        		})
        
        		if cfg.Icon then
        			Creator.Icon(cfg.Icon, tabObj.Button, UDim2.new(0, 18, 0, 18), cfg.IconColor or theme.Colors.Primary)
        		end
        
        		Creator.Text({
        			Parent = tabObj.Button,
        			Text = cfg.Title or "Tab",
        			Size = UDim2.new(1, cfg.Icon and -36 or -16, 1, 0),
        			Position = UDim2.new(0, cfg.Icon and 32 or 12, 0, 0),
        		})
        
        		tabObj.Content = createTabContentHolder(tabContainer, theme)
        		bindElementMethods(tabObj, tabObj.Content, theme, windowObj)
        
        		if cfg.Locked then
        			tabObj.Locked = true
        			tabObj.Button.BackgroundTransparency = 0.8
        		end
        
        		tabObj.Button.MouseButton1Click:Connect(function()
        			if tabObj.Locked then
        				VillainsUI:Notify({ Title = "Locked", Content = "This tab is locked.", Type = "Warning", Duration = 2 })
        				return
        			end
        			windowObj:SelectTab(tabObj)
        		end)
        
        		Creator.AddHoverEffect(tabObj.Button, theme.Colors.SurfaceHover, theme.Colors.Surface, 0.6, 0.3)
        
        		table.insert(windowObj.Tabs, tabObj)
        
        		if #windowObj.Tabs == 1 then
        			windowObj:SelectTab(tabObj)
        		end
        
        		return tabObj
        	end
        
        	function windowObj:Section(cfg)
        		local tabObj = windowObj:Tab({
        			Title = cfg.Title or "Section",
        			Icon = cfg.Icon or "◆",
        		})
        		return tabObj
        	end
        
        	function windowObj:TabSection(cfg)
        		local sectionLabel = Creator.New("TextLabel", {
        			Parent = sidebar,
        			Size = UDim2.new(1, -16, 0, 24),
        			BackgroundTransparency = 1,
        			Text = cfg.Title or "Section",
        			TextColor3 = theme.Colors.TextMuted,
        			Font = theme.Font.Title,
        			TextSize = 11,
        			TextXAlignment = Enum.TextXAlignment.Left,
        		})
        		table.insert(windowObj.TabSections, sectionLabel)
        		return sectionLabel
        	end
        
        	function windowObj:SetCurrentConfig(cfg)
        		windowObj.CurrentConfig = cfg
        	end
        
        	function windowObj:SaveConfig(name)
        		if VillainsUI.ConfigManager then
        			local cfg = VillainsUI.ConfigManager:Config(name)
        			return cfg:Save()
        		end
        	end
        
        	function windowObj:LoadConfig(name)
        		if VillainsUI.ConfigManager then
        			local cfg = VillainsUI.ConfigManager:Config(name)
        			return cfg:Load()
        		end
        	end
        
        	function windowObj:SetUIScale(scale)
        		local uiScale = main:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        		uiScale.Scale = scale or 1
        		uiScale.Parent = main
        	end
        
        	function windowObj:EditOpenButton(cfg)
        		if not openButton then return end
        		if cfg.Title then openButton.Text = string.sub(cfg.Title, 1, 1) end
        		if cfg.Enabled == false then openButton.Visible = false end
        	end
        
        	function windowObj:SetTitle(title)
        		local titleLabel = topbar:FindFirstChild("Text")
        		if titleLabel then titleLabel.Text = title end
        	end
        
        	function windowObj:SetAuthor(author)
        		for _, child in ipairs(topbar:GetChildren()) do
        			if child:IsA("TextLabel") and child.TextSize == 11 then
        				child.Text = author
        				break
        			end
        		end
        	end
        
        	function windowObj:SetSize(newSize)
        		size = newSize
        		originalSize = newSize
        		main.Size = newSize
        	end
        
        	function windowObj:SetBackgroundImage(bg)
        		applyBackground(bg)
        	end
        
        	function windowObj:SetBackgroundImageTransparency(value)
        		bgTransparency = value
        		local img = bgHolder:FindFirstChild("BackgroundImage")
        		if img then img.ImageTransparency = value end
        	end
        
        	function windowObj:ToggleTransparency(state)
        		isTransparent = state ~= false
        		Animation.Tween(main, {
        			BackgroundTransparency = isTransparent and 0.35 or theme.Transparency.Window,
        		}, theme.Animation.Normal)
        		windowObj.Transparent = isTransparent
        	end
        
        	function windowObj:SetPanelBackground(state)
        		main.BackgroundTransparency = state and theme.Transparency.Window or 1
        	end
        
        	function windowObj:ToggleFullscreen(state)
        		isFullscreen = state ~= false
        		if isFullscreen then
        			Animation.Tween(main, {
        				Size = UDim2.new(1, -40, 1, -40),
        				Position = UDim2.new(0.5, 0, 0.5, 0),
        			}, theme.Animation.Normal)
        		else
        			Animation.Tween(main, {
        				Size = originalSize,
        				Position = UDim2.new(0.5, 0, 0.5, 0),
        			}, theme.Animation.Normal)
        		end
        	end
        
        	function windowObj:ToggleAcrylic(state)
        		if windowObj.AcrylicPaint then
        			if state == false then
        				windowObj.AcrylicPaint.Disable()
        			else
        				windowObj.AcrylicPaint.Enable()
        			end
        		end
        	end
        
        	minimizeBtn.MouseButton1Click:Connect(function()
        		windowObj:SetVisible(false)
        	end)
        
        	closeBtn.MouseButton1Click:Connect(function()
        		windowObj:Destroy()
        	end)
        
        	closeBtn.MouseEnter:Connect(function()
        		Animation.Tween(closeBtn, { BackgroundColor3 = theme.Colors.Error }, theme.Animation.Fast)
        	end)
        	closeBtn.MouseLeave:Connect(function()
        		Animation.Tween(closeBtn, { BackgroundColor3 = theme.Colors.PrimaryDark }, theme.Animation.Fast)
        	end)
        
        	windowObj.Gui = main
        	windowObj.OpenButton = openButton
        
        	if config.Acrylic then
        		local ok, paint = pcall(function()
        			return Paint.Create(gui, true)
        		end)
        		if ok and paint then
        			windowObj.AcrylicPaint = paint
        			VillainsUI.AcrylicEnabled = true
        		else
        			warn("[VillainsUI] Acrylic not supported on this executor.")
        		end
        	end
        
        	main.Size = UDim2.new(size.X.Scale, size.X.Offset * 0.9, size.Y.Scale, size.Y.Offset * 0.9)
        	main.BackgroundTransparency = 1
        	Animation.ScaleIn(main, theme.Animation.Slow)
        
        	table.insert(Window.Instances, windowObj)
        	return windowObj
        end
        return Window
    end)()

    Modules["VillainsUI"] = (function()
        local Compat = Import("Compat")
        Compat.Apply()
        
        local Theme = Import("Theme")
        local Themes = Import("Themes")
        local Creator = Import("Creator")
        local Animation = Import("Animation")
        local Paint = Import("Paint")
        local Window = Import("Window")
        local Notification = Import("Notification")
        local Popup = Import("Popup")
        local KeySystem = Import("KeySystem")
        local Localization = Import("Localization")
        local ConfigManager = Import("Config")
        local Services = Import("Services")
        
        Theme.Version = "3.0.0"
        
        local VillainsUI = {
        	Version = Theme.Version,
        	Theme = Theme.Name,
        	TransparencyValue = Theme.Transparency.Window,
        	UIScale = 1,
        	Window = nil,
        	AcrylicEnabled = false,
        	Services = Services,
        	ConfigManager = ConfigManager,
        	LocalizationModule = nil,
        	OnThemeChange = nil,
        	CustomFont = nil,
        }
        
        Notification.Init(VillainsUI)
        
        function VillainsUI:SetTheme(themeName)
        	local applied = Themes.Apply(themeName)
        	if applied and self.OnThemeChange then
        		self.OnThemeChange(themeName)
        	end
        	return self
        end
        
        function VillainsUI:ToggleAcrylic(state)
        	if VillainsUI.Window and VillainsUI.Window.AcrylicPaint then
        		if state == false then
        			VillainsUI.Window.AcrylicPaint.Disable()
        			self.AcrylicEnabled = false
        		else
        			VillainsUI.Window.AcrylicPaint.Enable()
        			self.AcrylicEnabled = true
        		end
        	elseif state ~= false and not VillainsUI.Window then
        		warn("[VillainsUI] Create a window with Acrylic = true first.")
        	end
        	return self
        end
        
        function VillainsUI:SetFont(assetId)
        	if assetId then
        		self.CustomFont = assetId
        		local ok, fontFace = pcall(function()
        			return Font.new(assetId, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        		end)
        		if ok and fontFace then
        			Theme.FontFace = fontFace
        		end
        	end
        	return self
        end
        
        function VillainsUI:AddTheme(name, overrides)
        	Themes[name] = Themes.Get("DarkRed") -- base clone would be better but Apply works
        	if overrides and overrides.Colors then
        		for k, v in pairs(overrides.Colors) do
        			Theme.Colors[k] = v
        		end
        	end
        	return self
        end
        
        function VillainsUI:GetThemes()
        	return Themes.List()
        end
        
        function VillainsUI:GetCurrentTheme()
        	return Theme.Name
        end
        
        function VillainsUI:SetTransparency(value)
        	self.TransparencyValue = value
        	Theme.Transparency.Window = value
        	return self
        end
        
        function VillainsUI:OnThemeChangeFunc(func)
        	self.OnThemeChange = func
        end
        
        function VillainsUI:Localization(config)
        	self.LocalizationModule = Localization.New(config)
        	return self.LocalizationModule
        end
        
        function VillainsUI:SetLanguage(lang)
        	if self.LocalizationModule then
        		return self.LocalizationModule:SetLanguage(lang)
        	end
        	return false
        end
        
        function VillainsUI:Translate(text)
        	if self.LocalizationModule then
        		return self.LocalizationModule:Translate(text)
        	end
        	return text
        end
        
        function VillainsUI:Gradient(stops, props)
        	local colorSequence = {}
        	local transparencySequence = {}
        	for posStr, stop in pairs(stops) do
        		local position = math.clamp(tonumber(posStr) / 100, 0, 1)
        		local color = stop.Color
        		if typeof(color) == "string" then
        			color = Color3.fromHex(color)
        		end
        		table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
        		table.insert(transparencySequence, NumberSequenceKeypoint.new(position, stop.Transparency or 0))
        	end
        	table.sort(colorSequence, function(a, b) return a.Time < b.Time end)
        	if #colorSequence < 2 then
        		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
        	end
        	return {
        		Color = ColorSequence.new(colorSequence),
        		Transparency = NumberSequence.new(transparencySequence),
        		Rotation = props and props.Rotation or 0,
        	}
        end
        
        function VillainsUI:Notify(config)
        	if self.LocalizationModule then
        		config.Title = self:Translate(config.Title)
        		config.Content = self:Translate(config.Content)
        	end
        	return Notification.Create(config)
        end
        
        function VillainsUI:Popup(config)
        	if self.LocalizationModule then
        		config.Title = self:Translate(config.Title)
        		config.Content = self:Translate(config.Content)
        	end
        	return Popup.Create(self, config)
        end
        
        function VillainsUI:Dialog(config)
        	config = config or {}
        	if self.LocalizationModule then
        		config.Title = self:Translate(config.Title)
        		config.Content = self:Translate(config.Content)
        	end
        	if not config.Buttons then
        		config.Buttons = {
        			{ Title = "Cancel", Variant = "Secondary" },
        			{ Title = "Confirm", Variant = "Primary", Callback = config.Callback },
        		}
        	end
        	return Popup.Create(self, config)
        end
        
        function VillainsUI:CreateWindow(config)
        	config = config or {}
        
        	if writefile and not game:GetService("RunService"):IsStudio() then
        		if not isfolder("VillainsUI") then makefolder("VillainsUI") end
        		local folder = config.Folder or config.Title or "VillainsUI"
        		if not isfolder("VillainsUI/" .. folder) then makefolder("VillainsUI/" .. folder) end
        	end
        
        	local Players = game:GetService("Players")
        	local hwid = gethwid and gethwid() or tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or "0")
        	local canLoad = true
        	local finished = true
        
        	if config.KeySystem then
        		canLoad = false
        		finished = false
        		KeySystem.CheckAndRun(config, hwid, function(result)
        			canLoad = result
        			finished = true
        		end, self)
        		repeat task.wait() until finished
        		if not canLoad then
        			return nil
        		end
        	end
        
        	if VillainsUI.Window then
        		warn("[VillainsUI] Only one window allowed per instance.")
        		return VillainsUI.Window
        	end
        
        	local window = Window.Create(self, config)
        	VillainsUI.Window = window
        
        	if config.Folder and writefile then
        		ConfigManager:Init(window)
        	end
        
        	return window
        end
        
        function VillainsUI:Destroy()
        	if VillainsUI.Window and VillainsUI.Window.AcrylicPaint then
        		VillainsUI.Window.AcrylicPaint.Destroy()
        	end
        	if Creator.ScreenGui then
        		Creator.ScreenGui:Destroy()
        		Creator.ScreenGui = nil
        	end
        	VillainsUI.Window = nil
        end
        return VillainsUI
    end)()

    return Import("VillainsUI")
end)()