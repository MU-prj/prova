# Piano: prototipo MANICHINI PAZZI

Branch: `claude/roblox-dev-setup-b7utv1`. Concept in
[../CONCEPT.md](../CONCEPT.md) (ex "Mannequin Panic", ribattezzato
MANICHINI PAZZI).

## Obiettivo

Prototipo giocabile del mash-up Dress to Impress × nascondino: i nascosti
si vestono e si congelano tra manichini NPC identici a loro; il cercatore
ha accuse limitate; i sopravvissuti vengono votati per stile.

## Slice (in ordine)

1. **CI/CD** — GitHub Actions: StyLua `--check`, selene, build Rojo con
   place file come artifact. Ogni push sulla PR dice se il progetto
   "funziona" (compila e passa l'analisi statica).
2. **Mappa procedurale** (`MapService`) — arena con pedane, lobby con
   SpawnLocation, cella del cercatore. Tutto generato da codice: nessun
   oggetto piazzato a mano in Studio.
3. **Travestimenti e manichini** (`DisguiseService`, `Outfits`) — outfit a
   colori applicati via `HumanoidDescription` sia ai giocatori sia agli
   NPC creati con `CreateHumanoidModelFromDescription`, così sono
   indistinguibili. Congelamento: anchor lato server + stop animazioni
   lato client.
4. **Round completo** (`RoundService`) — teleport, scelta cercatore,
   accuse con raggio e limite, cattura (KO teatrale dell'NPC innocente),
   condizioni di vittoria, punteggi in leaderstats (`ScoreService`).
5. **Voto di stile** — durante i Risultati i giocatori votano il
   sopravvissuto meglio vestito; bonus punti al vincitore.
6. **UI client** — banner fase/timer/ruolo, guardaroba, mirino accusa,
   scheda di voto.

## Fuori scope (prossime iterazioni)

Mappe a tema, pose multiple, DataStore per punteggi persistenti,
monetizzazione, suoni, bilanciamento dai playtest.

## Verifica

- CI verde sulla PR (build + lint + formattazione).
- Playtest umano in Studio: `Test → Clients and Servers → 2+ players`
  (unica cosa che la CI non può coprire: Roblox non gira su Linux).
