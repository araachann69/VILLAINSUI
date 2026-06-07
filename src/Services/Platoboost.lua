--[[ VILLAINS UI - Platoboost Service (simplified) ]]

local Platoboost = {}

function Platoboost.New(serviceId, secret)
	local HttpService = game:GetService("HttpService")
	local copy = setclipboard or toclipboard or function() end
	local baseUrl = "https://platoboost.com"

	return {
		Verify = function(key)
			local ok, result = pcall(function()
				local url = string.format("%s/api/public/validate?service=%s&key=%s", baseUrl, tostring(serviceId), HttpService:UrlEncode(key))
				local res = game.HttpGetAsync and game:HttpGetAsync(url) or HttpService:GetAsync(url)
				local data = HttpService:JSONDecode(res)
				if data and (data.success or data.valid) then
					return true, "Key valid!"
				end
				return false, data and (data.message or data.error) or "Invalid key"
			end)
			if ok then
				return result
			end
			return false, "Validation failed"
		end,
		Copy = function()
			copy(string.format("%s/a/%s", baseUrl, tostring(serviceId)))
		end,
	}
end

return Platoboost
