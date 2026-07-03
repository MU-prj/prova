--!strict
-- Il cuore di MANICHINI PAZZI: round, squadre, accuse, voti e punteggi.
--
--   Attesa -> Lobby -> Nascondiglio -> Caccia -> Risultati -> (di nuovo)
--
-- Il server è l'unica autorità: i client mandano solo input (outfit,
-- accuse, voti) che vengono validati qui.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.GameConfig)
local Fasi = require(ReplicatedStorage.Shared.Fasi)
local Outfits = require(ReplicatedStorage.Shared.Outfits)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local DisguiseService = require(script.Parent.DisguiseService)
local MapService = require(script.Parent.MapService)
local ScoreService = require(script.Parent.ScoreService)

local RoundService = {}

local phaseChanged = Remotes.get("PhaseChanged")
local outfitScelto = Remotes.get("OutfitScelto")
local accusa = Remotes.get("Accusa")
local accusaEsito = Remotes.get("AccusaEsito")
local votaStile = Remotes.get("VotaStile")

type Dettagli = { [string]: any }

local faseCorrente: string = Fasi.Attesa
local dettagliCorrenti: Dettagli = {}
local cercatoreCorrente: Player? = nil
local nascostiVivi: { [Player]: boolean } = {}
local sopravvissutiRound: { [string]: Player } = {}
local votiRicevuti: { [Player]: Player } = {}
local accuseRimaste = 0
local ultimaAccusa = 0

local function broadcast(dettagli: Dettagli)
	phaseChanged:FireAllClients(faseCorrente, dettagli)
end

local function cambiaFase(fase: string, dettagli: Dettagli)
	faseCorrente = fase
	dettagliCorrenti = dettagli
	broadcast(dettagli)
	print(`[MANICHINI PAZZI] Fase: {fase}`)
end

local function countdown(secondi: number)
	for rimanenti = secondi, 1, -1 do
		dettagliCorrenti.tempoRimanente = rimanenti
		broadcast(dettagliCorrenti)
		task.wait(1)
	end
end

local function contaNascosti(): number
	local totale = 0
	for nascosto in nascostiVivi do
		if nascosto.Parent ~= nil then
			totale += 1
		end
	end
	return totale
end

local function teleporta(player: Player, destinazione: CFrame)
	local personaggio = player.Character
	if personaggio ~= nil then
		-- Piccolo offset casuale per non impilare i giocatori.
		local offset = CFrame.new(math.random(-4, 4), 0, math.random(-4, 4))
		personaggio:PivotTo(destinazione * offset)
	end
end

local function eliminaPersonaggio(player: Player)
	local personaggio = player.Character
	if personaggio == nil then
		return
	end
	local umanoide = personaggio:FindFirstChildOfClass("Humanoid")
	if umanoide ~= nil then
		umanoide.Health = 0
	end
end

local function gestisciAccusa(player: Player, bersaglio: unknown)
	if faseCorrente ~= Fasi.Caccia or player ~= cercatoreCorrente or accuseRimaste <= 0 then
		return
	end
	-- Debounce: un'accusa al secondo, niente click selvaggio.
	if os.clock() - ultimaAccusa < 1 then
		return
	end
	if typeof(bersaglio) ~= "Instance" then
		return
	end
	if not bersaglio:IsA("Model") then
		return
	end

	local personaggio = player.Character
	if personaggio == nil then
		return
	end
	local distanza = (personaggio:GetPivot().Position - bersaglio:GetPivot().Position).Magnitude
	if distanza > GameConfig.RaggioAccusa then
		return
	end

	local bersaglioGiocatore = Players:GetPlayerFromCharacter(bersaglio)
	if bersaglioGiocatore ~= nil and nascostiVivi[bersaglioGiocatore] == true then
		-- Beccato: era un giocatore travestito.
		ultimaAccusa = os.clock()
		nascostiVivi[bersaglioGiocatore] = nil
		ScoreService.aggiungi(player, GameConfig.PuntiCattura)
		accusaEsito:FireAllClients("cattura", bersaglioGiocatore.Name, accuseRimaste)
		DisguiseService.congela(bersaglioGiocatore, false)
		eliminaPersonaggio(bersaglioGiocatore)
	elseif DisguiseService.eManichinoNpc(bersaglio) then
		-- Figuraccia: era un manichino innocente.
		ultimaAccusa = os.clock()
		accuseRimaste -= 1
		DisguiseService.abbattiNpc(bersaglio)
		accusaEsito:FireAllClients("errore", nil, accuseRimaste)
	end
end

local function connettiEventi()
	outfitScelto.OnServerEvent:Connect(function(player: Player, indice: unknown)
		if faseCorrente ~= Fasi.Nascondiglio or nascostiVivi[player] ~= true then
			return
		end
		if typeof(indice) ~= "number" then
			return
		end
		local outfit = Outfits[indice]
		if outfit ~= nil then
			DisguiseService.applicaOutfit(player, outfit)
		end
	end)

	accusa.OnServerEvent:Connect(gestisciAccusa)

	votaStile.OnServerEvent:Connect(function(votante: Player, nome: unknown)
		if faseCorrente ~= Fasi.Risultati then
			return
		end
		if typeof(nome) ~= "string" then
			return
		end
		local votato = sopravvissutiRound[nome]
		if votato ~= nil and votato ~= votante then
			votiRicevuti[votante] = votato
		end
	end)

	-- I nuovi arrivati devono sapere subito in che fase siamo.
	Players.PlayerAdded:Connect(function(player: Player)
		phaseChanged:FireClient(player, faseCorrente, dettagliCorrenti)
	end)
end

local function faseCaccia(cercatore: Player)
	accuseRimaste = contaNascosti() + GameConfig.AccuseExtra
	cambiaFase(Fasi.Caccia, { cercatore = cercatore.Name, accuse = accuseRimaste })

	local scadenza = os.clock() + GameConfig.DurataCaccia
	while os.clock() < scadenza do
		if contaNascosti() == 0 or accuseRimaste <= 0 or cercatore.Parent == nil then
			break
		end
		dettagliCorrenti.tempoRimanente = math.ceil(scadenza - os.clock())
		dettagliCorrenti.accuse = accuseRimaste
		broadcast(dettagliCorrenti)
		task.wait(1)
	end
end

local function eseguiRound()
	cercatoreCorrente = nil
	nascostiVivi = {}
	sopravvissutiRound = {}
	votiRicevuti = {}

	cambiaFase(Fasi.Attesa, { necessari = GameConfig.MinGiocatori })
	while #Players:GetPlayers() < GameConfig.MinGiocatori do
		task.wait(1)
	end

	cambiaFase(Fasi.Lobby, {})
	countdown(GameConfig.DurataLobby)

	local giocatori = Players:GetPlayers()
	if #giocatori < GameConfig.MinGiocatori then
		-- Qualcuno è uscito durante la lobby: si torna ad aspettare.
		return
	end

	local cercatore = giocatori[math.random(#giocatori)]
	cercatoreCorrente = cercatore
	for _, giocatore in giocatori do
		if giocatore ~= cercatore then
			nascostiVivi[giocatore] = true
		end
	end

	-- Arena pronta: manichini sulle pedane, cercatore in cella, nascosti dentro.
	DisguiseService.spawnManichini(MapService.cimePedaneCasuali(GameConfig.NumManichiniNpc))
	teleporta(cercatore, MapService.puntoCella())
	for nascosto in nascostiVivi do
		teleporta(nascosto, MapService.puntoArena())
	end

	cambiaFase(Fasi.Nascondiglio, { cercatore = cercatore.Name })
	countdown(GameConfig.DurataNascondiglio)

	-- Si parte: nascosti congelati in posa, cercatore libero.
	for nascosto in nascostiVivi do
		DisguiseService.congela(nascosto, true)
	end
	teleporta(cercatore, MapService.puntoArena())
	faseCaccia(cercatore)

	-- Risultati: punti di sopravvivenza e voto di stile.
	local nomiSopravvissuti: { string } = {}
	for nascosto in nascostiVivi do
		if nascosto.Parent ~= nil then
			sopravvissutiRound[nascosto.Name] = nascosto
			table.insert(nomiSopravvissuti, nascosto.Name)
			ScoreService.aggiungi(nascosto, GameConfig.PuntiSopravvivenza)
		end
	end
	local vincitore = if #nomiSopravvissuti > 0 then "nascosti" else "cercatore"
	cambiaFase(Fasi.Risultati, { vincitore = vincitore, sopravvissuti = nomiSopravvissuti })
	countdown(GameConfig.DurataRisultati)

	-- Spoglio dei voti di stile.
	local migliore: Player? = nil
	local votiMigliore = 0
	local conteggi: { [Player]: number } = {}
	for _, votato in votiRicevuti do
		local nuovi = (conteggi[votato] or 0) + 1
		conteggi[votato] = nuovi
		if nuovi > votiMigliore then
			votiMigliore = nuovi
			migliore = votato
		end
	end
	if migliore ~= nil and migliore.Parent ~= nil then
		ScoreService.aggiungi(migliore, GameConfig.PuntiVotoStile)
		broadcast({ migliorStile = migliore.Name, voti = votiMigliore })
		task.wait(4)
	end

	-- Pulizia: via i manichini, tutti in lobby col proprio avatar.
	DisguiseService.rimuoviManichini()
	for _, giocatore in Players:GetPlayers() do
		DisguiseService.congela(giocatore, false)
		giocatore:LoadCharacter()
	end
end

function RoundService.avvia()
	connettiEventi()
	while true do
		eseguiRound()
	end
end

return RoundService
