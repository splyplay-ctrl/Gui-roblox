-- СПООКИ ХАК - ESP С ИМЕНАМИ ИГРОКОВ
-- Вставь это в ServerScriptService

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local function createMenu(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Удаляем старое меню
    if playerGui:FindFirstChild("SpookyHack") then
        playerGui.SpookyHack:Destroy()
    end

    -- === ПРИВЕТСТВИЕ ===
    local greet = Instance.new("ScreenGui")
    greet.Name = "SpookyGreeting"
    greet.ResetOnSpawn = false
    greet.Parent = playerGui
    greet.DisplayOrder = 1000
    greet.IgnoreGuiInset = true

    local black = Instance.new("Frame")
    black.Parent = greet
    black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    black.BackgroundTransparency = 0.5
    black.Size = UDim2.new(1, 0, 1, 0)
    black.BorderSizePixel = 0

    local text = Instance.new("TextLabel")
    text.Parent = greet
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 0, 100)
    text.Position = UDim2.new(0, 0, 0.5, -50)
    text.Text = "by spooky"
    text.TextColor3 = Color3.fromRGB(255, 200, 0)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextTransparency = 1

    TweenService:Create(text, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(text, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(black, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    greet:Destroy()

    -- === ОСНОВНОЙ GUI ===
    local gui = Instance.new("ScreenGui")
    gui.Name = "SpookyHack"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- === ПЕРЕМЕННЫЕ ===
    local selectedGame = "none"
    local isAutoFarming = false
    local isESPEnabled = false
    local isESPEggsEnabled = false
    local isInfJump = false
    local isFullbright = false
    local isRainbowOn = false
    local autoFarmConnection
    local espConnections = {}
    local espEggsConnections = {}
    local infJumpConnection
    local rainbowConnection
    local coinsList = {}
    local currentCoinIndex = 0

    -- === КНОПКА ДЛЯ ОТКРЫТИЯ ===
    local openBtn = Instance.new("TextButton")
    openBtn.Parent = gui
    openBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    openBtn.BackgroundTransparency = 0
    openBtn.Size = UDim2.new(0, 80, 0, 35)
    openBtn.Position = UDim2.new(0.5, -40, 0, 10)
    openBtn.Text = "⚡ SPOOKY ⚡"
    openBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    openBtn.TextScaled = true
    openBtn.Font = Enum.Font.GothamBold
    openBtn.Visible = false
    openBtn.Draggable = true
    openBtn.ZIndex = 1000
    openBtn.BorderSizePixel = 0
    openBtn.AutoButtonColor = false
    
    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(0, 18)
    openCorner.Parent = openBtn

    -- === ОСНОВНОЕ МЕНЮ ===
    local main = Instance.new("Frame")
    main.Parent = gui
    main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    main.BackgroundTransparency = 0.05
    main.Size = UDim2.new(0, 280, 0, 350)
    main.Position = UDim2.new(0.5, -140, 0.5, -175)
    main.Active = true
    main.Draggable = true
    main.ZIndex = 10
    main.BorderSizePixel = 0
    main.Visible = true

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Parent = main
    mainStroke.Color = Color3.fromRGB(255, 200, 0)
    mainStroke.Thickness = 2

    -- === КРЕСТИК ===
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = main
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 20
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false

    -- === ЗАГОЛОВОК ===
    local title = Instance.new("TextLabel")
    title.Parent = main
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 3)
    title.Text = "⚡ SPOOKY HACK ⚡"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- === ВЕРХНИЕ КНОПКИ ===
    local topBar = Instance.new("Frame")
    topBar.Parent = main
    topBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    topBar.BackgroundTransparency = 0
    topBar.Size = UDim2.new(1, -20, 0, 35)
    topBar.Position = UDim2.new(0, 10, 0, 40)
    topBar.BorderSizePixel = 0

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 6)
    topCorner.Parent = topBar

    -- Кнопка GAME
    local gameBtn = Instance.new("TextButton")
    gameBtn.Parent = topBar
    gameBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    gameBtn.BackgroundTransparency = 0
    gameBtn.Size = UDim2.new(0.5, -5, 1, -8)
    gameBtn.Position = UDim2.new(0, 4, 0, 4)
    gameBtn.Text = "🎮 GAME"
    gameBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    gameBtn.TextScaled = true
    gameBtn.Font = Enum.Font.GothamBold
    gameBtn.BorderSizePixel = 0
    gameBtn.AutoButtonColor = false

    local gameBtnCorner = Instance.new("UICorner")
    gameBtnCorner.CornerRadius = UDim.new(0, 5)
    gameBtnCorner.Parent = gameBtn

    -- Кнопка MAIN
    local mainBtn = Instance.new("TextButton")
    mainBtn.Parent = topBar
    mainBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    mainBtn.BackgroundTransparency = 0
    mainBtn.Size = UDim2.new(0.5, -5, 1, -8)
    mainBtn.Position = UDim2.new(0.5, 1, 0, 4)
    mainBtn.Text = "⚙️ MAIN"
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.TextScaled = true
    mainBtn.Font = Enum.Font.GothamBold
    mainBtn.BorderSizePixel = 0
    mainBtn.AutoButtonColor = false

    local mainBtnCorner = Instance.new("UICorner")
    mainBtnCorner.CornerRadius = UDim.new(0, 5)
    mainBtnCorner.Parent = mainBtn

    -- === КОНТЕЙНЕР ДЛЯ СКРОЛЛИНГА ===
    local scrollingContainer = Instance.new("ScrollingFrame")
    scrollingContainer.Parent = main
    scrollingContainer.BackgroundTransparency = 1
    scrollingContainer.Size = UDim2.new(1, -20, 1, -95)
    scrollingContainer.Position = UDim2.new(0, 10, 0, 85)
    scrollingContainer.CanvasSize = UDim2.new(0, 0, 0, 550)
    scrollingContainer.ScrollBarThickness = 5
    scrollingContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)
    scrollingContainer.BorderSizePixel = 0

    -- === ЭКРАН GAME ===
    local gameScreen = Instance.new("Frame")
    gameScreen.Parent = scrollingContainer
    gameScreen.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    gameScreen.BackgroundTransparency = 0
    gameScreen.Size = UDim2.new(1, 0, 0, 140)
    gameScreen.Position = UDim2.new(0, 0, 0, 0)
    gameScreen.Visible = true
    gameScreen.BorderSizePixel = 0

    local gameScreenCorner = Instance.new("UICorner")
    gameScreenCorner.CornerRadius = UDim.new(0, 6)
    gameScreenCorner.Parent = gameScreen

    local gameTitle = Instance.new("TextLabel")
    gameTitle.Parent = gameScreen
    gameTitle.BackgroundTransparency = 1
    gameTitle.Size = UDim2.new(1, -20, 0, 25)
    gameTitle.Position = UDim2.new(0, 10, 0, 8)
    gameTitle.Text = "CHOOSE A GAME"
    gameTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    gameTitle.TextScaled = true
    gameTitle.Font = Enum.Font.GothamBold

    -- Кнопка DPTB4
    local dptb4Btn = Instance.new("TextButton")
    dptb4Btn.Parent = gameScreen
    dptb4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dptb4Btn.BackgroundTransparency = 0
    dptb4Btn.Size = UDim2.new(1, -20, 0, 40)
    dptb4Btn.Position = UDim2.new(0, 10, 0, 40)
    dptb4Btn.Text = "🎮 Don't Press The Button 4"
    dptb4Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dptb4Btn.TextScaled = true
    dptb4Btn.Font = Enum.Font.GothamBold
    dptb4Btn.BorderSizePixel = 0
    dptb4Btn.AutoButtonColor = false

    local dptb4Corner = Instance.new("UICorner")
    dptb4Corner.CornerRadius = UDim.new(0, 6)
    dptb4Corner.Parent = dptb4Btn

    -- Текст для будущих игр
    local moreGamesText = Instance.new("TextLabel")
    moreGamesText.Parent = gameScreen
    moreGamesText.BackgroundTransparency = 1
    moreGamesText.Size = UDim2.new(1, -20, 0, 25)
    moreGamesText.Position = UDim2.new(0, 10, 0, 90)
    moreGamesText.Text = "More games coming soon..."
    moreGamesText.TextColor3 = Color3.fromRGB(150, 150, 150)
    moreGamesText.TextScaled = true
    moreGamesText.Font = Enum.Font.Gotham

    -- === ЭКРАН MAIN ===
    local mainScreen = Instance.new("Frame")
    mainScreen.Parent = scrollingContainer
    mainScreen.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainScreen.BackgroundTransparency = 0
    mainScreen.Size = UDim2.new(1, 0, 0, 400)
    mainScreen.Position = UDim2.new(0, 0, 0, 150)
    mainScreen.Visible = false
    mainScreen.BorderSizePixel = 0

    local mainScreenCorner = Instance.new("UICorner")
    mainScreenCorner.CornerRadius = UDim.new(0, 6)
    mainScreenCorner.Parent = mainScreen

    -- Информация о выбранной игре (всегда видна)
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.Parent = mainScreen
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Size = UDim2.new(1, -20, 0, 30)
    selectedLabel.Position = UDim2.new(0, 10, 0, 8)
    selectedLabel.Text = "No game selected. Go to GAME tab."
    selectedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    selectedLabel.TextScaled = true
    selectedLabel.Font = Enum.Font.Gotham

    -- === ФУНКЦИЯ СОЗДАНИЯ КНОПОК ===
    local function createButtons()
        -- Очищаем старые кнопки
        for _, child in ipairs(mainScreen:GetChildren()) do
            if child.Name ~= "SelectedLabel" then
                child:Destroy()
            end
        end
        
        -- Если игра не выбрана - показываем только текст
        if selectedGame == "none" then
            selectedLabel.Text = "No game selected. Go to GAME tab."
            return
        end
        
        -- Обновляем текст выбранной игры
        selectedLabel.Text = "🎮 Don't Press The Button 4"
        
        -- Создаем кнопки
        local yPos = 45
        
        -- AUTO FARM
        local autoSection = Instance.new("Frame")
        autoSection.Parent = mainScreen
        autoSection.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        autoSection.BackgroundTransparency = 0
        autoSection.Size = UDim2.new(1, -20, 0, 65)
        autoSection.Position = UDim2.new(0, 10, 0, yPos)
        autoSection.BorderSizePixel = 0

        local autoCorner = Instance.new("UICorner")
        autoCorner.CornerRadius = UDim.new(0, 6)
        autoCorner.Parent = autoSection

        local autoTitle = Instance.new("TextLabel")
        autoTitle.Parent = autoSection
        autoTitle.BackgroundTransparency = 1
        autoTitle.Size = UDim2.new(1, -10, 0, 18)
        autoTitle.Position = UDim2.new(0, 5, 0, 2)
        autoTitle.Text = "🪙 AUTO COIN FARM"
        autoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoTitle.TextScaled = true
        autoTitle.Font = Enum.Font.GothamBold
        autoTitle.TextXAlignment = Enum.TextXAlignment.Left

        local autoBtn = Instance.new("TextButton")
        autoBtn.Name = "AutoFarmButton"
        autoBtn.Parent = autoSection
        autoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        autoBtn.BackgroundTransparency = 0
        autoBtn.Size = UDim2.new(1, -10, 0, 25)
        autoBtn.Position = UDim2.new(0, 5, 0, 22)
        autoBtn.Text = "🔴 AUTO FARM (OFF)"
        autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        autoBtn.TextScaled = true
        autoBtn.Font = Enum.Font.Gotham
        autoBtn.BorderSizePixel = 0
        autoBtn.AutoButtonColor = false

        local autoBtnCorner = Instance.new("UICorner")
        autoBtnCorner.CornerRadius = UDim.new(0, 5)
        autoBtnCorner.Parent = autoBtn

        local coinCounter = Instance.new("TextLabel")
        coinCounter.Name = "CoinCounter"
        coinCounter.Parent = autoSection
        coinCounter.BackgroundTransparency = 1
        coinCounter.Size = UDim2.new(1, -10, 0, 15)
        coinCounter.Position = UDim2.new(0, 5, 0, 48)
        coinCounter.Text = "Coins: 0"
        coinCounter.TextColor3 = Color3.fromRGB(255, 255, 0)
        coinCounter.TextScaled = true
        coinCounter.Font = Enum.Font.Gotham

        yPos = yPos + 70
        
        -- ESP
        local espSection = Instance.new("Frame")
        espSection.Parent = mainScreen
        espSection.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        espSection.BackgroundTransparency = 0
        espSection.Size = UDim2.new(1, -20, 0, 95)
        espSection.Position = UDim2.new(0, 10, 0, yPos)
        espSection.BorderSizePixel = 0

        local espCorner = Instance.new("UICorner")
        espCorner.CornerRadius = UDim.new(0, 6)
        espCorner.Parent = espSection

        local espTitle = Instance.new("TextLabel")
        espTitle.Parent = espSection
        espTitle.BackgroundTransparency = 1
        espTitle.Size = UDim2.new(1, -10, 0, 18)
        espTitle.Position = UDim2.new(0, 5, 0, 2)
        espTitle.Text = "👁️ ESP"
        espTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        espTitle.TextScaled = true
        espTitle.Font = Enum.Font.GothamBold
        espTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- ESP PLAYER
        local espBtn = Instance.new("TextButton")
        espBtn.Name = "ESPButton"
        espBtn.Parent = espSection
        espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espBtn.BackgroundTransparency = 0
        espBtn.Size = UDim2.new(1, -10, 0, 25)
        espBtn.Position = UDim2.new(0, 5, 0, 22)
        espBtn.Text = "⚪ ESP PLAYER (OFF)"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        espBtn.TextScaled = true
        espBtn.Font = Enum.Font.Gotham
        espBtn.BorderSizePixel = 0
        espBtn.AutoButtonColor = false

        local espBtnCorner = Instance.new("UICorner")
        espBtnCorner.CornerRadius = UDim.new(0, 5)
        espBtnCorner.Parent = espBtn

        -- ESP EGGS
        local espEggsBtn = Instance.new("TextButton")
        espEggsBtn.Name = "ESPEggsButton"
        espEggsBtn.Parent = espSection
        espEggsBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        espEggsBtn.BackgroundTransparency = 0
        espEggsBtn.Size = UDim2.new(1, -10, 0, 25)
        espEggsBtn.Position = UDim2.new(0, 5, 0, 52)
        espEggsBtn.Text = "🥚 ESP EGGS (OFF)"
        espEggsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        espEggsBtn.TextScaled = true
        espEggsBtn.Font = Enum.Font.Gotham
        espEggsBtn.BorderSizePixel = 0
        espEggsBtn.AutoButtonColor = false

        local espEggsCorner = Instance.new("UICorner")
        espEggsCorner.CornerRadius = UDim.new(0, 5)
        espEggsCorner.Parent = espEggsBtn

        yPos = yPos + 100
        
        -- MISC
        local miscSection = Instance.new("Frame")
        miscSection.Parent = mainScreen
        miscSection.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        miscSection.BackgroundTransparency = 0
        miscSection.Size = UDim2.new(1, -20, 0, 120)
        miscSection.Position = UDim2.new(0, 10, 0, yPos)
        miscSection.BorderSizePixel = 0

        local miscCorner = Instance.new("UICorner")
        miscCorner.CornerRadius = UDim.new(0, 6)
        miscCorner.Parent = miscSection

        local miscTitle = Instance.new("TextLabel")
        miscTitle.Parent = miscSection
        miscTitle.BackgroundTransparency = 1
        miscTitle.Size = UDim2.new(1, -10, 0, 18)
        miscTitle.Position = UDim2.new(0, 5, 0, 2)
        miscTitle.Text = "🎮 MISC"
        miscTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        miscTitle.TextScaled = true
        miscTitle.Font = Enum.Font.GothamBold
        miscTitle.TextXAlignment = Enum.TextXAlignment.Left

        -- INF JUMP
        local infJumpBtn = Instance.new("TextButton")
        infJumpBtn.Name = "InfJumpButton"
        infJumpBtn.Parent = miscSection
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        infJumpBtn.BackgroundTransparency = 0
        infJumpBtn.Size = UDim2.new(1, -10, 0, 25)
        infJumpBtn.Position = UDim2.new(0, 5, 0, 22)
        infJumpBtn.Text = "🦘 INF JUMP (OFF)"
        infJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        infJumpBtn.TextScaled = true
        infJumpBtn.Font = Enum.Font.Gotham
        infJumpBtn.BorderSizePixel = 0
        infJumpBtn.AutoButtonColor = false

        local infJumpCorner = Instance.new("UICorner")
        infJumpCorner.CornerRadius = UDim.new(0, 5)
        infJumpCorner.Parent = infJumpBtn

        -- FULLBRIGHT
        local fullBtn = Instance.new("TextButton")
        fullBtn.Name = "FullbrightButton"
        fullBtn.Parent = miscSection
        fullBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        fullBtn.BackgroundTransparency = 0
        fullBtn.Size = UDim2.new(1, -10, 0, 25)
        fullBtn.Position = UDim2.new(0, 5, 0, 52)
        fullBtn.Text = "💡 FULLBRIGHT (OFF)"
        fullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        fullBtn.TextScaled = true
        fullBtn.Font = Enum.Font.Gotham
        fullBtn.BorderSizePixel = 0
        fullBtn.AutoButtonColor = false

        local fullCorner = Instance.new("UICorner")
        fullCorner.CornerRadius = UDim.new(0, 5)
        fullCorner.Parent = fullBtn

        -- RAINBOW
        local rainbowBtn = Instance.new("TextButton")
        rainbowBtn.Name = "RainbowButton"
        rainbowBtn.Parent = miscSection
        rainbowBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        rainbowBtn.BackgroundTransparency = 0
        rainbowBtn.Size = UDim2.new(1, -10, 0, 25)
        rainbowBtn.Position = UDim2.new(0, 5, 0, 82)
        rainbowBtn.Text = "🌈 RAINBOW ALL (OFF)"
        rainbowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rainbowBtn.TextScaled = true
        rainbowBtn.Font = Enum.Font.Gotham
        rainbowBtn.BorderSizePixel = 0
        rainbowBtn.AutoButtonColor = false

        local rainbowCorner = Instance.new("UICorner")
        rainbowCorner.CornerRadius = UDim.new(0, 5)
        rainbowCorner.Parent = rainbowBtn

        -- === ФУНКЦИИ ДЛЯ AUTO FARM ===
        local function updateCoins()
            coinsList = {}
            -- Ищем монеты по разным возможным названиям
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    -- Проверяем разные варианты названий монет
                    if name == "coin" or 
                       name:find("coin") or 
                       name == "money" or 
                       name:find("money") or
                       name == "gem" or
                       name:find("gem") or
                       name:find("collectible") then
                        table.insert(coinsList, obj)
                    end
                end
            end
            coinCounter.Text = "Coins: " .. #coinsList
        end

        local function getNextCoin()
            if #coinsList == 0 then
                return nil
            end
            
            currentCoinIndex = currentCoinIndex + 1
            if currentCoinIndex > #coinsList then
                currentCoinIndex = 1
            end
            
            local coin = coinsList[currentCoinIndex]
            if coin and coin.Parent then
                return coin
            else
                updateCoins()
                return getNextCoin()
            end
        end

        -- AUTO FARM обработчик
        autoBtn.MouseButton1Click:Connect(function()
            isAutoFarming = not isAutoFarming
            if isAutoFarming then
                autoBtn.Text = "🟢 AUTO FARM (ON)"
                autoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                
                autoFarmConnection = task.spawn(function()
                    while isAutoFarming do
                        local char = player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            updateCoins()
                            if #coinsList > 0 then
                                local targetCoin = getNextCoin()
                                if targetCoin then
                                    local hrp = char.HumanoidRootPart
                                    -- Телепортируемся выше монеты
                                    hrp.CFrame = CFrame.new(targetCoin.Position + Vector3.new(0, 8, 0))
                                end
                            end
                        end
                        task.wait(0.3)
                    end
                end)
            else
                autoBtn.Text = "🔴 AUTO FARM (OFF)"
                autoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                if autoFarmConnection then
                    task.cancel(autoFarmConnection)
                    autoFarmConnection = nil
                end
            end
        end)

        -- === НОВАЯ ФУНКЦИЯ: СОЗДАНИЕ ESP С ИМЕНАМИ ===
        local function createPlayerESP(targetPlayer)
            if targetPlayer == player then return end
            
            -- Создаем BillboardGui с именем
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_" .. targetPlayer.Name
            billboard.Parent = gui
            billboard.Adornee = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head")
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            
            -- Фон для имени
            local background = Instance.new("Frame")
            background.Parent = billboard
            background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            background.BackgroundTransparency = 0.3
            background.Size = UDim2.new(1, 0, 1, 0)
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(0, 4)
            bgCorner.Parent = background
            
            -- Текст с именем
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = billboard
            nameLabel.BackgroundTransparency = 1
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Text = targetPlayer.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.GothamBold
            
            -- Highlight для подсветки
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight_" .. targetPlayer.Name
            highlight.Parent = gui
            highlight.Adornee = targetPlayer.Character
            highlight.FillColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            -- Сохраняем все в таблицу
            table.insert(espConnections, {
                player = targetPlayer,
                billboard = billboard,
                highlight = highlight
            })
            
            -- Обновляем при смене персонажа
            targetPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                local head = char:FindFirstChild("Head")
                if head and billboard then
                    billboard.Adornee = head
                end
                if highlight then
                    highlight.Adornee = char
                end
            end)
        end

        -- ESP PLAYER обработчик (ОБНОВЛЕННЫЙ)
        espBtn.MouseButton1Click:Connect(function()
            isESPEnabled = not isESPEnabled
            if isESPEnabled then
                espBtn.Text = "⚪ ESP PLAYER (ON)"
                espBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                
                -- Создаем ESP для всех игроков
                for _, other in ipairs(Players:GetPlayers()) do
                    createPlayerESP(other)
                end
                
                -- Следим за новыми игроками
                local connection = Players.PlayerAdded:Connect(function(newPlayer)
                    task.wait(1)
                    if isESPEnabled then
                        createPlayerESP(newPlayer)
                    end
                end)
                
                table.insert(espConnections, {connection = connection})
                
            else
                espBtn.Text = "⚪ ESP PLAYER (OFF)"
                espBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                
                -- Удаляем все ESP
                for _, data in ipairs(espConnections) do
                    if data.connection then
                        data.connection:Disconnect()
                    end
                    if data.billboard then
                        data.billboard:Destroy()
                    end
                    if data.highlight then
                        data.highlight:Destroy()
                    end
                end
                espConnections = {}
            end
        end)

        -- ESP EGGS
        espEggsBtn.MouseButton1Click:Connect(function()
            if isESPEggsEnabled then
                isESPEggsEnabled = false
                espEggsBtn.Text = "🥚 ESP EGGS (OFF)"
                espEggsBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                
                for _, data in ipairs(espEggsConnections) do
                    if data.connection then
                        data.connection:Disconnect()
                    end
                    if data.highlight then
                        data.highlight:Destroy()
                    end
                end
                espEggsConnections = {}
            else
                isESPEggsEnabled = true
                espEggsBtn.Text = "🥚 ESP EGGS (ON)"
                espEggsBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and string.lower(obj.Name):find("egg") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = gui
                        highlight.Adornee = obj
                        highlight.FillColor = Color3.fromRGB(0, 100, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        
                        table.insert(espEggsConnections, {
                            obj = obj,
                            highlight = highlight
                        })
                    end
                end
                
                local connection = workspace.DescendantAdded:Connect(function(obj)
                    if isESPEggsEnabled and obj:IsA("BasePart") and string.lower(obj.Name):find("egg") then
                        task.wait(0.1)
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = gui
                        highlight.Adornee = obj
                        highlight.FillColor = Color3.fromRGB(0, 100, 255)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        
                        table.insert(espEggsConnections, {
                            obj = obj,
                            highlight = highlight
                        })
                    end
                end)
                
                table.insert(espEggsConnections, {connection = connection})
            end
        end)

        -- INF JUMP
        infJumpBtn.MouseButton1Click:Connect(function()
            isInfJump = not isInfJump
            if isInfJump then
                infJumpBtn.Text = "🦘 INF JUMP (ON)"
                infJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                
                infJumpConnection = UserInputService.JumpRequest:Connect(function()
                    local char = player.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                infJumpBtn.Text = "🦘 INF JUMP (OFF)"
                infJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                if infJumpConnection then
                    infJumpConnection:Disconnect()
                    infJumpConnection = nil
                end
            end
        end)

        -- FULLBRIGHT
        fullBtn.MouseButton1Click:Connect(function()
            isFullbright = not isFullbright
            if isFullbright then
                fullBtn.Text = "💡 FULLBRIGHT (ON)"
                fullBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            else
                fullBtn.Text = "💡 FULLBRIGHT (OFF)"
                fullBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                Lighting.Brightness = 1
                Lighting.Ambient = Color3.fromRGB(128, 128, 128)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 128)
            end
        end)

        -- RAINBOW
        rainbowBtn.MouseButton1Click:Connect(function()
            isRainbowOn = not isRainbowOn
            if isRainbowOn then
                rainbowBtn.Text = "🌈 RAINBOW ALL (ON)"
                rainbowBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                
                local hue = 0
                rainbowConnection = RunService.RenderStepped:Connect(function()
                    hue = (hue + 0.002) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    Lighting.Ambient = color
                    Lighting.ColorShift_Top = color
                    Lighting.ColorShift_Bottom = color * 0.5
                end)
            else
                rainbowBtn.Text = "🌈 RAINBOW ALL (OFF)"
                rainbowBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                if rainbowConnection then
                    rainbowConnection:Disconnect()
                    rainbowConnection = nil
                end
                Lighting.Ambient = Color3.fromRGB(128, 128, 128)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 128)
            end
        end)

        -- Эффекты для кнопок
        local function hover(btn)
            btn.MouseEnter:Connect(function()
                if btn.BackgroundColor3 == Color3.fromRGB(0, 120, 0) then return end
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                if btn.BackgroundColor3 == Color3.fromRGB(0, 120, 0) then return end
                btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end)
        end

        hover(autoBtn)
        hover(espBtn)
        hover(espEggsBtn)
        hover(infJumpBtn)
        hover(fullBtn)
        hover(rainbowBtn)
    end

    -- === ОБРАБОТЧИКИ ===

    -- Выбор игры
    dptb4Btn.MouseButton1Click:Connect(function()
        selectedGame = "dptb4"
        
        -- Переключаем на MAIN и создаем кнопки
        gameScreen.Visible = false
        mainScreen.Visible = true
        createButtons()
        
        -- Обновляем цвета кнопок
        gameBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        gameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        mainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Визуальный эффект на кнопке игры
        dptb4Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        task.wait(0.2)
        dptb4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        scrollingContainer.CanvasPosition = Vector2.new(0, 0)
    end)

    -- Переключение экранов
    gameBtn.MouseButton1Click:Connect(function()
        gameScreen.Visible = true
        mainScreen.Visible = false
        gameBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        gameBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        mainBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        scrollingContainer.CanvasPosition = Vector2.new(0, 0)
    end)

    mainBtn.MouseButton1Click:Connect(function()
        gameScreen.Visible = false
        mainScreen.Visible = true
        mainBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        mainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        gameBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        gameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        scrollingContainer.CanvasPosition = Vector2.new(0, 0)
        
        -- ВАЖНО: при переходе на MAIN создаем кнопки заново
        createButtons()
    end)

    -- Закрытие/открытие меню
    closeBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        openBtn.Visible = true
    end)

    openBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        openBtn.Visible = false
    end)

    -- Эффекты для верхних кнопок
    gameBtn.MouseEnter:Connect(function()
        if gameScreen.Visible then return end
        TweenService:Create(gameBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)
    gameBtn.MouseLeave:Connect(function()
        if gameScreen.Visible then 
            gameBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        else
            gameBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end)

    mainBtn.MouseEnter:Connect(function()
        if mainScreen.Visible then return end
        TweenService:Create(mainBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)
    mainBtn.MouseLeave:Connect(function()
        if mainScreen.Visible then 
            mainBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        else
            mainBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end)

    -- Эффекты для крестика
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 0, 0)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)

    -- Эффекты для открывашки
    openBtn.MouseEnter:Connect(function()
        TweenService:Create(openBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 100),
            Size = UDim2.new(0, 90, 0, 40)
        }):Play()
    end)
    openBtn.MouseLeave:Connect(function()
        TweenService:Create(openBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 0),
            Size = UDim2.new(0, 80, 0, 35)
        }):Play()
    end)
end

-- Запуск для всех
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(createMenu, p)
end

Players.PlayerAdded:Connect(createMenu)
