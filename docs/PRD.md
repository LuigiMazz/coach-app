# PRD MVP — Coach Exercise Manager
### Piattaforma gestione esercizi e programmi per professionisti sportivi

_Versione approfondita — deriva dal PRD iniziale + wireframe low-fi (`project/Wireframes.dc.html`, 17 schermate)._
_Stack confermato: **Flutter** (mobile + web), **Backend a scelta implementativa** → proposta: Supabase._

---

## 1. Informazioni prodotto

**Nome provvisorio:** Coach Exercise Manager (da validare — vedi note sotto)

**Vision**
Diventare lo strumento di riferimento con cui un professionista del movimento trasforma la propria conoscenza in un archivio strutturato, riutilizzabile e assegnabile.

**Mission MVP**
Permettere a un professionista singolo di creare una libreria privata di esercizi, arricchirla con video, costruire programmi, assegnarli e ricevere feedback — tutto in un unico posto, sostituendo Excel + WhatsApp + YouTube + Drive.

**Approfondimento — cosa aggiungiamo rispetto al PRD originale:**

- **Naming**: "Coach Exercise Manager" è descrittivo ma generico e lungo per un app store listing e per un logo mobile. Non è un blocco per l'MVP (si può shippare col nome provvisorio), ma va segnato come **decisione aperta** prima del lancio pubblico. Non la risolviamo ora — non impatta l'architettura.
- **Value prop unica in una frase**, da usare in onboarding/marketing: _"Il tuo archivio professionale di esercizi, pronto per creare programmi in pochi minuti."_ (già presente nel brief originale, la promuoviamo a headline ufficiale).
- **Non-goal esplicito da vision**: il prodotto non deve mai posizionarsi come sostituto della competenza del professionista (niente suggerimenti automatici di esercizi, niente "AI coach" — coerente col Fuori Scope §4).

---

## 2. Target utenti

**Persona primaria — Professionista**
| Sotto-categoria | Bisogno dominante | Implicazione prodotto |
|---|---|---|
| Personal Trainer | Programmi vari per clienti eterogenei | Libreria taggata per obiettivo, non per sport |
| Preparatore atletico | Programmi per squadra/sport specifico | Tag "sport", programmi con settimane multiple |
| Fisioterapista | Precisione clinica, tracciamento dolore | Campo dolore 0-10 nel feedback atleta è **critico**, non opzionale |
| Chinesiologo | Documentazione tecnica dettagliata | Descrizione tecnica + note personali per esercizio |

**Job-to-be-done primario:** _"Quando prendo in carico un nuovo atleta, voglio assegnargli un programma coerente in meno di 2 minuti, così posso concentrarmi sulla seduta invece che sull'amministrazione."_

**Problemi attuali (validati dal PRD):** Excel, WhatsApp, YouTube, Drive, note sparse → frammentazione. Aggiungiamo un problema implicito non scritto ma centrale per fisioterapisti/preparatori: **assenza di uno storico strutturato del dolore/esecuzione** nel tempo — oggi vive in messaggi WhatsApp, difficile da consultare.

**Persona secondaria — Atleta/Cliente**
Non ha bisogno di account "pesante": vuole aprire l'app, vedere l'allenamento di oggi, guardare il video, spuntare, dare feedback. Qualunque frizione (registrazione complessa, troppi campi) è un rischio di abbandono — coerente con la mobile-first semplicità richiesta nel brief originale.

**Nota architetturale derivata:** servono **due superfici applicative con permessi diversi** sullo stesso backend: Professionista (full CRUD sui propri dati) e Atleta (solo lettura del proprio programma + scrittura feedback/completamenti). Questo va disegnato nel modello di autorizzazione (RLS in Supabase) fin dall'inizio, non aggiunto dopo.

---

## 3. Obiettivi MVP

**Obiettivi business** (da validare in beta):
1. Interesse: ≥30% dei professionisti contattati accetta di provare il prodotto.
2. Utilizzo ricorrente: ≥50% dei professionisti attivi torna a usare l'app almeno 1x/settimana per 4 settimane consecutive.
3. Willingness to pay: ≥20% dichiara disponibilità a pagare in un'intervista post-trial.

**Obiettivo prodotto (north star metric MVP):**
> Un professionista deve poter creare e assegnare un programma a un atleta in **meno di 2 minuti**, misurato dal click su "Nuovo programma" al conferma-assegnazione.

Questo numero è testabile e diventa il criterio guida per ogni scelta UX (già riflesso nel wireframe: flow "Assegna programma" è 2 schermate, non di più).

**Come lo misuriamo:** timestamp lato client tra evento `program_create_started` e `assignment_confirmed` (vedi §8 KPI — serve instrumentazione minima di eventi fin dal giorno 1).

---

## 4. Fuori scope MVP

Confermato dal PRD originale, nessuna modifica. Aggiungiamo solo la motivazione per due voci ambigue:

- **❌ Statistiche avanzate** → nell'MVP restano solo i contatori semplici già nel wireframe (numero esercizi, programmi attivi, atleti, allenamenti completati, % completamento). Niente grafici/trend/analytics — quello è un upsell post-MVP.
- **❌ Collaborazione tra professionisti** → implica anche: **niente condivisione di un atleta tra due professionisti**, niente subordinati/staff. Ogni riga `Athlete` ha un solo `professional_id` (vedi §6).

---

## 5. User Flow principali — mappati alle schermate del wireframe

Il wireframe attuale copre **7 delle 7 aree di flow**, ma non tutti gli step. Ecco la mappatura puntuale, con i gap evidenziati.

### Flow A — Registrazione professionista
**Copertura wireframe: ❌ nessuna schermata esiste ancora.**
Step richiesti dal PRD: (1) Registrazione [nome, email, password, professione/ruolo], (2) Creazione profilo [foto, specializzazione, descrizione], (3) Accesso dashboard.
→ **Gap da colmare prima o durante l'implementazione Flutter**: servono 2-3 nuove schermate (signup form, profile setup) che il wireframe non disegna. Possiamo costruirle direttamente in Flutter seguendo il design system (accent `#C1633A`, palette calda) senza bisogno di tornare al tool di design, a meno che tu non preferisca prima wireframare anche queste.

### Flow B — Creazione esercizio
**Copertura wireframe: ✅ completa** — Group C, 4 step (`Creazione Esercizio / Step 1..4`).
Confronto campi PRD vs wireframe:
| Campo PRD | Nel wireframe? | Note |
|---|---|---|
| Nome | ✅ Step 1 | |
| Categoria | ✅ Step 1 | il wireframe usa "categoria" come select singola; il PRD parla di tag liberi multi-asse (area/obiettivo/sport) — **da riconciliare**: proponiamo categoria = 1 valore strutturato (Forza/Mobilità/...) per i filtri rapidi, + tag liberi multipli per area/sport, come già distinto nello step 3 ("+ aggiungi tag") |
| Video (upload/YouTube/libreria) | ✅ Step 2 | formati MP4/MOV da validare lato upload |
| Descrizione tecnica | ✅ Step 3 | |
| Note personali | ❌ non presente | **Gap minore**: aggiungere un campo separato da "descrizione tecnica" (quest'ultima pensata per l'atleta, le note personali no) |
| Serie/Ripetizioni/Durata/Recupero/Carico | ⚠️ parziale | wireframe Step 3 mostra solo Serie/Ripetizioni/Recupero/Carico — **manca "Durata"** come campo distinto (utile per esercizi isometrici/plank) |
| Tag | ✅ Step 3 | |

### Flow C — Libreria esercizi
**Copertura wireframe: ✅ struttura base**, azioni sulla card **da completare**.
Il wireframe (Desktop 02, Mobile Pro 02) mostra ricerca, filtri, categorie, griglia card con thumbnail/nome/categoria/tag. Il PRD richiede sulla card anche: **Apri dettaglio, Modifica, Duplica, Elimina, Aggiungi a programma** e il **preferito (⭐)** — nel wireframe "Preferiti" esiste solo come filtro in alto, non come azione per-card, e le azioni CRUD sulla card non sono disegnate (probabile hover/menu contestuale, non visibile in bassa fedeltà).
→ In fase di alta fedeltà aggiungeremo: icona ⭐ sulla card, menu "⋯" con Modifica/Duplica/Elimina, bottone/drag "Aggiungi a programma" (quest'ultimo già implicito nel Programma Builder A3, dove la libreria si trascina).

### Flow D — Creazione programma
**Copertura wireframe: ✅ parziale** — A3 "Programma Builder" mostra blocchi (Warm-up/Forza/Core), drag&drop dalla libreria, parametri "3 x 8 · rec 90″" per esercizio, "Salva template".
Gap rispetto al PRD:
- **Nome e descrizione del programma** in fase di creazione iniziale non hanno una schermata dedicata nel wireframe (si vede solo il titolo "Pre-season Calcio" già valorizzato) → serve un piccolo step "Crea programma" (nome, descrizione, durata in settimane) prima di arrivare al builder.
- **Durata in settimane**: nel wireframe appare solo come testo statico "Settimana 1 di 6" — nel prodotto reale sarà un campo impostato alla creazione e la UI dovrà permettere di navigare/duplicare le settimane.
- **Note per esercizio nel programma**: il PRD le richiede, il wireframe mostra solo serie/rip/recupero inline — le note andranno in un editor per-esercizio (probabilmente un tap sull'item apre un mini-form).

### Flow E — Gestione atleta
**Copertura wireframe: ✅ completa** per lista (A4) e profilo (A5) e mobile (Atleti).
Creazione atleta (form nome/cognome/email/sport/note): **❌ non disegnata** — solo il bottone "+ Nuovo atleta" esiste, non lo screen del form. Da costruire in Flutter seguendo lo stile degli altri form modali (step Creazione Esercizio come riferimento visivo).
Nota: PRD chiede "Cognome" separato da "Nome" — il wireframe usa sempre nome completo ("Marco Rossi"); nel data model terremo `name`+`surname` separati (vedi §6) ma l'UI può comunque mostrarli concatenati nelle liste.

### Flow F — Assegnazione programma
**Copertura wireframe: ✅ completa** — Group D, 2 step (seleziona programma → seleziona atleta e conferma). Coerente col north-star "< 2 minuti" di §3.

### Flow G — Esperienza atleta
**Copertura wireframe: ✅ completa** — Group E: dashboard "Allenamento di oggi", player esercizio+video, feedback (difficoltà 3 opzioni + dolore 0-10). Il PRD aggiunge **"Nota libera"** nel feedback, che nel wireframe **non è presente** (solo difficoltà + dolore) → gap minore da aggiungere come campo di testo opzionale nello screen "Feedback".

### Riepilogo gap da colmare prima/durante l'implementazione
1. Flow A (registrazione + profilo) — schermate nuove, nessun riferimento nel wireframe.
2. Form creazione atleta — schermata nuova.
3. Form/step "crea programma" (nome, descrizione, durata) prima del builder.
4. Azioni CRUD su card esercizio (modifica/duplica/elimina/preferito) nella libreria.
5. Campo "Note personali" ed eventualmente "Durata" nell'esercizio.
6. Campo "Note" per esercizio dentro un programma.
7. Campo "Nota libera" nel feedback atleta.

Nessuno di questi blocca l'inizio dello sviluppo: sono tutti coerenti con lo stile visivo già stabilito (palette calda, accento `#C1633A`, componenti a card/dash-border in bozza → pieni in alta fedeltà) e li disegneremo direttamente in Flutter durante l'implementazione, salvo tua indicazione contraria.

---

## 6. Architettura dati MVP

Schema del PRD confermato e reso esplicito con tipi, vincoli e note RLS (pensando a un backend Postgres/Supabase, ma valido concettualmente per qualsiasi DB relazionale).

```sql
-- Professionisti
User (
  id            uuid PK,
  name          text NOT NULL,
  email         text UNIQUE NOT NULL,
  role          text NOT NULL, -- 'pt' | 'preparatore' | 'fisioterapista' | 'chinesiologo' | 'altro'
  photo_url     text,
  specialization text,
  description   text,
  created_at    timestamptz DEFAULT now()
)

-- Libreria privata di esercizi
Exercise (
  id            uuid PK,
  owner_id      uuid FK -> User.id,   -- ownership: un esercizio appartiene a un solo professionista
  name          text NOT NULL,
  category      text,                 -- Forza | Mobilità | Prevenzione | Recupero | Core | Performance
  description   text,                 -- descrizione tecnica (visibile anche all'atleta)
  personal_notes text,                -- note private, MAI visibili all'atleta
  video_type    text,                 -- 'upload' | 'youtube' | 'internal_library'
  video_url     text,
  sets          int,
  reps          int,
  duration      text,                 -- es. "45s" — testo libero per coprire secondi/metri/tempo
  rest          text,                 -- es. "90s"
  load          text,                 -- carico: testo libero (kg, banda, corpo libero...)
  is_favorite   boolean DEFAULT false,
  created_at    timestamptz DEFAULT now()
)

Tag ( id uuid PK, name text UNIQUE NOT NULL )
Exercise_Tags ( exercise_id uuid FK, tag_id uuid FK, PRIMARY KEY(exercise_id, tag_id) )

-- Programmi
Program (
  id            uuid PK,
  owner_id      uuid FK -> User.id,
  name          text NOT NULL,
  description   text,
  duration_weeks int,
  is_template   boolean DEFAULT false,
  created_at    timestamptz DEFAULT now()
)

Program_Exercise (
  id            uuid PK,
  program_id    uuid FK -> Program.id,
  exercise_id   uuid FK -> Exercise.id,
  week          int DEFAULT 1,        -- necessario per programmi multi-settimana (non nel PRD originale, ma richiesto da "Settimana 1 di 6" nel wireframe)
  block_label   text,                 -- "Warm-up" | "Forza" | "Core" ... (dal wireframe A3)
  order         int NOT NULL,
  sets          int,
  reps          int,
  rest          text,
  notes         text,
  created_at    timestamptz DEFAULT now()
)

-- Atleti
Athlete (
  id            uuid PK,
  professional_id uuid FK -> User.id, -- 1 atleta = 1 professionista (no condivisione, §4)
  name          text NOT NULL,
  surname       text NOT NULL,
  email         text,
  sport         text,
  notes         text,
  created_at    timestamptz DEFAULT now()
)

-- Assegnazioni
Assignment (
  id            uuid PK,
  program_id    uuid FK -> Program.id,
  athlete_id    uuid FK -> Athlete.id,
  start_date    date NOT NULL,
  status        text DEFAULT 'active', -- 'active' | 'completed' | 'paused'
  created_at    timestamptz DEFAULT now()
)

-- Completamenti / feedback
Completion (
  id            uuid PK,
  assignment_id uuid FK -> Assignment.id,
  exercise_id   uuid FK -> Exercise.id,
  completed     boolean DEFAULT false,
  difficulty    text,   -- 'facile' | 'corretto' | 'difficile'
  pain_score    int,    -- 0-10, CHECK (pain_score BETWEEN 0 AND 10)
  note          text,   -- nota libera (gap #7 sopra)
  date          date DEFAULT current_date,
  created_at    timestamptz DEFAULT now()
)
```

**Note di design dati aggiunte rispetto al PRD grezzo:**
- `week` in `Program_Exercise`: necessario appena un programma ha più di 1 settimana — il wireframe lo implica ("Settimana 1 di 6") ma lo schema originale non lo prevedeva.
- `block_label`: raggruppamento visivo (Warm-up/Forza/Core) usato nel Programma Builder — senza questo campo perdiamo la struttura a blocchi vista in A3.
- `is_favorite` su `Exercise`: il filtro "☆ Preferiti" in libreria implica questo campo, assente nello schema originale.
- **Row-Level Security (se Supabase)**: ogni tabella con `owner_id`/`professional_id` deve avere policy che limitano lettura/scrittura al proprietario autenticato. L'atleta avrà un ruolo separato con policy di sola lettura su `Assignment`/`Program`/`Exercise` collegati a lui, e sola scrittura su `Completion` per le proprie righe.

---

## 7. Stack tecnico

**Frontend: Flutter** (confermato) — target iOS, Android, **Web** (per l'uso desktop/tablet del professionista, come richiesto nel brief originale: "vorrei la versione mobile funzionante anche per i professionisti", quindi Flutter Web risponde sia al bisogno mobile che desktop con un'unica codebase).

Considerazioni pratiche:
- **Layout responsive**: un'unica codebase Flutter dovrà biforcare il layout (sidebar desktop vs bottom nav mobile) con breakpoint — coerente con le due famiglie di schermate nel wireframe (Desktop A1-A5 vs Mobile B1-B3).
- **State management**: consigliato Riverpod o Bloc per gestire lo stato condiviso (utente corrente, libreria esercizi, programma in editing) tra le tante schermate.
- **Routing**: `go_router` per gestire deep-link e navigazione dichiarativa tra le 17+ schermate/flow.
- **Drag & drop** (Programma Builder, A3): Flutter supporta `Draggable`/`DragTarget` nativamente — fattibile sia su web che mobile, ma su mobile potremmo sostituirlo con un flusso "seleziona esercizio → aggiungi" più touch-friendly (drag&drop è scomodo su schermi piccoli).

**Backend: proposta Supabase** (in assenza di indicazione, scelgo lo stack più adatto a low-ops + iterazione rapida per un MVP):
- **Auth**: Supabase Auth (email/password, coerente con Flow A).
- **Database**: Postgres gestito, schema di §6 diretto.
- **Storage video**: Supabase Storage per l'MVP (upload diretto, quota limitata) — migrazione a Mux/Cloudflare Stream se il volume/qualità streaming lo richiede (già previsto nel PRD originale, confermato).
- **Client**: pacchetto `supabase_flutter` ufficiale, ben supportato.

**Deciso: Supabase.**

---

## 8. KPI Beta (30 giorni)

| Metrica | Target | Come si misura |
|---|---|---|
| **Activation** | ≥10 esercizi creati, ≥2 programmi creati, ≥3 atleti invitati per professionista | Query aggregate su `Exercise`/`Program`/`Athlete` filtrate per `owner_id`, cron settimanale |
| **Engagement** | programmi creati/settimana, esercizi aggiunti/settimana, accessi settimanali | Eventi `program_created`, `exercise_created`, `session_start` loggati lato client/Supabase |
| **Conversion** | ≥20% interesse dichiarato a Premium | Survey in-app o intervista post-trial (non richiede instrumentazione tecnica) |
| **North star (§3)** | tempo medio creazione+assegnazione < 2 min | Eventi `program_create_started` → `assignment_confirmed`, delta timestamp |

**Nota**: serve instrumentazione minima di analytics fin dal primo sprint (anche solo una tabella `events` in Supabase con `user_id, event_name, payload, created_at`) — non è nel PRD originale ma è indispensabile per misurare gli obiettivi di §3 e §8, altrimenti la beta non è misurabile.

---

## 9. Definition of Done MVP

Confermato dal PRD originale. Lo trasformiamo in checklist verificabile end-to-end (mappata ai flow):

- [ ] Un professionista può registrarsi → **Flow A** (wireframe pronto — vedi `project/Wireframes-new-screens.html`)
- [ ] Può creare la propria libreria → **Flow B/C** (wireframe pronto)
- [ ] Può aggiungere video (upload / YouTube / libreria interna) → **Flow B Step 2** (wireframe pronto)
- [ ] Può creare programmi → **Flow D** (wireframe pronto — step iniziale in `Wireframes-new-screens.html`, builder in `Wireframes.dc.html`)
- [ ] Può assegnare programmi → **Flow F** (wireframe pronto)
- [ ] Un atleta può visualizzare il programma → **Flow G** (wireframe pronto)
- [ ] L'atleta può completare esercizi → **Flow G** (wireframe pronto)
- [ ] Il professionista riceve feedback → **Flow G → Completion** (wireframe pronto, manca solo nota libera)

Su questa base **100% delle schermate necessarie sono ora disegnate in bassa fedeltà** tra i due file wireframe.

---

## Decisioni chiuse

1. **Backend: Supabase** (Auth + Postgres + Storage). Confermato — procediamo con lo schema RLS di §6 così com'è.
2. **Schermate mancanti**: colmate con un nuovo wireframe low-fi, stesso linguaggio visivo del bundle originale — vedi `project/Wireframes-new-screens.html` (Registrazione professionista 2 step, Nuovo atleta, Nuovo programma step 0). File statico, senza dipendenza da `support.js`, coerente con palette e componenti di `Wireframes.dc.html`.
3. **Naming**: resta provvisorio ("Coach Exercise Manager") per tutta la durata dell'MVP — non blocca lo sviluppo, si rivede prima del lancio pubblico.

Prossimo passo: revisione di `Wireframes-new-screens.html`, poi via libera all'implementazione Flutter.
