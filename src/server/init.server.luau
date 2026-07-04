--!strict
-- Bootstrap del server: costruisce la mappa, prepara i punteggi e avvia
-- il ciclo dei round di MANICHINI PAZZI.

local MapService = require(script.MapService)
local ScoreService = require(script.ScoreService)
local RoundService = require(script.RoundService)

MapService.costruisci()
ScoreService.init()
RoundService.avvia()
