--[[
	VILLAINS UI Library - Dark Red Theme
]]

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
