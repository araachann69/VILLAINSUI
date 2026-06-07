--[[ VILLAINS UI - Luarmor Service ]]

local Luarmor = {}

function Luarmor.New(scriptId, discord)
	local HttpService = game:GetService("HttpService")
	local APIURL = "https://sdkapi-public.luarmor.net/library.lua"
	local API = loadstring(
		game.HttpGetAsync and game:HttpGetAsync(APIURL) or HttpService:GetAsync(APIURL)
	)()
	local copy = setclipboard or toclipboard or function() end
	API.script_id = scriptId

	return {
		Verify = function(key)
			local status = API.check_key(key)
			if status.code == "KEY_VALID" then
				return true, "Key valid!"
			elseif status.code == "KEY_HWID_LOCKED" then
				return false, "Key linked to different HWID."
			elseif status.code == "KEY_INCORRECT" then
				return false, "Key is wrong or deleted!"
			end
			return false, "Key check failed: " .. (status.message or status.code)
		end,
		Copy = function()
			copy(tostring(discord or ""))
		end,
	}
end

return Luarmor
