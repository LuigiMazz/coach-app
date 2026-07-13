# Coach Exercise Manager MVP

_Started 2026-07-13 13:27 UTC_

---

## User

# UX/UI Design Brief — MVP App gestione esercizi e programmi per professionisti sportivi

## Ruolo

Agisci come Senior Product Designer specializzato in applicazioni SaaS B2B mobile-first per professionisti del settore salute, sport e benessere.

Devi progettare in Figma la UX/UI di un MVP di una piattaforma chiamata provvisoriamente "Coach Exercise Manager".

L'app permette a professionisti come:

* Personal Trainer
* Preparatori atletici
* Fisioterapisti
* Chinesiologi

di creare una propria libreria privata di esercizi con video, costruire programmi personalizzati e assegnarli ai propri atleti/clienti.

---

# Obiettivo del prodotto

Creare lo strumento più veloce per trasformare la conoscenza del professionista in programmi personalizzati.

Il prodotto NON deve essere un social fitness e NON deve sostituire il professionista.

Il valore principale è:

"Il mio archivio professionale di esercizi, organizzato e pronto per creare programmi per i miei atleti."

---

# Target principale

Utente primario:
Professionista singolo.

Esempi:

* Preparatore atletico che segue diversi atleti di sport differenti.
* Personal trainer con clienti diversi.
* Fisioterapista che assegna esercizi riabilitativi.

L'utente lavora individualmente, senza team nella prima versione MVP.

---

# Principi UX

Priorità:

1. Velocità
2. Semplicità
3. Organizzazione
4. Personalizzazione

Il professionista deve poter:

* creare un esercizio;
* aggiungere un video;
* organizzarlo;
* creare un programma;
* assegnarlo a un atleta;

in pochi minuti.

---

# MVP Features

## Area Professionista

### Dashboard principale

Mostrare:

* numero esercizi nella libreria;
* programmi attivi;
* numero atleti;
* allenamenti completati.

Azioni rapide:

* Nuovo esercizio
* Nuovo programma
* Nuovo atleta

---

# Libreria esercizi (feature principale)

Creare una schermata con:

* ricerca;
* filtri;
* categorie;
* preferiti.

Categorie esempio:

* Forza
* Mobilità
* Prevenzione
* Recupero
* Core
* Performance

Ogni esercizio deve avere:

Nome

Esempio:
"Nordic Hamstring"

Video:

Possibilità di:

* caricare video personale;
* inserire link YouTube;
* utilizzare video dalla libreria interna.

Descrizione tecnica:

* esecuzione;
* errori comuni;
* indicazioni.

Parametri:

* serie;
* ripetizioni;
* durata;
* recupero;
* carico.

Tag:

Esempi:

* Hamstring
* LCA
* Calcio
* Forza eccentrica
* Mobilità

---

# Creazione esercizio

Progettare un flusso semplice:

Step 1:
Inserimento nome esercizio.

Step 2:
Aggiunta video:

Scelte:

* Upload video personale
* Link YouTube
* Libreria interna

Step 3:
Aggiunta dettagli.

Step 4:
Salvataggio nella libreria privata.

---

# Programmi di allenamento

Creare una UX drag & drop.

Il professionista deve poter:

* creare un programma;
* aggiungere esercizi;
* ordinare gli esercizi;
* impostare serie/ripetizioni/recuperi;
* salvare template riutilizzabili.

Esempio:

Programma:

"Pre-season calcio"

Settimana 1

Warm-up

↓
Mobilità anca

↓
Nordic Hamstring

↓
Core

---

# Gestione atleti/clienti

Schermata elenco:

Ogni atleta mostra:

* nome;
* programma attivo;
* ultimo allenamento;
* percentuale completamento.

Profilo atleta:

* programmi assegnati;
* storico;
* feedback.

---

# Assegnazione programma

Flusso:

Seleziona programma

↓

Seleziona atleta

↓

Assegna

Deve essere estremamente rapido.

---

# App atleta (seconda parte MVP)

Interfaccia semplice.

L'atleta vede:

Allenamento di oggi

Lista esercizi:

Esempio:

Nordic Hamstring

Video

3 serie x 8 ripetizioni

Completa

Dopo esercizio:

Feedback:

* Facile
* Corretto
* Difficile

Dolore:

scala 0-10

---

# Design System

Creare un design moderno SaaS professionale.

Riferimenti:

* Linear
* Notion
* Strava
* Apple Fitness

Non utilizzare uno stile troppo "fitness commerciale".

Il prodotto deve comunicare:

* competenza;
* affidabilità;
* precisione;
* professionalità.

---

# Layout

Progettare:

## Mobile first

Per atleta.

## Responsive desktop/tablet

Per professionista.

Il professionista probabilmente lavorerà principalmente da desktop/tablet.

---

# Componenti Figma richiesti

Creare component library:

* Button
* Input
* Search bar
* Cards esercizio
* Cards programma
* Tag
* Video player
* Exercise selector
* Modal
* Bottom navigation mobile
* Sidebar desktop
* Empty states
* Loading states

---

# User Flow principali da prototipare

Flow 1:

Registrazione professionista

↓

Dashboard

↓

Creazione primo esercizio

↓

Creazione programma

↓

Aggiunta atleta

↓

Assegnazione programma

Flow 2:

Apertura libreria

↓

Ricerca esercizio

↓

Aggiunta al programma

Flow 3:

Atleta apre allenamento

↓

Guarda video

↓

Completa esercizio

↓

Invia feedback

---

# Cosa NON includere nell'MVP

Non progettare:

* chat;
* pagamenti;
* nutrizione;
* marketplace;
* community;
* AI coach;
* condivisione pubblica librerie;
* team/studi;
* social.

---

# Output richiesto

Genera:

1. User journey completo.
2. Information architecture.
3. Wireframe low fidelity.
4. UI high fidelity.
5. Design system.
6. Prototype cliccabile Figma.
7. Componenti riutilizzabili.

Obiettivo finale:

Creare un MVP realistico sviluppabile da un piccolo team e testabile con 5-10 professionisti reali.

## Assistant

_[tool: questions_v2]_

## User

Questions answered:
- deliverable_start: Wireframe low-fi di tutti i flussi principali
- platform_focus: Vorrei entrambe le versioni, ma vorrei la versione mobile funzionante anche per i progessionisti
- visual_mood: Caldo ma professionale (neutri caldi, un accento deciso, stile Apple Fitness)
- color_accent: 3
- language: Italiano
- variations: Una sola direzione, procedi
- data_content: Sì, dati di esempio realistici va bene

## Assistant

_[tool: read_skill_prompt]_

_[tool: dc_write]_

_[tool: dc_html_str_replace]_

_[tool: dc_js_str_replace]_

_[tool: dc_js_str_replace]_

Verificando.

_[tool: ready_for_verification]_

Wireframe low-fi completo: 17 schermate — Dashboard/Libreria/Programma/Atleti desktop, versione mobile professionista, flow creazione esercizio (4 step), flow assegna programma, e app atleta (allenamento/video/feedback). Pan/zoom libero nel canvas.
