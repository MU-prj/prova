--!strict
-- Punteggi in leaderstats: la classifica nativa che Roblox mostra
-- nella lista giocatori.

local Players = game:GetService("Players")

local ScoreService = {}

local function assicuraPunti(player: Player): IntValue
	local stats = player:FindFirstChild("leaderstats")
	if stats == nil then
		local cartella = Instance.new("Folder")
		cartella.Name = "leaderstats"
		cartella.Parent = player
		stats = cartella
	end

	local punti = stats:FindFirstChild("Punti")
	if punti ~= nil and punti:IsA("IntValue") then
		return punti
	end
	local nuovo = Instance.new("IntValue")
	nuovo.Name = "Punti"
	nuovo.Parent = stats
	return nuovo
end

function ScoreService.init()
	Players.PlayerAdded:Connect(function(player: Player)
		assicuraPunti(player)
	end)
	for _, player in Players:GetPlayers() do
		assicuraPunti(player)
	end
end

function ScoreService.aggiungi(player: Player, punti: number)
	local valore = assicuraPunti(player)
	valore.Value += punti
end

return ScoreService
