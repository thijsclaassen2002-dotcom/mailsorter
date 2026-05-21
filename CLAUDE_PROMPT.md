# MailSorter — Claude Setup Prompt

Copy and paste the block below into a new Claude conversation to get help building your own personalized MailSorter configuration.

---

## Paste this into Claude:

```
I want to set up MailSorter, an AppleScript-based automatic email organizer for Apple Mail on macOS.

## How MailSorter works

The script scans my Inbox every 5 minutes using two layers:

**Layer 1 — Inbox:**
- Each message is matched against a list of sender rules (top-to-bottom, first match wins).
- Rule format: {"@domain-fragment", flag_color, "Archive/FolderName"}
- flag_color = 0: auto-sort immediately to archive folder, no flag.
- flag_color = 1–6: assign a color flag, message stays in Inbox.
  When I press Archive, Layer 2 routes it to the right subfolder.
- Unknown senders with attachments or invoice keywords → red flag (flag 1), stays in Inbox.

**Layer 2 — Archive root:**
- Uses the same rules to route anything I manually archived to the right subfolder.
- Flags stay on mail after archiving (they indicate category, not urgency).

**Flag color = category:**
- 0 = no flag (auto-sorted newsletters/deliveries)
- 1 = red — action required (unknown sender with attachment/invoice)
- 2 = orange — financial
- 3 = yellow — business/legal
- 4 = green — work
- 5 = blue — housing/real estate
- 6 = purple — health & government

## My email setup

[DESCRIBE YOUR EMAIL HERE — for example:]
- I use iCloud Mail as my primary account.
- I work at [your company] — emails come from @yourcompany.com.
- My bank is [your bank] — emails come from @yourbank.com.
- I shop at [stores].
- I receive newsletters from [services].
- My doctor/health providers: [names].
- Government agencies I hear from: [names].
- Deliveries come from: [couriers].
- Real estate / housing searches via: [sites].
- Other important senders: [list].

## What I need

1. Suggest a folder structure under Archive/ that makes sense for my life.
2. Write the complete senderRules list with the right flag colors.
3. Write the invoiceKeywords list for my language (I speak [LANGUAGE]).
4. Write the complete MailSorter.applescript configuration section.
5. Explain any rules you're not sure about and ask me to confirm.

Please ask me clarifying questions before writing the final config.
```

---

## Tips for filling in the template

**Finding your senders:**
On Mac, open Mail → Preferences → Rules, or just look at who you receive mail from. In Terminal you can run:
```bash
grep "^From:" ~/Library/Mail/V*/[AccountName]/INBOX.mbox/mbox | sort -u | head -100
```

**Languages:**
The `invoiceKeywords` list should match your language. For example:
- English: `{"invoice", "payment due", "overdue", "statement", "reminder"}`
- Dutch: `{"factuur", "betaling", "rekening", "herinnering", "nota", "betalingsherinnering"}`
- German: `{"Rechnung", "Zahlungserinnerung", "Mahnung", "Überweisung"}`
- French: `{"facture", "paiement", "rappel", "relevé"}`
- Spanish: `{"factura", "pago", "recordatorio", "vencimiento"}`

**Account type:**
- iCloud Mail: folders under Archive/ sync automatically to iPhone. Recommended.
- Gmail/Outlook: works too, but folder sync behavior varies by app.

---

## After Claude generates your config

1. Open `MailSorter.applescript` in Script Editor (the generic template).
2. Replace the entire CONFIGURATION section with Claude's output.
3. Click Run (▶) to test.
4. Follow README.md to install the launchd agent for automatic running.
5. Run `MailSorter_OneTime.applescript` once to sort your existing inbox.
6. Run `MailFlagFixer.applescript` once to fix flag colors on archived mail.
