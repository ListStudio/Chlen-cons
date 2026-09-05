-- CHLEN-2.0 | STEAL EGG ULTIMATE v3 (MULTI-SELECT)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local replicated = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- === БАЗА ДАННЫХ (106 питомцев) ===
local petDB = {
    Forest = {
        {name="Chicken", rarity="Common", value=1},
        {name="Dog", rarity="Common", value=2},
        {name="Bird", rarity="Uncommon", value=8},
        {name="Owl", rarity="Rare", value=35},
        {name="Raccoon", rarity="Rare", value=45},
        {name="Bear", rarity="Epic", value=240},
        {name="Fox", rarity="Epic", value=180},
        {name="Brr Brr Patapim", rarity="Legendary", value=1800}
    },
    Lake = {
        {name="Frog", rarity="Common", value=3},
        {name="Duckling", rarity="Common", value=4},
        {name="Catfish", rarity="Uncommon", value=12},
        {name="Turtle", rarity="Rare", value=60},
        {name="Trulimero Trulicina", rarity="Epic", value=260},
        {name="Swan", rarity="Epic", value=320},
        {name="Axolotl", rarity="Legendary", value=2800},
        {name="Leviathan", rarity="Cosmic", value=220000}
    },
    Desert = {
        {name="Jerboa", rarity="Common", value=6},
        {name="Fennec", rarity="Uncommon", value=18},
        {name="Camel", rarity="Rare", value=75},
        {name="Tob Tobi Tob Tob", rarity="Epic", value=325},
        {name="Snake", rarity="Legendary", value=3600},
        {name="Scorpion", rarity="Mythic", value=18500},
        {name="Sand Spider", rarity="Mythic", value=16000},
        {name="Royal Sphinx", rarity="Cosmic", value=280000}
    },
    Jungle = {
        {name="Toucan", rarity="Rare", value=110},
        {name="Chimpanzee", rarity="Rare", value=90},
        {name="Crocodile", rarity="Epic", value=420},
        {name="Gorilla", rarity="Legendary", value=4800},
        {name="Orangutini Ananassini", rarity="Legendary", value=5500},
        {name="Spider", rarity="Mythic", value=22000},
        {name="Tiger", rarity="Mythic", value=28000},
        {name="King Snake", rarity="Secret", value=3500000}
    },
    Snow = {
        {name="Penguin", rarity="Rare", value=140},
        {name="Walrus", rarity="Epic", value=600},
        {name="Polar Bear", rarity="Legendary", value=7000},
        {name="Sabertooth Tiger", rarity="Mythic", value=35000},
        {name="Mammoth", rarity="Mythic", value=42000},
        {name="King Mammoth", rarity="Cosmic", value=400000},
        {name="Yeti", rarity="Secret", value=5000000},
        {name="Ice Dragon", rarity="Eternal", value=65000000}
    },
    Volcano = {
        {name="Lava Gecko", rarity="Rare", value=180},
        {name="Lava Frog", rarity="Epic", value=850},
        {name="Flaming Bull", rarity="Legendary", value=9500},
        {name="Lava Iguana", rarity="Legendary", value=11000},
        {name="Chillin Chilli", rarity="Mythic", value=55000},
        {name="Cerberus", rarity="Secret", value=8000000},
        {name="Phoenix", rarity="Eternal", value=85000000},
        {name="Lava Dragon", rarity="Eternal", value=100000000}
    },
    ["Abyss Ocean"] = {
        {name="Parrotfish", rarity="Rare", value=220},
        {name="Swordfish", rarity="Epic", value=1100},
        {name="Shark", rarity="Legendary", value=15000},
        {name="Orca", rarity="Mythic", value=80000},
        {name="Whale Shark", rarity="Cosmic", value=700000},
        {name="Beluga Whale", rarity="Cosmic", value=850000},
        {name="Kraken", rarity="Secret", value=15000000},
        {name="El Maja", rarity="Eternal", value=130000000}
    },
    Prehistoric = {
        {name="Dodo", rarity="Rare", value=280},
        {name="Pterodactyl", rarity="Legendary", value=22000},
        {name="Ankylosaurus", rarity="Mythic", value=120000},
        {name="Triceratops", rarity="Cosmic", value=1200000},
        {name="Bronto", rarity="Cosmic", value=1500000},
        {name="Tralaledon", rarity="Secret", value=32000000},
        {name="T-Rex", rarity="Secret", value=25000000},
        {name="Mosasaurus", rarity="Eternal", value=180000000}
    },
    Cosmic = {
        {name="Centapede", rarity="Epic", value=1500},
        {name="Cosmic Gecko", rarity="Legendary", value=30000},
        {name="Cosmic Gorilla", rarity="Mythic", value=180000},
        {name="La Vacca Saturno Saturnita", rarity="Cosmic", value=2200000},
        {name="Cosmic Dragon", rarity="Secret", value=60000000},
        {name="Cosmic Skeleton Boss", rarity="Secret", value=45000000},
        {name="Eternal Lunar Dragon", rarity="Eternal", value=250000000},
        {name="Unicorn", rarity="Divine", value=1000000000}
    },
    ["Cherry Blossom"] = {
        {name="Crane", rarity="Epic", value=4000},
        {name="Salamander", rarity="Legendary", value=74000},
        {name="Red Panda", rarity="Mythic", value=450000},
        {name="Koi", rarity="Cosmic", value=12000000},
        {name="Snowy Owl", rarity="Cosmic", value=7500000},
        {name="Stag", rarity="Secret", value=145000000},
        {name="Oni Tiger", rarity="Eternal", value=600000000},
        {name="Kitsune", rarity="Divine", value=1800000000}
    },
    ["Titan Temple"] = {
        {name="Crustacia", rarity="Legendary", value=130000},
        {name="Spideron", rarity="Legendary", value=95000},
        {name="Bladehide", rarity="Mythic", value=750000},
        {name="Mantaris", rarity="Cosmic", value=11000000},
        {name="Rhinotaur", rarity="Cosmic", value=17500000},
        {name="Mutant Shark", rarity="Secret", value=215000000},
        {name="Gorilla King", rarity="Eternal", value=880000000},
        {name="Nightflame", rarity="Divine", value=3000000000}
    }
}

-- === НАСТРОЙКИ ===
local rarityOrder = {Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10}
local allRarities = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}
local allLocations = {"Forest","Lake","Desert","Jungle","Snow","Volcano","Abyss Ocean","Prehistoric","Cosmic","Cherry Blossom","Titan Temple"}

local selectedRarities = {Divine=true}
local selectedLocations = {}
for _, loc in pairs(allLocations) do selectedLocations[loc] = true end
local autoSteal = false
local auraActive = false

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CHLEN_GUI"
screenGui.Parent = player.PlayerGui

-- ФОН (твоя PNG)
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 1, 1, 1)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://1234567890"  -- ЗАМЕНИ
bg.ImageTransparency = 0.4
bg.Parent = screenGui

-- === МАЛЕНЬКАЯ ИКОНКА ===
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 52, 0, 52)
iconFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
iconFrame.BackgroundTransparency = 0.2
iconFrame.BorderSizePixel = 0
iconFrame.Parent = screenGui

local iconBtn = Instance.new("TextButton")
iconBtn.Size = UDim2.new(1, 0, 1, 0)
iconBtn.BackgroundTransparency = 1
iconBtn.Text = "⚡"
iconBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 28
iconBtn.Parent = iconFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 0, 16)
iconLabel.Position = UDim2.new(0, 0, 1, -2)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "CHLEN"
iconLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
iconLabel.Font = Enum.Font.GothamBold
iconLabel.TextSize = 10
iconLabel.Parent = iconFrame

-- === ГЛАВНОЕ ОКНО ===
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 600)
main.Position = UDim2.new(0.5, -260, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = screenGui

-- Заголовок
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
header.BackgroundTransparency = 0.15
header.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ CHLEN-2.0 | MULTI-STEAL"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = header

-- Скролл
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -44)
scroll.Position = UDim2.new(0, 0, 0, 44)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
scroll.ScrollBarThickness = 4
scroll.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 900)
content.BackgroundTransparency = 1
content.Parent = scroll

local y = 6

-- === ФУНКЦИЯ СОЗДАНИЯ ЧЕКБОКСА ===
function createCheckbox(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.28, 0, 0, 26)
    frame.Position = UDim2.new(0.02 + (math.floor(#text/2) % 3) * 0.32, 0, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local check = Instance.new("ImageButton")
    check.Size = UDim2.new(0, 18, 0, 18)
    check.Position = UDim2.new(0, 0, 0.5, -9)
    check.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    check.BorderSizePixel = 0
    check.Image = default and "rbxassetid://6023099522" or ""
    check.ImageColor3 = Color3.fromRGB(255, 200, 50)
    check.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -22, 1, 0)
    label.Position = UDim2.new(0, 22, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local state = default
    check.MouseButton1Click:Connect(function()
        state = not state
        check.Image = state and "rbxassetid://6023099522" or ""
        callback(state)
    end)
    return frame
end

-- Заголовок "Редкости"
local rarityTitle = Instance.new("TextLabel")
rarityTitle.Size = UDim2.new(0.9, 0, 0, 22)
rarityTitle.Position = UDim2.new(0.05, 0, 0, y)
rarityTitle.BackgroundTransparency = 1
rarityTitle.Text = "🎯 РЕДКОСТИ (выбери несколько)"
rarityTitle.TextColor3 = Color3.fromRGB(255, 200, 150)
rarityTitle.Font = Enum.Font.GothamBold
rarityTitle.TextSize = 14
rarityTitle.TextXAlignment = Enum.TextXAlignment.Left
rarityTitle.Parent = content
y = y + 28

local rarityFrame = Instance.new("Frame")
rarityFrame.Size = UDim2.new(0.96, 0, 0, 70)
rarityFrame.Position = UDim2.new(0.02, 0, 0, y)
rarityFrame.BackgroundTransparency = 1
rarityFrame.Parent = content
y = y + 76

local rarityChecks = {}
for i, r in ipairs(allRarities) do
    local cb = createCheckbox(rarityFrame, r, r == "Divine", function(state)
        selectedRarities[r] = state
    end)
    rarityChecks[r] = cb
end

-- Заголовок "Локации"
local locTitle = Instance.new("TextLabel")
locTitle.Size = UDim2.new(0.9, 0, 0, 22)
locTitle.Position = UDim2.new(0.05, 0, 0, y)
locTitle.BackgroundTransparency = 1
locTitle.Text = "📍 ЛОКАЦИИ (выбери несколько)"
locTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
locTitle.Font = Enum.Font.GothamBold
locTitle.TextSize = 14
locTitle.TextXAlignment = Enum.TextXAlignment.Left
locTitle.Parent = content
y = y + 28

local locFrame = Instance.new("Frame")
locFrame.Size = UDim2.new(0.96, 0, 0, 90)
locFrame.Position = UDim2.new(0.02, 0, 0, y)
locFrame.BackgroundTransparency = 1
locFrame.Parent = content
y = y + 96

local locChecks = {}
for i, loc in ipairs(allLocations) do
    local cb = createCheckbox(locFrame, loc, true, function(state)
        selectedLocations[loc] = state
    end)
    locChecks[loc] = cb
end

-- Кнопки
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.44, 0, 0, 38)
stealBtn.Position = UDim2.new(0.04, 0, 0, y)
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealBtn.BackgroundTransparency = 0.3
stealBtn.Text = "▶ AUTO STEAL"
stealBtn.TextColor3 = Color3.new(1,1,1)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16
stealBtn.Parent = content

local auraBtn = Instance.new("TextButton")
auraBtn.Size = UDim2.new(0.44, 0, 0, 38)
auraBtn.Position = UDim2.new(0.52, 0, 0, y)
auraBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
auraBtn.BackgroundTransparency = 0.3
auraBtn.Text = "🌀 PVP AURA"
auraBtn.TextColor3 = Color3.new(1,1,1)
auraBtn.Font = Enum.Font.GothamBold
auraBtn.TextSize = 16
auraBtn.Parent = content
y = y + 48

-- Лучшее яйцо
local bestLabel = Instance.new("TextLabel")
bestLabel.Size = UDim2.new(0.9, 0, 0, 28)
bestLabel.Position = UDim2.new(0.05, 0, 0, y)
bestLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
bestLabel.BackgroundTransparency = 0.4
bestLabel.Text = "🏆 BEST: N/A"
bestLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
bestLabel.Font = Enum.Font.GothamBold
bestLabel.TextSize = 15
bestLabel.Parent = content
y = y + 36

-- Список питомцев
local petTitle = Instance.new("TextLabel")
petTitle.Size = UDim2.new(0.9, 0, 0, 22)
petTitle.Position = UDim2.new(0.05, 0, 0, y)
petTitle.BackgroundTransparency = 1
petTitle.Text = "📋 ДОСТУПНЫЕ ПИТОМЦЫ:"
petTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
petTitle.Font = Enum.Font.GothamBold
petTitle.TextSize = 14
petTitle.TextXAlignment = Enum.TextXAlignment.Left
petTitle.Parent = content
y = y + 28

local petListFrame = Instance.new("Frame")
petListFrame.Size = UDim2.new(0.92, 0, 0, 160)
petListFrame.Position = UDim2.new(0.04, 0, 0, y)
petListFrame.BackgroundTransparency = 1
petListFrame.Parent = content
y = y + 168

-- === ЯДРО ЛОГИКИ ===
local function getPetInfo(egg)
    for loc, pets in pairs(petDB) do
        for _, p in pairs(pets) do
            if egg.Name:lower():find(string.lower(p.name)) or string.lower(p.name):find(string.lower(egg.Name)) then
                return p, loc
            end
        end
    end
    return {name="Unknown", rarity="Common", value=0}, "Unknown"
end

local function getAllEggs()
    local list = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.lower(v.Name):find("egg") then
            local info, loc = getPetInfo(v)
            table.insert(list, {part=v, pet=info.name, rarity=info.rarity, value=info.value, location=loc})
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
        if rank > bestRank and selectedRarities[e.rarity] and selectedLocations[e.location] then
            bestRank = rank
            best = e
        end
    end
    return best
end

-- === МЕТКИ НА ЯЙЦАХ ===
local function updateLabels()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and string.lower(v.Name):find("egg") then
            local existing = v:FindFirstChild("EggLabel")
            if existing then existing:Destroy() end
            
            local info, loc = getPetInfo(v)
            local color = {
                Common=Color3.new(0.7,0.7,0.7),
                Uncommon=Color3.new(0.3,0.9,0.3),
                Rare=Color3.new(0.3,0.6,1),
                Epic=Color3.new(0.7,0.3,1),
                Legendary=Color3.new(1,0.5,0),
                Mythic=Color3.new(1,0.2,0.4),
                Cosmic=Color3.new(1,0.4,1),
                Secret=Color3.new(1,0,0.3),
                Eternal=Color3.new(1,0.9,0),
                Divine=Color3.new(1,1,1)
            }
            
            local label = Instance.new("BillboardGui")
            label.Name = "EggLabel"
            label.Size = UDim2.new(0, 140, 0, 32)
            label.AlwaysOnTop = true
            label.Parent = v

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Text = info.name .. " [" .. info.rarity .. "]"
            txt.TextColor3 = color[info.rarity] or Color3.new(1,1,1)
            txt.TextStrokeColor3 = Color3.new(0,0,0)
            txt.TextStrokeTransparency = 0.2
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 13
            txt.Parent = label
        end
    end
end

-- === ОБНОВЛЕНИЕ СПИСКА ПИТОМЦЕВ ===
local function updatePetList()
    for _, c in pairs(petListFrame:GetChildren()) do c:Destroy() end
    local yOff = 0
    for loc, pets in pairs(petDB) do
        if selectedLocations[loc] then
            for _, p in pairs(pets) do
                if selectedRarities[p.rarity] then
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 0, 20)
                    lbl.Position = UDim2.new(0, 0, 0, yOff)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "• " .. p.name .. " [" .. p.rarity .. "] $" .. p.value .. "/s"
                    local colors = {Common=Color3.new(0.7,0.7,0.7), Uncommon=Color3.new(0.3,0.9,0.3), Rare=Color3.new(0.3,0.6,1), Epic=Color3.new(0.7,0.3,1), Legendary=Color3.new(1,0.5,0), Mythic=Color3.new(1,0.2,0.4), Cosmic=Color3.new(1,0.4,1), Secret=Color3.new(1,0,0.3), Eternal=Color3.new(1,0.9,0), Divine=Color3.new(1,1,1)}
                    lbl.TextColor3 = colors[p.rarity] or Color3.new(1,1,1)
                    lbl.Font = Enum.Font.Gotham
                    lbl.TextSize = 11
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.Parent = petListFrame
                    yOff = yOff + 22
                end
            end
        end
    end
    petListFrame.Size = UDim2.new(0.92, 0, 0, math.max(yOff, 20))
end

-- === АУРА ДЛЯ ПВП ===
local auraParts = {}
local function createAura()
    if #auraParts > 0 then return end
    for i = 1, 14 do
        local angle = (i / 14) * math.pi * 2
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.5, 0.5, 1.4)
        part.BrickColor = BrickColor.new("Bright red")
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.2
        part.Parent = workspace
        table.insert(auraParts, part)
    end
end

local function getNearestPlayer()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, minDist = nil, 10
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if d < minDist then
                minDist, nearest = d, plr.Character
            end
        end
    end
    return nearest
end

local function hitPlayer(target)
    if not target or not target:FindFirstChild("Humanoid") then return end
    local hum = target.Humanoid
    hum.Health = hum.Health - 25
    -- Визуал удара
    local flash = Instance.new("Part")
    flash.Size = Vector3.new(3, 3, 3)
    flash.BrickColor = BrickColor.new("Bright red")
    flash.Material = Enum.Material.Neon
    flash.Anchored = true
    flash.CanCollide = false
    flash.Transparency = 0.6
    flash.Position = target.HumanoidRootPart.Position
    flash.Parent = workspace
    game:GetService("Debris"):AddItem(flash, 0.3)
end

local function updateAura()
    if not auraActive then
        for _, p in pairs(auraParts) do p:Destroy() end
        auraParts = {}
        return
    end
    createAura()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local time = tick()
    for i, p in pairs(auraParts) do
        local angle = (i / #auraParts) * math.pi * 2 + time * 2.5
        local radius = 4.5 + math.sin(time * 1.5 + i) * 0.5
        p.CFrame = root.CFrame * CFrame.new(math.sin(angle) * radius, 1.5 + math.sin(time * 2 + i) * 0.5, math.cos(angle) * radius)
        p.Orientation = Vector3.new(0, math.deg(angle), math.sin(time + i) * 30)
    end
    local target = getNearestPlayer()
    if target then hitPlayer(target) end
end

-- === КНОПКИ ===
stealBtn.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealBtn.Text = autoSteal and "⏹ STOP" or "▶ AUTO STEAL"
    stealBtn.BackgroundColor3 = autoSteal and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    spawn(function()
        while autoSteal do
            local best = getBestEgg()
            if best and char and char:FindFirstChild("HumanoidRootPart") then
                bestLabel.Text = "🏆 BEST: " .. best.pet .. " [" .. best.rarity .. "]"
                char.HumanoidRootPart.CFrame = best.part.CFrame + Vector3.new(0, 2, 0)
                wait(0.1)
                local remote = replicated:FindFirstChild("StealEgg") or replicated:FindFirstChild("EggSteal")
                if remote then remote:FireServer(best.part) end
                updateLabels()
            else
                bestLabel.Text = "🏆 BEST: No egg found"
            end
            wait(0.5)
        end
    end)
end)

auraBtn.MouseButton1Click:Connect(function()
    auraActive = not auraActive
    auraBtn.Text = auraActive and "🌀 AURA: ON" or "🌀 PVP AURA"
    auraBtn.BackgroundColor3 = auraActive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(50, 100, 255)
    spawn(function()
        while auraActive do
            updateAura()
            wait(0.05)
        end
    end)
end)

-- === СВОРАЧИВАНИЕ ===
iconBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    iconFrame.Size = main.Visible and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 52, 0, 52)
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    iconFrame.Size = UDim2.new(0, 52, 0, 52)
end)

-- Обновление при изменении фильтров
for _, cb in pairs(rarityChecks) do
    cb:GetChildren()[1].MouseButton1Click:Connect(updatePetList)
end
for _, cb in pairs(locChecks) do
    cb:GetChildren()[1].MouseButton1Click:Connect(updatePetList)
end

updatePetList()
print("CHLEN-2.0 | MULTI-SELECT ULTIMATE LOADED")
