# MailSorter — Complete System Overview
### Source document for NotebookLM

---

## What is MailSorter?

MailSorter is a free, open-source Apple Mail automation system built entirely in AppleScript for macOS. It automatically sorts your inbox every 5 minutes — no plugins, no subscriptions, no email leaving your Mac.

The core idea: **flag color equals category, not urgency.** When you see a colored flag in your inbox, you immediately know what type of mail it is. When you press Archive, the mail goes to the correct folder automatically. The flag stays on it forever so you always know what you're looking at.

---

## The problem it solves

Most people have one of two inbox problems:

**Problem A — Inbox chaos.** Everything piles up. Newsletters sit next to bank alerts. LinkedIn notifications bury invoices. Finding anything requires search.

**Problem B — Over-engineered rules.** Apple Mail has a built-in rules system, but it's rigid and manual. Third-party apps like SaneBox or Superhuman cost money and process your email on their servers.

MailSorter solves both without any of the downsides. It runs locally, costs nothing, and you configure it in plain text.

---

## How it works — the two layers

### Layer 1: Inbox scan (runs every 5 minutes)

Every incoming message is checked against a list of sender rules. There are three outcomes:

**Auto-sort (flag color 0):** Newsletters, deliveries, LinkedIn — mail that doesn't need your attention is moved directly to the right archive folder. No flag, no noise.

**Category flag (colors 2–6):** Mail from your bank, employer, doctor, lawyer — anything that matters — gets a color flag and stays in your inbox. You decide when to deal with it. When you press Archive, the script automatically routes it to the correct subfolder.

**Red flag (color 1):** Unknown sender with an attachment or invoice keyword in the subject. You haven't seen this before, and it might need action. It stays in your inbox flagged red.

### Layer 2: Archive routing (also runs every 5 minutes)

Anything you manually pressed Archive on goes to the "Archive" root folder. Layer 2 reads those messages and moves each one to the right subfolder based on the same sender rules. The flag is preserved — it stays on the mail in the archive forever.

---

## The flag color system

| Color | Number | Category |
|-------|--------|----------|
| No flag | 0 | Auto-sorted — newsletters, deliveries, transport |
| Red | 1 | Action required — unknown sender, has attachment or invoice |
| Orange | 2 | Financial — bank, insurance, payment services |
| Yellow | 3 | Business / Legal — contracts, KVK, lawyers |
| Green | 4 | Work — employer, clients, colleagues |
| Blue | 5 | Housing / Real estate — rentals, mortgage, agents |
| Purple | 6 | Health & Government — doctors, municipality, tax authority |

---

## The folder structure

All folders live under Archive, which syncs to iPhone via iCloud automatically.

```
Archive/
├── Financial/
│   └── Mortgage
├── Business
├── Work
├── Housing/
│   └── Search
├── Health
├── Government
├── Personal
├── LinkedIn
├── Deliveries
├── Transport
└── Newsletters/
    ├── Fashion & Shopping
    ├── Tech & AI
    ├── Events & Going Out
    └── Food & Sports
```

---

## How the rules work

Rules are defined as a simple list:

```
{"@domain-fragment.com", flag_color, "Archive/FolderName"}
```

Rules are checked top-to-bottom. First match wins. The sender's email address is matched case-insensitively against the fragment. For example:

- `{"@linkedin.com", 0, "Archive/LinkedIn"}` — auto-archives all LinkedIn mail
- `{"@mybank.com", 2, "Archive/Financial"}` — flags bank mail orange, stays in inbox
- `{"@docusign.net", 3, "Archive/Business"}` — flags DocuSign yellow

---

## How it was built

The project started by analyzing three years of email history. The mbox files from Mail's local storage were read using grep to extract all unique sender domains. These were then fed into Claude (Anthropic's AI) to classify senders into categories.

The first version took one afternoon. Subsequent versions refined the flag logic, fixed edge cases (like attachment-based flags overriding category flags), and added migration scripts to reorganize an existing mail archive.

The final system consists of five scripts:

1. **MailSorter.applescript** — the main script, runs every 5 minutes via launchd
2. **MailSorter_OneTime.applescript** — sorts everything currently in inbox at once
3. **MailFlagFixer.applescript** — corrects flag colors on all archived mail
4. A **launchd plist** — the macOS background scheduler
5. A **Claude prompt** — lets anyone generate their own personalized rules in minutes

---

## Privacy

The script only reads the `From:` header and `Subject:` line of each message. It never reads the email body. Everything runs locally on the user's Mac. No data is sent anywhere.

---

## Who is this for?

- Mac users with Apple Mail and iCloud
- Anyone who gets 50+ emails a day and wants zero inbox management overhead
- Developers who want a fully customizable, transparent system with no black box
- People who have tried other solutions and don't want to pay monthly fees

---

## The bigger picture

MailSorter is an example of what happens when you combine a capable AI (Claude) with a simple scripting language (AppleScript) and a clear problem (inbox chaos). The AI didn't write the code autonomously — it collaborated: analyzing email headers, classifying senders, suggesting rule structures, and debugging AppleScript edge cases in real time.

The result is a system that feels like it was hand-crafted for one specific person's life, because it was. And the generic version lets anyone recreate that for their own inbox in under an hour.

---

## Key quotes / insights for discussion

- "Flag color equals category, not urgency."
- "Your inbox should only show mail that needs your attention."
- "Every rule is one line. Adding a new sender takes ten seconds."
- "It runs while you sleep. You wake up to a clean inbox."
- "We fed three years of email headers to Claude. It classified 300+ senders in minutes."
- "The mail never leaves your Mac. No subscription. No server. Just AppleScript."
