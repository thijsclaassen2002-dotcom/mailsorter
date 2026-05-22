# MailSorter

**Automatic Apple Mail organizer for macOS.** Runs silently every 5 minutes, sorts your inbox by category, and routes archived mail to the right folder — all locally, free, no subscriptions.

> Flag color = category, not urgency.

---

## What it looks like

```
Inbox
 🟠  Invoice from your bank           → stays, you handle it
 🟢  Message from your employer       → stays, you handle it
 🔴  Unknown sender + attachment      → stays, flagged red
                                         (newsletters, LinkedIn, deliveries never show up here)

Archive/
 ├── Financieel/       🟠 bank, insurance, tax
 ├── Zakelijk/         🟡 contracts, KVK, accountant
 ├── Werk/             🟢 employer, clients
 ├── Wonen/            🔵 housing, real estate
 ├── Gezondheid/       🟣 doctors, health insurer
 ├── Overheid/         🟣 municipality, DigiD, DUO
 ├── Bezorging/           PostNL, DHL, UPS, Amazon
 ├── LinkedIn/            all LinkedIn notifications
 └── Nieuwsbrieven/       Zalando, Spotify, GitHub, etc.
```

---

## How it works

**Layer 1 — Inbox** (every 5 minutes):
- Known unimportant sender → moved directly to the right Archive subfolder, no flag
- Known important sender → color flag assigned, stays in Inbox
- Unknown sender with attachment or invoice keyword → red flag, stays in Inbox

**Layer 2 — Archive root** (same run):
- Anything you manually pressed Archive on gets routed to the correct subfolder
- The flag stays on the mail forever — you always know the category

**Flag colors = categories:**

| Flag | # | Category |
|------|---|----------|
| 🔴 Red | 1 | Action required — unknown sender with attachment/invoice |
| 🟠 Orange | 2 | Financial — bank, insurance, tax |
| 🟡 Yellow | 3 | Business / Legal — contracts, accountant |
| 🟢 Green | 4 | Work — employer, clients |
| 🔵 Blue | 5 | Housing / Real estate |
| 🟣 Purple | 6 | Health & Government |
| — | 0 | Auto-sorted — no flag, no attention needed |

---

## Files in this repo

| File | What it does |
|------|-------------|
| `MailSorter.applescript` | Main script — generic template, fill in your own rules |
| `MailSorter_NL.applescript` | **Dutch edition** — 130+ Dutch senders pre-configured |
| `MailSorter_OneTime.applescript` | One-time inbox cleanup (run once on first setup) |
| `MailFlagFixer.applescript` | Fixes flag colors on existing archived mail |
| `GENERATE_MY_MAILSORTER.md` | Prompt for any LLM (Claude, ChatGPT, Gemini) to generate your personal script |
| `README.md` | This file |

---

## Quick start

### Option A — Use the Dutch edition (recommended for NL users)

Open `MailSorter_NL.applescript` in **Script Editor**. It already has 130+ Dutch senders configured. Add your own bank, employer, and doctor — search for `JOUW` to find the placeholders.

### Option B — Generate your own with an LLM

Open `GENERATE_MY_MAILSORTER.md`, copy the prompt between the `--- START PROMPT ---` and `--- END PROMPT ---` markers, paste it into Claude, ChatGPT, or Gemini, and answer the questions. You'll get a complete, personalized script back in minutes.

### Option C — Start from the generic template

Open `MailSorter.applescript` and fill in the CONFIGURATION section manually.

---

## Installation

### Step 1 — Test first

Set `dryRun to true` in the CONFIGURATION section, open the script in **Script Editor**, and press **Run**. Open **Venster → Log** to see every decision the script would make — without moving anything.

Once it looks right, set `dryRun to false`.

### Step 2 — Run once to clean up the current inbox

Open and run `MailSorter_OneTime.applescript`. This processes everything currently in your Inbox.

### Step 3 — Install for automatic running every 5 minutes

**a) Copy the script:**

```bash
cp MailSorter_NL.applescript ~/Library/Scripts/MailSorter.applescript
```

**b) Create the launchd agent:**

Save this as `~/Library/LaunchAgents/com.mailsorter.plist` (replace `YOUR_USERNAME`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.mailsorter</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/osascript</string>
        <string>/Users/YOUR_USERNAME/Library/Scripts/MailSorter.applescript</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

**c) Load it:**

```bash
launchctl load ~/Library/LaunchAgents/com.mailsorter.plist
```

**d) Verify:**

```bash
launchctl list | grep mailsorter
```

### Step 4 — Fix flags on existing archived mail (optional)

Run `MailFlagFixer.applescript` once to correct flag colors on mail you archived before installing MailSorter.

---

## Logs

After each live run, the script appends a line to `~/Library/Logs/MailSorter.log`:

```
Thu 22 May 2026 09:00:01: auto=14 vlag=3 archief=2
```

---

## Adding a new sender

1. Find their email domain (e.g. `@newservice.nl`)
2. Open `MailSorter.applescript` in Script Editor
3. Add one line in the right section:
   ```applescript
   {"@newservice.nl", 0, "Archive/Nieuwsbrieven"},
   ```
4. Save — the launchd agent picks it up on the next run

---

## Rule format

```applescript
{"@domain-fragment", flag_color, "Archive/FolderName"}
```

- Checked top-to-bottom. **First match wins.**
- `@` prefix is required. Matching is case-insensitive.
- Specific subdomains first: `@mail.mybank.com` before `@mybank.com`
- Flag `0` = auto-sort (move immediately, no flag)
- Flag `1–6` = color flag, stays in Inbox

---

## Privacy

Runs **100% locally on your Mac**. No mail content ever leaves your machine. The script only reads the `From:` header and `Subject:` line — never the body.

---

## Requirements

- macOS 12 or later
- Apple Mail (configured with at least one account)
- iCloud Mail recommended — Archive folders sync to iPhone automatically

---

## License

MIT — do whatever you want with it.

---

*Built with AppleScript and [Claude](https://claude.ai). Dutch edition includes 130+ pre-configured senders.*
