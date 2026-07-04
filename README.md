# prova — progetto Roblox

Ambiente di sviluppo professionale per un gioco Roblox: codice Luau
versionato in Git e sincronizzato con Roblox Studio via Rojo.

## Partenza rapida

```bash
rokit install   # oppure: npm install (fallback senza Rokit)
make build      # genera build/Prova.rbxlx da aprire in Roblox Studio
make serve      # sincronizza il codice con Studio in tempo reale
make help       # tutti i comandi
```

Mai programmato? Parti da **[docs/SETUP.md](docs/SETUP.md)**: spiega da
zero cosa installare e come funziona tutto.

### Senza installare niente sul PC (container)

C'è un **Dev Container**: apri il repo in VS Code (*Reopen in Container*) o
in GitHub Codespaces e trovi già `rojo`, `stylua` e `selene` pronti — nessun
tool da installare sul tuo computer. Funziona `make build`, `make check` e
`make serve`. L'unica cosa che resta sul PC è **Roblox Studio** (serve solo
per giocare/testare): con `make serve` attivo, collega il plugin Rojo di
Studio a `localhost:34872`.

## Il gioco

**MANICHINI PAZZI** — un mash-up in stile MECCHA CHAMELEON:
**Dress to Impress × nascondino**. I nascosti si vestono e si congelano
in posa tra manichini NPC identici a loro; il cercatore ha accuse
limitate; chi sopravvive viene votato per stile. Ricerca e proposta in
**[docs/CONCEPT.md](docs/CONCEPT.md)**, piano di lavoro in
**[docs/plans/manichini-pazzi.md](docs/plans/manichini-pazzi.md)**.

In `src/` c'è il prototipo giocabile: mappa generata da codice, round
completo (lobby → nascondiglio → caccia → risultati), guardaroba,
accuse e voto di stile. Gira in Studio con 2+ giocatori di test.

## Struttura

```
src/server/   logica autoritativa (round, punteggi)     → ServerScriptService
src/client/   UI e input del giocatore                  → StarterPlayerScripts
src/shared/   configurazione e codice comune            → ReplicatedStorage
docs/         guida setup + concept del gioco
```

Toolchain: [Rojo](https://rojo.space) ·
[Wally](https://wally.run) ·
[Selene](https://kampfkarren.github.io/selene/) ·
[StyLua](https://github.com/JohnnyMorganz/StyLua) ·
[luau-lsp](https://github.com/JohnnyMorganz/luau-lsp) — versioni bloccate
in `rokit.toml`.
