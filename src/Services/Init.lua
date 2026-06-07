--[[ VILLAINS UI - Key Validation Services ]]

return {
	platoboost = {
		Name = "Platoboost",
		Icon = "🔑",
		Args = { "ServiceId", "Secret" },
		New = require(script.Parent.Platoboost).New,
	},
	pandadevelopment = {
		Name = "Panda Development",
		Icon = "🐼",
		Args = { "ServiceId" },
		New = require(script.Parent.PandaDevelopment).New,
	},
	luarmor = {
		Name = "Luarmor",
		Icon = "🛡",
		Args = { "ScriptId", "Discord" },
		New = require(script.Parent.Luarmor).New,
	},
	junkie = {
		Name = "Junkie Development",
		Icon = "🔐",
		Args = { "ServiceId", "ApiKey" },
		New = require(script.Parent.JunkieDevelopment).New,
	},
	junkiedevelopment = {
		Name = "Junkie Development",
		Icon = "🔐",
		Args = { "ServiceId", "ApiKey" },
		New = require(script.Parent.JunkieDevelopment).New,
	},
}
