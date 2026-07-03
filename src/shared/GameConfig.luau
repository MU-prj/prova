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
}

local GameConfig: Config = {
	-- Giocatori minimi per far partire un round.
	MinGiocatori = 2,

	-- Durate delle fasi, in secondi.
	DurataLobby = 15,
	DurataNascondiglio = 30,
	DurataCaccia = 120,
	DurataRisultati = 10,
}

return GameConfig
