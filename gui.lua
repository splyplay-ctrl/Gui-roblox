local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function createMenuForPlayer(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Удаляем старое меню если есть
    if playerGui:FindFirstChild("AutoFarmMenu") then
        playerGui.AutoFarmMenu:Destroy()
    end

    -- === ОСНОВНОЙ GUI ===
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoFarmMenu"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999

    -- === ПЕРЕМЕННЫЕ ===
    local isMenuOpen = true
    local isAutoFarming = false
    local isESPEnabled = false
    local currentCoinIndex = 0
    local coinsList = {}
    local espConnections = {}
    local autoFarmConnection = nil

    -- === КНОПКА ДЛЯ ОТКРЫТИЯ (ПО ЦЕНТРУ СВЕРХУ) ===
    local openButton = Instance.new("TextButton")
    openButton.Name = "OpenButton"
    openButton.Parent = screenGui
    openButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    openButton.BackgroundTransparency = 0
    openButton.BorderSizePixel = 0 -- Убираем рамку
    openButton.Size = UDim2.new(0, 100, 0, 40)
    openButton.Position = UDim2.new(0.5, -50, 0, 10)
    openButton.AnchorPoint = Vector2.new(0, 0)
    openButton.Text = "⚡ MENU ⚡"
    openButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    openButton.TextScaled = true
    openButton.Font = Enum.Font.GothamBold
    openButton.Visible = false
    openButton.Draggable = true
    openButton.Active = true
    openButton.ZIndex = 1000
    openButton.AutoButtonColor = false

    -- Закругленные углы
    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(0, 20)
    openCorner.Parent = openButton

    -- Тень для открывашки (вместо квадратика)
    local openStroke = Instance.new("UIStroke")
    openStroke.Parent = openButton
    openStroke.Color = Color3.fromRGB(255, 255, 255)
    openStroke.Thickness = 2
    openStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- === ОСНОВНОЕ МЕНЮ ===
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0 -- Убираем рамку
    mainFrame.Size = UDim2.new(0, 260, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -130, 0.5, -110)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    mainFrame.ZIndex = 10

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    -- Золотая обводка для меню
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Parent = mainFrame
    mainStroke.Color = Color3.fromRGB(255, 200, 0)
    mainStroke.Thickness = 3
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- === КРЕСТИК (БЕЗ КВАДРАТИКА) ===
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = mainFrame
    closeButton.BackgroundTransparency = 1 -- Полностью прозрачный фон
    closeButton.BorderSizePixel = 0 -- Нет рамки
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 100, 100) -- Красноватый цвет
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.ZIndex = 20
    closeButton.AutoButtonColor = false
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Не используется из-за прозрачности

    -- Эффект для крестика (меняем только цвет текста)
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 0, 0)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)

    -- === ЗАГОЛОВОК ===
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -50, 0, 35)
    titleLabel.Position = UDim2.new(0, 10, 0, 3)
    titleLabel.Text = "⚡ CHEAT MENU ⚡"
    titleLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 15

    -- === РАЗДЕЛ 1: AUTO ===
    local autoSection = Instance.new("Frame")
    autoSection.Parent = mainFrame
    autoSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    autoSection.BackgroundTransparency = 0
    autoSection.BorderSizePixel = 0
    autoSection.Size = UDim2.new(1, -20, 0, 75)
    autoSection.Position = UDim2.new(0, 10, 0, 45)

    local autoCorner = Instance.new("UICorner")
    autoCorner.CornerRadius = UDim.new(0, 8)
    autoCorner.Parent = autoSection

    -- Заголовок раздела
    local autoTitle = Instance.new("TextLabel")
    autoTitle.Parent = autoSection
    autoTitle.BackgroundTransparency = 1
    autoTitle.Size = UDim2.new(1, -10, 0, 20)
    autoTitle.Position = UDim2.new(0, 5, 0, 2)
    autoTitle.Text = "🪙 AUTO COIN FARM" -- ИЗМЕНЕНО
    autoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoTitle.TextScaled = true
    autoTitle.Font = Enum.Font.GothamBold
    autoTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка Auto Farm
    local autoButton = Instance.new("TextButton")
    autoButton.Name = "AutoFarmButton"
    autoButton.Parent = autoSection
    autoButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoButton.BorderSizePixel = 0
    autoButton.Size = UDim2.new(1, -10, 0, 28)
    autoButton.Position = UDim2.new(0, 5, 0, 25)
    autoButton.Text = "🔴 AUTO FARM (OFF)" -- ИЗМЕНЕНО
    autoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoButton.TextScaled = true
    autoButton.Font = Enum.Font.Gotham

    local autoButtonCorner = Instance.new("UICorner")
    autoButtonCorner.CornerRadius = UDim.new(0, 6)
    autoButtonCorner.Parent = autoButton

    -- Счетчик монет
    local coinCounter = Instance.new("TextLabel")
    coinCounter.Parent = autoSection
    coinCounter.BackgroundTransparency = 1
    coinCounter.Size = UDim2.new(1, -10, 0, 18)
    coinCounter.Position = UDim2.new(0, 5, 0, 55)
    coinCounter.Text = "Coins: 0" -- ИЗМЕНЕНО
    coinCounter.TextColor3 = Color3.fromRGB(255, 255, 0)
    coinCounter.TextScaled = true
    coinCounter.Font = Enum.Font.Gotham

    -- === РАЗДЕЛ 2: ESP ===
    local espSection = Instance.new("Frame")
    espSection.Parent = mainFrame
    espSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    espSection.BackgroundTransparency = 0
    espSection.BorderSizePixel = 0
    espSection.Size = UDim2.new(1, -20, 0, 70)
    espSection.Position = UDim2.new(0, 10, 0, 130)

    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espSection

    -- Заголовок раздела
    local espTitle = Instance.new("TextLabel")
    espTitle.Parent = espSection
    espTitle.BackgroundTransparency = 1
    espTitle.Size = UDim2.new(1, -10, 0, 20)
    espTitle.Position = UDim2.new(0, 5, 0, 2)
    espTitle.Text = "👁️ ESP"
    espTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    espTitle.TextScaled = true
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Parent = espSection
    espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    espButton.BorderSizePixel = 0
    espButton.Size = UDim2.new(1, -10, 0, 30)
    espButton.Position = UDim2.new(0, 5, 0, 25)
    espButton.Text = "⚪ ESP PLAYER (OFF)"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.TextScaled = true
    espButton.Font = Enum.Font.Gotham

    local espButtonCorner = Instance.new("UICorner")
    espButtonCorner.CornerRadius = UDim.new(0, 6)
    espButtonCorner.Parent = espButton

    -- === ФУНКЦИИ ДЛЯ ESP ===
    local function createESPForPlayer(targetPlayer)
        if targetPlayer == player then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight_" .. targetPlayer.Name
        highlight.Adornee = targetPlayer.Character
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = screenGui
        
        local connection = targetPlayer.CharacterAdded:Connect(function(newCharacter)
            task.wait(0.1)
            highlight.Adornee = newCharacter
        end)
        
        table.insert(espConnections, {
            player = targetPlayer,
            highlight = highlight,
            connection = connection
        })
    end

    local function enableESP()
        isESPEnabled = true
        espButton.Text = "⚪ ESP PLAYER (ON)"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            createESPForPlayer(otherPlayer)
        end
        
        local espPlayerAdded = Players.PlayerAdded:Connect(function(newPlayer)
            createESPForPlayer(newPlayer)
        end)
        table.insert(espConnections, {connection = espPlayerAdded})
    end

    local function disableESP()
        isESPEnabled = false
        espButton.Text = "⚪ ESP PLAYER (OFF)"
        espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        for _, data in ipairs(espConnections) do
            if data.connection then
                data.connection:Disconnect()
            end
            if data.highlight then
                data.highlight:Destroy()
            end
        end
        espConnections = {}
    end

    -- === ФУНКЦИИ ДЛЯ AUTO FARM ===
    local function updateCoinsList()
        coinsList = {}
        local allCoins = workspace:GetDescendants()
        
        for _, obj in ipairs(allCoins) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                table.insert(coinsList, obj)
            end
        end
        
        coinCounter.Text = "Coins: " .. #coinsList
        return #coinsList
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
            updateCoinsList()
            return getNextCoin()
        end
    end

    local function startAutoFarm()
        isAutoFarming = true
        autoButton.Text = "🟢 AUTO FARM (ON)"
        autoButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        autoFarmConnection = task.spawn(function()
            while isAutoFarming do
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    
                    if humanoidRootPart and humanoid then
                        updateCoinsList()
                        local targetCoin = getNextCoin()
                        
                        if targetCoin then
                            -- Сохраняем текущую ориентацию персонажа
                            local currentCFrame = humanoidRootPart.CFrame
                            
                            -- Телепортируемся выше монеты с сохранением направления
                            local newPosition = targetCoin.Position + Vector3.new(0, 8, 0)
                            humanoidRootPart.CFrame = CFrame.new(newPosition, newPosition + currentCFrame.LookVector)
                        end
                    end
                end
                
                task.wait(0.3)
            end
        end)
    end

    local function stopAutoFarm()
        isAutoFarming = false
        autoButton.Text = "🔴 AUTO FARM (OFF)"
        autoButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if autoFarmConnection then
            task.cancel(autoFarmConnection)
            autoFarmConnection = nil
        end
    end

    -- === ОБРАБОТЧИКИ ===
    autoButton.MouseButton1Click:Connect(function()
        if isAutoFarming then
            stopAutoFarm()
        else
            startAutoFarm()
        end
    end)

    espButton.MouseButton1Click:Connect(function()
        if isESPEnabled then
            disableESP()
        else
            enableESP()
        end
    end)

    -- ЗАКРЫТИЕ МЕНЮ
    closeButton.MouseButton1Click:Connect(function()
        isMenuOpen = false
        mainFrame.Visible = false
        openButton.Visible = true
        
        TweenService:Create(openButton, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 110, 0, 45),
            Rotation = 0
        }):Play()
    end)

    -- ОТКРЫТИЕ МЕНЮ
    openButton.MouseButton1Click:Connect(function()
        isMenuOpen = true
        mainFrame.Visible = true
        openButton.Visible = false
    end)

    -- Эффекты для кнопок
    local function setupButtonEffects(btn, onColor, offColor)
        btn.MouseEnter:Connect(function()
            if (btn == autoButton and isAutoFarming) or (btn == espButton and isESPEnabled) then return end
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = onColor}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            if btn == autoButton and isAutoFarming then
                btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            elseif btn == espButton and isESPEnabled then
                btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            else
                btn.BackgroundColor3 = offColor
            end
        end)
    end

    setupButtonEffects(autoButton, Color3.fromRGB(100, 100, 100), Color3.fromRGB(60, 60, 60))
    setupButtonEffects(espButton, Color3.fromRGB(100, 100, 100), Color3.fromRGB(60, 60, 60))
    
    -- Эффекты для открывашки
    openButton.MouseEnter:Connect(function()
        TweenService:Create(openButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 100),
            Size = UDim2.new(0, 115, 0, 48)
        }):Play()
    end)
    
    openButton.MouseLeave:Connect(function()
        TweenService:Create(openButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 0),
            Size = UDim2.new(0, 110, 0, 45)
        }):Play()
    end)

    -- Обновление списка монет
    task.spawn(function()
        while true do
            task.wait(2)
            updateCoinsList()
        end
    end)

    -- Очистка ESP
    Players.PlayerRemoving:Connect(function(leavingPlayer)
        if isESPEnabled then
            for i, data in ipairs(espConnections) do
                if data.player == leavingPlayer then
                    if data.highlight then
                        data.highlight:Destroy()
                    end
                    table.remove(espConnections, i)
                    break
                end
            end
        end
    end)

    updateCoinsList()
    print("Меню создано для игрока:", player.Name)
end

-- Запуск для всех игроков
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(createMenuForPlayer, player)
end

Players.PlayerAdded:Connect(createMenuForPlayer)
