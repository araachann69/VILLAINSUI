--[[
	VILLAINS UI Library v3.0.0 - Premium Full Edition
]]

local Theme = require(script.Parent.Core.Theme)
local Themes = require(script.Parent.Core.Themes)
local Creator = require(script.Parent.Core.Creator)
local Animation = require(script.Parent.Core.Animation)
local Paint = require(script.Parent.Core.Paint)
local Window = require(script.Parent.Components.Window)
local Notification = require(script.Parent.Components.Notification)
local Popup = require(script.Parent.Components.Popup)
local KeySystem = require(script.Parent.Components.KeySystem)
local Localization = require(script.Parent.Modules.Localization)
local ConfigManager = require(script.Parent.Modules.Config)
local Services = require(script.Parent.Services.Init)

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
