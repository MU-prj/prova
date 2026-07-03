# Concept: che gioco facciamo?

Ricerca del 2026-07-03. Obiettivo: trovare un mash-up di due giochi noti
che possa funzionare su Roblox, sul modello di MECCHA CHAMELEON.

## Il caso MECCHA CHAMELEON

- Uscito su Steam il 9 giugno 2026, sviluppatore giapponese solo
  (lemorion_1224). Nascondino + pittura: i nascosti hanno il corpo bianco
  e si dipingono per mimetizzarsi nella mappa; i cercatori cercano
  qualunque cosa sembri "fuori posto".
- **10 milioni di copie in 16 giorni**, picco di ~340.000 giocatori
  simultanei, **zero spesa in pubblicità**: è esploso via clip virali e
  streamer, come Among Us.
- Su Roblox sono già comparsi i cloni: *Paint to Hide*, *Paint and Hide*,
  *Chameleon!*.

### Perché la formula funziona

1. **Due meccaniche che tutti già conoscono** (nascondino + disegnare):
   zero tutorial, chiunque capisce il gioco in 5 secondi di clip.
2. **Ogni round produce contenuto**: il travestimento riuscito male/bene È
   la clip. Il gioco si pubblicizza da solo su TikTok/YouTube.
3. **Creatività dentro una competizione**: non vince chi mira meglio, ma
   chi ha l'idea più furba. Accessibile a bambini, divertente per streamer.

## La mappa dei top Roblox (metà 2026)

| Gioco | Loop | Perché è grande |
|---|---|---|
| Grow a Garden | pianta/raccogli, anche offline | progressione rilassata, record storici di CCU |
| Steal a Brainrot | compra/ruba ai vicini | meme + furto sociale (picco storico 25,8M CCU) |
| Brookhaven RP | roleplay libero | casa/ruoli, social puro |
| Adopt Me | cura e scambio pet | collezionismo + trading |
| Dress to Impress | vestiti a tema, poi votazione | creatività + giuria sociale, virale tra streamer |
| Doors / Rainbow Friends | horror a round | tensione clippabile |
| Blox Fruits | RPG anime grind | progressione infinita |

Tendenza chiara: vincono i giochi **sociali, a round brevi, clippabili**,
dove la creatività del giocatore genera il contenuto.

## Proposta principale: «MANNEQUIN PANIC» (titolo di lavoro)

**Dress to Impress × Nascondino.**

- I nascosti hanno 60 secondi per **vestirsi** pescando da un guardaroba a
  tema (es. "museo delle statue", "negozio anni '80", "casa stregata") e
  poi **congelarsi in posa** in mezzo a decine di manichini NPC vestiti in
  modo simile.
- Il cercatore entra e ha N accuse: tocca un manichino e, se è un
  giocatore, lo cattura; se è un NPC, perde un'accusa (e tutti ridono).
- Twist alla Dress to Impress: a fine round i sopravvissuti vengono
  **votati per stile**. Si vince in due modi: sopravvivere O essere
  bellissimi. Doppio incentivo, doppia clip.

### Perché può spaccare

- Stessa formula MECCHA: due meccaniche universali, zero tutorial, ogni
  round genera una clip (l'outfit assurdo che non viene scoperto, l'accusa
  sbagliata sull'NPC).
- Pesca dal pubblico di Dress to Impress (top 10 stabile) e dei nascondino,
  che su Roblox sono generi enormi.
- Il clone diretto di MECCHA su Roblox è **già occupato** (*Paint to
  Hide* ecc.): copiare adesso significa arrivare terzi. Meglio la stessa
  formula con ingredienti diversi.
- Monetizzazione naturale e non pay-to-win: guardaroba cosmetici, pose,
  emote da manichino.

### Rischi

- La pittura libera di MECCHA è più espressiva del vestirsi da catalogo:
  serve un guardaroba abbastanza ricco da far sentire furbi.
- Il rilevamento "tocco = accusa" va bilanciato (accuse limitate, cooldown).

## Alternative considerate

- **«GIARDINO IMPOSTORE»** — Grow a Garden × Among Us: in un orto
  condiviso una "erbaccia" travestita da pianta sabota il raccolto; i
  contadini devono scovarla. Forte richiamo al gioco n.1, ma la social
  deduction è difficile da bilanciare per un primo progetto.
- **«DISEGNA E SCAPPA»** — Gartic × obby: un compagno disegna in tempo
  reale le piattaforme su cui i runner scappano dal cercatore. Bella idea,
  ma il "disegno che diventa geometria" è tecnicamente il pezzo più
  rischioso: non adatto al primo giorno.

**Raccomandazione: MANNEQUIN PANIC.** Massimo rapporto tra potenziale
virale e fattibilità: è un nascondino a round (facile) + avatar dressing
(API native di Roblox: `HumanoidDescription`) + votazione (una GUI).

## Cosa si fa in un giorno di Claude Fable

Con l'ambiente di questo repo già pronto, in una giornata di lavoro
insieme è realistico arrivare a un **prototipo giocabile e pubblicato**:

| Fascia | Obiettivo |
|---|---|
| Ora 1–2 | ciclo di round completo (già impostato in `src/`), teleport lobby↔arena, squadre cercatore/nascosti |
| Ora 3–4 | meccanica manichino: congelamento in posa, spawn degli NPC manichini, guardaroba base (10–15 outfit) |
| Ora 5–6 | accuse del cercatore (tocco, limite, cooldown), condizioni di vittoria, punteggi |
| Ora 7 | votazione stile a fine round, classifica della sessione |
| Ora 8 | UI/suoni/polish, test multi-client in Studio, pubblicazione della prima versione privata |

Fuori portata in un giorno (e va bene così): mappe multiple rifinite,
salvataggio progressi su DataStore, monetizzazione, bilanciamento serio —
sono le settimane 2 e 3, guidate dai dati dei primi playtest.

Nota pratica: Claude lavora su tutto il codice Luau, la logica di gioco,
le GUI e la struttura del progetto da questo repo; servono mani umane su
Roblox Studio (Windows/macOS) per il playtest multi-client e per il
click su "Publish".

## Fonti

- [MECCHA CHAMELEON su Steam](https://store.steampowered.com/app/4704690/MECCHA_CHAMELEON/)
- [Meccha Chameleon — Wikipedia](https://en.wikipedia.org/wiki/Meccha_Chameleon)
- [10 milioni di copie in 16 giorni — GosuGamers](https://www.gosugamers.net/entertainment/news/78702-viral-indie-hit-meccha-chameleon-reaches-10-million-sales-in-just-16-days)
- [3M vendite in una settimana, dev solo — TechTimes](https://www.techtimes.com/articles/318581/20260617/meccha-chameleon-hits-3-million-steam-sales-solo-dev-tops-charts-one-week.htm)
- [Picco giocatori — activeplayer.io](https://activeplayer.io/meccha-chameleon-244k-players-3-million-steam-sales/)
- [GamingOnLinux sul fenomeno](https://www.gamingonlinux.com/2026/06/meccha-chameleon-is-a-hide-and-seek-body-painting-game-taking-over-steam/)
- [Paint to Hide su Roblox](https://www.roblox.com/games/72876380181807/Paint-to-Hide)
- [Classifiche Roblox 2026 — StudioKrew](https://studiokrew.com/blog/top-roblox-games-may-2026/)
- [Statista: giochi Roblox più visitati](https://www.statista.com/statistics/1220905/roblox-most-visited-games/)
- [rotrends.com](https://rotrends.com/top-roblox-games)
