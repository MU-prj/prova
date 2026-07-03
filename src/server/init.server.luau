--!strict
-- Punto di ingresso del server: il ciclo di gioco.
--
--   Attesa -> Lobby -> Nascondiglio -> Caccia -> Risultati -> (di nuovo Lobby)
--
-- Questo skeleton funziona già: aprilo in Studio con Rojo, avvia un test
-- con 2+ giocatori (Test > Clients and Servers) e vedrai le fasi alternarsi.
-- La meccanica vera del gioco (travestimenti, cattura...) si innesta qui.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.GameConfig)
local Fasi = require(ReplicatedStorage.Shared.Fasi)

-- RemoteEvent con cui il server annuncia ai client la fase corrente.
-- Creato dal server così il progetto non dipende da oggetti piazzati a mano in Studio.
local phaseEvent = Instance.new("RemoteEvent")
phaseEvent.Name = "PhaseChanged"
phaseEvent.Parent = ReplicatedStorage

local function broadcast(fase: Fasi.Fase, dettagli: { [string]: any }?)
	phaseEvent:FireAllClients(fase, dettagli or {})
end

-- I nuovi arrivati devono sapere subito in che fase siamo.
local faseCorrente: Fasi.Fase = Fasi.Attesa
Players.PlayerAdded:Connect(function(player: Player)
	phaseEvent:FireClient(player, faseCorrente, {})
end)

local function cambiaFase(fase: Fasi.Fase, dettagli: { [string]: any }?)
	faseCorrente = fase
	broadcast(fase, dettagli)
	print(`[GameLoop] Fase: {fase}`)
end

-- Conto alla rovescia che tiene aggiornati i client secondo per secondo.
local function countdown(secondi: number, fase: Fasi.Fase)
	for rimanenti = secondi, 1, -1 do
		broadcast(fase, { tempoRimanente = rimanenti })
		task.wait(1)
	end
end

local function attendiGiocatori()
	cambiaFase(Fasi.Attesa, { necessari = GameConfig.MinGiocatori })
	while #Players:GetPlayers() < GameConfig.MinGiocatori do
		task.wait(1)
	end
end

local function scegliCercatore(): Player?
	local giocatori = Players:GetPlayers()
	if #giocatori == 0 then
		return nil
	end
	return giocatori[math.random(#giocatori)]
end

-- Il ciclo infinito del gioco.
while true do
	attendiGiocatori()

	cambiaFase(Fasi.Lobby)
	countdown(GameConfig.DurataLobby, Fasi.Lobby)

	local cercatore = scegliCercatore()
	if cercatore == nil then
		-- Tutti usciti durante la lobby: si torna ad aspettare.
		continue
	end

	cambiaFase(Fasi.Nascondiglio, { cercatore = cercatore.Name })
	countdown(GameConfig.DurataNascondiglio, Fasi.Nascondiglio)

	cambiaFase(Fasi.Caccia, { cercatore = cercatore.Name })
	countdown(GameConfig.DurataCaccia, Fasi.Caccia)

	cambiaFase(Fasi.Risultati)
	countdown(GameConfig.DurataRisultati, Fasi.Risultati)
end
