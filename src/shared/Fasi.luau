--!strict
-- Le fasi del round, condivise tra server (che le decide)
-- e client (che le mostra a schermo).

local Fasi = {
	Attesa = "Attesa",
	Lobby = "Lobby",
	Nascondiglio = "Nascondiglio",
	Caccia = "Caccia",
	Risultati = "Risultati",
}

export type Fase = string

return Fasi
