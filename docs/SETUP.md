# Ambiente di sviluppo Roblox — guida da zero

Guida per chi non ha mai programmato. Spiega cosa serve, cosa fa ogni
pezzo e come mettersi al lavoro.

## Le basi in 60 secondi

- I giochi Roblox si chiamano **experience** e girano sui server di Roblox.
- Si costruiscono con **Roblox Studio**, l'editor ufficiale gratuito
  (**solo Windows e macOS** — non esiste per Linux).
- Il linguaggio di programmazione è **Luau**: un dialetto di Lua creato da
  Roblox, semplice da leggere, con i tipi opzionali. È l'unico linguaggio
  supportato, quindi la scelta è già fatta.
- Pubblicare è gratis: da Studio, `File → Publish to Roblox`. I soldi veri
  (Robux) arrivano da pass e acquisti in-game.

## Due modi di lavorare

1. **Solo Studio** (per iniziare): scrivi gli script dentro l'editor di
   Studio. Zero setup, ma niente Git, niente code review, niente Claude.
2. **Repo + Rojo** (quello configurato qui): il codice vive in questo
   repository come normali file `.luau`; **Rojo** lo sincronizza dentro
   Studio in tempo reale. Così il codice è versionato con Git e Claude può
   lavorarci come su qualsiasi progetto software.

Questo repo usa il modo 2, che è lo standard dei team professionali.

## Cosa installare sul TUO computer

| Cosa | A cosa serve | Dove |
|---|---|---|
| Account Roblox | pubblicare il gioco | [roblox.com](https://www.roblox.com) |
| Roblox Studio | l'editor del gioco | [create.roblox.com](https://create.roblox.com) |
| Git | versionare il codice | [git-scm.com](https://git-scm.com) |
| VS Code | scrivere il codice | [code.visualstudio.com](https://code.visualstudio.com) |
| Rokit | installa i tool qui sotto | [github.com/rojo-rbx/rokit](https://github.com/rojo-rbx/rokit) |

Rokit legge `rokit.toml` e installa da solo, alle versioni giuste:

| Tool | Ruolo |
|---|---|
| **Rojo** | sincronizza i file del repo con Roblox Studio |
| **Wally** | gestore di pacchetti (librerie di terzi), come npm/pip |
| **Selene** | linter: trova errori e API deprecate prima di eseguire |
| **StyLua** | formattatore automatico del codice |

In VS Code, all'apertura della cartella, accetta le **estensioni
consigliate** (`.vscode/extensions.json`): tra queste `luau-lsp`, che dà
autocompletamento e controllo dei tipi su tutte le API Roblox.

## Primi passi

```bash
git clone <questo-repo>
cd prova
rokit install        # installa rojo, wally, selene, stylua
make build           # crea build/Prova.rbxlx
```

1. Apri `build/Prova.rbxlx` con Roblox Studio.
2. In Studio installa il plugin Rojo (te lo propone l'estensione VS Code,
   oppure da [rojo.space](https://rojo.space)).
3. Nel terminale: `make serve`. In Studio: pannello Rojo → **Connect**.
4. Da questo momento ogni salvataggio in VS Code appare subito in Studio.
5. Per provare il gioco: in Studio `Test → Clients and Servers → 2 players`
   (il nascondino ha bisogno di almeno 2 giocatori).

## Comandi del repo

`make help` mostra tutto. I principali:

| Comando | Effetto |
|---|---|
| `make build` | compila il place file `build/Prova.rbxlx` |
| `make serve` | avvia la sincronizzazione con Studio |
| `make fmt` | formatta il codice |
| `make check` | formattazione + lint, da lanciare prima di ogni commit |

Su macchine senza Rokit (container, CI) c'è un fallback: `npm install`
mette a disposizione `rojo` e `stylua` via npx, e il Makefile li trova da solo.

## Struttura del repo

```
prova/
├── default.project.json   # mappa: quale cartella va dove dentro Roblox
├── rokit.toml             # versioni dei tool
├── wally.toml             # dipendenze (per ora nessuna)
├── selene.toml            # config linter
├── stylua.toml            # config formattatore
├── .luaurc                # Luau in modalità strict (tipi controllati)
├── src/
│   ├── server/            # → ServerScriptService (gira SOLO sul server)
│   ├── client/            # → StarterPlayerScripts (gira su ogni giocatore)
│   └── shared/            # → ReplicatedStorage (visibile a entrambi)
├── docs/                  # questa guida + concept del gioco
└── build/                 # artefatti generati (fuori da Git)
```

La divisione server/client/shared è IL concetto chiave di Roblox:

- il **server** è l'autorità: decide punteggi, catture, fasi del round.
  Mai fidarsi del client (i cheater esistono anche su Roblox);
- il **client** mostra UI ed effetti e invia gli input;
- parlano tra loro con i **RemoteEvent** (vedi `src/server/init.server.luau`).

## Glossario minimo

- **Place**: un "livello"/mondo; un'experience ne contiene uno o più.
- **Instance**: ogni oggetto nel gioco (una Part, una GUI, un suono).
- **DataStore**: il database di Roblox per salvare i progressi dei giocatori.
- **Robux**: la valuta; si guadagna con Game Pass e Developer Products.
- **Sourcemap**: file che dice a luau-lsp come i file del repo diventano
  oggetti Roblox (`make sourcemap` la rigenera).
