--[[
🔰 GOD SHIELD V∞ - VÔ CỰC TOÀN DIỆN 🔰
Tự động bật tất cả: Anti Ban, Kick, Admin, Roblox, Report, Spectate, Crash, Lag, Stream, Theo dõi, Debug.
Fake Name, Fake IP, Auto Block, Infinity Jump, ESP, chống 267, chống Check, Auto Clean, Auto Destroy GUI.

Hoàn toàn không cần giao diện, hỗ trợ 100% Delta, Synapse, KRNL, Hydrogen, Arceus X.
]]--

-- Thông báo khi bật
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🛡️ GOD SHIELD V∞",
        Text = "Tất cả hệ thống bảo vệ đã được kích hoạt.",
        Duration = 10
    })
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")

-- Fake Name & Fake IP
pcall(function()
    local fakeName = "Unknown_"..math.random(1000,9999)
    local fakeDisplay = "Admin_VN"
    local fakeIP = "192.168."..math.random(0,255).."."..math.random(0,255)

    local mt = getrawmetatable(game)
    setreadonly(mt, false)

    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod():lower()
        if tostring(self):lower():find("getname") or tostring(self):lower():find("ip") then
            return nil
        end
        if method == "getpropertychangedsignal" or method == "getattribute" then
            return function() return nil end
        end
        return oldNamecall(self, unpack(args))
    end)

    pcall(function()
        LocalPlayer.Name = fakeName
        LocalPlayer.DisplayName = fakeDisplay
    end)
end)

-- Infinity Jump
pcall(function()
    UIS.JumpRequest:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

-- Anti Spectate / Admin Camera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local cam = workspace.CurrentCamera
    if cam and cam.CameraSubject ~= LocalPlayer.Character and cam.CameraSubject ~= LocalPlayer.Character:FindFirstChild("Humanoid") then
        cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character
    end
end)

-- Anti Admin & Roblox Tracking
pcall(function()
    local function blockPlayer(plr)
        local uid = plr.UserId
        local blacklist = {1, 2, 3, 7, 261, 145550229, 2040921923, 2077923043}
        if table.find(blacklist, uid) then
            LocalPlayer:Kick("🛡️ Blocked Admin/Roblox: " .. plr.Name)
        end
    end
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then blockPlayer(p) end end
    Players.PlayerAdded:Connect(blockPlayer)
end)

-- Auto Remove Remote, Script, GUI, Notification
task.spawn(function()
    while task.wait(0.5) do
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                if tostring(obj.Name):lower():find("log") or tostring(obj.Name):lower():find("track") or tostring(obj.Name):lower():find("kick") then
                    pcall(function() obj:Destroy() end)
                end
            elseif obj:IsA("Message") or obj:IsA("Hint") or obj:IsA("BillboardGui") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Script") or obj:IsA("LocalScript") then
                if tostring(obj.Name):lower():find("kick") or tostring(obj.Name):lower():find("ban") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end)

-- Anti Crash / Lag / Debug / LogService
pcall(function()
    game:GetService("ScriptContext").Error:Connect(function() return nil end)
    game:GetService("LogService").MessageOut:Connect(function(msg)
        if tostring(msg):lower():find("kick") or tostring(msg):lower():find("ban") then
            return ""
        end
    end)
end)

-- ESP Advanced
pcall(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            box.Size = Vector3.new(4,6,2)
            box.Color3 = Color3.fromRGB(255,0,0)
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Adornee = p.Character.HumanoidRootPart
        end
    end
end)

-- ESP Advanced (hiển thị box + tên + healthbar)
pcall(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera

    local function createESP(player)
        if player == Players.LocalPlayer then return end
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Size = Vector2.new(2, 2)
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Transparency = 1
        box.Filled = false

        local name = Drawing.new("Text")
        name.Size = 13
        name.Center = true
        name.Outline = true
        name.Color = Color3.fromRGB(0, 255, 0)
        name.Text = player.Name

        local function update()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                box.Visible = false
                name.Visible = false
                return
            end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude
                local size = math.clamp(2000 / distance, 4, 80)
                box.Size = Vector2.new(size, size * 1.5)
                box.Position = Vector2.new(pos.X - size / 2, pos.Y - size * 1.5 / 2)
                box.Visible = true
                name.Position = Vector2.new(pos.X, pos.Y - size)
                name.Visible = true
                name.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
            else
                box.Visible = false
                name.Visible = false
            end
        end

        RunService.RenderStepped:Connect(update)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            createESP(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
    end)
end)


-- Aimbot + Silent Aim V∞
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    local function getClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    -- Aimbot (Camera lock)
    RunService.RenderStepped:Connect(function()
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Right click
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- Silent Aim (hook raycast)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if tostring(method):lower() == "findpartonraywithignorelist" or tostring(method):lower() == "raycast" then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end)
end)


-- Auto Shoot V∞ (Bắn tự động khi trỏ vào mục tiêu)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local function isEnemy(target)
        if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            return plr and plr ~= LocalPlayer
        end
        return false
    end

    RunService.RenderStepped:Connect(function()
        local target = Mouse.Target
        if target and isEnemy(target) then
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end)
end)


-- Aimbot Mượt (Soft Lock - Không lock mạnh)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local Sensitivity = 0.2 -- Điều chỉnh độ mượt (0.1 = rất mượt, 1 = nhanh)

    local function getClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                    local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    RunService.RenderStepped:Connect(function()
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Nhấn chuột phải để kích hoạt
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                local direction = (targetPos - Camera.CFrame.Position).Unit
                local newLookVector = Camera.CFrame.LookVector:Lerp(direction, Sensitivity)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLookVector)
            end
        end
    end)
end)


-- Aimbot Nhắm Player Gần Vật Phẩm (Item-Aware Aimbot)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local Sensitivity = 0.2 -- Độ mượt của aimbot
    local itemSearchRange = 15 -- khoảng cách tối đa từ player tới item để được chọn

    local function isNearItem(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
        local root = player.Character.HumanoidRootPart
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("Part") or obj:IsA("Model") then
                if (obj.Position - root.Position).Magnitude <= itemSearchRange then
                    return true
                end
            end
        end
        return false
    end

    local function getClosestPlayerNearItem()
        local closestPlayer = nil
        local shortestDistance = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and isNearItem(player) then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                    local dist = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    RunService.RenderStepped:Connect(function()
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Chuột phải
            local target = getClosestPlayerNearItem()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = target.Character.HumanoidRootPart.Position
                local direction = (targetPos - Camera.CFrame.Position).Unit
                local newLookVector = Camera.CFrame.LookVector:Lerp(direction, Sensitivity)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLookVector)
            end
        end
    end)
end)


-- Auto Spam: VÂN IS KING mỗi vài giây (ẩn danh)
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    task.spawn(function()
        while task.wait(3) do -- đổi 3 thành số giây giữa mỗi lần spam nếu muốn
            local msg = "VÂN IS KING 👑"
            for _, v in pairs(Players:GetPlayers()) do
                if v == LocalPlayer then
                    local args = {
                        [1] = msg,
                        [2] = "All"
                    }
                    local success = pcall(function()
                        local say = LocalPlayer:FindFirstChild("SayMessageRequest", true) or ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
                        if say then
                            say:FireServer(unpack(args))
                        end
                    end)
                end
            end
        end
    end)
end)


-- Auto Spam: VÂN IS KING toàn server (Fix lỗi chat + sử dụng API an toàn)
pcall(function()
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local TextChatService = game:GetService("TextChatService")
    local ChatInputBarConfiguration = TextChatService:FindFirstChild("ChatInputBarConfiguration")

    task.spawn(function()
        while task.wait(3) do
            local msg = "VÂN IS KING 👑"

            -- Cách 1: Ưu tiên API TextChatService (mới)
            if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local success = pcall(function()
                    TextChatService:Chat(msg)
                end)
            end

            -- Cách 2: API truyền thống (fallback)
            local args = {
                [1] = msg,
                [2] = "All"
            }
            local success2 = pcall(function()
                local chatRemote = Players.LocalPlayer:FindFirstChild("SayMessageRequest", true)
                    or game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true)
                if chatRemote then
                    chatRemote:FireServer(unpack(args))
                end
            end)

            -- Cách 3: Dự phòng UI chat nếu tồn tại
            pcall(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = msg,
                    Color = Color3.fromRGB(255, 200, 0),
                    Font = Enum.Font.SourceSansBold,
                    FontSize = Enum.FontSize.Size24
                })
            end)
        end
    end)
end)


-- Ẩn toàn bộ chat hiển thị trên đầu nhân vật
pcall(function()
    local Players = game:GetService("Players")
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                for _, c in pairs(head:GetChildren()) do
                    if c:IsA("BillboardGui") or c.Name:lower():find("chat") then
                        pcall(function() c:Destroy() end)
                    end
                end
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head", 5)
            if head then
                for _, c in pairs(head:GetChildren()) do
                    if c:IsA("BillboardGui") or c.Name:lower():find("chat") then
                        pcall(function() c:Destroy() end)
                    end
                end
            end
        end)
    end)
end)


-- Anti Freeze + Anti Admin Cam (Ngăn phát hiện và bị theo dõi)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    -- Ngăn admin đổi camera quan sát bạn (anti spectate cam)
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local cam = workspace.CurrentCamera
        if cam and cam.CameraSubject ~= LocalPlayer.Character and cam.CameraSubject ~= LocalPlayer.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character
        end
    end)

    -- Anti Freeze: luôn cho phép điều khiển nhân vật
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum.WalkSpeed < 5 then hum.WalkSpeed = 16 end
            if hum.JumpPower < 20 then hum.JumpPower = 50 end
            hum.PlatformStand = false
        end
    end)

    -- Tự động phục hồi camera nếu bị đổi
    RunService.RenderStepped:Connect(function()
        if Camera.CameraSubject ~= LocalPlayer.Character and Camera.CameraSubject ~= LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or LocalPlayer.Character
        end
    end)
end)


-- Toàn bộ hệ thống Anti & Combat mở rộng V∞

pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    -- Auto Repair Character (nếu bị phá humanoid/head)
    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            if not char:FindFirstChild("Humanoid") then
                Instance.new("Humanoid", char).Name = "Humanoid"
            end
            if not char:FindFirstChild("Head") then
                local head = Instance.new("Part", char)
                head.Name = "Head"
                head.Size = Vector3.new(2, 1, 1)
                head.Position = char:GetPivot().Position + Vector3.new(0, 3, 0)
            end
        end
    end)

    -- Anti Sit / Anchor / ForceReset / PlatformStand
    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum.Sit = false
            hum.PlatformStand = false
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Anchored = false
                end
            end
        end
    end)

    -- Anti TP xuống hố (Void)
    RunService.Stepped:Connect(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -100 then
            root.Velocity = Vector3.new(0, 250, 0)
        end
    end)

    -- Anti Velocity chỉnh bất thường
    RunService.Stepped:Connect(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Velocity.Magnitude > 150 then
            root.Velocity = Vector3.zero
        end
    end)

    -- Anti GUI Force từ admin (ẩn GUI bất kỳ bị ép)
    game:GetService("CoreGui").ChildAdded:Connect(function(obj)
        if obj:IsA("ScreenGui") and not obj.Name:match("Rayfield") then
            pcall(function() obj.Enabled = false obj:Destroy() end)
        end
    end)

    -- Triggerbot + Auto Headshot
    local mouse = LocalPlayer:GetMouse()
    RunService.RenderStepped:Connect(function()
        local target = mouse.Target
        if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            if plr and plr ~= LocalPlayer then
                if target.Name == "Head" then
                    mouse1press()
                    task.wait(0.05)
                    mouse1release()
                end
            end
        end
    end)

    -- Wallbang (bắn xuyên nếu raycast thấy địch)
    local function wallCheck()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local origin = Camera.CFrame.Position
                local direction = (player.Character.Head.Position - origin).Unit * 1000
                local result = workspace:Raycast(origin, direction, RaycastParams.new())
                if result and result.Instance and result.Instance:IsDescendantOf(player.Character) then
                    mouse1press()
                    task.wait(0.05)
                    mouse1release()
                end
            end
        end
    end

    RunService.Heartbeat:Connect(wallCheck)
end)


-- Anti Check Account (ẩn danh, fake info nếu bị truy vấn)
pcall(function()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    -- Giả danh tính nếu bị truy cập
    local fakeName = "Guest_"..math.random(1000,9999)
    local fakeUserId = math.random(10000000,99999999)

    -- Hook tên và UserId
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local old_index = mt.__index

    mt.__index = newcclosure(function(t, k)
        if t == LocalPlayer then
            if k == "Name" or k == "DisplayName" then
                return fakeName
            elseif k == "UserId" then
                return fakeUserId
            end
        end
        return old_index(t, k)
    end)
end)


-- Anti Check Account Nâng Cao V∞ (Fake tất cả thông tin tài khoản)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local fakeName = "Guest_"..math.random(1000,9999)
    local fakeUserId = math.random(10000000,99999999)
    local fakeAccountAge = math.random(0, 5)
    local fakeMembership = Enum.MembershipType.None
    local isFakePremium = false

    -- Hook toàn bộ truy cập thông tin
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local old_index = mt.__index

    mt.__index = newcclosure(function(t, k)
        if t == LocalPlayer then
            if k == "Name" or k == "DisplayName" then
                return fakeName
            elseif k == "UserId" then
                return fakeUserId
            elseif k == "AccountAge" then
                return fakeAccountAge
            elseif k == "MembershipType" then
                return fakeMembership
            elseif k == "HasPremium" then
                return isFakePremium
            end
        end
        return old_index(t, k)
    end)
end)


-- Fake Avatar + Block Group Check + Hide Appearance (V∞)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Fake Avatar Thumbnail (ẩn hình đại diện)
    local oldGetUserThumbnailAsync = Players.GetUserThumbnailAsync
    Players.GetUserThumbnailAsync = function(self, userId, thumbType, size)
        if userId == LocalPlayer.UserId then
            return "rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420", true -- Avatar ẩn
        end
        return oldGetUserThumbnailAsync(self, userId, thumbType, size)
    end

    -- Block Group Check
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local old_namecall = mt.__namecall

    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "GetRankInGroup" or method == "IsInGroup" then
            return false
        end
        return old_namecall(...)
    end)

    -- Fake Appearance (ẩn trang phục nhân vật)
    local function hideAppearance(char)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") then
                pcall(function() part:Destroy() end)
            end
        end
    end

    if LocalPlayer.Character then hideAppearance(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(char)
        hideAppearance(char)
    end)
end)


-- Nâng cấp vô cực: Ẩn toàn bộ mã cheat khỏi các công cụ kiểm tra (obfuscation đơn giản)
pcall(function()
    -- Xóa mọi Script.Name để tránh bị dò
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "Instance" and obj:IsA("LocalScript") then
            pcall(function()
                obj.Name = tostring(math.random(100000,999999))
                obj.Disabled = true
                obj.Parent = nil
            end)
        end
    end

    -- Xóa các đoạn code khỏi memory inspect (ẩn function)
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and islclosure(f) and not isexecutorclosure(f) then
            setfenv(f, setmetatable({}, {__index = function() return nil end}))
        end
    end

    -- Xoá dấu vết khỏi PlayerGui nếu có giao diện
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, gui in pairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and not gui.Name:match("Chat") then
                pcall(function() gui.ResetOnSpawn = false gui.Enabled = false gui.Parent = nil end)
            end
        end
    end
end)


-- Auto Attack: Đánh người xung quanh liên tục (Knock/Aggro Bot)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local attackRange = 300

    -- Hàm tấn công (tùy game có thể thay đổi tool hoặc remote)
    local function attackTarget(target)
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Activate") then
            tool:Activate()
        elseif tool then
            -- Simulate click nếu tool không có Activate
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end

    -- Dò tìm người chơi gần và đánh
    RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = LocalPlayer.Character.HumanoidRootPart
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist <= attackRange then
                    attackTarget(player)
                end
            end
        end
    end)
end)


-- Auto Knockdown (Giả lập đánh ngã nếu trong phạm vi)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local attackRange = 300

    -- Gây ngã nếu địch gần
    RunService.Heartbeat:Connect(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                if (targetRoot.Position - root.Position).Magnitude <= attackRange and targetHum and targetHum.Health > 0 then
                    -- Gây lực Knockback
                    local bodyVel = Instance.new("BodyVelocity")
                    bodyVel.Velocity = (targetRoot.Position - root.Position).Unit * 100 + Vector3.new(0, 100, 0)
                    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bodyVel.P = 3000
                    bodyVel.Parent = targetRoot
                    game.Debris:AddItem(bodyVel, 0.2)
                end
            end
        end
    end)
end)


-- Tự động bật tất cả chức năng khi khởi chạy script (Auto Enable All)
pcall(function()
    task.spawn(function()
        wait(1) -- Đợi 1s để đảm bảo toàn bộ script đã nạp

        -- Kích hoạt Tool nếu có
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function()
                tool:Activate()
            end)
        end

        -- Kích hoạt toàn bộ các script toggle/tự động (nếu đặt trong function hoặc module)
        -- Vì ta đang dùng script gộp 1 file, các chức năng đã auto chạy qua RunService, không cần toggle
        print("[AUTO] ✅ Tất cả chức năng đã được kích hoạt hoàn toàn.")
    end)
end)


-- LITE MODE (Chế độ tối giản cho máy yếu)
pcall(function()
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")

    -- Tắt hiệu ứng ánh sáng nặng
    Lighting.FogEnd = 1000000
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.ClockTime = 14

    -- Tắt hiệu ứng hậu cảnh & khử lag
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

    -- Tắt hiệu ứng particles, decals, textures dư thừa
    RunService.Heartbeat:Connect(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            end
        end
    end)

    -- Giảm chất lượng đồ họa nhân vật
    local function simplifyChar(char)
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("Accessory") or p:IsA("Clothing") then
                p:Destroy()
            end
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then simplifyChar(plr.Character) end
        plr.CharacterAdded:Connect(simplifyChar)
    end

    -- Tắt thông báo hệ thống
    StarterGui:SetCore("ResetButtonCallback", false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)


-- AUTO ENABLE PERFORMANCE BOOSTS (Bật tất cả tối ưu tự động)
pcall(function()
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local Debris = game:GetService("Debris")
    local HttpService = game:GetService("HttpService")
    local SoundService = game:GetService("SoundService")

    -- Tối ưu ánh sáng + hậu cảnh
    Lighting.FogEnd = 1e6
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

    -- Tắt âm thanh nền không cần thiết
    for _, s in pairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then
            s.Volume = 0
            s.Playing = false
        end
    end

    -- Tự động dọn workspace mỗi 10s
    task.spawn(function()
        while true do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    pcall(function() obj:Destroy() end)
                end
            end
            task.wait(10)
        end
    end)

    -- Tắt UI hệ thống và cảnh báo
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        StarterGui:SetCore("ResetButtonCallback", false)
    end)

    -- Giảm tải nhân vật
    local function stripChar(char)
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("Accessory") or p:IsA("Clothing") or p:IsA("Decal") then
                pcall(function() p:Destroy() end)
            end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then stripChar(p.Character) end
        p.CharacterAdded:Connect(stripChar)
    end
end)


-- Anti Die Khi Bay Cao (chống rơi xuống void hoặc chết vì cao độ)
pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Humanoid, HRP

    local function setup()
        if LocalPlayer.Character then
            Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    setup()
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        setup()
    end)

    -- Theo dõi vị trí, nếu rơi quá xa thì dịch ngược lên
    RunService.Heartbeat:Connect(function()
        if HRP and Humanoid and Humanoid.Health > 0 then
            if HRP.Position.Y < -50 or HRP.Position.Y > 10000 then
                HRP.Velocity = Vector3.zero
                HRP.CFrame = CFrame.new(0, 100, 0)
                Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                task.wait(0.1)
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
end)


-- Anti Check Infinity Jump (ẩn hành vi nhảy vô hạn khỏi script kiểm tra)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Fake jump count & state nếu bị truy vấn bởi script khác
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local old_index = mt.__index

    mt.__index = newcclosure(function(t, k)
        if t == LocalPlayer and (k == "Jump" or k == "Humanoid" or k == "JumpPower" or k == "UseJumpPower") then
            -- Trả giá trị mặc định để che giấu
            if k == "Jump" then return false end
            if k == "UseJumpPower" then return true end
        end

        if typeof(t) == "Instance" and t:IsA("Humanoid") and (k == "Jump" or k == "JumpPower" or k == "GetState") then
            if k == "Jump" then return false end
            if k == "JumpPower" then return 50 end
            if k == "GetState" then return Enum.HumanoidStateType.Running end
        end

        return old_index(t, k)
    end)
end)


-- ANTI CRASH MẠNH (Chặn các hành vi gây lag, treo hoặc spam loop độc hại)
pcall(function()
    local RS = game:GetService("RunService")
    local WS = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local debris = game:GetService("Debris")

    -- Chặn quá nhiều descendants xuất hiện cùng lúc
    local function isTooManyDescendants()
        local total = #WS:GetDescendants()
        return total > 20000 -- Ngưỡng nguy hiểm tùy game
    end

    -- Dọn các đối tượng spam gây lag
    RS.Heartbeat:Connect(function()
        for _, obj in ipairs(WS:GetDescendants()) do
            if obj:IsA("Explosion") or obj:IsA("Sound") or obj:IsA("Smoke") or obj:IsA("Fire") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Part") and obj.Size.Magnitude > 200 then
                -- Xóa part khổng lồ spam
                pcall(function() obj:Destroy() end)
            end
        end
        -- Tự dọn khi số lượng đối tượng vượt ngưỡng
        if isTooManyDescendants() then
            for _, obj in ipairs(WS:GetChildren()) do
                if not obj:IsA("Camera") and not obj:IsA("Terrain") then
                    debris:AddItem(obj, 0.1)
                end
            end
        end
    end)

    -- Giới hạn FPS drop / chống lỗi vòng lặp treo
    setfpscap(240)
end)


-- ANTI ERROR VÔ CỰC – Chặn toàn bộ lỗi nguy hiểm, lỗi biến mất object, lỗi nil, lỗi gọi sai hàm
pcall(function()
    -- Toàn bộ code nguy hiểm bọc bằng pcall / xpcall
    local oldHook = hookfunction or function(f, g) return f end

    -- Hook các hàm dễ gây lỗi nếu gọi sai
    for _, fn in pairs({"WaitForChild", "FindFirstChild", "IsA"}) do
        if typeof(game[fn]) == "function" then
            local real = game[fn]
            oldHook(real, newcclosure(function(self, ...)
                local s, r = pcall(real, self, ...)
                if s then return r else return nil end
            end))
        end
    end

    -- Hook toàn bộ các kết nối lỗi nguy hiểm
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        local ok, result = pcall(oldNamecall, ...)
        if ok then return result else return nil end
    end)

    -- Hook tất cả function lỗi khác bằng xpcall nếu cần
    if typeof(getgc) == "function" then
        for _, f in pairs(getgc(true)) do
            if typeof(f) == "function" and islclosure(f) and not isexecutorclosure(f) then
                xpcall(function() getfenv(f) end, function() end)
            end
        end
    end

    -- Ngăn lỗi GUI, nil, module, v.v.
    game.DescendantAdded:Connect(function(obj)
        pcall(function()
            if obj:IsA("ScreenGui") or obj:IsA("ModuleScript") then
                obj.Archivable = true
            end
        end)
    end)
end)


-- BLOCK CONSOLE ROBLOX & ADMIN (Chặn log, ẩn toàn bộ hành vi từ console)
pcall(function()
    -- Gỡ log và cảnh báo ra console
    local mt = getrawmetatable(console)
    if mt and setreadonly then setreadonly(mt, false) end

    -- Hook console methods nếu có
    local fakeFunc = function(...) return nil end

    local funcsToBlock = {
        "print", "warn", "error", "debug", "traceback", "assert"
    }

    for _, name in pairs(funcsToBlock) do
        if typeof(_G[name]) == "function" then
            _G[name] = fakeFunc
        end
        if typeof(console[name]) == "function" then
            console[name] = fakeFunc
        end
    end

    -- Hook logService nếu có
    local LogService = game:GetService("LogService")
    pcall(function()
        LogService.MessageOut:Connect(function() return nil end)
        LogService.MessageIn:Connect(function() return nil end)
    end)

    -- Block Admin console detect nếu sử dụng RemoteSpy hoặc log mạng
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            local args = {...}
            if typeof(args[1]) == "string" and string.find(string.lower(args[1]), "log") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
end)


-- ANTI SERVER & SCRIPT ERROR CỰC MẠNH – Chống lỗi mạng, lỗi server, lỗi script phá game
pcall(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local NetworkServer = game:FindService("NetworkServer")
    local HttpService = game:GetService("HttpService")
    local LogService = game:GetService("LogService")

    -- Ngăn lỗi mạng đột ngột, server overload
    setfflag("TaskSchedulerTargetFps", "60")
    setfpscap(240)

    -- Ngăn lỗi script loop gây crash
    local success, err = pcall(function()
        while true do
            task.wait(5)
            if #workspace:GetChildren() > 30000 then
                for _, obj in pairs(workspace:GetChildren()) do
                    if not obj:IsA("Terrain") and not obj:IsA("Camera") then
                        obj:Destroy()
                    end
                end
            end
        end
    end)
    if not success then warn("[ANTI ERROR] Script loop protected") end

    -- Bọc toàn bộ sự kiện mạng bằng pcall
    local function safeConnect(sig, callback)
        pcall(function()
            sig:Connect(function(...)
                local s, r = pcall(callback, ...)
                if not s then return end
            end)
        end)
    end

    -- Chặn log lỗi từ LogService
    pcall(function()
        LogService.MessageOut:Connect(function(msg, typ)
            if typ == Enum.MessageType.MessageError then return nil end
        end)
    end)

    -- Auto retry kết nối nếu server lag (mock)
    pcall(function()
        local tries = 0
        game:GetService("Players").PlayerRemoving:Connect(function(plr)
            tries = tries + 1
            if tries > 3 then
                warn("[ANTI ERROR] Server may be unstable. Retrying protections...")
                task.wait(1)
            end
        end)
    end)
end)


-- AUTO BLOCK ALL PLAYERS (Tự động block toàn bộ người chơi khác)
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function blockPlayer(player)
        if player ~= LocalPlayer then
            pcall(function()
                LocalPlayer:RequestStreamAroundAsync(player.Position or player.Character:FindFirstChild("HumanoidRootPart").Position)
                LocalPlayer:BlockUserId(player.UserId)
            end)
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        blockPlayer(player)
    end

    Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)
        blockPlayer(player)
    end)
end)


-- ANTI ADMIN STREAM + BLOCK WEB – chống theo dõi + ngăn gửi dữ liệu ra ngoài
pcall(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- BLOCK HTTP REQUEST (ngăn gửi dữ liệu ra ngoài)
    if hookfunction then
        local old_request = request or http_request or syn and syn.request
        if old_request then
            hookfunction(old_request, newcclosure(function(args)
                if typeof(args) == "table" and typeof(args.Url) == "string" then
                    if string.find(string.lower(args.Url), "webhook") or string.find(args.Url, "http") then
                        warn("[ANTI] Blocked Web Request:", args.Url)
                        return { Success = false, StatusCode = 403 }
                    end
                end
                return old_request(args)
            end))
        end
    end

    -- ANTI STREAM: theo dõi admin stream camera
    local function detectStreamWatcher()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer and plr.Character == nil and not plr:GetRankInGroup(0) == 0 then
                warn("[ANTI] Possible stream mode / admin cam detected:", plr.Name)
                -- Có thể kick local cam hoặc spam teleport để out stream
                local char = Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char:MoveTo(Vector3.new(math.random(1,999), 1000, math.random(1,999)))
                end
            end
        end
    end

    RunService.Heartbeat:Connect(function()
        pcall(detectStreamWatcher)
    end)
end)


-- ANTI KICK TỪ THÔNG BÁO KIỂM DUYỆT VÀ ADMIN – Bảo vệ cực mạnh khỏi kick/ban qua UI hoặc Remote
pcall(function()
    local mt = getrawmetatable(game)
    if setreadonly then setreadonly(mt, false) end
    local old_namecall = mt.__namecall
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Hook kick và thông báo
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        -- Chặn Kick thông qua các hình thức thông báo
        if tostring(self) == "Kick" or method == "Kick" then
            warn("[ANTI] Kick attempt blocked")
            return nil
        end

        -- Chặn thông báo hệ thống có chứa lý do kiểm duyệt / báo cáo / từ khóa nghi ngờ
        if method == "FireServer" or method == "InvokeServer" then
            for i,v in pairs(args) do
                if typeof(v) == "string" and (
                    v:lower():find("moderation") or
                    v:lower():find("report") or
                    v:lower():find("exploit") or
                    v:lower():find("ban") or
                    v:lower():find("log") or
                    v:lower():find("kick")
                ) then
                    warn("[ANTI] Attempted report/kick request blocked:", v)
                    return nil
                end
            end
        end

        return old_namecall(self, ...)
    end)

    -- Block trực tiếp từ lệnh Kick local
    LocalPlayer.Kick = function(...) return warn("[ANTI] Kick function bypassed") end
end)
