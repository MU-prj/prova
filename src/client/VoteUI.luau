--!strict
-- Scheda di voto: durante i Risultati si vota il sopravvissuto con lo
-- stile migliore (niente autovoto: il proprio nome non compare).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fasi = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Fasi"))
local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local phaseChanged = Remotes.get("PhaseChanged")
local votaStile = Remotes.get("VotaStile")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VotoStile"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

local cornice = Instance.new("Frame")
cornice.Name = "Cornice"
cornice.Size = UDim2.fromScale(0.22, 0.4)
cornice.Position = UDim2.fromScale(0.76, 0.3)
cornice.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
cornice.BackgroundTransparency = 0.25
cornice.Parent = screenGui

local titolo = Instance.new("TextLabel")
titolo.Name = "Titolo"
titolo.Size = UDim2.fromScale(1, 0.15)
titolo.BackgroundTransparency = 1
titolo.TextColor3 = Color3.fromRGB(255, 255, 255)
titolo.TextScaled = true
titolo.Font = Enum.Font.GothamBold
titolo.Text = "VOTA LO STILE"
titolo.Parent = cornice

local lista = Instance.new("Frame")
lista.Name = "Lista"
lista.Size = UDim2.fromScale(1, 0.85)
lista.Position = UDim2.fromScale(0, 0.15)
lista.BackgroundTransparency = 1
lista.Parent = cornice

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0.02, 0)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = lista

local costruita = false

local function costruisciLista(nomi: { string })
	for _, figlio in lista:GetChildren() do
		if figlio:IsA("TextButton") then
			figlio:Destroy()
		end
	end

	local candidati = 0
	for ordine, nome in nomi do
		if nome == player.Name then
			continue
		end
		candidati += 1
		local bottone = Instance.new("TextButton")
		bottone.Name = nome
		bottone.LayoutOrder = ordine
		bottone.Size = UDim2.fromScale(1, 0.18)
		bottone.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		bottone.TextColor3 = Color3.fromRGB(255, 255, 255)
		bottone.TextScaled = true
		bottone.Font = Enum.Font.Gotham
		bottone.Text = nome
		bottone.Parent = lista
		bottone.Activated:Connect(function()
			votaStile:FireServer(nome)
			titolo.Text = `Hai votato {nome}`
		end)
	end

	screenGui.Enabled = candidati > 0
end

phaseChanged.OnClientEvent:Connect(function(fase: string, dettagli: { [string]: any })
	if fase ~= Fasi.Risultati then
		screenGui.Enabled = false
		costruita = false
		return
	end
	if costruita then
		return
	end
	local sopravvissuti = dettagli.sopravvissuti
	if typeof(sopravvissuti) ~= "table" then
		return
	end
	costruita = true
	titolo.Text = "VOTA LO STILE"
	costruisciLista(sopravvissuti :: { string })
end)

return true
