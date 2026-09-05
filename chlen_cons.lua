-- S.A.I.-2.0 | CHLEN CONS | Steal a Egg PRO
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- === НАСТРОЙКИ ===
local rarityOrder = {Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Godly=7}
local locationsList = {"Forest", "Desert", "Ice", "Volcano", "City", "Beach", "Cave", "Sky"} -- подставь свои

local selectedRarity = "Godly"
local selectedLocation = "All"
local autoSteal = false
local showLabels = true
local minimized = false

-- === СОЗДАНИЕ GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CHLEN_GUI"
screenGui.Parent = player.PlayerGui

-- Фон (твой PNG)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://1234567890" -- ЗАМЕНИ НА ID ТВОЕЙ PNG (или поставь локальный)
bg.ImageTransparency = 0.7
bg.Parent = screenGui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок + кнопка свернуть
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "CHLEN-2.0 | STEAL EGG PRO"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = mainFrame
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 400, 0, 35) or UDim2.new(0, 400, 0, 500)
end)

-- Контент (прокрутка)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -35)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 5
scroll.Parent = mainFrame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 600)
content.BackgroundTransparency = 1
content.Parent = scroll

local y = 5

-- Функция создания выпадающего списка
function Dropdown(parent, text, items, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. ": " .. default
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    y = y + 35

    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0.9, 0, 0, #items * 25)
    dropdown.Position = UDim2.new(0.05, 0, 0, y)
    dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    dropdown.Visible = false
    dropdown.Parent = parent

    for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 25)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*25)
        opt.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        opt.Text = item
        opt.TextColor3 = Color3.new(1,1,1)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.Parent = dropdown
        opt.MouseButton1Click:Connect(function()
            callback(item)
            btn.Text = text .. ": " .. item
            dropdown.Visible = false
        end)
    end

    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
    return btn
end

-- Выбор редкости
Dropdown(content, "Rarity", rarityOrder, "Godly", function(val)
    selectedRarity = val
end)

-- Выбор локации
Dropdown(content, "Location", locationsList, "All", function(val)
    selectedLocation = val
end)

-- Кнопка авто-воровства
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.9, 0, 0, 35)
stealBtn.Position = UDim2.new(0.05, 0, 0, y)
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealBtn.Text = "▶ START AUTO STEAL"
stealBtn.TextColor3 = Color3.new(1,1,1)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16
stealBtn.Parent = content
y = y + 45

-- Текст "Самый крутой вариант"
local bestLabel = Instance.new("TextLabel")
bestLabel.Size = UDim2.new(0.9, 0, 0, 40)
bestLabel.Position = UDim2.new(0.05, 0, 0, y)
bestLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
bestLabel.Text = "🏆 BEST: N/A"
bestLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
bestLabel.Font = Enum.Font.GothamBold
bestLabel.TextSize = 16
bestLabel.Parent = content
y = y + 50

-- === ЛОГИКА ===
local function getPetName(eggPart)
    for _, child in pairs(eggPart:GetChildren()) do
        if child:IsA("StringValue") and child.Name == "PetName" then
            return child.Value
        end
    end
    return "Unknown"
end

local function getRarity(eggPart)
    for _, child in pairs(eggPart:GetChildren()) do
        if child:IsA("StringValue") and child.Name == "Rarity" then
            return child.Value
        end
    end
    return "Common"
end

local function getLocation(eggPart)
    for _, child in pairs(eggPart:GetChildren()) do
        if child:IsA("StringValue") and child.Name == "Location" then
            return child.Value
        end
    end
    return "Unknown"
end

local function getAllEggs()
    local eggs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("egg") then
            local rarity = getRarity(v)
            local loc = getLocation(v)
            local pet = getPetName(v)
            table.insert(eggs, {part = v, rarity = rarity, location = loc, pet = pet})
        end
    end
    return eggs
end

local function getBestEgg()
    local eggs = getAllEggs()
    local best = nil
    local bestRank = -1
    for _, e in pairs(eggs) do
        local rank = rarityOrder[e.rarity] or 0
        if rank > bestRank and (selectedLocation == "All" or e.location == selectedLocation) then
            bestRank = rank
            best = e
        end
    end
    return best
end

-- Обновление меток на яйцах
local function updateLabels()
    if not showLabels then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("egg") then
            local existing = v:FindFirstChild("EggLabel")
            if existing then existing:Destroy() end
            local label = Instance.new("BillboardGui")
            label.Name = "EggLabel"
            label.Size = UDim2.new(0, 100, 0, 30)
            label.AlwaysOnTop = true
            label.Parent = v

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = getPetName(v) .. " [" .. getRarity(v) .. "]"
            txt.TextColor3 = Color3.new(1,1,1)
            txt.TextStrokeColor3 = Color3.new(0,0,0)
            txt.TextStrokeTransparency = 0.3
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 14
            txt.Parent = label
        end
    end
end

-- Авто-воровство
stealBtn.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealBtn.Text = autoSteal and "⏹ STOP" or "▶ START AUTO STEAL"
    stealBtn.BackgroundColor3 = autoSteal and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

    while autoSteal do
        local best = getBestEgg()
        if best then
            -- Обновляем лучший вариант
            bestLabel.Text = "🏆 BEST: " .. best.pet .. " [" .. best.rarity .. "] at " .. best.location
            -- Телепорт к яйцу + взятие (симуляция клика)
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = best.part.CFrame + Vector3.new(0, 2, 0)
                wait(0.1)
                -- эмуляция нажатия E или клика (подстрой под игру)
                local args = {[1] = best.part}
                game:GetService("ReplicatedStorage"):FindFirstChild("StealEgg"):FireServer(unpack(args)) -- пример
            end
        else
            bestLabel.Text = "🏆 BEST: No egg found"
        end
        updateLabels()
        wait(0.5)
    end
end)

-- Обновление labels каждые 3 сек
spawn(function()
    while wait(3) do
        if showLabels then updateLabels() end
    end
end)

print("CHLEN-2.0 | PRO script loaded. Enjoy.")
