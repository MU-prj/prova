--!strict
-- Banner di fase: dove siamo nel round, countdown e istruzioni per il
-- proprio ruolo, più i toast con l'esito delle accuse.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fasi = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Fasi"))
local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local phaseChanged = Remotes.get("PhaseChanged")
local accusaEsito = Remotes.get("AccusaEsito")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ManichiniHud"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local banner = Instance.new("TextLabel")
banner.Name = "Banner"
banner.Size = UDim2.fromScale(0.6, 0.07)
banner.Position = UDim2.fromScale(0.2, 0.02)
banner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
banner.BackgroundTransparency = 0.3
banner.TextColor3 = Color3.fromRGB(255, 255, 255)
banner.TextScaled = true
banner.Font = Enum.Font.GothamBold
banner.Text = "MANICHINI PAZZI"
banner.Parent = screenGui

local sottotitolo = Instance.new("TextLabel")
sottotitolo.Name = "Sottotitolo"
sottotitolo.Size = UDim2.fromScale(0.5, 0.04)
sottotitolo.Position = UDim2.fromScale(0.25, 0.095)
sottotitolo.BackgroundTransparency = 1
sottotitolo.TextColor3 = Color3.fromRGB(235, 235, 235)
sottotitolo.TextStrokeTransparency = 0.5
sottotitolo.TextScaled = true
sottotitolo.Font = Enum.Font.Gotham
sottotitolo.Text = ""
sottotitolo.Parent = screenGui

local toast = Instance.new("TextLabel")
toast.Name = "Toast"
toast.Size = UDim2.fromScale(0.4, 0.06)
toast.Position = UDim2.fromScale(0.3, 0.72)
toast.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
toast.BackgroundTransparency = 0.2
toast.TextColor3 = Color3.fromRGB(255, 255, 255)
toast.TextScaled = true
toast.Font = Enum.Font.GothamBold
toast.Visible = false
toast.Parent = screenGui

local function testiPerFase(fase: string, dettagli: { [string]: any }): (string, string)
	local sonoCercatore = dettagli.cercatore == player.Name
	if fase == Fasi.Attesa then
		return "In attesa di giocatori...", ""
	elseif fase == Fasi.Lobby then
		return "Il round sta per iniziare", "Un giocatore a caso sarà il cercatore"
	elseif fase == Fasi.Nascondiglio then
		if sonoCercatore then
			return "Sei il CERCATORE", "Aspetta in cella: i manichini si stanno preparando"
		end
		return "Nasconditi!", "Scegli un outfit e mettiti in posa tra i manichini"
	elseif fase == Fasi.Caccia then
		if sonoCercatore then
			return "A caccia!", `Clicca il manichino sospetto — accuse rimaste: {dettagli.accuse}`
		end
		return "Il cercatore è in arena", "Sei un manichino: non muoverti"
	elseif fase == Fasi.Risultati then
		if dettagli.vincitore == "nascosti" then
			return "Vincono i manichini!", "Vota il sopravvissuto con lo stile migliore"
		end
		return "Vince il cercatore!", "Nessun manichino è sopravvissuto"
	end
	return fase, ""
end

phaseChanged.OnClientEvent:Connect(function(fase: string, dettagli: { [string]: any })
	if dettagli.migliorStile ~= nil then
		banner.Text = `Premio stile a {dettagli.migliorStile}!`
		sottotitolo.Text = "Il manichino meglio vestito del round"
		return
	end

	local principale, secondario = testiPerFase(fase, dettagli)
	if dettagli.tempoRimanente ~= nil then
		principale = `{principale} — {dettagli.tempoRimanente}s`
	end
	banner.Text = principale
	sottotitolo.Text = secondario
end)

local generazioneToast = 0
accusaEsito.OnClientEvent:Connect(function(tipo: string, nome: string?, accuse: number?)
	if tipo == "cattura" then
		toast.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
		toast.Text = `{nome} è stato scoperto!`
	else
		toast.BackgroundColor3 = Color3.fromRGB(30, 90, 120)
		toast.Text = `Era un manichino innocente! Accuse rimaste: {accuse}`
	end
	toast.Visible = true

	generazioneToast += 1
	local generazione = generazioneToast
	task.delay(3, function()
		if generazione == generazioneToast then
			toast.Visible = false
		end
	end)
end)

return true
