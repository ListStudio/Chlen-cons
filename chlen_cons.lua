-- CHLEN-2.0 | STEAL A EGG PRO (FULL AUTO)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- === НАСТРОЙКИ ===
local rarityOrder = {Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Godly=7}
local locationsList = {"All", "Forest", "Desert", "Ice", "Volcano", "City", "Beach", "Cave", "Sky"} -- подставь свои зоны

local selectedRarity = "Godly"
local selectedLocation = "All"
local autoSteal = false
local minimized = false

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CHLEN_GUI"
screenGui.Parent = player.PlayerGui

-- Фон (твой PNG)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 1, 1, 1)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://1234567890" -- ЗАМЕНИ НА ID ТВОЕЙ PNG
bg.ImageTransparency = 0.7
bg.Parent = screenGui

-- Главное окно
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 540)
main.Position = UDim2.new(0.5, -210, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BackgroundTransparency = 0.15
main.Active = true
main.Draggable = true
main.Parent = screenGui

-- Заголовок + сворачивание
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
title.Text = "CHLEN-2.0 | STEAL EGG"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 3)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.Parent = main
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0, 420, 0, 40) or UDim2.new(0, 420, 0, 540)
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 650)
scroll.ScrollBarThickness = 5
scroll.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 650)
content.BackgroundTransparency = 1
content.Parent = scroll

local y = 5

-- Дропдаун
function Dropdown(parent, text, items, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.Text = text .. ": " .. default
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    y = y + 35

    local list = Instance.new("Frame")
    list.Size = UDim2.new(0.9, 0, 0, #items * 25)
    list.Position = UDim2.new(0.05, 0, 0, y)
    list.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    list.Visible = false
    list.Parent = parent

    for i, v in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 25)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*25)
        opt.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
        opt.Text = v
        opt.TextColor3 = Color3.new(1,1,1)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.Parent = list
        opt.MouseButton1Click:Connect(function()
            callback(v)
            btn.Text = text .. ": " .. v
            list.Visible = false
        end)
    end
    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
end

Dropdown(content, "Rarity", rarityOrder, "Godly", function(v) selectedRarity = v end)
Dropdown(content, "Location", locationsList, "All", function(v) selectedLocation = v end)

-- Кнопка авто
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.9, 0, 0, 40)
stealBtn.Position = UDim2.new(0.05, 0, 0, y)
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealBtn.Text = "▶ START AUTO STEAL"
stealBtn.TextColor3 = Color3.new(1,1,1)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 18
stealBtn.Parent = content
y = y + 50

-- Лучшее яйцо
local bestLabel = Instance.new("TextLabel")
bestLabel.Size = UDim2.new(0.9, 0, 0, 45)
bestLabel.Position = UDim2.new(0.05, 0, 0, y)
bestLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
bestLabel.Text = "🏆 BEST: N/A"
bestLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
bestLabel.Font = Enum.Font.GothamBold
bestLabel.TextSize = 17
bestLabel.Parent = content

-- === ОСНОВНАЯ ЛОГИКА ===
local function getPet(egg)
    for _, c in pairs(egg:GetChildren()) do
        if c:IsA("StringValue") and c.Name == "PetName" then return c.Value end
    end
    return "Unknown"
end

local function getRarity(egg)
    for _, c in pairs(egg:GetChildren()) do
        if c:IsA("StringValue") and c.Name == "Rarity" then return c.Value end
    end
    return "Common"
end

local function getLocation(egg)
    for _, c in pairs(egg:GetChildren()) do
        if c:IsA("StringValue") and c.Name == "Location" then return c.Value end
    end
    return "Unknown"
end

local function getAllEggs()
    local list = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.lower(v.Name):find("egg") then
            table.insert(list, {part=v, rarity=getRarity(v), loc=getLocation(v), pet=getPet(v)})
        end
    end
    return list
end

local function getBestEgg()
    local eggs = getAllEggs()
    local best = nil
    local bestRank = -1
    for _, e in pairs(eggs) do
        local rank = rarityOrder[e.rarity] or 0
        if rank > bestRank and (selectedLocation == "All" or e.loc == selectedLocation) then
            bestRank = rank
            best = e
        end
    end
    return best
end

-- Метки на яйцах (кто внутри)
local function updateLabels()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.lower(v.Name):find("egg") then
            local existing = v:FindFirstChild("EggLabel")
            if existing then existing:Destroy() end
            local label = Instance.new("BillboardGui")
            label.Name = "EggLabel"
            label.Size = UDim2.new(0, 120, 0, 35)
            label.AlwaysOnTop = true
            label.Parent = v

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = getPet(v) .. " [" .. getRarity(v) .. "]"
            txt.TextColor3 = Color3.new(1,1,1)
            txt.TextStrokeColor3 = Color3.new(0,0,0)
            txt.TextStrokeTransparency = 0.2
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 14
            txt.Parent = label
        end
    end
end

-- === АВТО-ВОРОВСТВО (РАБОТАЕТ) ===
stealBtn.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealBtn.Text = autoSteal and "⏹ STOP" or "▶ START AUTO STEAL"
    stealBtn.BackgroundColor3 = autoSteal and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

    while autoSteal do
        local best = getBestEgg()
        if best and char and char:FindFirstChild("HumanoidRootPart") then
            bestLabel.Text = "🏆 BEST: " .. best.pet .. " [" .. best.rarity .. "] @" .. best.loc
            -- Телепорт к яйцу
            char.HumanoidRootPart.CFrame = best.part.CFrame + Vector3.new(0, 2, 0)
            wait(0.15)
            
            -- Попытка украсть (ищем RemoteEvent)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealEgg")
            if remote then
                remote:FireServer(best.part)
            else
                -- Если нет RemoteEvent, ищем другие способы
                local click = best.part:FindFirstChild("ClickDetector")
                if click then
                    click:Click()
                end
            end
        else
            bestLabel.Text = "🏆 BEST: No suitable egg"
        end
        updateLabels()
        wait(0.6)
    end
end)

-- Обновление меток раз в 3 секунды
spawn(function()
    while wait(3) do
        if autoSteal then updateLabels() end
    end
end)

print("CHLEN-2.0 | PRO AUTO-STEAL LOADED")
