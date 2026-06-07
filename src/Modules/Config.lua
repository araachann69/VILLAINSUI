--[[ VILLAINS UI - Config Manager ]]

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local ConfigManager = {
	Folder = nil,
	Path = nil,
	Configs = {},
	Parser = {
		Toggle = {
			Save = function(obj) return { __type = "Toggle", value = obj.Value } end,
			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
		},
		Checkbox = {
			Save = function(obj) return { __type = "Checkbox", value = obj.Value } end,
			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
		},
		Slider = {
			Save = function(obj) return { __type = "Slider", value = obj.Value } end,
			Load = function(el, data) if el.SetValue then el:SetValue(tonumber(data.value)) end end,
		},
		Input = {
			Save = function(obj) return { __type = "Input", value = obj.Value } end,
			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
		},
		Dropdown = {
			Save = function(obj) return { __type = "Dropdown", value = obj.Value } end,
			Load = function(el, data) if el.SetValue then el:SetValue(data.value) end end,
		},
		Keybind = {
			Save = function(obj) return { __type = "Keybind", value = tostring(obj.Value) } end,
			Load = function(el, data)
				if el.SetValue then
					local ok, key = pcall(function() return Enum.KeyCode[data.value] end)
					if ok and key then el:SetValue(key) end
				end
			end,
		},
		Colorpicker = {
			Save = function(obj) return { __type = "Colorpicker", value = obj.Value:ToHex() } end,
			Load = function(el, data) if el.SetValue then el:SetValue(Color3.fromHex(data.value)) end end,
		},
	},
}

local WindowRef = nil

function ConfigManager:Init(window)
	if RunService:IsStudio() or not writefile then
		warn("[VillainsUI.Config] Config system unavailable in Studio.")
		return false
	end
	if not window.Folder and not window.Config then
		warn("[VillainsUI.Config] Window Folder not specified.")
		return false
	end
	WindowRef = window
	local folder = (window.Config and window.Config.Folder) or window.Folder or "VillainsUI"
	ConfigManager.Folder = folder
	ConfigManager.Path = "VillainsUI/" .. folder .. "/config/"
	if not isfolder("VillainsUI") then makefolder("VillainsUI") end
	if not isfolder("VillainsUI/" .. folder) then makefolder("VillainsUI/" .. folder) end
	if not isfolder(ConfigManager.Path) then makefolder(ConfigManager.Path) end
	return ConfigManager
end

function ConfigManager:CreateConfig(name, autoload)
	if not name then return false, "No config name" end

	local ConfigModule = {
		Path = ConfigManager.Path .. name .. ".json",
		Elements = {},
		CustomData = {},
		AutoLoad = autoload or false,
		Version = 1.0,
	}

	function ConfigModule:Register(flag, element)
		ConfigModule.Elements[flag] = element
	end

	function ConfigModule:Set(key, value)
		ConfigModule.CustomData[key] = value
	end

	function ConfigModule:Get(key)
		return ConfigModule.CustomData[key]
	end

	function ConfigModule:Save()
		if WindowRef and WindowRef.PendingFlags then
			for flag, el in pairs(WindowRef.PendingFlags) do
				ConfigModule:Register(flag, el)
			end
		end
		local saveData = {
			__version = ConfigModule.Version,
			__elements = {},
			__autoload = ConfigModule.AutoLoad,
			__custom = ConfigModule.CustomData,
		}
		for flagName, element in pairs(ConfigModule.Elements) do
			local t = element.__type
			if ConfigManager.Parser[t] then
				saveData.__elements[tostring(flagName)] = ConfigManager.Parser[t].Save(element)
			end
		end
		writefile(ConfigModule.Path, HttpService:JSONEncode(saveData))
		return saveData
	end

	function ConfigModule:Load()
		if not isfile(ConfigModule.Path) then return false, "Config not found" end
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(ConfigModule.Path))
		end)
		if not ok then return false, "Parse error" end
		if WindowRef and WindowRef.PendingFlags then
			for flag, el in pairs(WindowRef.PendingFlags) do
				ConfigModule:Register(flag, el)
			end
		end
		for flagName, elData in pairs(data.__elements or {}) do
			local el = ConfigModule.Elements[flagName]
			if el and ConfigManager.Parser[elData.__type] then
				task.spawn(function()
					ConfigManager.Parser[elData.__type].Load(el, elData)
				end)
			end
		end
		ConfigModule.CustomData = data.__custom or {}
		return ConfigModule.CustomData
	end

	function ConfigModule:Delete()
		if isfile(ConfigModule.Path) then
			delfile(ConfigModule.Path)
		end
		ConfigManager.Configs[name] = nil
		return true
	end

	ConfigManager.Configs[name] = ConfigModule
	if WindowRef then WindowRef.CurrentConfig = ConfigModule end

	if autoload and isfile(ConfigModule.Path) then
		task.spawn(function()
			task.wait(0.5)
			pcall(function() ConfigModule:Load() end)
		end)
	end

	return ConfigModule
end

function ConfigManager:Config(name, autoload)
	return ConfigManager:CreateConfig(name, autoload)
end

function ConfigManager:AllConfigs()
	if not listfiles then return {} end
	local files = {}
	for _, file in ipairs(listfiles(ConfigManager.Path)) do
		local n = file:match("([^\\/]+)%.json$")
		if n then table.insert(files, n) end
	end
	return files
end

return ConfigManager
