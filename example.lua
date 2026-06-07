--[[
    VILLAINS UI Library v3.0.0 - Premium Full Example
    Compatible with Delta Mobile & other executors
]]

local LIBRARY_URL = "https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"

local function loadVillainsUI()
	local loader = loadstring or load
	if not loader then
		error("[VILLAINS UI] Executor tidak support loadstring/load. Gunakan executor lain.")
	end

	local source
	local ok, result = pcall(function()
		return game:HttpGet(LIBRARY_URL, true)
	end)

	if ok and type(result) == "string" and result ~= "" and not string.find(result, "<!DOCTYPE", 1, true) then
		source = result
	elseif syn and syn.request then
		local res = syn.request({ Url = LIBRARY_URL, Method = "GET" })
		source = res and res.Body
	elseif http and http.request then
		local res = http.request({ Url = LIBRARY_URL, Method = "GET" })
		source = res and res.Body
	elseif request then
		local res = request({ Url = LIBRARY_URL, Method = "GET" })
		source = res and res.Body
	end

	if not source or source == "" then
		error("[VILLAINS UI] Gagal download library. Cek koneksi internet & URL GitHub.")
	end

	local fn, compileErr = loader(source, "VillainsUI")
	if not fn then
		error("[VILLAINS UI] Gagal compile: " .. tostring(compileErr))
	end

	local libOk, VillainsUI = pcall(fn)
	if not libOk then
		error("[VILLAINS UI] Gagal run library: " .. tostring(VillainsUI))
	end

	if type(VillainsUI) ~= "table" then
		error("[VILLAINS UI] Library return nil. Pastikan dist/VillainsUI.lua sudah di-upload ke GitHub.")
	end

	return VillainsUI
end

local VillainsUI = loadVillainsUI()

VillainsUI:Popup({
	Title = "VILLAINS UI v" .. VillainsUI.Version,
	Icon = "lucide:shield",
	Content = "Premium Full Edition — 100% WindUI parity with enhanced dark red theme!",
	Buttons = { { Title = "Continue", Variant = "Primary" } },
})

local Window = VillainsUI:CreateWindow({
	Title = "VILLAINS Hub",
	Author = "Premium Dark Red Theme",
	Folder = "VillainsUI_Demo",
	Icon = "lucide:sword",
	Size = UDim2.fromOffset(640, 540),
	SideBarWidth = 220,
	Acrylic = true,
	Transparent = true,
	User = {
		Enabled = true,
		Callback = function()
			VillainsUI:Notify({ Title = "Profile", Content = "User clicked!", Type = "Info" })
		end,
	},
	OpenButton = {
		Title = "Open VILLAINS",
		Enabled = true,
		Color = ColorSequence.new(Color3.fromRGB(139, 0, 0), Color3.fromRGB(220, 20, 60)),
	},
})

Window:Tag({
	Title = "Premium v" .. VillainsUI.Version,
	Icon = "lucide:star",
	Color = Color3.fromRGB(220, 20, 60),
	Border = true,
})

Window:TabSection({ Title = "MAIN" })

local MainTab = Window:Tab({ Title = "Combat", Icon = "lucide:sword", Border = true })

MainTab:Paragraph({
	Title = "VILLAINS UI Premium",
	Content = "Full WindUI parity: Acrylic, Video BG, HSV Colorpicker, Viewport, Tooltip, Icons, Junkie service, and premium animations.",
})

MainTab:Toggle({
	Title = "Auto Farm",
	Desc = "Automatically farm resources",
	Flag = "AutoFarm",
	Default = false,
	Tooltip = "Enable auto farming mode",
	Callback = function(v) print("AutoFarm:", v) end,
})

MainTab:Checkbox({
	Title = "Safe Mode",
	Desc = "Avoid PvP zones",
	Flag = "SafeMode",
	Default = true,
})

MainTab:Slider({
	Title = "Walk Speed",
	Flag = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	IsTooltip = true,
	Desc = "Adjust your walk speed",
	Callback = function(v) print("Speed:", v) end,
})

MainTab:Colorpicker({
	Title = "Trail Color",
	Flag = "TrailColor",
	Default = Color3.fromRGB(220, 20, 60),
	Transparency = true,
	Callback = function(c, t) print("Color:", c, "Alpha:", t) end,
})

Window:TabSection({ Title = "VISUAL" })

local VisualTab = Window:Tab({ Title = "Visual", Icon = "lucide:heart" })

VisualTab:Viewport({
	Title = "Character Preview",
	Height = 200,
	Callback = function(viewport, worldModel)
		local char = game.Players.LocalPlayer.Character
		if char then
			local clone = char:Clone()
			clone.Parent = worldModel
			local cam = Instance.new("Camera")
			cam.CFrame = CFrame.new(Vector3.new(0, 2, 5), Vector3.new(0, 1, 0))
			viewport.CurrentCamera = cam
		end
	end,
})

VisualTab:Dropdown({
	Title = "Theme",
	Options = { "DarkRed", "BloodMoon", "Crimson", "Dark" },
	Default = "DarkRed",
	Callback = function(sel) VillainsUI:SetTheme(sel) end,
})

VisualTab:Button({
	Title = "Toggle Acrylic",
	Icon = "lucide:settings",
	Callback = function()
		VillainsUI:ToggleAcrylic(not VillainsUI.AcrylicEnabled)
	end,
})

Window:TabSection({ Title = "CONFIG" })

local ConfigTab = Window:Tab({ Title = "Config", Icon = "lucide:lock" })

ConfigTab:Button({
	Title = "Save Config",
	Callback = function()
		Window:SaveConfig("default")
		VillainsUI:Notify({ Title = "Saved", Type = "Success" })
	end,
})

ConfigTab:Button({
	Title = "Load Config",
	Callback = function()
		Window:LoadConfig("default")
		VillainsUI:Notify({ Title = "Loaded", Type = "Success" })
	end,
})

print("[VILLAINS UI] v" .. VillainsUI.Version .. " Premium loaded!")
