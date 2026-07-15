# Proposta — Attivazione account Atleta (colma gap Flow A-bis)

**Contesto**: il PRD (§2, §6) prevede una "Persona secondaria — Atleta" con accesso in sola lettura/scrittura al proprio programma, e il wireframe Group E ("App Atleta — Mobile") disegna già l'esperienza a partire dalla schermata "Allenamento di oggi" — cioè **assume un atleta già autenticato**. Non esiste però nessuna schermata né logica che spieghi come la riga anagrafica `Athlete` (creata dal professionista via form "Nuovo atleta", con solo nome/cognome/email/sport/note) diventi un account `User` con ruolo atleta capace di fare login. Questo documento propone come colmare quel gap, senza rimettere in discussione nulla di già deciso.

---

## 1. Meccanismo proposto: invito via email con link di attivazione

Flusso in 4 passi:

1. **Il professionista crea l'atleta** (form "Nuovo atleta" già wireframato, invariato) → riga in `Athlete` con `email`, `professional_id`, e un nuovo campo `status = 'invited'`.
2. **Il sistema invia automaticamente un'email di invito** all'indirizzo inserito, con un link univoco a scadenza (es. 7 giorni) per attivare l'account.
3. **L'atleta apre il link → schermata "Attiva il tuo account"**: imposta una password (nome/cognome/email pre-compilati e non modificabili, per garantire il match con la riga `Athlete` già creata dal coach). Un tap, non un form lungo — coerente con la richiesta PRD di zero frizione per l'atleta (§2: "Qualunque frizione... è un rischio di abbandono").
4. **Creazione dello `User` con ruolo `athlete`** collegato alla riga `Athlete` (`Athlete.user_id`, nuovo campo) → login immediato → redirect a "Allenamento di oggi" (Group E, già esistente).

Se l'atleta non attiva l'account, il professionista può comunque assegnargli programmi da subito (l'anagrafica `Athlete` esiste indipendentemente dallo `User`) — così il north star "< 2 minuti" di §3 non viene toccato dal nuovo flusso.

---

## 2. Modifiche allo schema dati (§6 PRD)

```sql
Athlete (
  ...campi esistenti invariati...
  status        text DEFAULT 'invited',  -- 'invited' | 'active'
  user_id       uuid FK -> User.id NULL, -- valorizzato solo dopo attivazione
  invite_token  uuid,                    -- token invito, rigenerabile
  invite_sent_at timestamptz
)
```

`User.role` si estende con il valore `'athlete'` accanto a `'pt' | 'preparatore' | ...` — oppure, se si preferisce non sovraccaricare `role` (che oggi distingue le specializzazioni professionali), si introduce un campo separato `User.user_type = 'professional' | 'athlete'`. **Consiglio la seconda opzione**: tenere `role` per la specializzazione del professionista ed evitare valori eterogenei nello stesso campo.

**RLS**: la policy già prevista in §6 ("l'atleta avrà un ruolo separato con policy di sola lettura...") si aggancia direttamente a `Athlete.user_id = auth.uid()` invece che a un meccanismo ancora da definire — questo era esattamente il pezzo mancante per rendere implementabile la RLS descritta.

---

## 3. Schermate nuove necessarie (nessuna esiste nel wireframe attuale)

| Schermata | Analoga a (riferimento visivo) | Note |
|---|---|---|
| **Attiva account** (imposta password da link invito) | Step 1 "Registrazione" del Flow A professionista, ma senza i campi già noti (nome/email pre-compilati, sola password) | Mobile-only, è il primo touchpoint dell'atleta |
| **Login atleta** | Riusa lo stesso schermo di login del professionista, con redirect basato su `user_type` dopo l'auth | Non serve una schermata visivamente diversa |
| **Stato "invito in sospeso"** nella lista/profilo atleta (A4/A5, lato professionista) | Badge sulla card atleta esistente ("Invitato" vs "Attivo") | Permette al coach di sapere se deve sollecitare l'atleta; possibilità di "Reinvia invito" |

Tutte compatibili con lo stile visivo già stabilito (palette calda, accento `#C1633A`), da costruire in Flutter come già fatto per Flow A/E/nuovo-atleta.

---

## 4. Punti aperti da decidere (servono una tua conferma)

1. **Invio email**: serve un provider transazionale (es. Supabase Auth stesso supporta invite-by-email nativamente — `supabase.auth.admin.inviteUserByEmail`). Consiglio di usarlo direttamente invece di costruire un sistema di token custom: riduce lavoro e rischio sicurezza. Da confermare se Supabase Auth basta o serve un provider email dedicato (es. per template personalizzati col brand).
2. **Atleta senza email**: il campo `email` in `Athlete` non è marcato NOT NULL nel PRD — cosa succede se il coach non la inserisce? Propongo di renderla obbligatoria *solo* se si vuole invitare l'atleta subito, ma restare opzionale per chi vuole solo tracciare l'anagrafica senza dare accesso app (caso plausibile: bambini, atleti che non useranno mai l'app).
3. **Scadenza invito e re-invio**: 7 giorni è un default arbitrario, da confermare o cambiare.
4. **Cosa succede se l'atleta cambia professionista** (fuori scope MVP per §4, ma la riga `Athlete` è 1:1 col professionista) — se in futuro serve, lo `User` atleta andrebbe disaccoppiato dalla singola riga `Athlete`. Non blocca l'MVP, ma vale la pena tenerlo a mente nello schema per non doverlo riscrivere.

---

## 5. Impatto sul Definition of Done (§9)

Aggiungerei una voce esplicita non presente oggi:
- [ ] Un atleta invitato può attivare il proprio account via link email e accedere in sola lettura al proprio programma → **Flow A-bis (nuovo)**

Nessun impatto sulle voci già presenti, è un'aggiunta puntuale.
