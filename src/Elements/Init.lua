--[[
	VILLAINS UI Library - UI Elements
]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)
local Tooltip = require(script.Parent.Parent.Components.Tooltip)

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
	local h, s, v = Color3.toHSV(color)

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
		h, s, v = Color3.toHSV(c)
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
