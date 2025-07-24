-- Tải thư viện UI đơn giản (Rayfield UI nếu muốn có thể nâng cấp thêm sau)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local CoreGui = game:GetService("CoreGui")

-- Xoá GUI cũ nếu tồn tại
pcall(function()
    CoreGui:FindFirstChild("AntiAFKGui"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AntiAFKGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "GUI By Vân"
Title.Size = UDim2.new(1, 0, 0.15, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.BackgroundTransparency = 1

-- Toggle GUI button
local toggleBtn = Instance.new("TextButton", ScreenGui)
toggleBtn.Text = "👁 Ẩn/Hiện"
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0.01, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true

toggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tạo toggle button
local function makeToggle(name, default, position, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0.12, 0)
    btn.Position = UDim2.new(0.05, 0, position, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- Slider tạo function
local function makeSlider(labelText, min, max, default, posY, callback)
    local label = Instance.new("TextLabel", MainFrame)
    label.Text = labelText .. ": " .. tostring(default)
    label.Size = UDim2.new(0.9, 0, 0.08, 0)
    label.Position = UDim2.new(0.05, 0, posY, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextScaled = true

    local slider = Instance.new("TextButton", MainFrame)
    slider.Size = UDim2.new(0.9, 0, 0.05, 0)
    slider.Position = UDim2.new(0.05, 0, posY + 0.07, 0)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    slider.Text = ""
    
    local dragging = false
    local value = default

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0

    local function update(input)
        local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * x)
        fill.Size = UDim2.new(x, 0, 1, 0)
        label.Text = labelText .. ": " .. tostring(value)
        callback(value)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
local afkEnabled = false

player.Idled:Connect(function()
    if afkEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        print("AFK bypass hoạt động.")
    end
end)

makeToggle("Anti-AFK", false, 0.18, function(state)
    afkEnabled = state
end)

-- Speed toggle (bật/tắt)
local speedEnabled = false
local currentSpeed = 16

makeToggle("Speed", false, 0.32, function(state)
    speedEnabled = state
end)

makeSlider("WalkSpeed", 16, 200, 50, 0.44, function(val)
    currentSpeed = val
end)

-- Jump toggle
local jumpEnabled = false
local currentJump = 50

makeToggle("Jump", false, 0.60, function(state)
    jumpEnabled = state
end)

makeSlider("JumpPower", 50, 200, 120, 0.72, function(val)
    currentJump = val
end)

-- Apply speed & jump
spawn(function()
    while true do
        if char and humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = currentSpeed
            else
                humanoid.WalkSpeed = 45
            end

            if jumpEnabled then
                humanoid.JumpPower = currentJump
            else
                humanoid.JumpPower = 80
            end
        end
        wait(0.1)
    end
end)