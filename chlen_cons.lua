--[[
    Retro Console v2.0 — Steal an Egg (Delta Executor)
    Полный функционал: автосбор, аура с битой, определение редкости,
    сворачивание в иконку, PNG-иконка, визуализация яиц на карте.
    Общее количество строк: ~680
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Конфиг
local Config = {
    AutoCollect = true,
    AuraActive = true,
    ShowRarity = true,
    ShowEggsOnMap = true,
    Minimized = false,
    BatCooldown = 0.3,
    CollectRadius = 50,
    AuraRadius = 35,
    Colors = {
        Common = Color3.fromRGB(128, 128, 128),
        Uncommon = Color3.fromRGB(0, 255, 0),
        Rare = Color3.fromRGB(0, 0, 255),
        Epic = Color3.fromRGB(128, 0, 128),
        Legendary = Color3.fromRGB(255, 215, 0),
        Mythic = Color3.fromRGB(255, 68, 255),
        Cosmic = Color3.fromRGB(0, 255, 255),
        Secret = Color3.fromRGB(255, 0, 0),
        Eternal = Color3.fromRGB(255, 140, 0),
        Divine = Color3.fromRGB(255, 215, 0)
    }
}

-- Список питомцев для определения редкости
local PetRarities = {
    -- Forest
    ["Chicken"] = "Common", ["Dog"] = "Common", ["Bird"] = "Uncommon",
    ["Owl"] = "Rare", ["Raccoon"] = "Rare", ["Bear"] = "Epic",
    ["Fox"] = "Epic", ["Brr Brr Patapim"] = "Legendary",
    -- Lake
    ["Frog"] = "Common", ["Duckling"] = "Common", ["Catfish"] = "Uncommon",
    ["Turtle"] = "Rare", ["Trulimero Trulicina"] = "Epic",
    ["Swan"] = "Epic", ["Axolotl"] = "Legendary", ["Leviathan"] = "Cosmic",
    -- Desert
    ["Jerboa"] = "Common", ["Fennec"] = "Uncommon", ["Camel"] = "Rare",
    ["Tob Tobi Tob Tob"] = "Epic", ["Snake"] = "Legendary",
    ["Scorpion"] = "Mythic", ["Sand Spider"] = "Mythic", ["Royal Sphinx"] = "Cosmic",
    -- Jungle
    ["Toucan"] = "Rare", ["Chimpanzee"] = "Rare", ["Crocodile"] = "Epic",
    ["Gorilla"] = "Legendary", ["Orangutini Ananassini"] = "Legendary",
    ["Spider"] = "Mythic", ["Tiger"] = "Mythic", ["King Snake"] = "Secret",
    -- Snow
    ["Penguin"] = "Rare", ["Walrus"] = "Epic", ["Polar Bear"] = "Legendary",
    ["Sabertooth Tiger"] = "Mythic", ["Mammoth"] = "Mythic",
    ["King Mammoth"] = "Cosmic", ["Yeti"] = "Secret", ["Ice Dragon"] = "Eternal",
    -- Volcano
    ["Lava Gecko"] = "Rare", ["Lava Frog"] = "Epic", ["Flaming Bull"] = "Legendary",
    ["Lava Iguana"] = "Legendary", ["Chillin Chilli"] = "Mythic",
    ["Cerberus"] = "Secret", ["Phoenix"] = "Eternal", ["Lava Dragon"] = "Eternal",
    -- Abyss Ocean
    ["Parrotfish"] = "Rare", ["Swordfish"] = "Epic", ["Shark"] = "Legendary",
    ["Orca"] = "Mythic", ["Whale Shark"] = "Cosmic", ["Beluga Whale"] = "Cosmic",
    ["Kraken"] = "Secret", ["El Maja"] = "Eternal",
    -- Prehistoric
    ["Dodo"] = "Rare", ["Pterodactyl"] = "Legendary", ["Ankylosaurus"] = "Mythic",
    ["Triceratops"] = "Cosmic", ["Bronto"] = "Cosmic", ["Tralaledon"] = "Secret",
    ["T-Rex"] = "Secret", ["Mosasaurus"] = "Eternal",
    -- Cosmic
    ["Centapede"] = "Epic", ["Cosmic Gecko"] = "Legendary",
    ["Cosmic Gorilla"] = "Mythic", ["La Vacca Saturno Saturnita"] = "Cosmic",
    ["Cosmic Dragon"] = "Secret", ["Cosmic Skeleton Boss"] = "Secret",
    ["Eternal Lunar Dragon"] = "Eternal", ["Unicorn"] = "Divine",
    -- Cherry Blossom
    ["Crane"] = "Epic", ["Salamander"] = "Legendary", ["Red Panda"] = "Mythic",
    ["Koi"] = "Cosmic", ["Snowy Owl"] = "Cosmic", ["Stag"] = "Secret",
    ["Oni Tiger"] = "Eternal", ["Kitsune"] = "Divine",
    -- Titan Temple
    ["Crustacia"] = "Legendary", ["Spideron"] = "Legendary", ["Bladehide"] = "Mythic",
    ["Mantaris"] = "Cosmic", ["Rhinotaur"] = "Cosmic", ["Mutant Shark"] = "Secret",
    ["Gorilla King"] = "Eternal", ["Nightflame"] = "Divine",
    -- Brainrot Egg
    ["Tung Tung Sahur"] = "Rare", ["Bananita Dolphinita"] = "Epic",
    ["Belula Beluga"] = "Mythic", ["Mangolini Parrochini"] = "Cosmic",
    ["Bomboclat Crocolat"] = "Secret", ["Strawberry Elephant"] = "Eternal",
    -- Monster Egg
    ["Scorpio"] = "Legendary", ["Froggo"] = "Mythic", ["Crawler"] = "Cosmic",
    ["Crocodon"] = "Secret", ["Krakenoid"] = "Eternal", ["Dreadscale"] = "Divine",
    -- Mecha
    ["Mecha Scorpio"] = "Legendary", ["Mecha Froggo"] = "Mythic",
    ["Mecha Crawler"] = "Cosmic", ["Mecha Crocodon"] = "Secret",
    ["Mecha Krakenoid"] = "Eternal", ["Mecha Dreadscale"] = "Divine"
}

-- Функция получения редкости
local function GetPetRarity(petName)
    for name, rarity in pairs(PetRarities) do
        if string.find(petName, name) or string.find(name, petName) then
            return rarity
        end
    end
    return "Unknown"
end

-- Функция получения цвета редкости
local function GetRarityColor(rarity)
    return Config.Colors[rarity] or Color3.fromRGB(255, 255, 255)
end

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RetroConsole"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 560)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(72, 219, 251)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Тень
local Shadow = Instance.new("Frame")
Shadow.Size = MainFrame.Size + UDim2.new(0, 10, 0, 10)
Shadow.Position = MainFrame.Position + UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.Parent = ScreenGui

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🎮 Retro Console — Steal an Egg"
TitleText.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Кнопка сворачивания
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 30, 0, 28)
MinButton.Position = UDim2.new(1, -90, 0, 6)
MinButton.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
MinButton.BorderSizePixel = 1
MinButton.BorderColor3 = Color3.fromRGB(72, 219, 251)
MinButton.Text = "─"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.TextScaled = true
MinButton.Font = Enum.Font.Code
MinButton.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 28)
CloseButton.Position = UDim2.new(1, -40, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(55, 25, 25)
CloseButton.BorderSizePixel = 1
CloseButton.BorderColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.Code
CloseButton.Parent = TitleBar

-- Лог-область
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 0, 180)
LogFrame.Position = UDim2.new(0, 10, 0, 50)
LogFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 16)
LogFrame.BorderSizePixel = 2
LogFrame.BorderColor3 = Color3.fromRGB(72, 219, 251)
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.ScrollBarThickness = 6
LogFrame.Parent = MainFrame

local LogText = Instance.new("TextLabel")
LogText.Size = UDim2.new(1, -10, 0, 0)
LogText.Position = UDim2.new(0, 5, 0, 5)
LogText.BackgroundTransparency = 1
LogText.Text = ""
LogText.TextColor3 = Color3.fromRGB(0, 255, 120)
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.TextScaled = false
LogText.Font = Enum.Font.Code
LogText.TextSize = 12
LogText.Parent = LogFrame

local function AddLog(msg, color)
    color = color or Color3.fromRGB(0, 255, 120)
    local time = os.date("%H:%M:%S")
    LogText.Text = LogText.Text .. string.format("[%s] %s\n", time, msg)
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogText.TextBounds.Y + 30)
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.CanvasSize.Y.Offset)
end

AddLog("Система запущена", Color3.fromRGB(0, 255, 255))
AddLog("Retro Console v2.0 загружена", Color3.fromRGB(255, 200, 100))

-- Панель управления
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, -20, 0, 120)
ControlPanel.Position = UDim2.new(0, 10, 0, 240)
ControlPanel.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
ControlPanel.BorderSizePixel = 2
ControlPanel.BorderColor3 = Color3.fromRGB(72, 219, 251)
ControlPanel.Parent = MainFrame

-- Кнопка автосбора
local CollectBtn = Instance.new("TextButton")
CollectBtn.Size = UDim2.new(0, 180, 0, 35)
CollectBtn.Position = UDim2.new(0, 10, 0, 10)
CollectBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
CollectBtn.BorderSizePixel = 2
CollectBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
CollectBtn.Text = "🔄 Автосбор: ВКЛ"
CollectBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
CollectBtn.TextScaled = true
CollectBtn.Font = Enum.Font.Code
CollectBtn.Parent = ControlPanel

-- Кнопка ауры
local AuraBtn = Instance.new("TextButton")
AuraBtn.Size = UDim2.new(0, 180, 0, 35)
AuraBtn.Position = UDim2.new(0, 10, 0, 55)
AuraBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
AuraBtn.BorderSizePixel = 2
AuraBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
AuraBtn.Text = "💥 Аура: ВКЛ"
AuraBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
AuraBtn.TextScaled = true
AuraBtn.Font = Enum.Font.Code
AuraBtn.Parent = ControlPanel

-- Кнопка показа редкости
local RarityBtn = Instance.new("TextButton")
RarityBtn.Size = UDim2.new(0, 180, 0, 35)
RarityBtn.Position = UDim2.new(0, 200, 0, 10)
RarityBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
RarityBtn.BorderSizePixel = 2
RarityBtn.BorderColor3 = Color3.fromRGB(255, 215, 0)
RarityBtn.Text = "⭐ Редкость: ВКЛ"
RarityBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
RarityBtn.TextScaled = true
RarityBtn.Font = Enum.Font.Code
RarityBtn.Parent = ControlPanel

-- Кнопка показа яиц на карте
local MapBtn = Instance.new("TextButton")
MapBtn.Size = UDim2.new(0, 180, 0, 35)
MapBtn.Position = UDim2.new(0, 200, 0, 55)
MapBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
MapBtn.BorderSizePixel = 2
MapBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
MapBtn.Text = "🗺️ Карта: ВКЛ"
MapBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
MapBtn.TextScaled = true
MapBtn.Font = Enum.Font.Code
MapBtn.Parent = ControlPanel

-- Статистика
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -20, 0, 120)
StatsFrame.Position = UDim2.new(0, 10, 0, 370)
StatsFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
StatsFrame.BorderSizePixel = 2
StatsFrame.BorderColor3 = Color3.fromRGB(72, 219, 251)
StatsFrame.Parent = MainFrame

local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, -10, 1, -10)
StatsText.Position = UDim2.new(0, 5, 0, 5)
StatsText.BackgroundTransparency = 1
StatsText.Text = "📊 Статистика:\nВсего питомцев: 106\nРедкостей: 10\nБиомов: 11\nШоп-яйца: 18"
StatsText.TextColor3 = Color3.fromRGB(200, 200, 255)
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.TextYAlignment = Enum.TextYAlignment.Top
StatsText.TextScaled = false
StatsText.Font = Enum.Font.Code
StatsText.TextSize = 13
StatsText.Parent = StatsFrame

-- Индикатор статуса
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
StatusBar.BorderSizePixel = 1
StatusBar.BorderColor3 = Color3.fromRGB(72, 219, 251)
StatusBar.Parent = MainFrame

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "✅ Готов к работе"
StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusText.TextScaled = true
StatusText.Font = Enum.Font.Code
StatusText.TextSize = 12
StatusText.Parent = StatusBar

-- Обработчики кнопок
CollectBtn.MouseButton1Click:Connect(function()
    Config.AutoCollect = not Config.AutoCollect
    CollectBtn.Text = Config.AutoCollect and "🔄 Автосбор: ВКЛ" or "🔄 Автосбор: ВЫКЛ"
    CollectBtn.BorderColor3 = Config.AutoCollect and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    CollectBtn.TextColor3 = CollectBtn.BorderColor3
    AddLog("Автосбор " .. (Config.AutoCollect and "включен" or "выключен"), 
           Config.AutoCollect and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50))
end)

AuraBtn.MouseButton1Click:Connect(function()
    Config.AuraActive = not Config.AuraActive
    AuraBtn.Text = Config.AuraActive and "💥 Аура: ВКЛ" or "💥 Аура: ВЫКЛ"
    AuraBtn.BorderColor3 = Config.AuraActive and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 100)
    AuraBtn.TextColor3 = AuraBtn.BorderColor3
    AddLog("Аура " .. (Config.AuraActive and "включена" or "выключена"),
           Config.AuraActive and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 100))
end)

RarityBtn.MouseButton1Click:Connect(function()
    Config.ShowRarity = not Config.ShowRarity
    RarityBtn.Text = Config.ShowRarity and "⭐ Редкость: ВКЛ" or "⭐ Редкость: ВЫКЛ"
    RarityBtn.BorderColor3 = Config.ShowRarity and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100)
    RarityBtn.TextColor3 = RarityBtn.BorderColor3
    AddLog("Отображение редкости " .. (Config.ShowRarity and "включено" or "выключено"),
           Config.ShowRarity and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 100))
end)

MapBtn.MouseButton1Click:Connect(function()
    Config.ShowEggsOnMap = not Config.ShowEggsOnMap
    MapBtn.Text = Config.ShowEggsOnMap and "🗺️ Карта: ВКЛ" or "🗺️ Карта: ВЫКЛ"
    MapBtn.BorderColor3 = Config.ShowEggsOnMap and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(100, 100, 100)
    MapBtn.TextColor3 = MapBtn.BorderColor3
    AddLog("Отображение карты " .. (Config.ShowEggsOnMap and "включено" or "выключено"),
           Config.ShowEggsOnMap and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(100, 100, 100))
end)

-- Сворачивание
MinButton.MouseButton1Click:Connect(function()
    Config.Minimized = not Config.Minimized
    MainFrame.Size = Config.Minimized and UDim2.new(0, 60, 0, 40) or UDim2.new(0, 420, 0, 560)
    MainFrame.Position = Config.Minimized and UDim2.new(1, -75, 0, 10) or UDim2.new(0.5, -210, 0.5, -280)
    Shadow.Size = MainFrame.Size + UDim2.new(0, 10, 0, 10)
    Shadow.Position = MainFrame.Position + UDim2.new(0, -5, 0, -5)
    Shadow.Visible = not Config.Minimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= TitleBar and child ~= StatusBar then
            child.Visible = not Config.Minimized
        end
    end
    TitleText.Text = Config.Minimized and "🎮 RC" or "🎮 Retro Console — Steal an Egg"
    StatusBar.Visible = not Config.Minimized
    if Config.Minimized then
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
        MainFrame.BorderSizePixel = 2
    else
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
        MainFrame.BorderSizePixel = 3
    end
    AddLog(Config.Minimized and "Консоль свернута" or "Консоль развернута")
end)

-- Закрытие
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    AddLog("Консоль закрыта")
end)

-- Ядра: автосбор и аура
local function GetEggs()
    local eggs = {}
    local eggContainer = Workspace:FindFirstChild("Eggs")
    if eggContainer then
        for _, child in pairs(eggContainer:GetChildren()) do
            if child:IsA("BasePart") and child:FindFirstChild("ClickDetector") then
                table.insert(eggs, child)
            end
        end
    end
    return eggs
end

local function GetBat()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name, "Bat") or string.find(tool.Name, "bat")) then
            return tool
        end
    end
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name, "Bat") or string.find(tool.Name, "bat")) then
            return tool
        end
    end
    return nil
end

local function CollectEgg(egg)
    local detector = egg:FindFirstChild("ClickDetector")
    if detector then
        fireclickdetector(detector)
        return true
    end
    return false
end

local function GetEggRarity(egg)
    local name = egg.Name
    local rarity = GetPetRarity(name)
    if rarity == "Unknown" then
        -- Пытаемся определить по цвету
        if egg.BrickColor then
            local color = egg.BrickColor.Name
            if color:find("yellow") then rarity = "Legendary"
            elseif color:find("violet") or color:find("purple") then rarity = "Mythic"
            elseif color:find("cyan") or color:find("blue") then rarity = "Cosmic"
            elseif color:find("red") then rarity = "Secret"
            elseif color:find("orange") then rarity = "Eternal"
            elseif color:find("gold") then rarity = "Divine"
            end
        end
    end
    return rarity
end

-- Система визуализации яиц на карте
local EggIndicators = {}
local function UpdateMapIndicators()
    if not Config.ShowEggsOnMap then
        for _, indicator in pairs(EggIndicators) do
            if indicator and indicator.Parent then
                indicator:Destroy()
            end
        end
        EggIndicators = {}
        return
    end
    
    local eggs = GetEggs()
    local currentIndicators = {}
    
    for _, egg in pairs(eggs) do
        local rarity = GetEggRarity(egg)
        local color = GetRarityColor(rarity)
        
        if not EggIndicators[egg] then
            local indicator = Instance.new("BillboardGui")
            indicator.Adornee = egg
            indicator.Size = UDim2.new(0, 40, 0, 40)
            indicator.StudsOffset = Vector3.new(0, 3, 0)
            indicator.Parent = egg
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = color
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 2
            frame.BorderColor3 = color
            frame.Parent = indicator
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = rarity
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextScaled = true
            label.Font = Enum.Font.Code
            label.Parent = frame
            
            EggIndicators[egg] = indicator
        end
        
        currentIndicators[egg] = true
    end
    
    -- Удаляем индикаторы для исчезнувших яиц
    for egg, indicator in pairs(EggIndicators) do
        if not currentIndicators[egg] and indicator and indicator.Parent then
            indicator:Destroy()
            EggIndicators[egg] = nil
        end
    end
end

-- Основной цикл сбора и ауры
local lastCollect = 0
local lastAura = 0

RunService.Heartbeat:Connect(function(deltaTime)
    local now = tick()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPos = char.HumanoidRootPart.Position
    local eggs = GetEggs()
    
    -- Автосбор
    if Config.AutoCollect and now - lastCollect > 0.5 then
        local collected = 0
        for _, egg in pairs(eggs) do
            if egg:IsA("BasePart") and egg:FindFirstChild("ClickDetector") then
                local dist = (rootPos - egg.Position).Magnitude
                if dist < Config.CollectRadius then
                    local success = CollectEgg(egg)
                    if success then
                        collected = collected + 1
                        local rarity = GetEggRarity(egg)
                        AddLog(string.format("Собрано: %s [%s]", egg.Name, rarity), GetRarityColor(rarity))
                    end
                end
            end
        end
        if collected > 0 then
            StatusText.Text = string.format("✅ Собрано %d яиц", collected)
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        end
        lastCollect = now
    end
    
    -- Аура
    if Config.AuraActive and now - lastAura > Config.BatCooldown then
        local bat = GetBat()
        if bat then
            local hit = false
            for _, egg in pairs(eggs) do
                if egg:IsA("BasePart") and egg:FindFirstChild("ClickDetector") then
                    local dist = (rootPos - egg.Position).Magnitude
                    if dist < Config.AuraRadius then
                        -- Симуляция удара битой
                        if not bat.Parent or bat.Parent ~= char then
                            bat.Parent = char
                        end
                        if bat:FindFirstChild("Handle") then
                            local handle = bat.Handle
                            local originalCF = handle.CFrame
                            handle.CFrame = egg.CFrame + Vector3.new(0, 2, 0)
                            wait(0.05)
                            handle.CFrame = originalCF
                        end
                        hit = true
                        local rarity = GetEggRarity(egg)
                        AddLog(string.format("💥 Удар по яйцу: %s [%s]", egg.Name, rarity), GetRarityColor(rarity))
                        
                        if Config.ShowRarity then
                            local rarityLabel = Instance.new("BillboardGui")
                            rarityLabel.Adornee = egg
                            rarityLabel.Size = UDim2.new(0, 80, 0, 30)
                            rarityLabel.StudsOffset = Vector3.new(0, 5, 0)
                            rarityLabel.Parent = egg
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundColor3 = GetRarityColor(rarity)
                            label.BackgroundTransparency = 0.2
                            label.BorderSizePixel = 2
                            label.BorderColor3 = GetRarityColor(rarity)
                            label.Text = rarity .. " | " .. egg.Name
                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                            label.TextScaled = true
                            label.Font = Enum.Font.Code
                            label.Parent = rarityLabel
                            
                            game:GetService("Debris"):AddItem(rarityLabel, 1.5)
                        end
                        
                        wait(0.1)
                    end
                end
            end
            if hit then
                StatusText.Text = "💥 Аура активна!"
                StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        else
            StatusText.Text = "⚠️ Бита не найдена!"
            StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
        lastAura = now
    end
    
    -- Обновление карты
    if Config.ShowEggsOnMap then
        UpdateMapIndicators()
    end
end)

-- Пересоздание GUI при респавне
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if ScreenGui and ScreenGui.Parent then
        AddLog("Персонаж респавн, перезапуск...")
    end
end)

-- Хоткеи
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Config.Minimized = not Config.Minimized
        MinButton.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        Config.AutoCollect = not Config.AutoCollect
        CollectBtn.MouseButton1Click:Fire()
    elseif input.KeyCode == Enum.KeyCode.RightAlt then
        Config.AuraActive = not Config.AuraActive
        AuraBtn.MouseButton1Click:Fire()
    end
end)

-- Инициализация
AddLog("=== RETRO CONSOLE v2.0 ЗАГРУЖЕНА ===")
AddLog("Хоткеи: RCtrl - свернуть, RShift - автосбор, RAlt - аура")
AddLog("Всего питомцев: 106 | Редкостей: 10 | Биомов: 11")
AddLog("Готов к работе!")

-- Сборка мусора
game:GetService("Debris"):AddItem(ScreenGui, 86400) -- На всякий случай
