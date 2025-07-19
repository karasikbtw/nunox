--keystrokes mod for ROBLOX by greenghost110

local gui = Instance.new("ScreenGui")
gui.Name = "KeystrokeGui"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local labels = {}

local function createLabel(name, position, size)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.Position = position
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.BackgroundColor3 = Color3.new(0, 0, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.Text = name
	label.Parent = gui
	return label
end

labels.W = createLabel("W", UDim2.new(1, -60, 0, 20), UDim2.new(0, 40, 0, 40))
labels.A = createLabel("A", UDim2.new(1, -100, 0, 60), UDim2.new(0, 40, 0, 40))
labels.S = createLabel("S", UDim2.new(1, -60, 0, 60), UDim2.new(0, 40, 0, 40))
labels.D = createLabel("D", UDim2.new(1, -20, 0, 60), UDim2.new(0, 40, 0, 40))
labels.LMB = createLabel("LMB       ", UDim2.new(1, -80, 0, 100), UDim2.new(0, 80, 0, 20))
labels.RMB = createLabel("RMB       ", UDim2.new(1, -20, 0, 100), UDim2.new(0, 80, 0, 20))
labels.CPSLMB = createLabel("CPS: 0", UDim2.new(1, -80, 0, 120), UDim2.new(0, 80, 0, 20))
labels.CPSRMB = createLabel("CPS: 0", UDim2.new(1, -20, 0, 120), UDim2.new(0, 80, 0, 20))

local clickHistoryLMB = {}
local clickHistoryRMB = {}
local maxHistoryLength = 10

local function calculateCPS(clickHistory)
	local currentTime = tick()
	local count = 0
	for _, clickTime in ipairs(clickHistory) do
		if currentTime - clickTime <= 1 then
			count = count + 1
		end
	end
	return count
end

local function updateCPSLabels()
	local cpsLMB = calculateCPS(clickHistoryLMB)
	local cpsRMB = calculateCPS(clickHistoryRMB)
	labels.CPSLMB.Text = "CPS: " .. cpsLMB .. "      "
	labels.CPSRMB.Text = "CPS: " .. cpsRMB .. "      "
end

local function setKeyPressedStyle(label)
	label.BackgroundColor3 = Color3.new(1, 1, 1)
	label.TextColor3 = Color3.new(0, 0, 0)
end

local function setKeyReleasedStyle(label)
	label.BackgroundColor3 = Color3.new(0, 0, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
	if not gameProcessedEvent then
		if input.KeyCode == Enum.KeyCode.W then
			setKeyPressedStyle(labels.W)
		elseif input.KeyCode == Enum.KeyCode.A then
			setKeyPressedStyle(labels.A)
		elseif input.KeyCode == Enum.KeyCode.S then
			setKeyPressedStyle(labels.S)
		elseif input.KeyCode == Enum.KeyCode.D then
			setKeyPressedStyle(labels.D)
		end
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.W then
		setKeyReleasedStyle(labels.W)
	elseif input.KeyCode == Enum.KeyCode.A then
		setKeyReleasedStyle(labels.A)
	elseif input.KeyCode == Enum.KeyCode.S then
		setKeyReleasedStyle(labels.S)
	elseif input.KeyCode == Enum.KeyCode.D then
		setKeyReleasedStyle(labels.D)
	end
end)

local function handleMouseButton(input, clickHistory)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
		input.UserInputType == Enum.UserInputType.MouseButton2 then
		setKeyPressedStyle(input.UserInputType == Enum.UserInputType.MouseButton1 and labels.LMB or labels.RMB)
		table.insert(clickHistory, tick())
		if #clickHistory > maxHistoryLength then
			table.remove(clickHistory, 1)
		end
		updateCPSLabels()
	end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
	handleMouseButton(input, input.UserInputType == Enum.UserInputType.MouseButton1 and clickHistoryLMB or clickHistoryRMB)
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		setKeyReleasedStyle(labels.LMB)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		setKeyReleasedStyle(labels.RMB)
	end
end)

game:GetService("RunService").Heartbeat:Connect(function()
	updateCPSLabels()
end)
return gui
