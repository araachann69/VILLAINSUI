--[[ VILLAINS UI - Key System ]]

local Theme = require(script.Parent.Parent.Core.Theme)
local Creator = require(script.Parent.Parent.Core.Creator)
local Animation = require(script.Parent.Parent.Core.Animation)

local KeySystem = {}

function KeySystem.Open(config, filename, callback, VillainsUI)
	config = config or {}
	local ks = config.KeySystem or config
	local theme = Theme
	local enteredKey = ""
	local services = {}

	local overlay = Creator.New("TextButton", {
		Name = "KeySystemOverlay",
		Parent = Creator.GetScreenGui(),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = theme.Colors.Overlay,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 200,
	})

	local modal = Creator.New("Frame", {
		Parent = overlay,
		Size = UDim2.fromOffset(420, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Colors.BackgroundSecondary,
		BackgroundTransparency = 0.02,
		CornerRadius = theme.CornerRadius.Large,
		Stroke = { Color = theme.Colors.Primary, Thickness = 2, Transparency = 0.3 },
		ZIndex = 201,
		Padding = {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24),
		},
		ListLayout = { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 14) },
	})

	local header = Creator.New("Frame", {
		Parent = modal,
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
	})

	Creator.Icon(ks.Icon or config.Icon or "🔑", header, UDim2.new(0, 28, 0, 28), theme.Colors.Primary)

	Creator.Text({
		Parent = header,
		Text = ks.Title or config.Title or "Key System",
		Font = theme.Font.Title,
		TextSize = 20,
		Size = UDim2.new(1, -40, 1, 0),
		Position = UDim2.new(0, 36, 0, 0),
	})

	if ks.Note then
		Creator.Text({
			Parent = modal,
			Text = ks.Note,
			TextSize = 14,
			TextColor3 = theme.Colors.TextSecondary,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		})
	end

	if ks.Thumbnail and ks.Thumbnail.Image then
		Creator.New("ImageLabel", {
			Parent = modal,
			Size = UDim2.new(1, 0, 0, ks.Thumbnail.Height or 120),
			BackgroundTransparency = 1,
			Image = ks.Thumbnail.Image,
			ScaleType = Enum.ScaleType.Crop,
			CornerRadius = theme.CornerRadius.Medium,
		})
	end

	local keyInput = Creator.New("TextBox", {
		Parent = modal,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = theme.Colors.Surface,
		BackgroundTransparency = 0.1,
		PlaceholderText = "Enter your key...",
		PlaceholderColor3 = theme.Colors.TextMuted,
		Text = "",
		TextColor3 = theme.Colors.Text,
		Font = theme.Font.Regular,
		TextSize = 14,
		ClearTextOnFocus = false,
		CornerRadius = theme.CornerRadius.Medium,
		Stroke = { Color = theme.Colors.BorderMuted, Thickness = 1, Transparency = 0.5 },
	})

	keyInput:GetPropertyChangedSignal("Text"):Connect(function()
		enteredKey = keyInput.Text
	end)

	local btnRow = Creator.New("Frame", {
		Parent = modal,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		ListLayout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 8),
		},
	})

	local function closeAndSuccess(key)
		Animation.Tween(overlay, { BackgroundTransparency = 1 }, theme.Animation.Fast)
		Animation.Tween(modal, { BackgroundTransparency = 1 }, theme.Animation.Fast, nil, nil, function()
			overlay:Destroy()
		end)
		if ks.SaveKey ~= false and writefile then
			local folder = config.Folder or "VillainsUI"
			if not isfolder("VillainsUI") then makefolder("VillainsUI") end
			if not isfolder("VillainsUI/" .. folder) then makefolder("VillainsUI/" .. folder) end
			writefile("VillainsUI/" .. folder .. "/" .. filename .. ".key", tostring(key))
		end
		task.wait(0.3)
		callback(true)
	end

	local function validateKey(key)
		key = tostring(key or "")

		if ks.KeyValidator then
			return ks.KeyValidator(key)
		end

		if not ks.API then
			if type(ks.Key) == "table" then
				return table.find(ks.Key, key) ~= nil, key
			end
			return tostring(ks.Key) == key, key
		end

		for _, apiConfig in ipairs(ks.API) do
			local serviceDef = VillainsUI.Services[apiConfig.Type]
			if serviceDef then
				local args = {}
				for _, argName in ipairs(serviceDef.Args) do
					table.insert(args, apiConfig[argName])
				end
				local service = serviceDef.New(table.unpack(args))
				table.insert(services, service)
			end
		end

		for _, service in ipairs(services) do
			local ok, msg = service.Verify(key)
			if ok then return true, msg end
		end
		return false, "Invalid key"
	end

	-- Get Key button (URL)
	if ks.URL then
		local getBtn = Creator.New("TextButton", {
			Parent = btnRow,
			Size = UDim2.new(0, 100, 1, 0),
			BackgroundColor3 = theme.Colors.Surface,
			Text = "Get Key",
			TextColor3 = theme.Colors.Text,
			Font = theme.Font.Body,
			TextSize = 13,
			AutoButtonColor = false,
			CornerRadius = theme.CornerRadius.Medium,
		})
		getBtn.MouseButton1Click:Connect(function()
			if setclipboard then setclipboard(ks.URL) end
			VillainsUI:Notify({ Title = "Key System", Content = "Link copied!", Duration = 3 })
		end)
	end

	-- API services dropdown
	if ks.API then
		for _, apiConfig in ipairs(ks.API) do
			local serviceDef = VillainsUI.Services[apiConfig.Type]
			if serviceDef then
				local args = {}
				for _, argName in ipairs(serviceDef.Args) do
					table.insert(args, apiConfig[argName])
				end
				local service = serviceDef.New(table.unpack(args))
				local svcBtn = Creator.New("TextButton", {
					Parent = btnRow,
					Size = UDim2.new(0, 110, 1, 0),
					BackgroundColor3 = theme.Colors.PrimaryDark,
					Text = apiConfig.Title or serviceDef.Name,
					TextColor3 = theme.Colors.Text,
					Font = theme.Font.Body,
					TextSize = 12,
					AutoButtonColor = false,
					CornerRadius = theme.CornerRadius.Medium,
				})
				svcBtn.MouseButton1Click:Connect(function()
					service.Copy()
					VillainsUI:Notify({ Title = "Key System", Content = "Link copied!", Duration = 3 })
				end)
			end
		end
	end

	local exitBtn = Creator.New("TextButton", {
		Parent = btnRow,
		Size = UDim2.new(0, 80, 1, 0),
		BackgroundColor3 = theme.Colors.Surface,
		Text = "Exit",
		TextColor3 = theme.Colors.TextSecondary,
		Font = theme.Font.Body,
		TextSize = 13,
		AutoButtonColor = false,
		CornerRadius = theme.CornerRadius.Medium,
	})
	exitBtn.MouseButton1Click:Connect(function()
		overlay:Destroy()
		callback(false)
	end)

	local submitBtn = Creator.New("TextButton", {
		Parent = btnRow,
		Size = UDim2.new(0, 100, 1, 0),
		BackgroundColor3 = theme.Colors.Primary,
		Text = "Submit",
		TextColor3 = Color3.new(1, 1, 1),
		Font = theme.Font.Title,
		TextSize = 14,
		AutoButtonColor = false,
		CornerRadius = theme.CornerRadius.Medium,
		Gradient = { Color = theme.GetGradient("Glow") },
	})
	submitBtn.MouseButton1Click:Connect(function()
		local ok, msg = validateKey(enteredKey)
		if ok then
			closeAndSuccess(enteredKey)
		else
			VillainsUI:Notify({
				Title = "Key System Error",
				Content = type(msg) == "string" and msg or "Invalid key!",
				Type = "Error",
				Duration = 4,
			})
		end
	end)

	Animation.Tween(overlay, { BackgroundTransparency = theme.Transparency.Overlay }, theme.Animation.Normal)
	Animation.ScaleIn(modal, theme.Animation.Normal)
end

function KeySystem.CheckAndRun(config, filename, callback, VillainsUI)
	local ks = config.KeySystem
	if not ks then
		callback(true)
		return
	end

	local folder = config.Folder or "VillainsUI"
	local keyPath = "VillainsUI/" .. folder .. "/" .. filename .. ".key"

	local function openKeySystem()
		KeySystem.Open(config, filename, callback, VillainsUI)
	end

	if ks.KeyValidator and ks.SaveKey and isfile and isfile(keyPath) then
		local saved = readfile(keyPath)
		if ks.KeyValidator(saved) then
			callback(true)
			return
		end
		openKeySystem()
		return
	end

	if not ks.API then
		if ks.SaveKey and isfile and isfile(keyPath) then
			local saved = readfile(keyPath)
			local valid = type(ks.Key) == "table" and table.find(ks.Key, saved) or tostring(ks.Key) == saved
			if valid then
				callback(true)
				return
			end
		end
		openKeySystem()
		return
	end

	if isfile and isfile(keyPath) then
		local saved = readfile(keyPath)
		local ok = false
		for _, apiConfig in ipairs(ks.API) do
			local def = VillainsUI.Services[apiConfig.Type]
			if def then
				local args = {}
				for _, a in ipairs(def.Args) do table.insert(args, apiConfig[a]) end
				local svc = def.New(table.unpack(args))
				local valid = svc.Verify(saved)
				if valid then ok = true break end
			end
		end
		if ok then callback(true) else openKeySystem() end
	else
		openKeySystem()
	end
end

return KeySystem
