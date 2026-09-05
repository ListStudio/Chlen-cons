-- CHLEN-2.0 | STEAL EGG ULTIMATE (AURA PVP + SVG)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local replicated = game:GetService("ReplicatedStorage")

-- === БАЗА ДАННЫХ ПИТОМЦЕВ (106 шт) ===
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
local locationsList = {"All", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple"}

local selectedRarity = "Divine"
local selectedLocation = "All"
local autoSteal = false
local auraActive = false
local minimized = false

-- === GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CHLEN_GUI"
screenGui.Parent = player.PlayerGui

-- Фон PNG
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 1, 1, 1)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://1234567890"  -- ЗАМЕНИ НА ID ТВОЕЙ PNG
bg.ImageTransparency = 0.6
bg.Parent = screenGui

-- === МАЛЕНЬКИЙ ЗНАЧОК ===
local iconBtn = Instance.new("ImageButton")
iconBtn.Size = UDim2.new(0, 48, 0, 48)
iconBtn.Position = UDim2.new(0.01, 0, 0.01, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
iconBtn.BackgroundTransparency = 0.15
iconBtn.BorderSizePixel = 0
iconBtn.Image = "rbxassetid://6031091071"
iconBtn.ImageColor3 = Color3.fromRGB(255, 200, 50)
iconBtn.Parent = screenGui

-- Главное окно
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 480, 0, 560)
main.Position = UDim2.new(0.5, -240, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Visible = false
main.Parent = screenGui

-- Заголовок
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
header.BackgroundTransparency = 0.15
header.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ CHLEN-2.0 | STEAL EGG"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 0.9
minBtn.Text = "×"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = header

-- Контент
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 750)
scroll.ScrollBarThickness = 4
scroll.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 750)
content.BackgroundTransparency = 1
content.Parent = scroll

local y = 8
local function addLabel(text, color, size)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 24)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = size or 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = content
    y = y + 28
    return lbl
end

function Dropdown(parent, text, items, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
    btn.BackgroundTransparency = 0.3
    btn.Text = text .. ": " .. default
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    y = y + 38

    local list = Instance.new("Frame")
    list.Size = UDim2.new(0.9, 0, 0, #items * 26)
    list.Position = UDim2.new(0.05, 0, 0, y)
    list.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    list.BackgroundTransparency = 0.2
    list.Visible = false
    list.Parent = parent

    for i, v in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 26)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*26)
        opt.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        opt.BackgroundTransparency = 0.2
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

Dropdown(content, "Rarity", {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine"}, "Divine", function(v) selectedRarity = v end)
Dropdown(content, "Location", locationsList, "All", function(v) selectedLocation = v; updatePetList() end)

-- Кнопки
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.42, 0, 0, 38)
stealBtn.Position = UDim2.new(0.05, 0, 0, y)
stealBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stealBtn.BackgroundTransparency = 0.2
stealBtn.Text = "▶ AUTO STEAL"
stealBtn.TextColor3 = Color3.new(1,1,1)
stealBtn.Font = Enum.Font.GothamBold
stealBtn.TextSize = 16
stealBtn.Parent = content

local auraBtn = Instance.new("TextButton")
auraBtn.Size = UDim2.new(0.42, 0, 0, 38)
auraBtn.Position = UDim2.new(0.53, 0, 0, y)
auraBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
auraBtn.BackgroundTransparency = 0.2
auraBtn.Text = "🌀 AURA (PVP)"
auraBtn.TextColor3 = Color3.new(1,1,1)
auraBtn.Font = Enum.Font.GothamBold
auraBtn.TextSize = 16
auraBtn.Parent = content
y = y + 48

-- Лучшее яйцо
local bestLabel = Instance.new("TextLabel")
bestLabel.Size = UDim2.new(0.9, 0, 0, 30)
bestLabel.Position = UDim2.new(0.05, 0, 0, y)
bestLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
bestLabel.BackgroundTransparency = 0.3
bestLabel.Text = "🏆 BEST: N/A"
bestLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
bestLabel.Font = Enum.Font.GothamBold
bestLabel.TextSize = 16
bestLabel.Parent = content
y = y + 38

-- Список питомцев
addLabel("📋 PETS IN ZONE:", Color3.fromRGB(200, 200, 255), 15)

local petListFrame = Instance.new("Frame")
petListFrame.Size = UDim2.new(0.9, 0, 0, 200)
petListFrame.Position = UDim2.new(0.05, 0, 0, y)
petListFrame.BackgroundTransparency = 1
petListFrame.Parent = content
y = y + 210

-- === ЛОГИКА ===
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
        if rank > bestRank and (selectedLocation == "All" or e.location == selectedLocation) then
            bestRank = rank
            best = e
        end
    end
    return best
end

local function updatePetList()
    for _, c in pairs(petListFrame:GetChildren()) do c:Destroy() end
    local loc = selectedLocation == "All" and "Forest" or selectedLocation
    local pets = petDB[loc] or petDB.Forest
    local yOff = 0
    for _, p in pairs(pets) do
        if rarityOrder[p.rarity] >= rarityOrder[selectedRarity] then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 22)
            lbl.Position = UDim2.new(0, 0, 0, yOff)
            lbl.BackgroundTransparency = 1
            lbl.Text = p.name .. " [" .. p.rarity .. "] $" .. p.value .. "/s"
            local colors = {Common=Color3.new(0.7,0.7,0.7), Uncommon=Color3.new(0.3,0.9,0.3), Rare=Color3.new(0.3,0.6,1), Epic=Color3.new(0.7,0.3,1), Legendary=Color3.new(1,0.5,0), Mythic=Color3.new(1,0.2,0.4), Cosmic=Color3.new(1,0.4,1), Secret=Color3.new(1,0,0.3), Eternal=Color3.new(1,0.9,0), Divine=Color3.new(1,1,1)}
            lbl.TextColor3 = colors[p.rarity] or Color3.new(1,1,1)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = petListFrame
            yOff = yOff + 24
        end
    end
    petListFrame.Size = UDim2.new(0.9, 0, 0, yOff)
end

-- === АУРА ДЛЯ ПВП (БЬЁТ ИГРОКОВ) ===
local auraParts = {}
local function createAura()
    if #auraParts > 0 then return end
    for i = 1, 16 do
        local angle = (i / 16) * math.pi * 2
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.6, 0.6, 1.8)
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
    local nearest = nil
    local minDist = 12
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = plr.Character
            end
        end
    end
    return nearest
end

local function hitPlayer(target)
    if not target or not target:FindFirstChild("Humanoid") then return end
    local humanoid = target.Humanoid
    humanoid.Health = humanoid.Health - 20
    
    -- Эффект удара
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 2, 2)
    part.BrickColor = BrickColor.new("Bright red")
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.Position = target.HumanoidRootPart.Position
    part.Parent = workspace
    game:GetService("Debris"):AddItem(part, 0.3)
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
    
    -- Вращение ауры
    for i, p in pairs(auraParts) do
        local angle = (i / #auraParts) * math.pi * 2 + time * 2.5
        local radius = 5 + math.sin(time * 1.2 + i) * 0.5
        p.CFrame = root.CFrame * CFrame.new(math.sin(angle) * radius, 1.5 + math.sin(time * 1.8 + i) * 0.5, math.cos(angle) * radius)
        p.Orientation = Vector3.new(0, math.deg(angle), math.sin(time + i) * 30)
    end
    
    -- Бьём ближайшего игрока
    local target = getNearestPlayer()
    if target then
        hitPlayer(target)
        -- Визуальный эффект удара (вспышка)
        for _, p in pairs(auraParts) do
            p.BrickColor = BrickColor.new("Bright yellow")
            p.Transparency = 0.1
            wait(0.05)
            p.BrickColor = BrickColor.new("Bright red")
            p.Transparency = 0.2
        end
    end
end

-- === КНОПКИ ===
stealBtn.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealBtn.Text = autoSteal and "⏹ STOP" or "▶ AUTO STEAL"
    stealBtn.BackgroundColor3 = autoSteal and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    while autoSteal do
        local best = getBestEgg()
        if best and char and char:FindFirstChild("HumanoidRootPart") then
            bestLabel.Text = "🏆 BEST: " .. best.pet .. " [" .. best.rarity .. "]"
            char.HumanoidRootPart.CFrame = best.part.CFrame + Vector3.new(0, 2, 0)
            wait(0.1)
            local remote = replicated:FindFirstChild("StealEgg") or replicated:FindFirstChild("EggSteal")
            if remote then remote:FireServer(best.part) end
        else
            bestLabel.Text = "🏆 BEST: No egg found"
        end
        wait(0.5)
    end
end)

auraBtn.MouseButton1Click:Connect(function()
    auraActive = not auraActive
    auraBtn.Text = auraActive and "🌀 AURA: ON" or "🌀 AURA (PVP)"
    auraBtn.BackgroundColor3 = auraActive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(50, 100, 255)
    if auraActive then
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

-- === СВОРАЧИВАНИЕ ===
iconBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    iconBtn.Size = main.Visible and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 48, 0, 48)
end)

minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    iconBtn.Size = UDim2.new(0, 48, 0, 48)
end)

updatePetList()
print("CHLEN-2.0 | ULTIMATE PVP AURA LOADED")
