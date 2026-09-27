-- github script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "github",
    Icon = "eye",
    Author = "github",
    Folder = "github",
    Size = UDim2.fromOffset(580, 460),
})

local ESP = {Ativo = false, Objetos = {}}

function ESP.Remover(player)
    local objeto = ESP.Objetos[player]
    if not objeto then return end
    if objeto.Nome then objeto.Nome:Destroy() end
    if objeto.Distancia then objeto.Distancia:Destroy() end
    ESP.Objetos[player] = nil
end

function ESP.Criar(player)
    if player == LocalPlayer or ESP.Objetos[player] then return end

    local function Aplicar(character)
        if not ESP.Ativo then return end
        local head = character:FindFirstChild("Head")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not head or not root then return end

        ESP.Remover(player)

        local nomeGui = Instance.new("BillboardGui")
        nomeGui.Name = "githubesp_nome"
        nomeGui.Adornee = head
        nomeGui.Size = UDim2.fromOffset(220, 35)
        nomeGui.StudsOffset = Vector3.new(0, 2.8, 0)
        nomeGui.AlwaysOnTop = true
        nomeGui.Parent = head

        local nome = Instance.new("TextLabel")
        nome.BackgroundTransparency = 1
        nome.Size = UDim2.fromScale(1, 1)
        nome.Font = Enum.Font.Arcade
        nome.TextSize = 14
        nome.TextColor3 = Color3.fromRGB(255, 255, 255)
        nome.TextStrokeTransparency = 0
        nome.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nome.Text = player.Name:lower()
        nome.Parent = nomeGui

        local distanciaGui = Instance.new("BillboardGui")
        distanciaGui.Name = "githubesp_distancia"
        distanciaGui.Adornee = root
        distanciaGui.Size = UDim2.fromOffset(220, 30)
        distanciaGui.StudsOffset = Vector3.new(0, -3.5, 0)
        distanciaGui.AlwaysOnTop = true
        distanciaGui.Parent = root

        local distancia = Instance.new("TextLabel")
        distancia.Name = "Distancia"
        distancia.BackgroundTransparency = 1
        distancia.Size = UDim2.fromScale(1, 1)
        distancia.Font = Enum.Font.Arcade
        distancia.TextSize = 13
        distancia.TextColor3 = Color3.fromRGB(255, 255, 255)
        distancia.TextStrokeTransparency = 0
        distancia.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distancia.Text = "[0m]"
        distancia.Parent = distanciaGui

        ESP.Objetos[player] = {Nome = nomeGui, Distancia = distanciaGui}
    end

    if player.Character then Aplicar(player.Character) end

    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if ESP.Ativo then Aplicar(character) end
    end)
end

function ESP.Ativar()
    if ESP.Ativo then return end
    ESP.Ativo = true
    for _, player in ipairs(Players:GetPlayers()) do ESP.Criar(player) end
end

function ESP.Desativar()
    ESP.Ativo = false
    for player in pairs(ESP.Objetos) do ESP.Remover(player) end
end

RunService.RenderStepped:Connect(function()
    if not ESP.Ativo then return end
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for player, objetos in pairs(ESP.Objetos) do
        local alvo = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local texto = objetos.Distancia and objetos.Distancia:FindFirstChild("Distancia")
        if alvo and texto then
            texto.Text = "[" .. math.floor((root.Position - alvo.Position).Magnitude) .. "m]"
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if ESP.Ativo then task.wait(0.5) ESP.Criar(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    ESP.Remover(player)
end)

local ESPTab = Window:Tab({Title = "player/s", Icon = "eye"})

ESPTab:Toggle({
    Title = "nome, distancia",
    Icon = "users",
    Value = false,
    Callback = function(Value)
        if Value then ESP.Ativar() else ESP.Desativar() end
    end
})

local ConfigManager = Window.ConfigManager
local ConfigNome = "default"
local ConfigAtual

local function Aviso(titulo, texto, icone)
    WindUI:Notify({
        Title = titulo,
        Content = texto,
        Icon = icone,
        Duration = 3
    })
end

local ConfigTab = Window:Tab({Title = "config", Icon = "save"})

local ConfigInput = ConfigTab:Input({
    Title = "nome",
    Value = "default",
    Placeholder = "nome da config",
    Callback = function(Value)
        if Value and Value ~= "" then ConfigNome = Value end
    end
})

ConfigTab:Space()

local ConfigDropdown = ConfigTab:Dropdown({
    Title = "configs",
    Values = ConfigManager:AllConfigs(),
    Value = nil,
    AllowNone = true,
    Callback = function(Value)
        if Value and Value ~= "" then
            ConfigNome = Value
            ConfigInput:Set(Value)
        end
    end
})

ConfigTab:Space()

ConfigTab:Button({
    Title = "salvar",
    Icon = "save",
    Callback = function()
        if not ConfigNome or ConfigNome == "" then
            Aviso("config", "digite um nome", "alert-triangle")
            return
        end

        local ok, resultado = pcall(function()
            ConfigAtual = ConfigManager:CreateConfig(ConfigNome)
            return ConfigAtual:Save()
        end)

        if ok and resultado then
            ConfigDropdown:Refresh(ConfigManager:AllConfigs())
            Aviso("config", "salva: " .. ConfigNome, "check")
        else
            Aviso("config", "erro ao salvar", "x")
        end
    end
})

ConfigTab:Space()

ConfigTab:Button({
    Title = "carregar",
    Icon = "folder",
    Callback = function()
        if not ConfigNome or ConfigNome == "" then
            Aviso("config", "selecione uma config", "alert-triangle")
            return
        end

        local ok, resultado = pcall(function()
            ConfigAtual = ConfigManager:CreateConfig(ConfigNome)
            return ConfigAtual:Load()
        end)

        if ok and resultado then
            Aviso("config", "carregada: " .. ConfigNome, "check")
        else
            Aviso("config", "config não encontrada", "x")
        end
    end
})

ConfigTab:Space()

ConfigTab:Button({
    Title = "excluir",
    Icon = "trash",
    Callback = function()
        if not ConfigNome or ConfigNome == "" then
            Aviso("config", "selecione uma config", "alert-triangle")
            return
        end

        local nome = ConfigNome

        local ok, resultado = pcall(function()
            return ConfigManager:DeleteConfig(nome)
        end)

        if ok and resultado then
            ConfigAtual = nil
            ConfigDropdown:Refresh(ConfigManager:AllConfigs())
            ConfigNome = "default"
            ConfigInput:Set("default")
            Aviso("config", "excluída: " .. nome, "check")
        else
            Aviso("config", "não foi possível excluir", "x")
        end
    end
})
