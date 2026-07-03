--!strict
-- Il guardaroba: durante il Nascondiglio i nascosti scelgono l'outfit
-- con cui mimetizzarsi tra i manichini.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fasi = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Fasi"))
local Outfits = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Outfits"))
local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local phaseChanged = Remotes.get("PhaseChanged")
local outfitScelto = Remotes.get("OutfitScelto")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Guardaroba"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

local cornice = Instance.new("Frame")
cornice.Name = "Cornice"
cornice.Size = UDim2.fromScale(0.56, 0.2)
cornice.Position = UDim2.fromScale(0.22, 0.78)
cornice.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
cornice.BackgroundTransparency = 0.25
cornice.Parent = screenGui

local titolo = Instance.new("TextLabel")
titolo.Name = "Titolo"
titolo.Size = UDim2.fromScale(1, 0.2)
titolo.BackgroundTransparency = 1
titolo.TextColor3 = Color3.fromRGB(255, 255, 255)
titolo.TextScaled = true
titolo.Font = Enum.Font.GothamBold
titolo.Text = "GUARDAROBA — clicca un outfit per vestirti"
titolo.Parent = cornice

local contenitore = Instance.new("Frame")
contenitore.Name = "Contenitore"
contenitore.Size = UDim2.fromScale(1, 0.8)
contenitore.Position = UDim2.fromScale(0, 0.2)
contenitore.BackgroundTransparency = 1
contenitore.Parent = cornice

local griglia = Instance.new("UIGridLayout")
griglia.CellSize = UDim2.fromScale(0.158, 0.42)
griglia.CellPadding = UDim2.fromScale(0.008, 0.06)
griglia.SortOrder = Enum.SortOrder.LayoutOrder
griglia.Parent = contenitore

for indice, outfit in Outfits do
	local bottone = Instance.new("TextButton")
	bottone.Name = outfit.nome
	bottone.LayoutOrder = indice
	bottone.BackgroundColor3 = outfit.torso
	bottone.TextColor3 = Color3.fromRGB(255, 255, 255)
	bottone.TextStrokeTransparency = 0.2
	bottone.TextScaled = true
	bottone.Font = Enum.Font.GothamBold
	bottone.Text = outfit.nome
	bottone.Parent = contenitore
	bottone.Activated:Connect(function()
		outfitScelto:FireServer(indice)
		titolo.Text = `Indossi "{outfit.nome}" — puoi ancora cambiare`
	end)
end

phaseChanged.OnClientEvent:Connect(function(fase: string, dettagli: { [string]: any })
	local sonoCercatore = dettagli.cercatore == player.Name
	local mostra = fase == Fasi.Nascondiglio and not sonoCercatore
	if mostra and not screenGui.Enabled then
		titolo.Text = "GUARDAROBA — clicca un outfit per vestirti"
	end
	screenGui.Enabled = mostra
end)

return true
