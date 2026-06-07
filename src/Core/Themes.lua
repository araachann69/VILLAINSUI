--[[ VILLAINS UI - Theme Registry ]]

local BaseTheme = require(script.Parent.Parent.Core.Theme)

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
