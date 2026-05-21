# MailSorter — Generate My Personal Script
### Paste the prompt below into any LLM (Claude, ChatGPT, Gemini, etc.)

---

## How to use

1. Copy everything between the `--- START PROMPT ---` and `--- END PROMPT ---` markers below.
2. Paste it into your LLM of choice.
3. Answer the questions the LLM asks you.
4. Copy the generated AppleScript into **Script Editor** on your Mac.
5. Press **Run** to test. Done.

---

--- START PROMPT ---

You are going to help me set up MailSorter, a free AppleScript-based email organizer for Apple Mail on macOS. Your job is to ask me a series of questions about my email life, then generate a complete, ready-to-run AppleScript file personalized for me.

## What MailSorter does

MailSorter scans my inbox every 5 minutes and sorts mail using two layers:

**Layer 1 — Inbox:**
- Known unimportant senders (newsletters, deliveries, LinkedIn) → moved directly to the right Archive folder. No flag.
- Known important senders (bank, employer, doctor, government) → color flag assigned, stays in inbox so I see it. When I press Archive, Layer 2 routes it to the right folder automatically.
- Unknown sender with an attachment or invoice keyword in the subject → red flag (action required).

**Layer 2 — Archive root:**
- Anything I manually press Archive on gets routed to the correct subfolder based on the same sender rules.
- Flags stay on archived mail forever so I always know the category.

**Flag colors = category (not urgency):**
- 0 = no flag — auto-sorted newsletters/deliveries
- 1 = red — action required (unknown sender + attachment/invoice)
- 2 = orange — financial (bank, insurance, energy, telecom bills)
- 3 = yellow — business/legal (contracts, chamber of commerce, accountant)
- 4 = green — work (employer, clients, job-related)
- 5 = blue — housing/real estate (rental, mortgage, agents)
- 6 = purple — health & government (doctors, municipality, tax authority)

**Rule format:** `{"@domain-fragment", flag_color, "Archive/FolderName"}`
Rules are checked top-to-bottom. First match wins.

---

## Step 1 — Ask me these questions

Ask me all of the following questions. You can ask them all at once in a numbered list. Wait for my answers before generating the script.

1. **Language** — What is your primary language? (This determines the invoice keyword list.)

2. **Account type** — What email service do you use? (iCloud, Gmail, Outlook/Hotmail, or something else?) iCloud is recommended for iPhone sync.

3. **Bank & financial** — What is your bank or banks? What payment services do you use? (e.g. PayPal, Klarna, Revolut, Wise, Stripe) Any insurance companies, energy providers, or telecom providers that send you bills?

4. **Work & business** — What is your employer's email domain? Any clients or freelance platforms? Do you use contract/signing tools like DocuSign?

5. **Housing** — Are you renting, buying, or settled? Which real estate or rental platforms do you use? Do you have a mortgage provider or property manager?

6. **Health & government** — Which hospitals, clinics, or health insurers email you? Which government agencies? (tax authority, municipality, social services, student loans, driving license authority)

7. **Deliveries** — Which delivery and courier services do you use? (PostNL, DHL, DPD, UPS, FedEx, Amazon, local services)

8. **Newsletters & shopping** — Which webshops, fashion brands, or subscription services send you newsletters you want auto-archived? (e.g. Zalando, HEMA, Netflix, Spotify, Bol.com)

9. **Tech tools** — Do you use any developer tools or tech services that send emails? (GitHub, Vercel, Supabase, OpenAI, Netlify, etc.)

10. **Events & food** — Any ticketing platforms, restaurant apps, or food delivery services? (Ticketmaster, TicketSwap, Uber Eats, Deliveroo, HelloFresh, etc.)

11. **Transport** — Which transport services email you? (national rail, airlines, OV/metro, car services, Airbnb, bike rental)

12. **Anything else** — Any other important senders that don't fit the categories above?

---

## Step 2 — Generate the script

Once I've answered your questions, generate a complete AppleScript file using the template below. Fill in ONLY the CONFIGURATION section based on my answers. Do not change the ENGINE section.

Rules:
- Put rules with the most specific domain fragment first to avoid false matches (e.g. `@mail.mybank.com` before `@mybank.com`).
- Use `@` prefix for all domain fragments.
- Put auto-sort rules (flag 0) before flagged rules (flag 1–6).
- Add a short comment above each group of rules explaining what they are.
- If I mentioned a service but you don't know its exact email domain, make a best guess and add a comment saying `-- verify this domain`.
- Use my language for the folder names if I'm not English-speaking (e.g. Dutch: "Financieel", French: "Financier", German: "Finanzen").
- Include invoice keywords in my language in the `invoiceKeywords` list.
- Add commented-out placeholder lines like `-- {"@yourbank.com", 2, "Archive/Financial"},` for categories I mentioned but couldn't fill in.

Output the complete script in a single code block. No explanation needed after the code — just the script.

---

## Script template (fill in the CONFIGURATION section only)

```applescript
-- =====================================================
-- MailSorter — Personal Edition
-- Generated by [LLM name] based on your answers
-- github.com/thijsclaassen2002-dotcom/mailsorter
-- =====================================================
--
-- FLAG COLORS = CATEGORY:
--   0 = no flag    (auto-sort)          1 = red   (action required)
--   2 = orange     (financial)          3 = yellow (business/legal)
--   4 = green      (work)               5 = blue   (housing)
--   6 = purple     (health/government)
-- =====================================================


-- =====================================================
-- CONFIGURATION — personalized for you
-- =====================================================

set archiveFolders to {
	-- FILL IN BASED ON USER ANSWERS
}

set invoiceKeywords to {
	-- FILL IN BASED ON USER LANGUAGE
}

set personalDomains to {
	"@gmail.com", "@icloud.com", "@outlook.com", "@hotmail.com",
	"@proton.me", "@yahoo.com", "@me.com"
	-- ADD USER'S LOCAL PERSONAL DOMAINS IF ANY
}

set senderRules to {

	-- ── AUTO-SORT (flag = 0) ──────────────────────────────────────
	-- FILL IN BASED ON USER ANSWERS

	-- ── FINANCIAL (flag = 2, orange) ─────────────────────────────
	-- FILL IN BASED ON USER ANSWERS

	-- ── BUSINESS / LEGAL (flag = 3, yellow) ─────────────────────
	-- FILL IN BASED ON USER ANSWERS

	-- ── WORK (flag = 4, green) ────────────────────────────────────
	-- FILL IN BASED ON USER ANSWERS

	-- ── HOUSING (flag = 5, blue) ──────────────────────────────────
	-- FILL IN BASED ON USER ANSWERS

	-- ── HEALTH & GOVERNMENT (flag = 6, purple) ───────────────────
	-- FILL IN BASED ON USER ANSWERS

}


-- =====================================================
-- ENGINE — do not edit below this line
-- =====================================================

tell application "Mail"
	with timeout of 300 seconds

	set icloudAccount to missing value
	repeat with anAccount in accounts
		try
			repeat with anEmail in (email addresses of anAccount)
				if (anEmail as string) contains "icloud.com" or (anEmail as string) contains "me.com" or (anEmail as string) contains "mac.com" then
					set icloudAccount to anAccount
					exit repeat
				end if
			end repeat
		end try
		if icloudAccount is not missing value then exit repeat
	end repeat
	if icloudAccount is missing value then set icloudAccount to item 1 of accounts

	repeat with fn in archiveFolders
		try
			set x to mailbox (fn as string) of icloudAccount
		on error
			make new mailbox with properties {name:(fn as string)} at icloudAccount
		end try
	end repeat

	set autoCount to 0
	set flagCount to 0
	set archiveCount to 0

	set inboxMsgs to messages of inbox
	repeat with aMsg in inboxMsgs
		try
			set sndr to sender of aMsg
			set subj to subject of aMsg
			set hasAttachment to (count of mail attachments of aMsg) > 0

			set isInvoice to false
			repeat with kw in invoiceKeywords
				if subj contains (kw as string) then
					set isInvoice to true
					exit repeat
				end if
			end repeat

			set matchedFlag to -1
			set matchedFolder to ""
			repeat with rule in senderRules
				if sndr contains (item 1 of rule as string) then
					set matchedFlag to item 2 of rule
					set matchedFolder to item 3 of rule
					exit repeat
				end if
			end repeat

			if matchedFlag is 0 then
				move aMsg to mailbox matchedFolder of icloudAccount
				set autoCount to autoCount + 1
			else if matchedFlag > 0 then
				set flag index of aMsg to matchedFlag
				set flagCount to flagCount + 1
			else
				if hasAttachment or isInvoice then
					set flag index of aMsg to 1
					set flagCount to flagCount + 1
				end if
			end if
		on error
		end try
	end repeat

	try
		set archiveMb to mailbox "Archive" of icloudAccount
		set archivedMsgs to messages of archiveMb
		repeat with aMsg in archivedMsgs
			try
				set sndr to sender of aMsg
				set matchedFolder to ""

				repeat with rule in senderRules
					if sndr contains (item 1 of rule as string) then
						set matchedFolder to item 3 of rule
						exit repeat
					end if
				end repeat

				if matchedFolder is "" then
					repeat with pd in personalDomains
						if sndr contains (pd as string) then
							set matchedFolder to "Archive/Personal"
							exit repeat
						end if
					end repeat
				end if

				if matchedFolder is not "" then
					move aMsg to mailbox matchedFolder of icloudAccount
					set archiveCount to archiveCount + 1
				end if
			on error
			end try
		end repeat
	on error
	end try

	if autoCount > 0 or archiveCount > 0 then
		set msg to ""
		if autoCount > 0 then set msg to msg & autoCount & " auto-sorted"
		if autoCount > 0 and archiveCount > 0 then set msg to msg & " · "
		if archiveCount > 0 then set msg to msg & archiveCount & " archived"
		display notification msg with title "MailSorter"
	end if

	end timeout
end tell
```

--- END PROMPT ---

---

## After you have your script

1. Open **Script Editor** (Applications → Utilities → Script Editor)
2. Paste the generated script
3. Press **Run (▶)** — your inbox will sort in real time
4. To run automatically every 5 minutes, follow the launchd setup in [README.md](README.md)
5. To fix flag colors on existing archived mail, run [MailFlagFixer.applescript](MailFlagFixer.applescript)

## Tips

- **Something sorted wrong?** Find the sender's domain and add or move the rule.
- **New sender you want to add?** One line in the `senderRules` list.
- **Want to improve your script?** Paste it back into the LLM with: *"Here is my current MailSorter config. I want to add rules for [new senders]. Update the senderRules list."*
- **Dutch users:** use [MailSorter_NL.applescript](MailSorter_NL.applescript) as your starting point — 100+ Dutch senders are already pre-configured.
