local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char, hrp
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "FlyAndDiscordGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 210)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0, 200, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 10)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 24
flyBtn.Text = "Fly"

local discordBtn = Instance.new("TextButton", frame)
discordBtn.Size = UDim2.new(0, 200, 0, 40)
discordBtn.Position = UDim2.new(0, 10, 0, 60)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.TextColor3 = Color3.new(1,1,1)
discordBtn.Font = Enum.Font.SourceSansBold
discordBtn.TextSize = 22
discordBtn.Text = "Copy Discord Link"

local creditLabel = Instance.new("TextLabel", frame)
creditLabel.Size = UDim2.new(0, 200, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 0, 105)
creditLabel.BackgroundTransparency = 1
creditLabel.TextColor3 = Color3.new(1, 1, 1)
creditLabel.Font = Enum.Font.SourceSansItalic
creditLabel.TextSize = 16
creditLabel.Text = "Made By Proofex"

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 90, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 135)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 18
speedLabel.Text = "Speed:"

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 135)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.SourceSans
speedBox.TextSize = 18
speedBox.Text = "50"
speedBox.ClearTextOnFocus = false
speedBox.TextStrokeTransparency = 0.8
speedBox.PlaceholderText = "Fly speed"

local hideHint = Instance.new("TextLabel", frame)
hideHint.Size = UDim2.new(0, 200, 0, 20)
hideHint.Position = UDim2.new(0, 10, 0, 165)
hideHint.BackgroundTransparency = 1
hideHint.TextColor3 = Color3.new(1, 1, 1)
hideHint.Font = Enum.Font.SourceSansItalic
hideHint.TextSize = 16
hideHint.Text = "Press H To Hide Menu"

local flying = false
local speed = 50
local move = {Up=false, Down=false, Forward=false}
local bv, bg

local function updateFly()
	if not flying or not bv then return end
	
	local vel = Vector3.new(0,0,0)
	
	if move.Forward then
		vel = vel + camera.CFrame.LookVector * speed
	end
	
	if move.Up then
		vel = vel + Vector3.new(0, speed, 0)
	end
	
	if move.Down then
		vel = vel - Vector3.new(0, speed, 0)
	end
	
	bv.Velocity = vel
end

local function startFly()
	if not hrp then return end
	
	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bv.Velocity = Vector3.zero

	bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bg.P = 9e4
	bg.CFrame = hrp.CFrame

	UIS.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode.Space then move.Up = true end
		if input.KeyCode == Enum.KeyCode.LeftShift then move.Down = true end
		if input.KeyCode == Enum.KeyCode.W then move.Forward = true end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then move.Up = false end
		if input.KeyCode == Enum.KeyCode.LeftShift then move.Down = false end
		if input.KeyCode == Enum.KeyCode.W then move.Forward = false end
	end)
end

local function stopFly()
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	bv = nil
	bg = nil
	move = {Up=false, Down=false, Forward=false}
end

-- Handle character respawn
local function onCharacterAdded(character)
	char = character
	hrp = char:WaitForChild("HumanoidRootPart")
	
	-- Restart flying if it was on so it attaches to new hrp
	if flying then
		stopFly()
		startFly()
	end
end

-- Initialize first time
if lp.Character then
	onCharacterAdded(lp.Character)
else
	lp.CharacterAdded:Wait()
	onCharacterAdded(lp.Character)
end

lp.CharacterAdded:Connect(onCharacterAdded)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Unfly" or "Fly"
	if flying then
		startFly()
	else
		stopFly()
	end
end)

discordBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.com")
		discordBtn.Text = "Copied!"
		wait(2)
		discordBtn.Text = "Copy Discord Link"
	else
		discordBtn.Text = "Clipboard not supported"
		wait(2)
		discordBtn.Text = "Copy Discord Link"
	end
end)

RunService.RenderStepped:Connect(function()
	if flying and bg and camera then
		bg.CFrame = camera.CFrame
		updateFly()
	end
end)

local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		math.clamp(startPos.X.Scale, 0, 1),
		math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
		math.clamp(startPos.Y.Scale, 0, 1),
		math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.H then
		gui.Enabled = not gui.Enabled
	end
end)

speedBox.FocusLost:Connect(function(enterPressed)
	local val = tonumber(speedBox.Text)
	if val and val > 0 then
		speed = val
	else
		speedBox.Text = tostring(speed)
	end
end)
