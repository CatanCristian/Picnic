# 🧺 Picnic Organizer

Organizza il tuo picnic perfetto! Un'app moderna e intuitiva per gestire ogni dettaglio del tuo evento all'aperto.

---

## ✨ Caratteristiche Principali

- 📋 **Gestione Liste**: Cibo, bevande e snack organizzati per categoria
- 🕐 **Programmazione Timeline**: Pianifica le attività con orari e note
- 👥 **Inviti Ospiti**: Invia inviti via email con RSVP automatico
- 📊 **Tracciamento Progresso**: Visualizza lo stato di preparazione in tempo reale
- 📍 **Mappa e Meteo**: Vedi il luogo su Apple Maps e previsioni meteo
- 📱 **PWA (App Mobile)**: Installa come app, funziona offline
- 🔐 **Sincronizzazione Real-time**: Tutti i cambiamenti sincronizzati istantaneamente

---

## 🚀 Quick Start

### Prerequisiti

- Account Supabase (gratuito su [supabase.com](https://supabase.com))
- GitHub per il deploy
- EmailJS (opzionale, per inviti email automatici)

### Setup Supabase

1. Crea un nuovo progetto su Supabase
2. Vai a **SQL Editor** → **New Query**
3. Copia tutto il contenuto da `supabase-setup.sql` e esegui
4. Vai a **Settings → API** e copia:
   - **Project URL**
   - **Anon Key**

### Configurazione App

1. Apri `index.html` e trovi la sezione **CONFIG** (linea 43)
2. Sostituisci i valori:

```javascript
const SUPABASE_URL = 'your-url-here';
const SUPABASE_KEY = 'your-key-here';
const APP_URL = 'https://yourusername.github.io/Picnic';
```

### Deploy su GitHub Pages

1. Fai push del file configurato su GitHub
2. Vai a **Settings → Pages**
3. Seleziona `main` branch e `/root` folder
4. La tua app sarà live! 🎉

---

## 📁 Struttura Progetto

```
Picnic/
├── index.html              # App principale (tutto-in-uno)
├── manifest.json           # Configurazione PWA
├── sw.js                   # Service Worker (offline)
├── supabase-setup.sql      # Schema database
├── fix-rls.sql             # Correzioni RLS
├── icons/                  # App icons
└── README.md              # Questo file
```

---

## 🎯 Come Usare

### Per l'Organizzatore

1. **Registrati** con email e password
2. **Crea Picnic**: Inserisci nome, data, location
3. **Gestisci Dettagli**:
   - Aggiungi/rimuovi cibo e bevande
   - Pianifica timeline con attività
   - Invita ospiti via email
4. **Traccia Progresso**: Dashboard mostra % completamento

### Per gli Ospiti

1. **Clicca il Link**: Ricevi invito via email
2. **Accedi**: Crea account o login
3. **Rispondi**: Scegli Sì/No al picnic
4. **Visualizza**: Vedi programmazione e altri ospiti

---

## 🗄️ Database Schema

| Tabella | Scopo |
|---------|-------|
| **picnics** | Evento principale (nome, data, location) |
| **picnic_guests** | Ospiti invitati (email, status RSVP) |
| **food_items** | Lista cibo/bevande con categorie |
| **schedule_items** | Timeline attività con orari |

---

## ⚙️ Configurazione Avanzata

### EmailJS (Opzionale)

Per inviti email automatici:

1. Registrati su [emailjs.com](https://emailjs.com)
2. Crea Email Service e Template
3. Aggiorna in `index.html`:

```javascript
const EMAILJS_SERVICE = 'service_abc123';
const EMAILJS_TEMPLATE = 'template_7i977jx';
const EMAILJS_KEY = 'your-public-key';
```

**Senza EmailJS**: Fallback a mailto (email client dell'utente)

### Sicurezza (Row Level Security)

Supabase protegge i dati con RLS:
- ✅ Organizzatore controlla il suo picnic
- ✅ Ospiti vedono solo il loro picnic
- ✅ Ospiti aggiornano solo il loro RSVP

---

## 🔧 Troubleshooting

| Problema | Soluzione |
|----------|-----------|
| "Connessione Supabase fallita" | Verifica URL e API Key in `index.html` |
| "Invito email non ricevuto" | Controlla EmailJS setup o usa fallback mailto |
| "Ospite non vede picnic" | Verifica che il link di invito contenga il token |
| "Cambiamenti non sincronizzati" | Ricarica pagina (Cmd+R / Ctrl+R) |

---

## 🛠️ Tecnologie

- **Frontend**: React 18 + Babel (JSX transpiler)
- **Backend**: Supabase (PostgreSQL + Auth + Realtime)
- **Hosting**: GitHub Pages
- **Email**: EmailJS (opzionale)
- **Maps**: Apple Maps API

---

## 📱 Linguaggio Progetto

- HTML: 86.9%
- PL/pgSQL: 12.4%
- JavaScript: 0.7%

---

## 📝 Note

- L'app è in **italiano**
- Tutto in un unico file `index.html` (nessun build richiesto)
- Funziona su desktop, tablet e mobile
- PWA: installabile come app nativa
- Offline first: service worker per cache

---

## 🤝 Contribuisci

Idee di miglioramento:
- [ ] Dark mode
- [ ] Supporto multi-lingua
- [ ] Galleria foto
- [ ] Budget tracking
- [ ] Suggerimenti parcheggio
- [ ] Promemoria automatici

---

**Fatto con 🧺 per picnic perfetti!**
