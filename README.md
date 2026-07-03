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

## Il gioco

Un mash-up in stile MECCHA CHAMELEON: **Dress to Impress × nascondino**,
titolo di lavoro *MANNEQUIN PANIC*. Ricerca, proposta e piano di lavoro in
**[docs/CONCEPT.md](docs/CONCEPT.md)**.

In `src/` c'è già lo skeleton funzionante del ciclo di gioco (lobby →
nascondiglio → caccia → risultati): compila, sincronizza e gira in Studio
con 2+ giocatori di test.

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
