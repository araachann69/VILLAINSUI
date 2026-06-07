--[[
	VILLAINS UI Library - Instance Creator
]]

local Theme = require(script.Parent.Theme)

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
		if key == "Parent" then
			continue
		end
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
			require(script.Parent.Animation).Tween(glow:FindFirstChildOfClass("UIStroke"), { Transparency = 0.4 }, 1.2)
			task.wait(1.2)
			require(script.Parent.Animation).Tween(glow:FindFirstChildOfClass("UIStroke"), { Transparency = 0.85 }, 1.2)
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
		require(script.Parent.Animation).Tween(gui, {
			BackgroundColor3 = hoverColor,
			BackgroundTransparency = hoverTransparency,
		}, theme.Animation.Fast)
	end)

	gui.MouseLeave:Connect(function()
		require(script.Parent.Animation).Tween(gui, {
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

		require(script.Parent.Animation).Tween(ripple, {
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
