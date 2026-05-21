# MailSorter — Generic Edition

An automatic Apple Mail organizer for macOS. Runs silently in the background every 5 minutes and keeps your inbox clean using rules you define yourself.

---

## How it works

```
Inbox message arrives
        │
        ▼
 Does it match a rule?
        │
   ┌────┴────┐
  YES        NO
   │          │
flag = 0?   Has attachment
   │        or invoice?
 Auto-        │
 archive    flag = 1 (red)
 to folder  stays in Inbox
   │
flag = 2–6?
 Color flag
 stays in Inbox
        │
        ▼
  You press Archive
        │
        ▼
 Layer 2 routes mail
 to correct subfolder
 (flag stays on the mail)
```

**Flag colors = categories**, not urgency:

| Color | # | Meaning |
|-------|---|---------|
| 🔴 Red | 1 | Action required — unknown sender with attachment or invoice |
| 🟠 Orange | 2 | Financial |
| 🟡 Yellow | 3 | Business / Legal |
| 🟢 Green | 4 | Work |
| 🔵 Blue | 5 | Housing / Real Estate |
| 🟣 Purple | 6 | Health & Government |
| — | 0 | Auto-sorted (newsletters, deliveries) — no flag, no attention needed |

---

## Setup

### Step 1 — Customize the rules

Open `MailSorter.applescript` in **Script Editor** (Applications → Utilities → Script Editor).

Edit the **CONFIGURATION** section at the top:

1. **`archiveFolders`** — the folder tree you want under Archive.
2. **`invoiceKeywords`** — subject-line words that trigger the red flag for unknown senders.
3. **`personalDomains`** — email domains of friends/family that go to Archive/Personal.
4. **`senderRules`** — your actual sorting rules (see format below).

#### Rule format

```applescript
{"@domain-fragment.com", flag_color, "Archive/FolderName"}
```

Examples:
```applescript
-- Auto-sort to archive immediately (no flag):
{"@linkedin.com",   0, "Archive/LinkedIn"},

-- Orange flag, stays in Inbox, routes to Financial when archived:
{"@mybank.com",     2, "Archive/Financial"},

-- Yellow flag for business/legal:
{"@docusign.net",   3, "Archive/Business"},
```

**Tips:**
- Rules are checked top-to-bottom. First match wins.
- Use `@domain.com` format for reliable matching (case-insensitive).
- You can match subdomains: `@mail.mybank.com` matches before `@mybank.com`.
- A fragment like `@mybank` matches any subdomain of mybank.

### Step 2 — Test it

1. Open Script Editor and open `MailSorter.applescript`.
2. Click **Run** (▶).
3. Check your inbox and Archive folders.

### Step 3 — Install for automatic running

Create a launchd agent so the script runs every 5 minutes automatically.

**a) Copy the script to your Scripts folder:**

```bash
cp MailSorter.applescript ~/Library/Scripts/MailSorter.applescript
```

**b) Create the launchd plist:**

Save the file below as `~/Library/LaunchAgents/com.mailsorter.plist`:

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
    <key>StandardOutPath</key>
    <string>/Users/YOUR_USERNAME/Library/Logs/MailSorter.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/YOUR_USERNAME/Library/Logs/MailSorter.log</string>
</dict>
</plist>
```

Replace `YOUR_USERNAME` with your macOS username.

**c) Load it:**

```bash
launchctl load ~/Library/LaunchAgents/com.mailsorter.plist
```

**d) Verify:**

```bash
launchctl list | grep mailsorter
```

You should see `com.mailsorter` in the list.

---

## One-time tools (run once, then you're done)

### MailFlagFixer.applescript

Corrects flag colors on all your already-archived mail based on folder name.
Run once after customizing your rules to clean up historical mail.

### MailSorter_OneTime.applescript

Processes all messages currently in your Inbox at once.
Useful for the initial cleanup when you first set this up.

---

## Adding new rules

When you start getting mail from a new sender:

1. Open `MailSorter.applescript` in Script Editor.
2. Find the right section (auto-sort, financial, work, etc.).
3. Add a line:
   ```applescript
   {"@newsender.com", flag_color, "Archive/TargetFolder"},
   ```
4. Save and run once to apply immediately. The launchd agent picks up changes automatically next run.

---

## Privacy

This script runs **100% locally on your Mac**. No mail content, sender information, or metadata ever leaves your machine. The script only reads `From:` header and `Subject:` line — it never reads email bodies.

---

## Requirements

- macOS 12 or later
- Apple Mail app (configured with at least one account)
- iCloud Mail recommended (syncs Archive folders to iPhone automatically)

---

## Personalize it with Claude

Not sure which rules to add? Drop your email headers into a conversation with Claude and ask:

> "I want to set up MailSorter for my inbox. Here are some senders I receive mail from: [paste sender list]. Help me write the senderRules configuration."

See `CLAUDE_PROMPT.md` for a full prompt template.
