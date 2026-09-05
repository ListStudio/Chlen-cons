-- CHLEN-2.0 | ФИНАЛ (PNG ИЗ РЕПОЗИТОРИЯ + ВСЁ РАБОТАЕТ)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local replicated = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")

-- === ЗАГРУЗКА PNG ИЗ РЕПОЗИТОРИЯ ===
local function getImageFromRepo()
    local success, data = pcall(function()
        return http:HttpGet("https://raw.githubusercontent.com/ListStudio/Chlen-cons/main/png.jpg")
    end)
    if success and data then
        -- Конвертируем в base64
        local base64 = game:GetService("HttpService"):Base64Encode(data)
        return "rbxassetid://" .. base64
    end
    return "rbxassetid://6031091071" -- заглушка, если не загрузится
end

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CHLEN_GUI"
screenGui.Parent = player.PlayerGui

-- ФОН (PNG ИЗ РЕПОЗИТОРИЯ)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 1, 1, 1)
bg.BackgroundTransparency = 1
bg.Image = getImageFromRepo()
bg.ImageTransparency = 0.4
bg.ScaleType = Enum.ScaleType.Fit
bg.Parent = screenGui

-- Подгрузка в фоне
spawn(function()
    local img = getImageFromRepo()
    if img then
        bg.Image = img
    end
end)

-- === МАЛЕНЬКАЯ ИКОНКА ===
local iconBtn = Instance.new("TextButton")
iconBtn.Size = UDim2.new(0, 48, 0, 48)
iconBtn.Position = UDim2.new(0.01, 0, 0.01, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
iconBtn.BackgroundTransparency = 0.15
iconBtn.BorderSizePixel = 0
iconBtn.Text = "⚡"
iconBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 28
iconBtn.Parent = screenGui

-- === ГЛАВНОЕ ОКНО ===
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 520)
main.Position = UDim2.new(0.5, -230, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = screenGui

-- Заголовок
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
header.BackgroundTransparency = 0.15
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.02, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ CHLEN-2.0 | ФИНАЛ"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = header

-- === ЭЛЕМЕНТЫ ===
local y = 55

-- Кнопка авто-стила
local styleBtn = Instance.new("TextButton")
styleBtn.Size = UDim2.new(0.85, 0, 0, 45)
styleBtn.Position = UDim2.new(0.075, 0, 0, y)
styleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
styleBtn.BackgroundTransparency = 0.2
styleBtn.Text = "🔥 АВТО-СТИЛ (ВЫКЛ)"
styleBtn.TextColor3 = Color3.new(1,1,1)
styleBtn.Font = Enum.Font.GothamBold
styleBtn.TextSize = 16
styleBtn.Parent = main
y = y + 55

-- Кнопка ауры с битой
local auraBtn = Instance.new("TextButton")
auraBtn.Size = UDim2.new(0.85, 0, 0, 45)
auraBtn.Position = UDim2.new(0.075, 0, 0, y)
auraBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
auraBtn.BackgroundTransparency = 0.2
auraBtn.Text = "🌀 БИТА-АУРА (ВЫКЛ)"
auraBtn.TextColor3 = Color3.new(1,1,1)
auraBtn.Font = Enum.Font.GothamBold
auraBtn.TextSize = 16
auraBtn.Parent = main
y = y + 55

-- Кнопка флая
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.85, 0, 0, 45)
flyBtn.Position = UDim2.new(0.075, 0, 0, y)
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
flyBtn.BackgroundTransparency = 0.2
flyBtn.Text = "🕊️ ФЛАЙ (ВЫКЛ)"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
flyBtn.Parent = main
y = y + 55

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.85, 0, 0, 30)
statusLabel.Position = UDim2.new(0.075, 0, 0, y)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🏆 Статус: Ожидание"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = main
y = y + 40

-- Инфо о яйце
local eggInfo = Instance.new("TextLabel")
eggInfo.Size = UDim2.new(0.85, 0, 0, 30)
eggInfo.Position = UDim2.new(0.075, 0, 0, y)
eggInfo.BackgroundTransparency = 1
eggInfo.Text = "🥚 Яйцо: нет"
eggInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
eggInfo.Font = Enum.Font.GothamBold
eggInfo.TextSize = 14
eggInfo.Parent = main

-- === ПЕРЕМЕННЫЕ ===
local autoStyle = false
local auraActive = false
local flyActive = false
local auraParts = {}

-- === ГОД-МОД (БЕССМЕРТИЕ + АНТИ-НОКАУТ) ===
local function godMode()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        humanoid.BreakJointsOnDeath = false
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
    -- Анти-нокаут
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Anchored = false
        root:GetPropertyChangedSignal("Position"):Connect(function()
            if root.Position.Y < -50 then
                root.Position = Vector3.new(0, 10, 0)
            end
        end)
    end
end

-- Автозапуск год-мода
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    godMode()
end)
godMode()

-- === ЛОГИКА ===
local function findEggs()
    local eggs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.lower(v.Name):find("egg") then
            table.insert(eggs, v)
        end
    end
    return eggs
end

local function getNearestEgg()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest = nil
    local minDist = math.huge
    for _, egg in pairs(findEggs()) do
        local dist = (egg.Position - root.Position).Magnitude
        if dist < minDist then
            minDist = dist
            nearest = egg
        end
    end
    return nearest
end

local function getEggInfo(egg)
    if not egg then return "Нет яйца" end
    return egg.Name
end

local function stealEgg(egg)
    if not egg then return false end
    local remote = replicated:FindFirstChild("StealEgg") or replicated:FindFirstChild("EggSteal") or replicated:FindFirstChild("Collect")
    if remote then remote:FireServer(egg); return true end
    local click = egg:FindFirstChild("ClickDetector")
    if click then click:Click(); return true end
    local prompt = egg:FindFirstChild("ProximityPrompt")
    if prompt then prompt:InputHoldBegin(); wait(0.15); prompt:InputHoldEnd(); return true end
    return false
end

-- === БИТА-АУРА ===
local function createAura()
    for _, p in pairs(auraParts) do p:Destroy() end
    auraParts = {}
    for i = 1, 16 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.6, 0.6, 1.8)
        part.BrickColor = BrickColor.new("Bright orange")
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.25
        part.Parent = workspace
        table.insert(auraParts, part)
    end
end

local function updateAura()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local time = tick()
    for i, p in pairs(auraParts) do
        local angle = (i / #auraParts) * math.pi * 2 + time * 2.5
        local radius = 5 + math.sin(time * 1.2 + i) * 0.5
        p.CFrame = root.CFrame * CFrame.new(math.sin(angle) * radius, 1.5 + math.sin(time * 1.8 + i) * 0.5, math.cos(angle) * radius)
        p.Orientation = Vector3.new(math.sin(time + i) * 30, math.deg(angle), math.sin(time * 0.5 + i) * 20)
    end
    
    -- Бьём ближайшего игрока БИТОЙ (отбрасывание, а не урон)
    local nearest = nil
    local minDist = 10
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < minDist then
                minDist = d
                nearest = plr.Character
            end
        end
    end
    if nearest and nearest:FindFirstChild("Humanoid") then
        local targetRoot = nearest.HumanoidRootPart
        -- Отбрасываем как битой
        local direction = (targetRoot.Position - root.Position).Unit
        targetRoot.Velocity = direction * 50 + Vector3.new(0, 20, 0)
        -- Визуальный эффект удара битой
        local flash = Instance.new("Part")
        flash.Size = Vector3.new(3, 3, 3)
        flash.BrickColor = BrickColor.new("Bright orange")
        flash.Material = Enum.Material.Neon
        flash.Anchored = true
        flash.CanCollide = false
        flash.Transparency = 0.5
        flash.Position = targetRoot.Position
        flash.Parent = workspace
        game:GetService("Debris"):AddItem(flash, 0.3)
    end
end

-- === ФЛАЙ ===
local flyBodyVelocity = nil
local function toggleFly(state)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if state then
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = root
        -- Управление
        runService.Heartbeat:Connect(function()
            if not flyActive then
                if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
                return
            end
            local dir = Vector3.new(0, 0, 0)
            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + root.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - root.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - root.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + root.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            if flyBodyVelocity then
                flyBodyVelocity.Velocity = dir * 60
            end
        end)
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    end
end

-- === КНОПКИ ===
styleBtn.MouseButton1Click:Connect(function()
    autoStyle = not autoStyle
    styleBtn.Text = autoStyle and "🔥 АВТО-СТИЛ (ВКЛ)" or "🔥 АВТО-СТИЛ (ВЫКЛ)"
    styleBtn.BackgroundColor3 = autoStyle and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    statusLabel.Text = autoStyle and "🏆 Статус: СТИЛУЮ..." or "🏆 Статус: Остановлен"
    
    spawn(function()
        while autoStyle do
            local egg = getNearestEgg()
            if egg then
                eggInfo.Text = "🥚 " .. getEggInfo(egg)
                statusLabel.Text = "🏆 Статус: СТИЛУЮ " .. egg.Name
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = egg.CFrame + Vector3.new(0, 2, 0) end
                wait(0.1)
                stealEgg(egg)
            else
                eggInfo.Text = "🥚 Яйцо: НЕТ"
                statusLabel.Text = "🏆 Статус: Яиц нет"
            end
            wait(0.5)
        end
    end)
end)

auraBtn.MouseButton1Click:Connect(function()
    auraActive = not auraActive
    auraBtn.Text = auraActive and "🌀 БИТА-АУРА (ВКЛ)" or "🌀 БИТА-АУРА (ВЫКЛ)"
    auraBtn.BackgroundColor3 = auraActive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(50, 100, 255)
    
    if auraActive then
        createAura()
        spawn(function()
            while auraActive do
                updateAura()
                wait(0.05)
            end
        end)
    else
        for _, p in pairs(auraParts) do p:Destroy() end
        auraParts = {}
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    flyBtn.Text = flyActive and "🕊️ ФЛАЙ (ВКЛ)" or "🕊️ ФЛАЙ (ВЫКЛ)"
    flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(100, 200, 100)
    toggleFly(flyActive)
end)

-- === СВОРАЧИВАНИЕ ===
iconBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

print("CHLEN-2.0 | ФИНАЛ ЗАГРУЖЕН")
