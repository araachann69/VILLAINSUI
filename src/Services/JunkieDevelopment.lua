--[[ VILLAINS UI - Junkie Development Key Service ]]

local JunkieDevelopment = {}

function JunkieDevelopment.New(args)
	args = args or {}
	local serviceId = args.ServiceId or args.HubId or ""
	local apiKey = args.ApiKey or args.Key or ""

	local service = {
		Name = "Junkie Development",
		ServiceId = serviceId,
		ApiKey = apiKey,
	}

	function service:Verify(key)
		if not key or key == "" then
			return false, "Key is empty"
		end

		local ok, result = pcall(function()
			local url = string.format(
				"https://api.jnkie.com/v1/verify?hub=%s&key=%s",
				serviceId,
				key
			)
			local response = game:HttpGet(url, true)
			if response then
				local decoded = game:GetService("HttpService"):JSONDecode(response)
				if decoded and (decoded.valid == true or decoded.success == true) then
					return true, key
				end
				return false, decoded.message or "Invalid key"
			end
			return false, "Verification failed"
		end)

		if ok then
			return result
		end
		return false, "Service unavailable"
	end

	function service:Copy()
		if setclipboard then
			setclipboard("https://jnkie.com/hub/" .. tostring(serviceId))
		end
	end

	return service
end

return JunkieDevelopment
