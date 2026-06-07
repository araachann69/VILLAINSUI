--[[ VILLAINS UI - Panda Development Service (simplified) ]]

local PandaDevelopment = {}

function PandaDevelopment.New(serviceId)
	local HttpService = game:GetService("HttpService")
	local copy = setclipboard or toclipboard or function() end

	return {
		Verify = function(key)
			local ok, result = pcall(function()
				local url = string.format("https://pandadevelopment.net/v2_validation?key=%s&service=%s", HttpService:UrlEncode(key), HttpService:UrlEncode(tostring(serviceId)))
				local res = game.HttpGetAsync and game:HttpGetAsync(url) or HttpService:GetAsync(url)
				local data = HttpService:JSONDecode(res)
				if data and (data.valid or data.success) then
					return true, "Key valid!"
				end
				return false, data and (data.message or data.error) or "Invalid key"
			end)
			if ok then return result end
			return false, "Validation failed"
		end,
		Copy = function()
			copy(string.format("https://pandadevelopment.net/getkey?service=%s", tostring(serviceId)))
		end,
	}
end

return PandaDevelopment
