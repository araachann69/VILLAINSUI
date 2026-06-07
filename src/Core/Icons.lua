--[[
	VILLAINS UI Library - Icon System (WindUI-compatible prefixes)
]]

local Icons = {}

Icons.Cache = {}
Icons.BaseUrl = "https://raw.githubusercontent.com/Footagesus/Icons/main/icons/"
Icons.FallbackEmoji = {
	["lucide:home"] = "🏠",
	["lucide:settings"] = "⚙",
	["lucide:user"] = "👤",
	["lucide:star"] = "⭐",
	["lucide:heart"] = "❤",
	["lucide:shield"] = "🛡",
	["lucide:sword"] = "⚔",
	["lucide:info"] = "ℹ",
	["lucide:bell"] = "🔔",
	["lucide:lock"] = "🔒",
}

function Icons.Parse(icon)
	if not icon or icon == "" then
		return nil, "none"
	end

	if string.find(icon, "rbxassetid://") or string.find(icon, "http") then
		return icon, "image"
	end

	if string.find(icon, ":") then
		local collection, name = icon:match("^([^:]+):(.+)$")
		if collection and name then
			return icon, "sprite", collection, name
		end
	end

	return icon, "emoji"
end

function Icons.GetUrl(collection, name)
	return Icons.BaseUrl .. collection .. "/" .. name .. ".png"
end

function Icons.Resolve(icon, callback)
	local parsed, kind, collection, name = Icons.Parse(icon)

	if kind == "emoji" then
		if callback then
			callback(parsed, "emoji")
		end
		return parsed, "emoji"
	end

	if kind == "image" then
		if callback then
			callback(parsed, "image")
		end
		return parsed, "image"
	end

	local cacheKey = icon
	if Icons.Cache[cacheKey] then
		if callback then
			callback(Icons.Cache[cacheKey], "image")
		end
		return Icons.Cache[cacheKey], "image"
	end

	local url = Icons.GetUrl(collection, name)

	task.spawn(function()
		local ok, assetId = pcall(function()
			if getcustomasset then
				local path = "VillainsUI/icons/" .. collection .. "_" .. name .. ".png"
				if not isfolder("VillainsUI/icons") then
					makefolder("VillainsUI/icons")
				end
				if not isfile(path) then
					writefile(path, game:HttpGet(url))
				end
				return getcustomasset(path)
			end
			return url
		end)

		if ok and assetId then
			Icons.Cache[cacheKey] = assetId
			if callback then
				callback(assetId, "image")
			end
		else
			local fallback = Icons.FallbackEmoji[icon] or "◆"
			if callback then
				callback(fallback, "emoji")
			end
		end
	end)

	return Icons.FallbackEmoji[icon] or "◆", "emoji"
end

return Icons
