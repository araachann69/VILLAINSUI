--[[
	VILLAINS UI Library - Animation System
]]

local TweenService = game:GetService("TweenService")

local Animation = {}
Animation.ActiveTweens = {}

local function getTheme()
	return require(script.Parent.Theme)
end

function Animation.Cancel(instance)
	if Animation.ActiveTweens[instance] then
		for _, tween in ipairs(Animation.ActiveTweens[instance]) do
			pcall(function()
				tween:Cancel()
			end)
		end
		Animation.ActiveTweens[instance] = nil
	end
end

function Animation.Tween(instance, props, duration, easingStyle, easingDirection, callback)
	Animation.Cancel(instance)

	local theme = getTheme()
	local info = TweenInfo.new(
		duration or theme.Animation.Normal,
		easingStyle or theme.Animation.Easing,
		easingDirection or theme.Animation.EasingDirection
	)

	local tween = TweenService:Create(instance, info, props)
	Animation.ActiveTweens[instance] = { tween }

	if callback then
		tween.Completed:Connect(function(state)
			if state == Enum.PlaybackState.Completed then
				callback()
			end
		end)
	end

	tween:Play()
	return tween
end

function Animation.Spring(instance, props, callback)
	return Animation.Tween(
		instance,
		props,
		getTheme().Animation.Spring,
		getTheme().Animation.BounceEasing,
		Enum.EasingDirection.Out,
		callback
	)
end

function Animation.FadeIn(instance, duration, callback)
	local props = {}
	if instance:IsA("GuiObject") then
		props.BackgroundTransparency = instance:GetAttribute("_TargetTransparency") or 0
	end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		props.TextTransparency = 0
	end
	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
		props.ImageTransparency = 0
	end
	return Animation.Tween(instance, props, duration, nil, nil, callback)
end

function Animation.FadeOut(instance, duration, callback)
	local props = {}
	if instance:IsA("GuiObject") then
		props.BackgroundTransparency = 1
	end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		props.TextTransparency = 1
	end
	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
		props.ImageTransparency = 1
	end
	return Animation.Tween(instance, props, duration, nil, nil, callback)
end

function Animation.ScaleIn(instance, duration, callback)
	local original = instance:GetAttribute("_OriginalSize") or instance.Size
	instance:SetAttribute("_OriginalSize", original)
	instance.Size = UDim2.new(original.X.Scale * 0.92, original.X.Offset, original.Y.Scale * 0.92, original.Y.Offset)

	if instance:IsA("GuiObject") then
		instance.BackgroundTransparency = 1
	end

	Animation.Tween(instance, {
		Size = original,
		BackgroundTransparency = instance:GetAttribute("_TargetTransparency") or 0,
	}, duration or getTheme().Animation.Normal, getTheme().Animation.BounceEasing, Enum.EasingDirection.Out, callback)
end

function Animation.SlideIn(instance, fromOffset, duration, callback)
	local original = instance.Position
	instance.Position = UDim2.new(
		original.X.Scale,
		original.X.Offset + fromOffset,
		original.Y.Scale,
		original.Y.Offset
	)
	return Animation.Tween(instance, { Position = original }, duration, nil, nil, callback)
end

function Animation.Pulse(instance, color, duration)
	local stroke = instance:FindFirstChildOfClass("UIStroke")
	if not stroke then
		return
	end

	local original = stroke.Color
	local theme = getTheme()
	Animation.Tween(stroke, { Color = color or theme.Colors.Glow }, duration or 0.2)
	task.delay(duration or 0.2, function()
		if stroke.Parent then
			Animation.Tween(stroke, { Color = original }, duration or 0.2)
		end
	end)
end

function Animation.Shimmer(frame)
	local theme = getTheme()
	local shimmer = Instance.new("Frame")
	shimmer.Name = "Shimmer"
	shimmer.Size = UDim2.new(0.3, 0, 1, 0)
	shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
	shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
	shimmer.BackgroundTransparency = 0.85
	shimmer.BorderSizePixel = 0
	shimmer.ZIndex = frame.ZIndex + 1
	shimmer.Parent = frame

	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.6),
		NumberSequenceKeypoint.new(1, 1),
	})
	gradient.Rotation = 25
	gradient.Parent = shimmer

	local tween = TweenService:Create(shimmer, TweenInfo.new(1.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
		Position = UDim2.new(1.3, 0, 0, 0),
	})
	tween:Play()
	return shimmer, tween
end

function Animation.StaggerIn(instances, delay, duration)
	delay = delay or 0.04
	duration = duration or getTheme().Animation.Normal
	for i, inst in ipairs(instances) do
		task.delay((i - 1) * delay, function()
			if inst.Parent then
				inst.BackgroundTransparency = 1
				Animation.FadeIn(inst, duration)
			end
		end)
	end
end

function Animation.GlowPulse(instance, color, theme)
	theme = theme or getTheme()
	local stroke = instance:FindFirstChildOfClass("UIStroke")
	if not stroke then
		return
	end
	local original = stroke.Color
	task.spawn(function()
		while instance.Parent do
			Animation.Tween(stroke, { Color = color or theme.Colors.Glow, Transparency = 0.1 }, 0.9)
			task.wait(0.9)
			Animation.Tween(stroke, { Color = original, Transparency = 0.5 }, 0.9)
			task.wait(0.9)
		end
	end)
end

function Animation.Bounce(instance, scale)
	scale = scale or 1.05
	local original = instance.Size
	Animation.Tween(instance, {
		Size = UDim2.new(original.X.Scale * scale, original.X.Offset, original.Y.Scale * scale, original.Y.Offset),
	}, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out, function()
		Animation.Tween(instance, { Size = original }, 0.15)
	end)
end

return Animation
