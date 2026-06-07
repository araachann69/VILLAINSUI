--[[
	VILLAINS UI Library - Executor Compatibility Layer
]]

local Compat = {}

function Compat.Apply()
	if not Color3.fromHex then
		function Color3.fromHex(hex)
			hex = string.gsub(hex, "#", "")
			return Color3.new(
				tonumber(string.sub(hex, 1, 2), 16) / 255,
				tonumber(string.sub(hex, 3, 4), 16) / 255,
				tonumber(string.sub(hex, 5, 6), 16) / 255
			)
		end
	end
end

function Compat.ToHSV(color)
	if Color3.toHSV then
		return Color3.toHSV(color)
	end
	return color:ToHSV()
end

function Compat.HttpGet(url)
	local ok, body = pcall(function()
		return game:HttpGet(url, true)
	end)
	if ok and type(body) == "string" and body ~= "" and not string.find(body, "<!DOCTYPE", 1, true) then
		return body
	end

	if syn and syn.request then
		local res = syn.request({ Url = url, Method = "GET" })
		if res and res.Body then
			return res.Body
		end
	end

	if http and http.request then
		local res = http.request({ Url = url, Method = "GET" })
		if res and res.Body then
			return res.Body
		end
	end

	if request then
		local res = request({ Url = url, Method = "GET" })
		if res and res.Body then
			return res.Body
		end
	end

	error("[VillainsUI] HttpGet failed for: " .. tostring(url))
end

function Compat.LoadString(source, chunkName)
	local loader = loadstring or load
	if not loader then
		error("[VillainsUI] This executor does not support loadstring/load.")
	end
	local fn, err = loader(source, chunkName or "VillainsUI")
	if not fn then
		error("[VillainsUI] Failed to compile: " .. tostring(err))
	end
	return fn
end

function Compat.SafeCall(fn, ...)
	local ok, result = pcall(fn, ...)
	if not ok then
		warn("[VillainsUI] " .. tostring(result))
		return nil
	end
	return result
end

Compat.Apply()

return Compat
