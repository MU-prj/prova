--!strict
-- Punto di ingresso del client: mostra a schermo la fase corrente
-- e il conto alla rovescia che il server trasmette via RemoteEvent.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fasi = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Fasi"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Banner minimale in alto allo schermo.
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FaseBanner"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(0.5, 0.08)
label.Position = UDim2.fromScale(0.25, 0.02)
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "..."
label.Parent = screenGui

local testiFase: { [string]: string } = {
	[Fasi.Attesa] = "In attesa di altri giocatori...",
	[Fasi.Lobby] = "Il round sta per iniziare",
	[Fasi.Nascondiglio] = "Nasconditi!",
	[Fasi.Caccia] = "Il cercatore è a caccia!",
	[Fasi.Risultati] = "Risultati",
}

local phaseEvent = ReplicatedStorage:WaitForChild("PhaseChanged") :: RemoteEvent

phaseEvent.OnClientEvent:Connect(function(fase: string, dettagli: { [string]: any })
	local testo = testiFase[fase] or fase

	if dettagli.cercatore ~= nil then
		testo = `{testo} (cercatore: {dettagli.cercatore})`
	end
	if dettagli.tempoRimanente ~= nil then
		testo = `{testo} — {dettagli.tempoRimanente}s`
	end

	label.Text = testo
end)
