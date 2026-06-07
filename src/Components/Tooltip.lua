--[[
	VILLAINS UI Library - Tooltip Component
]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)

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
