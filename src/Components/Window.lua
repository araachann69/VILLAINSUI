--[[
	VILLAINS UI Library - Window Component
]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)
local Elements = require(script.Parent.Parent.Elements.Init)
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
		windowObj.AcrylicPaint = Paint.Create(gui, true)
		VillainsUI.AcrylicEnabled = true
	end

	main.Size = UDim2.new(size.X.Scale, size.X.Offset * 0.9, size.Y.Scale, size.Y.Offset * 0.9)
	main.BackgroundTransparency = 1
	Animation.ScaleIn(main, theme.Animation.Slow)

	table.insert(Window.Instances, windowObj)
	return windowObj
end

return Window
