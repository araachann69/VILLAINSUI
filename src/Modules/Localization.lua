--[[ VILLAINS UI - Localization ]]

local Localization = {}
Localization.__index = Localization

function Localization.New(config)
	local self = setmetatable({}, Localization)
	self.Enabled = config.Enabled ~= false
	self.Prefix = config.Prefix or "loc:"
	self.DefaultLanguage = config.DefaultLanguage or "en"
	self.CurrentLanguage = self.DefaultLanguage
	self.Translations = config.Translations or {}
	return self
end

function Localization:SetLanguage(lang)
	if self.Translations[lang] then
		self.CurrentLanguage = lang
		return true
	end
	return false
end

function Localization:Get(key, fallback)
	if not self.Enabled then
		return fallback or key
	end
	if type(key) == "string" and string.sub(key, 1, #self.Prefix) == self.Prefix then
		key = string.sub(key, #self.Prefix + 1)
	end
	local lang = self.Translations[self.CurrentLanguage]
	if lang and lang[key] then
		return lang[key]
	end
	local default = self.Translations[self.DefaultLanguage]
	if default and default[key] then
		return default[key]
	end
	return fallback or key
end

function Localization:Translate(text)
	if not self.Enabled or type(text) ~= "string" then
		return text
	end
	if string.sub(text, 1, #self.Prefix) == self.Prefix then
		return self:Get(text, text)
	end
	return text
end

return Localization
