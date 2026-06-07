--[[
    VILLAINS UI v3.0.1 - Example (WindUI-style loader)
    https://github.com/araachann69/VILLAINSUI
]]

local VillainsUI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"
))()

VillainsUI:Popup({
	Title = "VILLAINS UI v" .. VillainsUI.Version,
	Icon = "☠",
	Content = "Premium Dark Red Theme — Powered by WindUI-compatible API",
	Buttons = { { Title = "Continue", Variant = "Primary" } },
})

local Window = VillainsUI:CreateWindow({
	Title = "VILLAINS Hub",
	Author = "Premium Dark Red",
	Folder = "VillainsUI_Demo",
	Icon = "☠",
	Size = UDim2.fromOffset(620, 500),
	SideBarWidth = 200,
	Transparent = true,
	User = {
		Enabled = true,
		Callback = function()
			VillainsUI:Notify({ Title = "Profile", Content = "Clicked!", Type = "Info" })
		end,
	},
})

Window:Tag({ Title = "v" .. VillainsUI.Version, Icon = "⚡", Color = Color3.fromRGB(220, 20, 60), Border = true })

Window:TabSection({ Title = "MAIN" })

local Tab = Window:Tab({ Title = "Home", Icon = "⚔" })

Tab:Paragraph({
	Title = "Welcome",
	Content = "VILLAINS UI — WindUI-compatible API with premium dark red theme.",
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
	Title = "Notify Test",
	Callback = function()
		VillainsUI:Notify({ Title = "Success", Content = "It works!", Type = "Success" })
	end,
})

Window:TabSection({ Title = "CONFIG" })

local Settings = Window:Tab({ Title = "Settings", Icon = "⚙" })

Settings:Button({
	Title = "Save Config",
	Callback = function() Window:SaveConfig("default") end,
})

Settings:Button({
	Title = "Load Config",
	Callback = function() Window:LoadConfig("default") end,
})

print("[VILLAINS UI] Loaded v" .. VillainsUI.Version)
