--!strict
-- Configurazione condivisa tra server e client.
-- Tutti i numeri "magici" del gioco vivono qui: cambiarli non richiede
-- di toccare la logica.

export type Config = {
	MinGiocatori: number,
	DurataLobby: number,
	DurataNascondiglio: number,
	DurataCaccia: number,
	DurataRisultati: number,
	NumManichiniNpc: number,
	AccuseExtra: number,
	RaggioAccusa: number,
	PuntiCattura: number,
	PuntiSopravvivenza: number,
	PuntiVotoStile: number,
}

local GameConfig: Config = {
	-- Giocatori minimi per far partire un round.
	MinGiocatori = 2,

	-- Durate delle fasi, in secondi.
	DurataLobby = 15,
	DurataNascondiglio = 40,
	DurataCaccia = 120,
	DurataRisultati = 25,

	-- Manichini NPC spawnati nell'arena, tra cui i nascosti si mimetizzano.
	NumManichiniNpc = 15,

	-- Il cercatore ha (numero di nascosti + AccuseExtra) accuse.
	AccuseExtra = 2,

	-- Distanza massima in studs per accusare un manichino.
	RaggioAccusa = 30,

	-- Punteggi.
	PuntiCattura = 10, -- al cercatore, per ogni nascosto catturato
	PuntiSopravvivenza = 15, -- a ogni nascosto vivo a fine round
	PuntiVotoStile = 20, -- al sopravvissuto più votato per stile
}

return GameConfig
