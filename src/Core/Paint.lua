--[[
	VILLAINS UI Library - Acrylic Paint System
]]

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Paint = {}
Paint.Instances = {}

local function getCamera()
	local cam = Workspace.CurrentCamera
	if not cam then
		Workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
		cam = Workspace.CurrentCamera
	end
	return cam
end

function Paint.Create(parentGui, enabled)
	local acrylic = {
		Enabled = enabled ~= false,
		Frame = nil,
		Model = nil,
		Blur = nil,
		Connection = nil,
	}

	local frame = Instance.new("Frame")
	frame.Name = "AcrylicLayer"
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
	frame.BackgroundTransparency = 0.65
	frame.BorderSizePixel = 0
	frame.ZIndex = 0
	frame.Parent = parentGui

	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 135
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 8, 8)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 4, 4)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 2, 2)),
	})
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 0.75),
	})
	gradient.Parent = frame

	acrylic.Frame = frame

	local blur = Lighting:FindFirstChild("_VillainsAcrylicDOF")
	if not blur then
		blur = Instance.new("DepthOfFieldEffect")
		blur.Name = "_VillainsAcrylicDOF"
		blur.FarIntensity = 0
		blur.NearIntensity = 1
		blur.FocusDistance = 0.05
		blur.InFocusRadius = 50
		blur.Enabled = false
		blur.Parent = Lighting
	end
	acrylic.Blur = blur

	local model = Instance.new("Model")
	model.Name = "_VillainsAcrylicModel"

	local part = Instance.new("Part")
	part.Name = "AcrylicPart"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Size = Vector3.new(1, 1, 1)
	part.Material = Enum.Material.Glass
	part.Transparency = 1
	part.Parent = model
	model.Parent = Workspace
	acrylic.Model = part

	local function updatePart()
		local cam = getCamera()
		if not cam or not part.Parent then
			return
		end
		part.CFrame = cam.CFrame * CFrame.new(0, 0, -8)
	end

	acrylic.Connection = RunService.RenderStepped:Connect(updatePart)

	function acrylic.SetVisibility(visible)
		if blur then
			blur.Enabled = visible and acrylic.Enabled
		end
		if part then
			part.Transparency = visible and 0.98 or 1
		end
		if frame then
			frame.Visible = visible
		end
	end

	function acrylic.Enable()
		acrylic.Enabled = true
		acrylic.SetVisibility(true)
	end

	function acrylic.Disable()
		acrylic.Enabled = false
		acrylic.SetVisibility(false)
	end

	function acrylic.Destroy()
		if acrylic.Connection then
			acrylic.Connection:Disconnect()
		end
		if model then
			model:Destroy()
		end
		if frame then
			frame:Destroy()
		end
		if blur and blur.Name == "_VillainsAcrylicDOF" then
			blur.Enabled = false
		end
	end

	if enabled then
		acrylic.Enable()
	else
		acrylic.Disable()
	end

	table.insert(Paint.Instances, acrylic)
	return acrylic
end

return Paint
