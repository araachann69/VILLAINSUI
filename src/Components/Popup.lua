--[[
	VILLAINS UI Library - Popup Component
]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)

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
