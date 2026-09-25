-- Protecao de jogo: este script so funciona no Metropoles RP
local ALLOWED_PLACE_ID=115224559183176
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer

if game.PlaceId~=ALLOWED_PLACE_ID then
    if LocalPlayer then
        LocalPlayer:Kick("Este script so funciona no Metropoles RP.")
    end
    return
end

local WindUI=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Teams=game:GetService("Teams")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local LP=Players.LocalPlayer

local CFG={
	Hitbox=false,
	IgnoreTeam=true,
	HitboxSize=15,
	HitboxTransparency=.5,
	ESP=false,
	TeamColor=true,
	ESPTransparency=.5,
	DefaultColor=Color3.fromRGB(255,60,60),
	TeamColors={}
}

local Dash={On=false,Force=80}

local Fly={
	On=false,
	Speed=60,
	Keys={W=false,A=false,S=false,D=false},
	Up=false,
	Down=false
}

local Aim={
	On=false,
	FOV=150,
	IgnoreFriends=true,
	IgnoreTeam=true,
	Part="Head",
	ShowFOV=true
}

local Window=WindUI:CreateWindow({
	Title="Github",
	Icon="github",
	Folder="BloodRedHub",
	Theme="Dark",
	Size=UDim2.fromOffset(580,460),
	OpenButton={Enabled=false}
})

local ParentGui=(gethui and gethui()) or game:GetService("CoreGui")
local OldBall=ParentGui:FindFirstChild("BloodRedFloatingButton")
if OldBall then OldBall:Destroy() end

local FloatGui=Instance.new("ScreenGui")
FloatGui.Name="BloodRedFloatingButton"
FloatGui.ResetOnSpawn=false
FloatGui.IgnoreGuiInset=true
FloatGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
FloatGui.Parent=ParentGui

local Ball=Instance.new("TextButton")
Ball.Name="BloodRedBall"
Ball.Size=UDim2.fromOffset(54,54)
Ball.Position=UDim2.new(0,20,.5,-27)
Ball.BackgroundColor3=Color3.fromRGB(110,0,0)
Ball.BorderSizePixel=0
Ball.Text=""
Ball.TextSize=18
Ball.TextColor3=Color3.fromRGB(255,255,255)
Ball.AutoButtonColor=false
Ball.Active=true
Ball.ZIndex=999
Ball.Parent=FloatGui

local BC=Instance.new("UICorner")
BC.CornerRadius=UDim.new(1,0)
BC.Parent=Ball

local BS=Instance.new("UIStroke")
BS.Color=Color3.fromRGB(255,30,30)
BS.Thickness=2
BS.Parent=Ball

local BG=Instance.new("UIGradient")
BG.Color=ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(60,0,0)),
	ColorSequenceKeypoint.new(.5,Color3.fromRGB(190,0,0)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(70,0,0))
})
BG.Rotation=45
BG.Parent=Ball

local GithubImage=Instance.new("ImageLabel")
GithubImage.Name="GithubImage"
GithubImage.Size=UDim2.new(1,-6,1,-6)
GithubImage.Position=UDim2.new(0,3,0,3)
GithubImage.BackgroundTransparency=1
GithubImage.BorderSizePixel=0
GithubImage.ZIndex=1000
GithubImage.ScaleType=Enum.ScaleType.Crop
GithubImage.Parent=Ball

local GithubCorner=Instance.new("UICorner")
GithubCorner.CornerRadius=UDim.new(1,0)
GithubCorner.Parent=GithubImage

pcall(function()
	if getcustomasset then
		GithubImage.Image=getcustomasset("Github.png")
	elseif getsynasset then
		GithubImage.Image=getsynasset("Github.png")
	end
end)

task.spawn(function()
	while Ball.Parent do
		for i=1,10 do
			if not Ball.Parent then return end
			BS.Transparency=i/30
			task.wait(.04)
		end
		for i=10,1,-1 do
			if not Ball.Parent then return end
			BS.Transparency=i/30
			task.wait(.04)
		end
	end
end)

local dragging=false
local dragStart
local startPos
local moved=false

Ball.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		moved=false
		dragStart=input.Position
		startPos=Ball.Position
		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
		local d=input.Position-dragStart
		if math.abs(d.X)>6 or math.abs(d.Y)>6 then moved=true end
		Ball.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)

Ball.Activated:Connect(function()
	if moved then moved=false return end
	Window:Toggle()
end)

WindUI:AddTheme({
	Name="blood red",
	Background=Color3.fromHex("#070707"),
	Accent=Color3.fromHex("#300404"),
	Outline=Color3.fromHex("#700808"),
	Text=Color3.fromHex("#FFFFFF"),
	Placeholder=Color3.fromHex("#806666"),
	Button=Color3.fromHex("#B00000"),
	Icon=Color3.fromHex("#FFFFFF")
})
WindUI:SetTheme("blood red")

local MainTab=Window:Tab({Title="aimbot",Icon="crosshair"})
local HitboxTab=Window:Tab({Title="hitbox",Icon="target"})
local ESPTab=Window:Tab({Title="esp player",Icon="eye"})
local ESPCarTab=Window:Tab({Title="esp car",Icon="car"})
local RevistarTab=Window:Tab({Title="revistar",Icon="search"})
local DashTab=Window:Tab({Title="dash",Icon="zap"})
local ConfigTab=Window:Tab({Title="config",Icon="settings"})
local FarmTab=Window:Tab({Title="farm",Icon="repeat"})



-- ═══════════════════════════════════════════════════════════════
local function notify(t,c,i)
	WindUI:Notify({Title=t,Content=c,Icon=i or "info",Duration=3})
end



-- ═══════════════════════════════════════════════════════════════
local function sameTeam(p)
	return LP.Team~=nil and p.Team~=nil and LP.Team==p.Team
end



-- ═══════════════════════════════════════════════════════════════
local function getColor(p)
	if CFG.TeamColor and p.Team then
		return CFG.TeamColors[p.Team.Name] or p.Team.TeamColor.Color
	end
	return CFG.DefaultColor
end

local hitboxRunning=false
local hitboxConnections={}



-- ═══════════════════════════════════════════════════════════════
local function resetHitbox(char)
	if not char then return end
	local h=char:FindFirstChild("Head")
	if not h or not h:GetAttribute("BRHitbox") then return end
	local s=h:GetAttribute("BROldSize")
	local t=h:GetAttribute("BROldTransparency")
	local c=h:GetAttribute("BROldCanCollide")
	local m=h:GetAttribute("BROldMassless")
	if typeof(s)=="Vector3" then h.Size=s end
	if typeof(t)=="number" then h.Transparency=t end
	if typeof(c)=="boolean" then h.CanCollide=c end
	if typeof(m)=="boolean" then h.Massless=m end
	for _,a in ipairs({"BRHitbox","BROldSize","BROldTransparency","BROldCanCollide","BROldMassless"}) do h:SetAttribute(a,nil) end
end



-- ═══════════════════════════════════════════════════════════════
local function applyHitbox(char)
	if not CFG.Hitbox or not char then return end
	local p=Players:GetPlayerFromCharacter(char)
	if not p or p==LP then return end
	if CFG.IgnoreTeam and sameTeam(p) then resetHitbox(char) return end
	local h=char:FindFirstChild("Head")
	if not h or not h:IsA("BasePart") then return end
	if not h:GetAttribute("BRHitbox") then
		h:SetAttribute("BRHitbox",true)
		h:SetAttribute("BROldSize",h.Size)
		h:SetAttribute("BROldTransparency",h.Transparency)
		h:SetAttribute("BROldCanCollide",h.CanCollide)
		h:SetAttribute("BROldMassless",h.Massless)
	end
	local s=CFG.HitboxSize
	h.Size=Vector3.new(s,s,s)
	h.Transparency=CFG.HitboxTransparency
	h.CanCollide=false
	h.Massless=true
end



-- ═══════════════════════════════════════════════════════════════
local function setupHitbox(p)
	if p==LP then return end
	if hitboxConnections[p] then hitboxConnections[p]:Disconnect() end
	hitboxConnections[p]=p.CharacterAdded:Connect(function(char)
		task.wait(.3)
		if hitboxRunning then applyHitbox(char) end
	end)
	if hitboxRunning then
		task.spawn(function()
			while hitboxRunning and p.Parent do
				if p.Character then applyHitbox(p.Character) end
				task.wait(.5)
			end
		end)
	end
end



-- ═══════════════════════════════════════════════════════════════
local function startHitbox()
	if hitboxRunning then return end
	hitboxRunning=true
	for _,p in ipairs(Players:GetPlayers()) do setupHitbox(p) end
end



-- ═══════════════════════════════════════════════════════════════
local function stopHitbox()
	hitboxRunning=false
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP then resetHitbox(p.Character) end
	end
	for p,c in pairs(hitboxConnections) do
		c:Disconnect()
		hitboxConnections[p]=nil
	end
end

local espRunning=false
local espConnections={}



-- ═══════════════════════════════════════════════════════════════
local function removeESP(char)
	if not char then return end
	local h=char:FindFirstChild("BloodRedESP")
	if h then h:Destroy() end
end



-- ═══════════════════════════════════════════════════════════════
local function applyESP(p)
	if not espRunning or not p or p==LP then return end
	local char=p.Character
	if not char or not char.Parent then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then
		task.spawn(function()
			local h=char:WaitForChild("Humanoid",3)
			if h and espRunning then applyESP(p) end
		end)
		return
	end
	if CFG.IgnoreTeam and sameTeam(p) then removeESP(char) return end
	local h=char:FindFirstChild("BloodRedESP")
	if not h then
		h=Instance.new("Highlight")
		h.Name="BloodRedESP"
		h.Adornee=char
		h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent=char
	end
	h.Enabled=true
	h.FillColor=getColor(p)
	h.OutlineColor=Color3.fromRGB(255,30,30)
	h.FillTransparency=CFG.ESPTransparency
	h.OutlineTransparency=0
end



-- ═══════════════════════════════════════════════════════════════
local function setupESP(p)
	if p==LP then return end
	if espConnections[p] then
		for _,c in ipairs(espConnections[p]) do if c then c:Disconnect() end end
	end
	espConnections[p]={}
	table.insert(espConnections[p],p.CharacterAdded:Connect(function(char)
		if not espRunning then return end
		task.spawn(function()
			local hum=char:WaitForChild("Humanoid",5)
			if hum and espRunning then task.wait(.1) applyESP(p) end
		end)
	end))
	table.insert(espConnections[p],p.CharacterRemoving:Connect(function(char) removeESP(char) end))
	table.insert(espConnections[p],p:GetPropertyChangedSignal("Team"):Connect(function()
		if espRunning then task.wait() applyESP(p) end
	end))
	if espRunning then task.spawn(function() if p.Character then applyESP(p) end end) end
end



-- ═══════════════════════════════════════════════════════════════
local function refreshESP()
	if not espRunning then return end
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP then task.spawn(function() applyESP(p) end) end
	end
end



-- ═══════════════════════════════════════════════════════════════
local function startESP()
	if espRunning then refreshESP() return end
	espRunning=true
	for _,p in ipairs(Players:GetPlayers()) do if p~=LP then setupESP(p) end end
	task.wait(.1)
	refreshESP()
end



-- ═══════════════════════════════════════════════════════════════
local function stopESP()
	espRunning=false
	for _,p in ipairs(Players:GetPlayers()) do if p~=LP then removeESP(p.Character) end end
	for p,connections in pairs(espConnections) do
		for _,c in ipairs(connections) do if c then c:Disconnect() end end
		espConnections[p]=nil
	end
end

local RV={On=false,Dist=8,CD=3,Last={}}



-- ═══════════════════════════════════════════════════════════════
local function dead(p)
	local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	return h and h.Health<=0
end



-- ═══════════════════════════════════════════════════════════════
local function dist(p)
	local a=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local b=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	return a and b and (a.Position-b.Position).Magnitude or math.huge
end



-- ═══════════════════════════════════════════════════════════════
local function chat(s)
	local T=game:GetService("TextChatService")
	if T.ChatVersion==Enum.ChatVersion.TextChatService then
		local c=T.TextChannels:FindFirstChild("RBXGeneral")
		if c then c:SendAsync(s) return true end
	end
	local e=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
	local r=e and e:FindFirstChild("SayMessageRequest")
	if r then r:FireServer(s,"All") return true end
	return false
end

task.spawn(function()
	while task.wait(.3) do
		if RV.On then
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=LP and dead(p) and dist(p)<=RV.Dist then
					local t=os.clock()
					if not RV.Last[p] or t-RV.Last[p]>=RV.CD then
						RV.Last[p]=t
						if chat("/revistar "..p.Name) then notify("revistar","revistando "..p.Name,"search") end
					end
				end
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	setupHitbox(p)
	setupESP(p)
end)

Players.PlayerRemoving:Connect(function(p)
	if hitboxConnections[p] then hitboxConnections[p]:Disconnect() hitboxConnections[p]=nil end
	if espConnections[p] then
		for _,c in ipairs(espConnections[p]) do if c then c:Disconnect() end end
		espConnections[p]=nil
	end
	RV.Last[p]=nil
end)

for _,p in ipairs(Players:GetPlayers()) do
	if p~=LP then setupESP(p) end
end

HitboxTab:Toggle({
	Title="ativar hitbox",
	Desc="aumenta a area da cabeca",
	Flag="HitboxEnabled",
	Value=false,
	Callback=function(v)
		CFG.Hitbox=v
		if v then startHitbox() notify("hitbox","ativada","check") else stopHitbox() notify("hitbox","desativada","x") end
	end
})

HitboxTab:Toggle({
	Title="ignorar aliados",
	Desc="nao aplica em jogadores do mesmo time",
	Flag="IgnoreTeam",
	Value=true,
	Callback=function(v)
		CFG.IgnoreTeam=v
		if CFG.Hitbox then for _,p in ipairs(Players:GetPlayers()) do applyHitbox(p.Character) end end
		if CFG.ESP then refreshESP() end
	end
})

HitboxTab:Slider({
	Title="tamanho",
	Desc="tamanho da hitbox",
	Flag="HitboxSize",
	Step=1,
	Value={Min=5,Max=50,Default=15},
	Callback=function(v)
		CFG.HitboxSize=v
		if CFG.Hitbox then for _,p in ipairs(Players:GetPlayers()) do applyHitbox(p.Character) end end
	end
})

HitboxTab:Slider({
	Title="transparencia",
	Desc="0 = invisivel | 1 = visivel",
	Flag="HitboxTransparency",
	Step=.05,
	Value={Min=0,Max=1,Default=.5},
	Callback=function(v)
		CFG.HitboxTransparency=v
		if CFG.Hitbox then for _,p in ipairs(Players:GetPlayers()) do applyHitbox(p.Character) end end
	end
})

HitboxTab:Paragraph({
	Title="funcionamento",
	Desc="aumenta o tamanho da cabeca dos jogadores para facilitar a deteccao de acertos. aliados podem ser ignorados pela opcao acima.",
	Image="info"
})

ESPTab:Toggle({
	Title="ativar chams",
	Desc="destaca os jogadores",
	Flag="ESPEnabled",
	Value=false,
	Callback=function(v)
		CFG.ESP=v
		if v then startESP() notify("esp","ativado","check") else stopESP() notify("esp","desativado","x") end
	end
})

ESPTab:Toggle({
	Title="cor por time",
	Desc="usa a cor do time",
	Flag="TeamColor",
	Value=true,
	Callback=function(v)
		CFG.TeamColor=v
		if CFG.ESP then refreshESP() end
	end
})

ESPTab:Slider({
	Title="transparencia",
	Desc="transparencia dos chams",
	Flag="ESPTransparency",
	Step=.05,
	Value={Min=0,Max=1,Default=.5},
	Callback=function(v)
		CFG.ESPTransparency=v
		if CFG.ESP then refreshESP() end
	end
})



-- ═══════════════════════════════════════════════════════════════
local function addTeam(team)
	if not team or CFG.TeamColors[team.Name] then return end
	CFG.TeamColors[team.Name]=team.TeamColor.Color
	ESPTab:Colorpicker({
		Title=string.lower(team.Name),
		Default=CFG.TeamColors[team.Name],
		Callback=function(c)
			CFG.TeamColors[team.Name]=c
			if CFG.ESP then refreshESP() end
		end
	})
end

for _,team in ipairs(Teams:GetTeams()) do addTeam(team) end
Teams.ChildAdded:Connect(function(obj)
	if obj:IsA("Team") then task.wait(.2) addTeam(obj) end
end)

RevistarTab:Toggle({
	Title="ativar revistar",
	Desc="revista automaticamente jogadores mortos proximos",
	Flag="RevistarEnabled",
	Value=false,
	Callback=function(v)
		RV.On=v
		RV.Last={}
		if v then notify("revistar","ativado","check") else notify("revistar","desativado","x") end
	end
})

RevistarTab:Slider({
	Title="distancia",
	Desc="distancia para detectar jogadores mortos",
	Flag="RevistarDistance",
	Step=1,
	Value={Min=3,Max=30,Default=8},
	Callback=function(v) RV.Dist=v end
})

RevistarTab:Slider({
	Title="cooldown",
	Desc="tempo antes de revistar o mesmo jogador novamente",
	Flag="RevistarCooldown",
	Step=.5,
	Value={Min=1,Max=10,Default=3},
	Callback=function(v) RV.CD=v end
})

RevistarTab:Paragraph({
	Title="funcionamento",
	Desc="ao chegar perto de um jogador morto, envia /revistar nomedoplayer. jogadores vivos sao ignorados.",
	Image="info"
})



-- ═══════════════════════════════════════════════════════════════
local function doDash()
	if not Dash.On then return end
	local char=LP.Character
	if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	local hrp=char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp or hum.Health<=0 then return end
	local direction=hum.MoveDirection
	if direction.Magnitude<.1 then direction=hrp.CFrame.LookVector end
	hrp.AssemblyLinearVelocity=Vector3.new(direction.X*Dash.Force,hrp.AssemblyLinearVelocity.Y,direction.Z*Dash.Force)
end

UIS.JumpRequest:Connect(function()
	if Dash.On then task.wait(.03) doDash() end
end)

DashTab:Toggle({
	Title="ativar dash",
	Desc="da um dash ao pular",
	Flag="DashEnabled",
	Value=false,
	Callback=function(v)
		Dash.On=v
		if v then notify("dash","ativado","zap") else notify("dash","desativado","x") end
	end
})

DashTab:Slider({
	Title="forca",
	Desc="ajusta a intensidade do dash",
	Flag="DashForce",
	Step=5,
	Value={Min=10,Max=200,Default=80},
	Callback=function(v) Dash.Force=v end
})

DashTab:Paragraph({
	Title="funcionamento",
	Desc="ative o dash e pule para executar o movimento na direcao em que estiver andando.",
	Image="zap"
})

local Noclip={
	On=false,
	Connections={},
	Parts={}
}



-- ═══════════════════════════════════════════════════════════════
local function saveNoclipPart(part)
	if not part or not part:IsA("BasePart") then return end
	if Noclip.Parts[part]==nil then
		Noclip.Parts[part]=part.CanCollide
	end
	part.CanCollide=false
end



-- ═══════════════════════════════════════════════════════════════
local function applyNoclip()
	local char=LP.Character
	if not char then return end

	for _,obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			saveNoclipPart(obj)
		end
	end
end



-- ═══════════════════════════════════════════════════════════════
local function stopNoclip()
	Noclip.On=false

	for _,connection in ipairs(Noclip.Connections) do
		if connection then connection:Disconnect() end
	end
	Noclip.Connections={}

	for part,oldValue in pairs(Noclip.Parts) do
		if part and part.Parent then
			part.CanCollide=oldValue
		end
	end

	Noclip.Parts={}
end



-- ═══════════════════════════════════════════════════════════════
local function startNoclip()
	if Noclip.On then return end

	Noclip.On=true
	applyNoclip()

	if LP.Character then
		table.insert(Noclip.Connections,LP.Character.DescendantAdded:Connect(function(obj)
			if Noclip.On and obj:IsA("BasePart") then
				saveNoclipPart(obj)
			end
		end))
	end

	table.insert(Noclip.Connections,LP.CharacterAdded:Connect(function(char)
		task.wait(.15)
		if not Noclip.On then return end

		for _,obj in ipairs(char:GetDescendants()) do
			if obj:IsA("BasePart") then
				saveNoclipPart(obj)
			end
		end

		table.insert(Noclip.Connections,char.DescendantAdded:Connect(function(obj)
			if Noclip.On and obj:IsA("BasePart") then
				saveNoclipPart(obj)
			end
		end))
	end))

	table.insert(Noclip.Connections,RunService.Heartbeat:Connect(function()
		if Noclip.On then
			applyNoclip()
		end
	end))
end

DashTab:Toggle({
	Title="ativar noclip",
	Desc="atravessa paredes e objetos sem colisao",
	Flag="NoclipEnabled",
	Value=false,
	Callback=function(v)
		if v then
			startNoclip()
			notify("noclip","ativado","move")
		else
			stopNoclip()
			notify("noclip","desativado","x")
		end
	end
})

DashTab:Paragraph({
	Title="noclip",
	Desc="permite atravessar paredes e objetos enquanto estiver ativado.",
	Image="ghost"
})

local FlyGui=nil
local FlyButtons={}
local FlyVelocity=nil
local FlyConnection=nil



-- ═══════════════════════════════════════════════════════════════
local function flyButton(name,text,pos)
	if not FlyGui then return end

	local b=Instance.new("TextButton")
	b.Name=name
	b.Size=UDim2.fromOffset(58,58)
	b.Position=pos
	b.BackgroundColor3=Color3.fromRGB(45,45,45)
	b.BackgroundTransparency=.15
	b.BorderSizePixel=0
	b.Text=text
	b.TextColor3=Color3.fromRGB(255,255,255)
	b.TextSize=24
	b.Font=Enum.Font.GothamBold
	b.AutoButtonColor=false
	b.ZIndex=100
	b.Parent=FlyGui

	local corner=Instance.new("UICorner")
	corner.CornerRadius=UDim.new(1,0)
	corner.Parent=b

	local stroke=Instance.new("UIStroke")
	stroke.Color=Color3.fromRGB(255,30,30)
	stroke.Thickness=2
	stroke.Parent=b

	FlyButtons[name]=b

	local function state(v)
		if name=="FlyW" then Fly.Keys.W=v end
		if name=="FlyA" then Fly.Keys.A=v end
		if name=="FlyS" then Fly.Keys.S=v end
		if name=="FlyD" then Fly.Keys.D=v end
		if name=="FlyUp" then Fly.Up=v end
		if name=="FlyDown" then Fly.Down=v end
		b.BackgroundColor3=v and Color3.fromRGB(130,0,0) or Color3.fromRGB(45,45,45)
	end

	b.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then state(true) end
	end)

	b.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then state(false) end
	end)
end



-- ═══════════════════════════════════════════════════════════════
local function createFlyGui()
	if FlyGui then FlyGui:Destroy() end
	FlyButtons={}

	FlyGui=Instance.new("ScreenGui")
	FlyGui.Name="BloodRedFlyControls"
	FlyGui.ResetOnSpawn=false
	FlyGui.IgnoreGuiInset=true
	FlyGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	FlyGui.Parent=ParentGui

	flyButton("FlyW","▲",UDim2.new(0,75,1,-190))
	flyButton("FlyA","◀",UDim2.new(0,10,1,-125))
	flyButton("FlyS","▼",UDim2.new(0,75,1,-125))
	flyButton("FlyD","▶",UDim2.new(0,140,1,-125))
	flyButton("FlyUp","⬆",UDim2.new(1,-140,1,-190))
	flyButton("FlyDown","⬇",UDim2.new(1,-140,1,-125))
end



-- ═══════════════════════════════════════════════════════════════
local function clearFlyInput()
	Fly.Keys.W=false
	Fly.Keys.A=false
	Fly.Keys.S=false
	Fly.Keys.D=false
	Fly.Up=false
	Fly.Down=false
end



-- ═══════════════════════════════════════════════════════════════
local function destroyFlyGui()
	clearFlyInput()
	if FlyGui then FlyGui:Destroy() FlyGui=nil end
	FlyButtons={}
end



-- ═══════════════════════════════════════════════════════════════
local function stopFly()
	Fly.On=false
	clearFlyInput()

	if FlyConnection then
		FlyConnection:Disconnect()
		FlyConnection=nil
	end

	if FlyVelocity then
		FlyVelocity:Destroy()
		FlyVelocity=nil
	end

	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.AssemblyLinearVelocity=Vector3.zero end

	destroyFlyGui()
end



-- ═══════════════════════════════════════════════════════════════
local function startFly()
	if Fly.On then return end

	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")

	if not hrp then
		notify("fly","personagem nao encontrado","x")
		return
	end

	Fly.On=true
	createFlyGui()

	FlyVelocity=Instance.new("BodyVelocity")
	FlyVelocity.Name="BloodRedFlyVelocity"
	FlyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	FlyVelocity.P=90000
	FlyVelocity.Velocity=Vector3.zero
	FlyVelocity.Parent=hrp

	FlyConnection=RunService.RenderStepped:Connect(function()
		if not Fly.On then return end

		local character=LP.Character
		local root=character and character:FindFirstChild("HumanoidRootPart")

		if not root then
			stopFly()
			return
		end

		if not FlyVelocity or FlyVelocity.Parent~=root then
			if FlyVelocity then FlyVelocity:Destroy() end
			FlyVelocity=Instance.new("BodyVelocity")
			FlyVelocity.Name="BloodRedFlyVelocity"
			FlyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
			FlyVelocity.P=90000
			FlyVelocity.Parent=root
		end

		local camera=workspace.CurrentCamera
		if not camera then return end

		local forward=Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z)
		local right=Vector3.new(camera.CFrame.RightVector.X,0,camera.CFrame.RightVector.Z)

		if forward.Magnitude>0 then forward=forward.Unit end
		if right.Magnitude>0 then right=right.Unit end

		local direction=Vector3.zero

		if Fly.Keys.W then direction+=forward end
		if Fly.Keys.S then direction-=forward end
		if Fly.Keys.D then direction+=right end
		if Fly.Keys.A then direction-=right end

		if direction.Magnitude>1 then direction=direction.Unit end

		local vertical=0
		if Fly.Up then vertical+=1 end
		if Fly.Down then vertical-=1 end

		FlyVelocity.Velocity=direction*Fly.Speed+Vector3.new(0,vertical*Fly.Speed,0)
	end)
end

DashTab:Toggle({
	Title="ativar fly",
	Desc="ativa os controles de voo no celular",
	Flag="FlyEnabled",
	Value=false,
	Callback=function(v)
		if v then
			startFly()
			if Fly.On then notify("fly","ativado","plane") end
		else
			stopFly()
			notify("fly","desativado","x")
		end
	end
})

DashTab:Slider({
	Title="velocidade",
	Desc="aumenta ou diminui a velocidade do fly",
	Flag="FlySpeed",
	Step=5,
	Value={Min=10,Max=250,Default=60},
	Callback=function(v) Fly.Speed=v end
})

DashTab:Paragraph({
	Title="controles mobile",
	Desc="▲ frente | ◀ esquerda | ▼ tras | ▶ direita | ⬆ subir | ⬇ descer",
	Image="smartphone"
})

local AimCircle=nil
local AimStroke=nil
local AimFOVGui=nil
local AimConnection=nil



-- ═══════════════════════════════════════════════════════════════
local function getAimPart(character)
	if not character then return nil end
	local names={
		Head={"Head"},
		HumanoidRootPart={"HumanoidRootPart"},
		UpperTorso={"UpperTorso","Torso"},
		Torso={"Torso","UpperTorso"}
	}
	for _,name in ipairs(names[Aim.Part] or {Aim.Part}) do
		local part=character:FindFirstChild(name)
		if part and part:IsA("BasePart") then return part end
	end
	return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end



-- ═══════════════════════════════════════════════════════════════
local function isFriend(p)
	if not p or p==LP then return false end
	local ok,result=pcall(function()
		return LP:IsFriendsWith(p.UserId)
	end)
	return ok and result==true
end



-- ═══════════════════════════════════════════════════════════════
local function validAimPlayer(p)
	if not p or p==LP then return false end
	if not p.Character then return false end
	local hum=p.Character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health<=0 then return false end
	if Aim.IgnoreTeam and sameTeam(p) then return false end
	if Aim.IgnoreFriends and isFriend(p) then return false end
	return getAimPart(p.Character)~=nil
end



-- ═══════════════════════════════════════════════════════════════
local function getAimTarget()
	local camera=workspace.CurrentCamera
	if not camera then return nil end

	local mouse=camera.ViewportSize/2
	local best=nil
	local bestDistance=Aim.FOV

	for _,p in ipairs(Players:GetPlayers()) do
		if validAimPlayer(p) then
			local part=getAimPart(p.Character)
			local screen,onScreen=camera:WorldToViewportPoint(part.Position)
			if onScreen and screen.Z>0 then
				local d=(Vector2.new(screen.X,screen.Y)-mouse).Magnitude
				if d<=bestDistance then
					bestDistance=d
					best=part
				end
			end
		end
	end

	return best
end

local AimCircle=nil
local AimStroke=nil



-- ═══════════════════════════════════════════════════════════════
local function destroyAimCircle()
	if AimCircle then
		AimCircle:Destroy()
		AimCircle=nil
	end
	if AimFOVGui then
		AimFOVGui:Destroy()
		AimFOVGui=nil
	end
	AimStroke=nil
end



-- ═══════════════════════════════════════════════════════════════
local function updateAimCircle(targetExists)
	if not Aim.ShowFOV or not Aim.On then
		destroyAimCircle()
		return
	end

	if not AimCircle then
		AimFOVGui=Instance.new("ScreenGui")
		AimFOVGui.Name="BloodRedAimbotFOVGui"
		AimFOVGui.ResetOnSpawn=false
		AimFOVGui.IgnoreGuiInset=true
		AimFOVGui.DisplayOrder=999999
		AimFOVGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
		AimFOVGui.Parent=ParentGui

		AimCircle=Instance.new("Frame")
		AimCircle.Name="BloodRedAimbotFOV"
		AimCircle.AnchorPoint=Vector2.new(.5,.5)
		AimCircle.Position=UDim2.new(.5,0,.5,0)
		AimCircle.BackgroundTransparency=1
		AimCircle.BorderSizePixel=0
		AimCircle.ZIndex=200
		AimCircle.Parent=AimFOVGui

		local corner=Instance.new("UICorner")
		corner.CornerRadius=UDim.new(1,0)
		corner.Parent=AimCircle

		local stroke=Instance.new("UIStroke")
		stroke.Name="FOVStroke"
		stroke.Color=Color3.fromRGB(255,30,30)
		stroke.Thickness=1
		stroke.Transparency=0
		stroke.Parent=AimCircle
		AimStroke=stroke
	end

	if AimStroke then
		AimStroke.Color=targetExists and Color3.fromRGB(30,255,80) or Color3.fromRGB(255,30,30)
	end

	local diameter=math.max(2,Aim.FOV*2)
	AimCircle.Size=UDim2.fromOffset(diameter,diameter)
	AimCircle.Visible=true
end



-- ═══════════════════════════════════════════════════════════════
local function stopAimbot()
	Aim.On=false
	if AimConnection then
		AimConnection:Disconnect()
		AimConnection=nil
	end
	destroyAimCircle()
end



-- ═══════════════════════════════════════════════════════════════
local function startAimbot()
	if Aim.On then return end
	Aim.On=true

	AimConnection=RunService.RenderStepped:Connect(function()
		if not Aim.On then return end
		local target=getAimTarget()
		updateAimCircle(target~=nil)
		local camera=workspace.CurrentCamera
		if target and camera then
			camera.CFrame=CFrame.lookAt(camera.CFrame.Position,target.Position)
		end
	end)
end

MainTab:Toggle({
	Title="ativar aimbot",
	Desc="mira automaticamente no jogador mais proximo dentro do FOV",
	Flag="AimbotEnabled",
	Value=false,
	Callback=function(v)
		if v then
			startAimbot()
			notify("aimbot","ativado","crosshair")
		else
			stopAimbot()
			notify("aimbot","desativado","x")
		end
	end
})

MainTab:Slider({
	Title="fov",
	Desc="aumenta ou diminui a area de mira",
	Flag="AimbotFOV",
	Step=5,
	Value={Min=25,Max=500,Default=150},
	Callback=function(v)
		Aim.FOV=v
		updateAimCircle()
	end
})

MainTab:Toggle({
	Title="ignorar amigos",
	Desc="nao trava a mira em jogadores da sua lista de amigos",
	Flag="AimbotIgnoreFriends",
	Value=true,
	Callback=function(v) Aim.IgnoreFriends=v end
})

MainTab:Toggle({
	Title="ignorar time",
	Desc="nao trava a mira em jogadores do mesmo time",
	Flag="AimbotIgnoreTeam",
	Value=true,
	Callback=function(v) Aim.IgnoreTeam=v end
})

MainTab:Toggle({
	Title="mostrar fov",
	Desc="mostra o circulo do FOV na tela",
	Flag="AimbotShowFOV",
	Value=true,
	Callback=function(v)
		Aim.ShowFOV=v
		if not v then destroyAimCircle() end
	end
})

MainTab:Dropdown({
	Title="parte do aimbot",
	Desc="escolha onde a mira vai grudar",
	Flag="AimbotPart",
	Values={"Head","HumanoidRootPart","UpperTorso","Torso"},
	Value="Head",
	AllowNone=false,
	Callback=function(v)
		if v and v~="" then Aim.Part=v end
	end
})

MainTab:Paragraph({
	Title="aimbot",
	Desc="o alvo e escolhido pela distancia do cursor ao centro da parte selecionada dentro do FOV.",
	Image="crosshair"
})


local VehicleESP={
	On=false,
	Connections={}
}



-- ═══════════════════════════════════════════════════════════════
local function isVehicleModel(obj)
	if not obj:IsA("Model") then return false end

	if obj:FindFirstChildWhichIsA("VehicleSeat",true) then
		return true
	end

	local n=obj.Name:lower()
	return n:find("vehicle")~=nil
		or n:find("car")~=nil
		or n:find("truck")~=nil
		or n:find("bus")~=nil
end



-- ═══════════════════════════════════════════════════════════════
local function addVehicleESP(obj)
	if not VehicleESP.On or not isVehicleModel(obj) then return end
	if obj:FindFirstChild("BloodRedVehicleESP") then return end

	local h=Instance.new("Highlight")
	h.Name="BloodRedVehicleESP"
	h.Adornee=obj
	h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
	h.FillColor=Color3.fromRGB(255,170,0)
	h.OutlineColor=Color3.fromRGB(255,255,255)
	h.FillTransparency=.65
	h.OutlineTransparency=0
	h.Parent=obj
end



-- ═══════════════════════════════════════════════════════════════
local function clearVehicleESP()
	for _,obj in ipairs(workspace:GetDescendants()) do
		local h=obj:FindFirstChild("BloodRedVehicleESP")
		if h then h:Destroy() end
	end
end



-- ═══════════════════════════════════════════════════════════════
local function startVehicleESP()
	if VehicleESP.On then return end
	VehicleESP.On=true

	for _,obj in ipairs(workspace:GetDescendants()) do
		addVehicleESP(obj)
	end

	table.insert(VehicleESP.Connections,workspace.DescendantAdded:Connect(function(obj)
		if not VehicleESP.On then return end
		task.defer(function()
			if obj:IsA("Model") then
				addVehicleESP(obj)
			elseif obj:IsA("VehicleSeat") and obj.Parent then
				addVehicleESP(obj.Parent)
			end
		end)
	end))
end



-- ═══════════════════════════════════════════════════════════════
local function stopVehicleESP()
	VehicleESP.On=false

	for _,connection in ipairs(VehicleESP.Connections) do
		if connection then connection:Disconnect() end
	end
	VehicleESP.Connections={}

	clearVehicleESP()
end

ESPCarTab:Toggle({
	Title="esp carros",
	Desc="destaca os carros e veiculos do servidor",
	Flag="VehicleESP",
	Value=false,
	Callback=function(v)
		if v then
			startVehicleESP()
			notify("esp carros","ativado","car")
		else
			stopVehicleESP()
			notify("esp carros","desativado","x")
		end
	end
})

ESPCarTab:Paragraph({
	Title="esp carros",
	Desc="mostra os veiculos encontrados no mapa.",
})

local CarFly={On=false,Speed=80,Vertical=50,Velocity=nil,Connection=nil,Gui=nil,Buttons={},Keys={W=false,A=false,S=false,D=false,Up=false,Down=false}}

local CarSpeed={On=false,Speed=180,Connection=nil,Original={}}



-- ═══════════════════════════════════════════════════════════════
local function getCurrentCarSeat()
	local char=LP.Character
	if not char then return nil end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("VehicleSeat") and obj.Occupant==hum then return obj end
	end
	return nil
end



-- ═══════════════════════════════════════════════════════════════
local function restoreCarSpeed()
	for seat,value in pairs(CarSpeed.Original) do
		if seat and seat.Parent and seat:IsA("VehicleSeat") then
			pcall(function() seat.MaxSpeed=value end)
		end
	end
	CarSpeed.Original={}
end



-- ═══════════════════════════════════════════════════════════════
local function stopCarSpeed()
	CarSpeed.On=false
	if CarSpeed.Connection then
		CarSpeed.Connection:Disconnect()
		CarSpeed.Connection=nil
	end
	restoreCarSpeed()
end



-- ═══════════════════════════════════════════════════════════════
local function startCarSpeed()
	if CarSpeed.On then return end
	if not getCurrentCarSeat() then
		notify("velocidade do carro","entre em um carro primeiro","x")
		return
	end
	CarSpeed.On=true
	CarSpeed.Connection=RunService.Heartbeat:Connect(function()
		if not CarSpeed.On then return end
		local seat=getCurrentCarSeat()
		if not seat then return end
		if CarSpeed.Original[seat]==nil then
			CarSpeed.Original[seat]=seat.MaxSpeed
		end
		pcall(function()
			seat.MaxSpeed=CarSpeed.Speed
		end)
	end)
end



-- ═══════════════════════════════════════════════════════════════
local function getCarSeat()
	local char=LP.Character
	if not char then return nil end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("VehicleSeat") and obj.Occupant==hum then return obj end
	end
	return nil
end



-- ═══════════════════════════════════════════════════════════════
local function getCarRoot(seat)
	if not seat then return nil end
	local model=seat:FindFirstAncestorOfClass("Model")
	if model and model.PrimaryPart then return model.PrimaryPart end
	return seat
end



-- ═══════════════════════════════════════════════════════════════
local function carFlyButton(name,text,pos)
	if not CarFly.Gui then return end
	local b=Instance.new("TextButton")
	b.Name=name;b.Size=UDim2.fromOffset(58,58);b.Position=pos
	b.BackgroundColor3=Color3.fromRGB(45,45,45);b.BackgroundTransparency=.15
	b.BorderSizePixel=0;b.Text=text;b.TextColor3=Color3.fromRGB(255,255,255)
	b.TextSize=24;b.Font=Enum.Font.GothamBold;b.AutoButtonColor=false;b.ZIndex=100;b.Parent=CarFly.Gui
	local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=b
	local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(255,30,30);stroke.Thickness=2;stroke.Parent=b
	CarFly.Buttons[name]=b
	local function state(v)
		CarFly.Keys[name]=v
		b.BackgroundColor3=v and Color3.fromRGB(130,0,0) or Color3.fromRGB(45,45,45)
	end
	b.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then state(true) end end)
	b.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then state(false) end end)
end



-- ═══════════════════════════════════════════════════════════════
local function createCarFlyGui()
	if CarFly.Gui then CarFly.Gui:Destroy() end
	CarFly.Buttons={}
	CarFly.Gui=Instance.new("ScreenGui")
	CarFly.Gui.Name="BloodRedCarFlyControls";CarFly.Gui.ResetOnSpawn=false;CarFly.Gui.IgnoreGuiInset=true
	CarFly.Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;CarFly.Gui.Parent=ParentGui
	carFlyButton("W","▲",UDim2.new(0,75,1,-190));carFlyButton("A","◀",UDim2.new(0,10,1,-125))
	carFlyButton("S","▼",UDim2.new(0,75,1,-125));carFlyButton("D","▶",UDim2.new(0,140,1,-125))
	carFlyButton("Up","⬆",UDim2.new(1,-140,1,-190));carFlyButton("Down","⬇",UDim2.new(1,-140,1,-125))
end



-- ═══════════════════════════════════════════════════════════════
local function clearCarFly()
	CarFly.Keys={W=false,A=false,S=false,D=false,Up=false,Down=false}
	if CarFly.Gui then CarFly.Gui:Destroy();CarFly.Gui=nil end
	CarFly.Buttons={}
end



-- ═══════════════════════════════════════════════════════════════
local function stopCarFly()
	CarFly.On=false
	if CarFly.Connection then CarFly.Connection:Disconnect();CarFly.Connection=nil end
	if CarFly.Velocity then CarFly.Velocity:Destroy();CarFly.Velocity=nil end
	clearCarFly()
end



-- ═══════════════════════════════════════════════════════════════
local function startCarFly()
	if CarFly.On then return end
	local seat=getCarSeat()
	if not seat then notify("fly carro","entre em um carro primeiro","x");return end
	local root=getCarRoot(seat)
	if not root or not root:IsA("BasePart") then notify("fly carro","carro nao encontrado","x");return end
	CarFly.On=true;createCarFlyGui()
	CarFly.Velocity=Instance.new("BodyVelocity")
	CarFly.Velocity.Name="BloodRedCarFlyVelocity";CarFly.Velocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
	CarFly.Velocity.P=90000;CarFly.Velocity.Velocity=Vector3.zero;CarFly.Velocity.Parent=root
	CarFly.Connection=RunService.RenderStepped:Connect(function()
		if not CarFly.On then return end
		local currentSeat=getCarSeat();local currentRoot=getCarRoot(currentSeat)
		if not currentSeat or not currentRoot then stopCarFly();return end
		if not CarFly.Velocity or CarFly.Velocity.Parent~=currentRoot then
			if CarFly.Velocity then CarFly.Velocity:Destroy() end
			CarFly.Velocity=Instance.new("BodyVelocity");CarFly.Velocity.Name="BloodRedCarFlyVelocity"
			CarFly.Velocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge);CarFly.Velocity.P=90000;CarFly.Velocity.Parent=currentRoot
		end
		local camera=workspace.CurrentCamera;if not camera then return end
		local forward=Vector3.new(camera.CFrame.LookVector.X,0,camera.CFrame.LookVector.Z)
		local right=Vector3.new(camera.CFrame.RightVector.X,0,camera.CFrame.RightVector.Z)
		if forward.Magnitude>0 then forward=forward.Unit end;if right.Magnitude>0 then right=right.Unit end
		local direction=Vector3.zero
		if CarFly.Keys.W then direction+=forward end;if CarFly.Keys.S then direction-=forward end
		if CarFly.Keys.D then direction+=right end;if CarFly.Keys.A then direction-=right end
		if direction.Magnitude>1 then direction=direction.Unit end
		local vertical=0;if CarFly.Keys.Up then vertical+=CarFly.Vertical end;if CarFly.Keys.Down then vertical-=CarFly.Vertical end
		CarFly.Velocity.Velocity=direction*CarFly.Speed+Vector3.new(0,vertical,0)
	end)
end

ESPCarTab:Toggle({
	Title="turbo carro",
	Desc="aumenta a velocidade normal do carro, separado do fly",
	Flag="CarSpeedEnabled",
	Value=false,
	Callback=function(v)
		if v then
			startCarSpeed()
			if not CarSpeed.On then
				WindUI:SetConfig("CarSpeedEnabled",false)
			else
				notify("velocidade do carro","ativado","car")
			end
		else
			stopCarSpeed()
			notify("velocidade do carro","desativado","x")
		end
	end
})

ESPCarTab:Slider({
	Title="velocidade do carro",
	Desc="velocidade máxima do carro normal",
	Flag="CarSpeedValue",
	Step=10,
	Value={Min=50,Max=500,Default=180},
	Callback=function(v)
		CarSpeed.Speed=v
	end
})

ESPCarTab:Toggle({Title="fly carro",Desc="voa com o carro usando controles mobile",Flag="CarFlyEnabled",Value=false,Callback=function(v)
	if v then startCarFly();if CarFly.On then notify("fly carro","ativado","car") end else stopCarFly();notify("fly carro","desativado","x") end
end})

ESPCarTab:Slider({Title="velocidade do fly",Desc="velocidade horizontal do carro",Flag="CarFlySpeed",Step=5,Value={Min=10,Max=250,Default=80},Callback=function(v) CarFly.Speed=v end})
ESPCarTab:Slider({Title="velocidade vertical",Desc="velocidade para subir e descer",Flag="CarFlyVertical",Step=5,Value={Min=10,Max=150,Default=50},Callback=function(v) CarFly.Vertical=v end})
ESPCarTab:Paragraph({Title="controles do fly carro",Desc="▲ frente | ◀ esquerda | ▼ tras | ▶ direita | ⬆ subir | ⬇ descer. entre em um carro antes de ativar.",Image="smartphone"})






-- ═════════
-- ═══════════════════════════════════════════════════════════════
-- FARM SIMPLES DO CAIXA
local Farm={
	On=false,
	Delay=0.25,
	Last={},
	Thread=nil
}

local FarmProducts={
	{keys={"bolo","cake","torta"},index=1},
	{keys={"bebida","drink","refri","refrigerante","coca","suco"},index=2},
	{keys={"sorvete","icecream","ice cream","gelado"},index=3},
	{keys={"hamburguer","hamburger","burger","lanche"},index=4},
	{keys={"pizza"},index=5},
	{keys={"sanduiche","sandwich","sanduíche"},index=6}
}

local function farmProductIndex(name)
	local n=tostring(name):lower()
	for _,data in ipairs(FarmProducts) do
		for _,key in ipairs(data.keys) do
			if n:find(key,1,true) then return data.index end
		end
	end
	return nil
end

local function farmRoot()
	local char=LP.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function farmFindBoardButtons()
	local root=LP:FindFirstChildOfClass("PlayerGui")
	if not root then return {} end

	local camera=workspace.CurrentCamera
	local view=camera and camera.ViewportSize or Vector2.new(1600,900)
	local candidates={}

	-- Procura um grupo com exatamente 6 botoes, como o painel do video.
	for _,obj in ipairs(root:GetDescendants()) do
		if obj:IsA("GuiObject") and obj.Visible then
			local buttons={}
			for _,child in ipairs(obj:GetChildren()) do
				if child:IsA("GuiButton") and child.Visible and child.Active then
					local s=child.AbsoluteSize
					if s.X>=45 and s.Y>=45 and s.X<=220 and s.Y<=220 then
						table.insert(buttons,child)
					end
				end
			end
			if #buttons==6 then
				local minX,minY=math.huge,math.huge
				local maxX,maxY=-math.huge,-math.huge
				for _,b in ipairs(buttons) do
					local p=b.AbsolutePosition
					local s=b.AbsoluteSize
					minX=math.min(minX,p.X); minY=math.min(minY,p.Y)
					maxX=math.max(maxX,p.X+s.X); maxY=math.max(maxY,p.Y+s.Y)
				end
				local cx=(minX+maxX)/2
				local cy=(minY+maxY)/2
				if cx>view.X*.20 and cx<view.X*.80 and cy>view.Y*.05 and cy<view.Y*.75 then
					table.sort(buttons,function(a,b)
						local pa,pb=a.AbsolutePosition,b.AbsolutePosition
						if math.abs(pa.Y-pb.Y)>20 then return pa.Y<pb.Y end
						return pa.X<pb.X
					end)
					return buttons
				end
			end
		end
	end

	return {}
end

local function farmClickButton(button)
	if not button or not button.Parent or not button.Visible then return false end
	local ok=pcall(function() button:Activate() end)
	if ok then return true end

	pcall(function()
		local vim=game:GetService("VirtualInputManager")
		local p=button.AbsolutePosition
		local s=button.AbsoluteSize
		local x=p.X+s.X/2
		local y=p.Y+s.Y/2
		vim:SendMouseButtonEvent(x,y,0,true,game,0)
		task.wait(.05)
		vim:SendMouseButtonEvent(x,y,0,false,game,0)
	end)
	return true
end

local function farmFindProducts()
	local root=farmRoot()
	if not root then return {} end

	local found={}
	local seen={}
	for _,obj in ipairs(workspace:GetDescendants()) do
		local pos=nil
		local name=obj.Name

		if obj:IsA("Model") then
			local rp=obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
			if rp then pos=rp.Position end
		elseif obj:IsA("BasePart") then
			pos=obj.Position
		end

		if pos and (pos-root.Position).Magnitude<=18 then
			local index=farmProductIndex(name)
			if index and not seen[index] then
				seen[index]=true
				table.insert(found,{index=index,dist=(pos-root.Position).Magnitude,obj=obj})
			end
		end
	end

	table.sort(found,function(a,b) return a.dist<b.dist end)
	return found
end

local function farmRunCycle()
	local products=farmFindProducts()
	if #products==0 then
		-- Quando o balcão fica vazio, libera a próxima rodada.
		Farm.Last=""
		return false
	end

	local ids={}
	for _,item in ipairs(products) do
		ids[#ids+1]=tostring(item.index)
	end
	table.sort(ids)
	local signature=table.concat(ids,",")

	-- Não clica novamente nos mesmos produtos enquanto eles continuam no balcão.
	if signature==Farm.Last then return false end
	Farm.Last=signature

	local buttons=farmFindBoardButtons()
	if #buttons~=6 then return false end

	for _,item in ipairs(products) do
		local button=buttons[item.index]
		if button then
			farmClickButton(button)
			task.wait(Farm.Delay)
		end
	end
	return true
end

local function stopFarm(msg)
	Farm.On=false
	if msg then notify("farm",msg,"info") end
end

local function startFarm()
	if Farm.On then return end
	Farm.On=true
	notify("farm","ativado — procurando os produtos do checkout...","repeat")

	Farm.Thread=task.spawn(function()
		while Farm.On do
			local worked=farmRunCycle()
			if worked then
				-- Espera o painel atualizar para o próximo pedido.
				task.wait(1.2)
			else
				task.wait(.5)
			end
		end
	end)
end

FarmTab:Toggle({
	Title="farm do trabalho",
	Desc="seleciona automaticamente os produtos que aparecem no checkout",
	Flag="FarmEnabled",
	Value=false,
	Callback=function(v)
		if v then
			startFarm()
		else
			stopFarm("desativado")
		end
	end
})

FarmTab:Slider({
	Title="velocidade",
	Desc="tempo entre cada seleção",
	Flag="FarmDelay",
	Step=.05,
	Value={Min=.05,Max=1,Default=.25},
	Callback=function(v)
		Farm.Delay=v
	end
})

FarmTab:Paragraph({
	Title="como funciona",
	Desc="deixe o personagem no caixa. O farm procura os produtos próximos e seleciona os respectivos 6 itens do painel automaticamente.",
	Image="info"
})


local ConfigManager=Window.ConfigManager
local configName="default"
local configFile=nil
local ConfigDropdown=nil

local configInput=ConfigTab:Input({
	Title="nome da config",
	Desc="digite o nome que deseja salvar",
	Value="default",
	Callback=function(v)
		if v and v~="" then configName=v end
	end
})

if ConfigManager then
	local ok=ConfigManager:Init(Window)
	if ok then
		ConfigDropdown=ConfigTab:Dropdown({
			Title="configs salvas",
			Values=ConfigManager:AllConfigs(),
			Value="default",
			AllowNone=false,
			SearchBarEnabled=true,
			Callback=function(v)
				if v and v~="" then
					configName=v
					if configInput then configInput:Set(v) end
				end
			end
		})

		ConfigTab:Button({
			Title="salvar config",
			Icon="save",
			Color=Color3.fromHex("#B00000"),
			Callback=function()
				if configName=="" then notify("config","digite um nome","alert-triangle") return end
				configFile=ConfigManager:CreateConfig(configName)
				configFile:Set("Theme",WindUI:GetCurrentTheme())

				if configFile:Save() then
					if ConfigDropdown then ConfigDropdown:Refresh(ConfigManager:AllConfigs()) end
					notify("config","salva: "..configName,"check")
				else
					notify("config","falha ao salvar","x")
				end
			end
		})

		ConfigTab:Button({
			Title="carregar config",
			Icon="folder-open",
			Callback=function()
				if configName=="" then
					notify("config","selecione uma config","alert-triangle")
					return
				end

				configFile=ConfigManager:CreateConfig(configName)
				local data,err=configFile:Load()

				if data then
					notify("config","carregada: "..configName,"check")
				else
					notify("config",tostring(err or "config nao encontrada"),"x")
				end
			end
		})

		ConfigTab:Button({
			Title="atualizar lista",
			Icon="refresh-cw",
			Callback=function()
				if ConfigDropdown then ConfigDropdown:Refresh(ConfigManager:AllConfigs()) end
				notify("config","lista atualizada","refresh-cw")
			end
		})

		ConfigTab:Button({
			Title="deletar config",
			Icon="trash-2",
			Color=Color3.fromHex("#650909"),
			Callback=function()
				if configName=="" then
					notify("config","nenhuma config selecionada","alert-triangle")
					return
				end

				local a,b=ConfigManager:DeleteConfig(configName)

				if a then
					if ConfigDropdown then ConfigDropdown:Refresh(ConfigManager:AllConfigs()) end
					notify("config","deletada: "..configName,"check")
				else
					notify("config",tostring(b or "erro ao deletar"),"x")
				end
			end
		})
	else
		ConfigTab:Paragraph({
			Title="config indisponivel",
			Desc="seu executor nao possui suporte ao sistema de arquivos do configmanager."
		})
	end
else
	ConfigTab:Paragraph({
		Title="configmanager indisponivel",
		Desc="o windui nao disponibilizou o configmanager."
	})
end

WindUI:SetTheme("blood red")

notify("Github 🐙","carregado com sucesso!","check")
