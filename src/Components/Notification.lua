--[[
	VILLAINS UI Library - Notification Component
]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)

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
