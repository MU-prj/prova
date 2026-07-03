--!strict
-- Costruisce la mappa via codice: arena con pedane, lobby con spawn e
-- cella del cercatore. Niente oggetti piazzati a mano in Studio, così il
-- place file si rigenera sempre da zero con `rojo build`.

local Workspace = game:GetService("Workspace")

local MapService = {}

local CENTRO_ARENA = Vector3.new(0, 0, 0)
local CENTRO_LOBBY = Vector3.new(0, 0, -220)
local CENTRO_CELLA = Vector3.new(180, 0, 0)

local LATO_ARENA = 120
local ALTEZZA_MURI = 24

-- Posizioni (sommità delle pedane) calcolate durante la costruzione.
local cimePedane: { Vector3 } = {}

local function creaParte(
	nome: string,
	dimensioni: Vector3,
	cframe: CFrame,
	colore: Color3,
	materiale: Enum.Material,
	genitore: Instance
): Part
	local parte = Instance.new("Part")
	parte.Name = nome
	parte.Size = dimensioni
	parte.CFrame = cframe
	parte.Color = colore
	parte.Material = materiale
	parte.Anchored = true
	parte.Parent = genitore
	return parte
end

local function costruisciStanza(
	modello: Model,
	nome: string,
	centro: Vector3,
	lato: number,
	colorePavimento: Color3
)
	creaParte(
		nome .. "Pavimento",
		Vector3.new(lato, 1, lato),
		CFrame.new(centro + Vector3.new(0, -0.5, 0)),
		colorePavimento,
		Enum.Material.SmoothPlastic,
		modello
	)

	local mezzoLato = lato / 2
	local coloreMuri = Color3.fromRGB(200, 200, 205)
	for _, offset in
		{
			Vector3.new(0, 0, mezzoLato),
			Vector3.new(0, 0, -mezzoLato),
			Vector3.new(mezzoLato, 0, 0),
			Vector3.new(-mezzoLato, 0, 0),
		}
	do
		local lungoX = offset.Z ~= 0
		creaParte(
			nome .. "Muro",
			Vector3.new(lungoX and lato or 1, ALTEZZA_MURI, lungoX and 1 or lato),
			CFrame.new(centro + offset + Vector3.new(0, ALTEZZA_MURI / 2, 0)),
			coloreMuri,
			Enum.Material.SmoothPlastic,
			modello
		)
	end
end

local function costruisciPedane(modello: Model)
	-- Griglia di pedane su cui mettersi in posa, con qualche buco per
	-- non renderla troppo regolare.
	local rng = Random.new(20260703)
	local passo = 18
	for riga = -2, 2 do
		for colonna = -2, 2 do
			if rng:NextNumber() < 0.2 then
				continue
			end
			local centro = CENTRO_ARENA
				+ Vector3.new(
					riga * passo + rng:NextNumber(-3, 3),
					1,
					colonna * passo + rng:NextNumber(-3, 3)
				)
			creaParte(
				"Pedana",
				Vector3.new(5, 2, 5),
				CFrame.new(centro),
				Color3.fromRGB(120, 120, 125),
				Enum.Material.Marble,
				modello
			)
			table.insert(cimePedane, centro + Vector3.new(0, 1, 0))
		end
	end
end

function MapService.costruisci()
	local modello = Instance.new("Model")
	modello.Name = "Mappa"

	costruisciStanza(modello, "Arena", CENTRO_ARENA, LATO_ARENA, Color3.fromRGB(234, 234, 236))
	costruisciStanza(modello, "Lobby", CENTRO_LOBBY, 60, Color3.fromRGB(160, 200, 160))
	costruisciStanza(modello, "Cella", CENTRO_CELLA, 24, Color3.fromRGB(90, 90, 95))

	-- Tetto sulla cella: il cercatore non deve sbirciare l'arena.
	creaParte(
		"CellaTetto",
		Vector3.new(24, 1, 24),
		CFrame.new(CENTRO_CELLA + Vector3.new(0, ALTEZZA_MURI, 0)),
		Color3.fromRGB(90, 90, 95),
		Enum.Material.SmoothPlastic,
		modello
	)

	costruisciPedane(modello)

	-- Lo spawn di default: si nasce (e si rinasce) in lobby.
	local spawnLobby = Instance.new("SpawnLocation")
	spawnLobby.Name = "SpawnLobby"
	spawnLobby.Size = Vector3.new(10, 1, 10)
	spawnLobby.CFrame = CFrame.new(CENTRO_LOBBY + Vector3.new(0, 0.5, 0))
	spawnLobby.Anchored = true
	spawnLobby.Neutral = true
	spawnLobby.Duration = 0
	spawnLobby.Color = Color3.fromRGB(100, 160, 100)
	spawnLobby.Parent = modello

	modello.Parent = Workspace
end

-- Punti di teleport: leggermente sollevati per non incastrarsi nel pavimento.
function MapService.puntoArena(): CFrame
	return CFrame.new(CENTRO_ARENA + Vector3.new(0, 4, LATO_ARENA / 2 - 8))
end

function MapService.puntoCella(): CFrame
	return CFrame.new(CENTRO_CELLA + Vector3.new(0, 4, 0))
end

function MapService.puntoLobby(): CFrame
	return CFrame.new(CENTRO_LOBBY + Vector3.new(0, 4, 0))
end

function MapService.cimePedaneCasuali(quante: number): { Vector3 }
	local copia = table.clone(cimePedane)
	local rng = Random.new()
	local scelte: { Vector3 } = {}
	for _ = 1, math.min(quante, #copia) do
		local indice = rng:NextInteger(1, #copia)
		table.insert(scelte, copia[indice])
		table.remove(copia, indice)
	end
	return scelte
end

return MapService
