-- github carro script

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

local Carros = {Ativo = false, Objetos = {}}

function Carros.Criar(model)
    if not Carros.Ativo or not model:IsA("Model") or Carros.Objetos[model] then return end

    local seat = model:FindFirstChildWhichIsA("VehicleSeat", true)
        or model:FindFirstChildWhichIsA("Seat", true)

    if not seat or not model:FindFirstChildWhichIsA("BasePart", true) then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "githubcarro"
    highlight.Adornee = model
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 140, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 180, 60)
    highlight.Parent = model
    Carros.Objetos[model] = highlight
end

function Carros.Remover(model)
    local highlight = Carros.Objetos[model]
    if highlight then
        highlight:Destroy()
        Carros.Objetos[model] = nil
    end
end

function Carros.Ativar()
    if Carros.Ativo then return end
    Carros.Ativo = true

    for _, objeto in ipairs(workspace:GetDescendants()) do
        if objeto:IsA("VehicleSeat") or objeto:IsA("Seat") then
            local model = objeto:FindFirstAncestorOfClass("Model")
            if model then Carros.Criar(model) end
        end
    end
end

function Carros.Desativar()
    Carros.Ativo = false
    for model, highlight in pairs(Carros.Objetos) do
        if highlight then highlight:Destroy() end
        Carros.Objetos[model] = nil
    end
end

workspace.DescendantAdded:Connect(function(objeto)
    if not Carros.Ativo then return end
    if objeto:IsA("VehicleSeat") or objeto:IsA("Seat") then
        local model = objeto:FindFirstAncestorOfClass("Model")
        if model then
            task.defer(function()
                if Carros.Ativo then Carros.Criar(model) end
            end)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(objeto)
    if objeto:IsA("Model") then Carros.Remover(objeto) end
end)

local NoclipCarro = {Ativo = false, Conexao = nil, Partes = {}}

function NoclipCarro.ObterCarro()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.SeatPart then return nil end
    return humanoid.SeatPart:FindFirstAncestorOfClass("Model")
end

function NoclipCarro.Aplicar()
    local carro = NoclipCarro.ObterCarro()
    if not carro then return end

    for _, objeto in ipairs(carro:GetDescendants()) do
        if objeto:IsA("BasePart") then
            if NoclipCarro.Partes[objeto] == nil then
                NoclipCarro.Partes[objeto] = objeto.CanCollide
            end
            objeto.CanCollide = false
        end
    end
end

function NoclipCarro.Ativar()
    if NoclipCarro.Ativo then return end
    NoclipCarro.Ativo = true
    NoclipCarro.Conexao = RunService.Stepped:Connect(function()
        if NoclipCarro.Ativo then NoclipCarro.Aplicar() end
    end)
end

function NoclipCarro.Desativar()
    NoclipCarro.Ativo = false

    if NoclipCarro.Conexao then
        NoclipCarro.Conexao:Disconnect()
        NoclipCarro.Conexao = nil
    end

    for parte, estado in pairs(NoclipCarro.Partes) do
        if parte and parte.Parent then parte.CanCollide = estado end
    end

    table.clear(NoclipCarro.Partes)
end

local FlyCarro = {
    Ativo = false,
    Velocidade = 70,
    Conexao = nil,
    BodyVelocity = nil,
    BodyGyro = nil,
    Carro = nil,
    Parte = nil,
    Controles = nil,
    Teclas = {W = false, A = false, S = false, D = false, Up = false, Down = false}
}

function FlyCarro.ObterCarro()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.SeatPart then return nil end
    return humanoid.SeatPart:FindFirstAncestorOfClass("Model")
end

function FlyCarro.CriarBotao(parent, texto, nome, posicao, tamanho)
    local botao = Instance.new("TextButton")
    botao.Name = nome
    botao.Size = tamanho
    botao.Position = posicao
    botao.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    botao.BackgroundTransparency = 0.1
    botao.BorderSizePixel = 0
    botao.Text = texto
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.TextSize = 18
    botao.Font = Enum.Font.GothamBold
    botao.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = botao

    local function pressionar() FlyCarro.Teclas[nome] = true end
    local function soltar() FlyCarro.Teclas[nome] = false end

    botao.MouseButton1Down:Connect(pressionar)
    botao.MouseButton1Up:Connect(soltar)
    botao.MouseLeave:Connect(soltar)

    botao.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then pressionar() end
    end)

    botao.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then soltar() end
    end)
end

function FlyCarro.CriarControles()
    if FlyCarro.Controles then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "github_fly_controles"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(230, 210)
    frame.Position = UDim2.new(1, -245, 1, -225)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local titulo = Instance.new("TextLabel")
    titulo.BackgroundTransparency = 1
    titulo.Size = UDim2.new(1, 0, 0, 30)
    titulo.Position = UDim2.fromOffset(0, 5)
    titulo.Text = "fly carro"
    titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
    titulo.TextSize = 15
    titulo.Font = Enum.Font.GothamBold
    titulo.Parent = frame

    FlyCarro.CriarBotao(frame, "W", "W", UDim2.fromOffset(80, 38), UDim2.fromOffset(65, 45))
    FlyCarro.CriarBotao(frame, "A", "A", UDim2.fromOffset(10, 88), UDim2.fromOffset(65, 45))
    FlyCarro.CriarBotao(frame, "S", "S", UDim2.fromOffset(80, 88), UDim2.fromOffset(65, 45))
    FlyCarro.CriarBotao(frame, "D", "D", UDim2.fromOffset(150, 88), UDim2.fromOffset(65, 45))
    FlyCarro.CriarBotao(frame, "↑", "Up", UDim2.fromOffset(10, 143), UDim2.fromOffset(105, 45))
    FlyCarro.CriarBotao(frame, "↓", "Down", UDim2.fromOffset(115, 143), UDim2.fromOffset(105, 45))

    FlyCarro.Controles = gui
end

function FlyCarro.RemoverControles()
    if FlyCarro.Controles then
        FlyCarro.Controles:Destroy()
        FlyCarro.Controles = nil
    end

    for tecla in pairs(FlyCarro.Teclas) do
        FlyCarro.Teclas[tecla] = false
    end
end

function FlyCarro.Ativar()
    if FlyCarro.Ativo then return end

    local carro = FlyCarro.ObterCarro()
    if not carro then return end

    local parte = carro.PrimaryPart or carro:FindFirstChildWhichIsA("BasePart", true)
    if not parte then return end

    FlyCarro.Ativo = true
    FlyCarro.Carro = carro
    FlyCarro.Parte = parte

    local velocidade = Instance.new("BodyVelocity")
    velocidade.Name = "github_fly_velocity"
    velocidade.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocidade.Velocity = Vector3.zero
    velocidade.Parent = parte

    local giro = Instance.new("BodyGyro")
    giro.Name = "github_fly_gyro"
    giro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    giro.P = 50000
    giro.D = 1000
    giro.CFrame = parte.CFrame
    giro.Parent = parte

    FlyCarro.BodyVelocity = velocidade
    FlyCarro.BodyGyro = giro
    FlyCarro.CriarControles()

    FlyCarro.Conexao = RunService.RenderStepped:Connect(function()
        if not FlyCarro.Ativo then return end

        if not FlyCarro.Carro or not FlyCarro.Carro.Parent
            or not FlyCarro.Parte or not FlyCarro.Parte.Parent then
            FlyCarro.Desativar()
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local frente = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
        local direita = Vector3.new(camera.CFrame.RightVector.X, 0, camera.CFrame.RightVector.Z)

        if frente.Magnitude > 0 then frente = frente.Unit end
        if direita.Magnitude > 0 then direita = direita.Unit end

        local direcao = Vector3.zero

        if FlyCarro.Teclas.W then direcao += frente end
        if FlyCarro.Teclas.S then direcao -= frente end
        if FlyCarro.Teclas.D then direcao += direita end
        if FlyCarro.Teclas.A then direcao -= direita end
        if FlyCarro.Teclas.Up then direcao += Vector3.new(0, 1, 0) end
        if FlyCarro.Teclas.Down then direcao -= Vector3.new(0, 1, 0) end

        if direcao.Magnitude > 0 then
            FlyCarro.BodyVelocity.Velocity = direcao.Unit * FlyCarro.Velocidade
        else
            FlyCarro.BodyVelocity.Velocity = Vector3.zero
        end

        if frente.Magnitude > 0 then
            FlyCarro.BodyGyro.CFrame = CFrame.lookAt(
                FlyCarro.Parte.Position,
                FlyCarro.Parte.Position + frente
            )
        end
    end)
end

function FlyCarro.Desativar()
    FlyCarro.Ativo = false

    if FlyCarro.Conexao then
        FlyCarro.Conexao:Disconnect()
        FlyCarro.Conexao = nil
    end

    if FlyCarro.BodyVelocity then
        FlyCarro.BodyVelocity:Destroy()
        FlyCarro.BodyVelocity = nil
    end

    if FlyCarro.BodyGyro then
        FlyCarro.BodyGyro:Destroy()
        FlyCarro.BodyGyro = nil
    end

    FlyCarro.RemoverControles()
    FlyCarro.Carro = nil
    FlyCarro.Parte = nil
end


-- CHAMS PLAYER POR TIME AUTOMATICO

local ChamsTime = {Ativo = false, Objetos = {}, Cores = {}}

local CoresDisponiveis = {
    Color3.fromRGB(0,120,255),
    Color3.fromRGB(255,0,0),
    Color3.fromRGB(0,255,0),
    Color3.fromRGB(255,220,0),
    Color3.fromRGB(255,0,255),
    Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,120,0),
    Color3.fromRGB(150,0,255)
}

function ChamsTime.PegarCor(team)
    if not team then return Color3.fromRGB(255,255,255) end
    if not ChamsTime.Cores[team.Name] then
        local total = 0
        for _ in pairs(ChamsTime.Cores) do total += 1 end
        ChamsTime.Cores[team.Name] = CoresDisponiveis[(total % #CoresDisponiveis) + 1]
    end
    return ChamsTime.Cores[team.Name]
end

function ChamsTime.Remover(player)
    local obj = ChamsTime.Objetos[player]
    if obj then obj:Destroy() end
    ChamsTime.Objetos[player] = nil
end

function ChamsTime.Criar(player)
    if player == LocalPlayer or not player.Character then return end
    ChamsTime.Remover(player)
    local h = Instance.new("Highlight")
    h.Name = "github_team_chams"
    h.Adornee = player.Character
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = ChamsTime.PegarCor(player.Team)
    h.OutlineColor = h.FillColor
    h.FillTransparency = 0.45
    h.Parent = player.Character
    ChamsTime.Objetos[player] = h
end

function ChamsTime.Ativar()
    if ChamsTime.Ativo then return end
    ChamsTime.Ativo = true
    for _,p in ipairs(Players:GetPlayers()) do ChamsTime.Criar(p) end
end

function ChamsTime.Desativar()
    ChamsTime.Ativo = false
    for p,h in pairs(ChamsTime.Objetos) do
        if h then h:Destroy() end
    end
    table.clear(ChamsTime.Objetos)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ChamsTime.Ativo then ChamsTime.Criar(player) end
    end)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ChamsTime.Ativo then ChamsTime.Criar(player) end
    end)
end)

local CarroTab = Window:Tab({Title = "carro", Icon = "car"})

CarroTab:Toggle({
    Title = "chams carros",
    Icon = "car",
    Value = false,
    Callback = function(Value)
        if Value then Carros.Ativar() else Carros.Desativar() end
    end
})

CarroTab:Space()

CarroTab:Toggle({
    Title = "noclip carro",
    Icon = "move",
    Value = false,
    Callback = function(Value)
        if Value then NoclipCarro.Ativar() else NoclipCarro.Desativar() end
    end
})

CarroTab:Space()

CarroTab:Toggle({
    Title = "fly carro",
    Icon = "plane",
    Value = false,
    Callback = function(Value)
        if Value then FlyCarro.Ativar() else FlyCarro.Desativar() end
    end
})

CarroTab:Space()

CarroTab:Slider({
    Title = "velocidade do fly",
    Step = 1,
    Value = {
        Min = 10,
        Max = 200,
        Default = 70
    },
    Callback = function(Value)
        FlyCarro.Velocidade = Value
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
            if ConfigAtual.Theme then
                TemaAtual = ConfigAtual.Theme
                TemaSalvo = ConfigAtual.Theme
                pcall(function()
                    WindUI:SetTheme(TemaAtual)
                end)
            end

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


-- aba de temas
local TemaTab = Window:Tab({
    Title = "tema",
    Icon = "palette"
})

local TemaAtual = "Dark"
local TemaSalvo = "Dark"

local TemasDisponiveis = {
    "Dark","Light","Aqua","Amethyst","Rose","Jester",
    "Ruby","Emerald","Blue","Violet","Orange","Red","Green"
}

local ListaTemas = {}

for _, tema in ipairs(TemasDisponiveis) do
    local ok = pcall(function()
        WindUI:SetTheme(tema)
    end)

    if ok then
        table.insert(ListaTemas, tema)
    end
end

pcall(function()
    WindUI:SetTheme(TemaAtual)
end)

local function AplicarTema()
    pcall(function()
        WindUI:SetTheme(TemaAtual)
    end)
end

local TemaDropdown = TemaTab:Dropdown({
    Title = "selecionar tema da UI",
    Values = ListaTemas,
    Value = TemaAtual,

    Callback = function(Value)
        TemaAtual = Value
        AplicarTema()
        Aviso("tema", "aplicado: " .. TemaAtual, "check")
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "aplicar tema",
    Icon = "check",
    Callback = function()
        AplicarTema()
        Aviso("tema", "aplicado: " .. TemaAtual, "check")
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "salvar tema na config",
    Icon = "save",
    Callback = function()
        TemaSalvo = TemaAtual

        if ConfigAtual then
            ConfigAtual.Theme = TemaSalvo
            pcall(function()
                ConfigAtual:Save()
            end)
            Aviso("tema", "salvo: " .. TemaSalvo, "save")
        else
            Aviso("tema", "salve uma config primeiro", "alert-triangle")
        end
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "carregar tema salvo",
    Icon = "folder",
    Callback = function()
        if table.find(ListaTemas, TemaSalvo) then
            TemaAtual = TemaSalvo
            TemaDropdown:Set(TemaAtual)
            AplicarTema()
            Aviso("tema", "carregado: " .. TemaAtual, "check")
        end
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "tema escuro",
    Icon = "moon",
    Callback = function()
        TemaAtual = "Dark"
        TemaDropdown:Set(TemaAtual)
        AplicarTema()
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "tema claro",
    Icon = "sun",
    Callback = function()
        TemaAtual = "Light"
        TemaDropdown:Set(TemaAtual)
        AplicarTema()
    end
})

TemaTab:Space()

TemaTab:Button({
    Title = "resetar tema",
    Icon = "refresh-cw",
    Callback = function()
        TemaAtual = "Dark"
        TemaSalvo = "Dark"
        TemaDropdown:Set(TemaAtual)
        AplicarTema()
        Aviso("tema", "resetado", "refresh-cw")
    end
})

