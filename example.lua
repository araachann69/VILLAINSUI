--[[
    VILLAINS UI v3.1.0 — Example
    WindUI core + Premium Dark Red theme
]]

local URL = "https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"

local loadfn = loadstring or load
if not loadfn then
	error("[VILLAINS UI] Executor tidak support loadstring/load")
end

local src = game:HttpGet(URL, true)
local chunk, err = loadfn(src, "VillainsUI")
if not chunk then
	error("[VILLAINS UI] Compile error: " .. tostring(err))
end

local VillainsUI = chunk()

VillainsUI:Popup({
	Title = "VILLAINS UI v" .. VillainsUI.Version,
	Icon = "bird",
	Content = "Premium Dark Red — powered by WindUI core",
	Buttons = { { Title = "Continue", Variant = "Primary" } },
})

local Window = VillainsUI:CreateWindow({
	Title = "VILLAINS Hub",
	Author = "Premium Dark Red",
	Folder = "VillainsUI_Demo",
	Icon = "solar:sword-bold",
	Size = UDim2.fromOffset(620, 500),
	SideBarWidth = 200,
	Acrylic = true,
	Transparent = true,
	User = {
		Enabled = true,
		Callback = function()
			VillainsUI:Notify({ Title = "Profile", Content = "Clicked!", Type = "Success" })
		end,
	},
})

Window:Tag({ Title = "v" .. VillainsUI.Version, Icon = "solar:star-bold", Color = Color3.fromRGB(220, 20, 60) })

Window:TabSection({ Title = "MAIN" })

local Tab = Window:Tab({ Title = "Home", Icon = "solar:home-2-bold" })

Tab:Paragraph({
	Title = "Welcome",
	Content = "VILLAINS UI — WindUI API dengan tema dark red premium.",
})

Tab:Toggle({
	Title = "Auto Farm",
	Flag = "AutoFarm",
	Default = false,
	Callback = function(v) print("AutoFarm:", v) end,
})

Tab:Slider({
	Title = "Walk Speed",
	Flag = "Speed",
	Min = 16,
	Max = 200,
	Default = 16,
	Callback = function(v) print("Speed:", v) end,
})

Tab:Button({
	Title = "Test Notify",
	Callback = function()
		VillainsUI:Notify({ Title = "Success", Content = "VILLAINS UI works!", Type = "Success" })
	end,
})

print("[VILLAINS UI] Loaded v" .. VillainsUI.Version)
