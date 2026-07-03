--!strict
-- Punto unico per i RemoteEvent: il server li crea, il client li aspetta.
-- Così nessuno dei due dipende da oggetti piazzati a mano in Studio.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NOME_CARTELLA = "Remotes"

-- Eventi usati dal gioco:
--   PhaseChanged  S->C  fase corrente e dettagli (timer, cercatore, ...)
--   OutfitScelto  C->S  il nascosto sceglie un outfit dal guardaroba
--   Accusa        C->S  il cercatore accusa un modello
--   AccusaEsito   S->C  esito di un'accusa, per UI ed effetti
--   Congelamento  S->C  congela/scongela il personaggio locale
--   VotaStile     C->S  voto per il sopravvissuto meglio vestito

local Remotes = {}

local function cartellaServer(): Folder
	local esistente = ReplicatedStorage:FindFirstChild(NOME_CARTELLA)
	if esistente ~= nil and esistente:IsA("Folder") then
		return esistente
	end
	local nuova = Instance.new("Folder")
	nuova.Name = NOME_CARTELLA
	nuova.Parent = ReplicatedStorage
	return nuova
end

function Remotes.get(nome: string): RemoteEvent
	if RunService:IsServer() then
		local cartella = cartellaServer()
		local esistente = cartella:FindFirstChild(nome)
		if esistente ~= nil and esistente:IsA("RemoteEvent") then
			return esistente
		end
		local nuovo = Instance.new("RemoteEvent")
		nuovo.Name = nome
		nuovo.Parent = cartella
		return nuovo
	end

	local cartella = ReplicatedStorage:WaitForChild(NOME_CARTELLA)
	return cartella:WaitForChild(nome) :: RemoteEvent
end

return Remotes
