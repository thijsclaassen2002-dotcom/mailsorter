# MailSorter — YouTube Tutorial Script
### Duration: ~5 minutes | Screen recording + voiceover

---

## INTRO — 0:00–0:30

*Scherm: inbox met honderden mails, scrollen*

**Voiceover:**
"This is what my inbox looked like six months ago. Bank alerts buried under LinkedIn. Newsletters next to invoices. Nothing in the right place.

I tried Apple's built-in rules. Too rigid. I tried third-party apps. Monthly fee, and my email going through someone else's server.

So I built my own. Free. Local. Fully automated. Let me show you how it works — and how you can set it up for yourself in under an hour."

---

## PART 1: HOW IT WORKS — 0:30–1:30

*Scherm: clean inbox met gekleurde vlaggetjes*

**Voiceover:**
"The system has one core idea: flag color equals category.

When I look at my inbox, I instantly know what every mail is."

*Zoom in op vlagjes, één voor één*

**Voiceover:**
"Orange — financial. Yellow — business. Green — work. Blue — housing. Purple — health or government. Red — unknown sender with an attachment or invoice. That one needs my attention.

No flag at all — newsletters, deliveries, LinkedIn — those never even hit the inbox. They're sorted automatically."

*Scherm: klik een oranje mail aan, druk Archive*

**Voiceover:**
"When I'm done reading a mail, I press Archive. The script detects where it should go based on the sender, and routes it to the right subfolder automatically. The flag stays on it."

*Scherm: Archive/Financial map opent, mail staat erin met oranje vlag*

---

## PART 2: THE FOLDER STRUCTURE — 1:30–2:00

*Scherm: sidebar van Mail app met Archive-mappen uitgeklapt*

**Voiceover:**
"All folders live under Archive. This syncs to your iPhone automatically via iCloud. Same structure, same flags, on every device."

*Scherm: iPhone Mail app, dezelfde mappen*

**Voiceover:**
"Nothing to configure on your phone. It just works."

---

## PART 3: THE SCRIPT — 2:00–3:00

*Scherm: Script Editor opent MailSorter.applescript*

**Voiceover:**
"The whole thing is one AppleScript file. There are two sections."

*Scroll naar CONFIGURATION sectie, highlight het blok*

**Voiceover:**
"Up top: the configuration. This is the only part you ever touch. Your folder structure, your rules."

*Zoom in op een paar rules*

**Voiceover:**
"Each rule is one line. Sender fragment, flag color, target folder. The script checks rules top to bottom. First match wins.

Here I'm saying: anything from linkedin.com gets flag zero — auto-archive, no attention needed. Anything from my bank gets flag two — orange, stays in inbox."

*Scroll naar ENGINE sectie*

**Voiceover:**
"Below that is the engine. You never touch this part. It reads your rules and does the work."

---

## PART 4: SETUP — 3:00–4:00

*Scherm: Terminal opent*

**Voiceover:**
"Setting it up takes three steps."

*Typ commando's langzaam, elke stap duidelijk zichtbaar*

**Voiceover:**
"Step one: copy the script to your Scripts folder."

```bash
cp MailSorter.applescript ~/Library/Scripts/MailSorter.applescript
```

**Voiceover:**
"Step two: create the launchd agent. This is the macOS background scheduler — it runs the script every five minutes, even when Mail is closed."

*Scherm: plist bestand opent in teksteditor*

**Voiceover:**
"Copy the plist from the README, replace YOUR_USERNAME with your actual username, save it."

```bash
launchctl load ~/Library/LaunchAgents/com.mailsorter.plist
```

**Voiceover:**
"Step three: load it. Done."

*Scherm: Mail app, inbox leegstroomt in real time*

**Voiceover:**
"First run. Watch it go."

---

## PART 5: PERSONALIZING WITH CLAUDE — 4:00–4:40

*Scherm: Claude.ai opent, CLAUDE_PROMPT.md tekst wordt geplakt*

**Voiceover:**
"Not sure which rules to add? The repo includes a Claude prompt. Paste it into any Claude conversation, describe your inbox — your bank, your employer, the newsletters you get — and Claude generates your complete configuration."

*Scherm: Claude genereert rules, copy-paste naar Script Editor*

**Voiceover:**
"Replace the config section, run once to test, and you're done."

---

## OUTRO — 4:40–5:00

*Scherm: lege, clean inbox. Niks dan vlaggetjes. Stilte.*

**Voiceover:**
"This is what my inbox looks like now. Every flagged mail needs my attention. Everything else is already filed.

Full script, setup guide, and Claude prompt are all on GitHub. Link in the description. Mac only. Free. Open source."

*Fade to black. GitHub URL verschijnt.*

---

## PRODUCTIE-NOTITIES

**Wat je nodig hebt:**
- QuickTime of ScreenFlow voor schermopname
- Rode microfoon of AirPods voor voiceover (geen ingebouwde mic)
- iMovie of DaVinci Resolve (gratis) voor montage

**Opname-tips:**
- Zet Do Not Disturb aan vóór opname
- Mail op lichte modus, Script Editor op donkere modus
- Vergroot lettertype in Mail (Cmd+= ) zodat het leesbaar is op video
- Neem elke shot 2x op — eerste keer voor ritme, tweede keer voor veiligheid

**Muziek:**
- Gebruik YouTube Audio Library (gratis, geen copyright issues)
- Zoek op: "lo-fi minimal" of "ambient focus"
- Alleen onder de voiceover, laag volume

**Hoofdstuk-markers voor YouTube:**
```
0:00 The problem
0:30 How it works
1:30 Folder structure
2:00 The script
3:00 Setup (3 steps)
4:00 Personalize with Claude
4:40 Result
```

**Thumbnail tekst:**
```
"I automated my inbox with AppleScript"
[screenshot clean inbox met vlaggetjes]
```
