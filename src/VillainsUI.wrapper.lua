--[[
    VILLAINS UI v3.1.0 — Premium Dark Red
    Core: WindUI (Footagesus/WindUI) — MIT License
    Rebranded API + premium dark-red defaults

    local loadfn = loadstring or load
    local VillainsUI = loadfn(game:HttpGet("YOUR_URL"))()
]]

local VILLAINS_VERSION = "3.1.0"
local WINDUI_URL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"

local function fromHex(hex)
	if Color3.fromHex then
		return Color3.fromHex(hex)
	end
	hex = string.gsub(hex, "#", "")
	return Color3.new(
		tonumber(string.sub(hex, 1, 2), 16) / 255,
		tonumber(string.sub(hex, 3, 4), 16) / 255,
		tonumber(string.sub(hex, 5, 6), 16) / 255
	)
end

local function httpGet(url)
	local ok, body = pcall(function()
		return game:HttpGet(url, true)
	end)
	if ok and type(body) == "string" and #body > 500 and not string.find(body, "<!DOCTYPE", 1, true) then
		return body
	end
	if syn and syn.request then
		local res = syn.request({ Url = url, Method = "GET" })
		if res and res.Body and #res.Body > 500 then
			return res.Body
		end
	end
	if http and http.request then
		local res = http.request({ Url = url, Method = "GET" })
		if res and res.Body and #res.Body > 500 then
			return res.Body
		end
	end
	if request then
		local res = request({ Url = url, Method = "GET" })
		if res and res.Body and #res.Body > 500 then
			return res.Body
		end
	end
	error("[VillainsUI] HttpGet failed: " .. tostring(url))
end

local loadfn = loadstring or load
if not loadfn then
	error("[VillainsUI] Executor tidak support loadstring/load. Gunakan Delta/Solara/Fluxus terbaru.")
end

local src = httpGet(WINDUI_URL)
local chunk, compileErr = loadfn(src, "WindUI")
if not chunk then
	error("[VillainsUI] WindUI compile error: " .. tostring(compileErr))
end

local runOk, WindUI = pcall(chunk)
if not runOk or type(WindUI) ~= "table" then
	error("[VillainsUI] WindUI init error: " .. tostring(WindUI))
end

local function pickThemeName()
	local themes = WindUI:GetThemes()
	if themes then
		if themes.Rose then return "Rose" end
		if themes.Dark then return "Dark" end
		if themes.Red then return "Red" end
		for name, theme in pairs(themes) do
			if type(theme) == "table" then
				return theme.Name or name
			end
		end
	end
	return "Dark"
end

local DEFAULT_THEME = pickThemeName()
local CRIMSON = fromHex("#DC143C")
local CRIMSON_DARK = fromHex("#8B0000")

local VillainsUI = setmetatable({}, { __index = WindUI })

VillainsUI.Version = VILLAINS_VERSION
VillainsUI.Name = "VILLAINS UI"
VillainsUI.WindUI = WindUI
VillainsUI.DefaultTheme = DEFAULT_THEME

function VillainsUI:CreateWindow(config)
	config = config or {}
	config.Theme = config.Theme or DEFAULT_THEME
	config.Transparent = config.Transparent ~= false

	if config.OpenButton == nil then
		config.OpenButton = {
			Title = "V",
			Enabled = true,
			Color = ColorSequence.new(CRIMSON_DARK, CRIMSON),
			CornerRadius = UDim.new(1, 0),
			StrokeThickness = 2,
		}
	else
		config.OpenButton.Color = config.OpenButton.Color
			or ColorSequence.new(CRIMSON_DARK, CRIMSON)
	end

	local window = WindUI:CreateWindow(config)
	self.Window = window
	return window
end

function VillainsUI:SetTheme(name)
	if name == "VillainsDarkRed" or name == "DarkRed" then
		return WindUI:SetTheme(DEFAULT_THEME)
	end
	return WindUI:SetTheme(name)
end

return VillainsUI
