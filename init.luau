local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VyrexUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Container frame (bottom right corner, starts off-screen for slide-in)
local frame = Instance.new("Frame")
frame.Name = "Container"
frame.Size = UDim2.new(0, 220, 0, 60)
frame.Position = UDim2.new(1, 20, 1, -70) -- starts just off-screen to the right
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 1 -- starts invisible
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title label: "Vyrex"
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextTransparency = 1
title.Text = "Vyrex"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Subtitle label: "Vyrex injected successfully"
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 24)
subtitle.Position = UDim2.new(0, 0, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.TextTransparency = 1
subtitle.Text = "Vyrex injected successfully"
subtitle.TextColor3 = Color3.fromRGB(0, 255, 140)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.Parent = frame

-- Tween settings
local slideInInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local slideOutInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Slide/fade in
local targetPosition = UDim2.new(1, -230, 1, -70)
TweenService:Create(frame, slideInInfo, {
	Position = targetPosition,
	BackgroundTransparency = 0.2
}):Play()

TweenService:Create(title, slideInInfo, {TextTransparency = 0}):Play()
TweenService:Create(subtitle, slideInInfo, {TextTransparency = 0}):Play()

-- Wait, then fade/slide out
task.delay(3.5, function()
	local outPosition = UDim2.new(1, 20, 1, -70)

	TweenService:Create(frame, slideOutInfo, {
		Position = outPosition,
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(title, slideOutInfo, {TextTransparency = 1}):Play()
	local outTween = TweenService:Create(subtitle, slideOutInfo, {TextTransparency = 1})
	outTween:Play()

	outTween.Completed:Wait()
	screenGui:Destroy()
end)
