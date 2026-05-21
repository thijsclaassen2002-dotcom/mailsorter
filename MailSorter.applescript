-- =====================================================
-- MailSorter — Generic Edition v1.0
-- An automatic Apple Mail organizer for macOS
-- https://github.com/yourusername/mailsorter
-- =====================================================
--
-- HOW IT WORKS:
--   Layer 1 — Inbox: checks every new message against your rules.
--     • Known sender, auto-sort (flag 0): moved to Archive immediately, no flag.
--     • Known sender, important (flag 1–6): gets a color flag, stays in Inbox.
--       When you press Archive, Layer 2 routes it to the right folder.
--     • Unknown sender with attachment or invoice keyword: red flag (action needed).
--   Layer 2 — Archive root: anything you manually archived routes to the right subfolder.
--   Flags stay on archived mail so you always know which category it belongs to.
--
-- FLAG COLORS:
--   0 = no flag        (auto-sort / newsletters)
--   1 = red            (action required — unknown sender with attachment/invoice)
--   2 = orange         (financial)
--   3 = yellow         (business / legal)
--   4 = green          (work)
--   5 = blue           (housing / real estate)
--   6 = purple         (health & government)
--
-- SETUP:
--   1. Edit the CONFIGURATION section below to match your life.
--   2. Open Script Editor, run this script once manually to verify.
--   3. Install as a launchd agent (see README.md) to run every 5 minutes.
--
-- RULE FORMAT: {"@sender-fragment.com", flag_color, "Archive/FolderName"}
--   • sender_fragment is matched case-insensitively anywhere in the From address.
--   • flag_color 0 = auto-archive immediately (no flag needed).
--   • flag_color 1–6 = assign color, leave in Inbox; Archive press → Layer 2 routes it.
--   • Rules are checked top-to-bottom. FIRST MATCH WINS.
-- =====================================================


-- =====================================================
-- CONFIGURATION — only edit this section
-- =====================================================

-- Your archive folder structure.
-- Parent folders must appear before their children.
set archiveFolders to {¬
	"Archive/Financial", ¬
	"Archive/Financial/Mortgage", ¬
	"Archive/Business", ¬
	"Archive/Work", ¬
	"Archive/Housing", ¬
	"Archive/Housing/Search", ¬
	"Archive/Health", ¬
	"Archive/Government", ¬
	"Archive/Personal", ¬
	"Archive/LinkedIn", ¬
	"Archive/Deliveries", ¬
	"Archive/Transport", ¬
	"Archive/Newsletters", ¬
	"Archive/Newsletters/Fashion & Shopping", ¬
	"Archive/Newsletters/Tech & AI", ¬
	"Archive/Newsletters/Events & Going Out", ¬
	"Archive/Newsletters/Food & Sports" ¬
}

-- Subject-line keywords that indicate an invoice or payment (triggers red flag for unknown senders).
set invoiceKeywords to {"invoice", "payment due", "overdue", "reminder", "statement", "factuur", "betaling", "rekening", "nota", "herinnering"}

-- Personal email domains — unrecognized senders from these go to Archive/Personal when archived.
set personalDomains to {"@gmail.com", "@icloud.com", "@outlook.com", "@hotmail.com", "@proton.me", "@yahoo.com", "@me.com"}

-- ── SENDER RULES ─────────────────────────────────────────────────────────────
-- Format: {"@domain-fragment", flag_color, "Archive/TargetFolder"}
-- Tip: use the most specific fragment first to avoid false matches.
-- ─────────────────────────────────────────────────────────────────────────────
set senderRules to {¬
	¬
	-- ── AUTO-SORT (flag = 0): moves silently to archive, no flag ─────────────
	¬
	-- LinkedIn
	{"@linkedin.com",                   0, "Archive/LinkedIn"}, ¬
	{"@lnkd.in",                        0, "Archive/LinkedIn"}, ¬
	¬
	-- Deliveries
	{"@postnl.nl",                      0, "Archive/Deliveries"}, ¬
	{"@edm.postnl.nl",                  0, "Archive/Deliveries"}, ¬
	{"@dhl.com",                        0, "Archive/Deliveries"}, ¬
	{"@dpd.nl",                         0, "Archive/Deliveries"}, ¬
	{"@ups.com",                        0, "Archive/Deliveries"}, ¬
	{"@fedex.com",                      0, "Archive/Deliveries"}, ¬
	{"@amazon.com",                     0, "Archive/Deliveries"}, ¬
	{"@bpost.be",                       0, "Archive/Deliveries"}, ¬
	¬
	-- Tech & AI newsletters
	{"@github.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@vercel.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@supabase.com",                   0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@openai.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@anthropic.com",                  0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@windsurf.ai",                    0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@resend.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	¬
	-- Fashion & Shopping newsletters
	{"@zalando.com",                    0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@zalando.nl",                     0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@uniqlo.com",                     0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@shopifyemail.com",               0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	¬
	-- Events & Going Out newsletters
	{"@ticketswap.com",                 0, "Archive/Newsletters/Events & Going Out"}, ¬
	{"@eventbrite.com",                 0, "Archive/Newsletters/Events & Going Out"}, ¬
	{"@paylogic.com",                   0, "Archive/Newsletters/Events & Going Out"}, ¬
	¬
	-- Food & Sports newsletters
	{"@strava.com",                     0, "Archive/Newsletters/Food & Sports"}, ¬
	{"@toogoodtogo.com",                0, "Archive/Newsletters/Food & Sports"}, ¬
	¬
	-- Transport
	{"@airbnb.com",                     0, "Archive/Transport"}, ¬
	{"@easyjet.com",                    0, "Archive/Transport"}, ¬
	{"@ryanair.com",                    0, "Archive/Transport"}, ¬
	¬
	-- Miscellaneous newsletters
	{"@socialdeal.nl",                  0, "Archive/Newsletters"}, ¬
	{"@indeedemail.com",                0, "Archive/Newsletters"}, ¬
	¬
	-- ── FINANCIAL (flag = 2, orange): stays in inbox ─────────────────────────
	-- Replace with your own bank and financial services.
	¬
	{"@yourbank.com",                   2, "Archive/Financial"}, ¬
	{"@paypal.com",                     2, "Archive/Financial"}, ¬
	{"@klarna.com",                     2, "Archive/Financial"}, ¬
	{"@communications.paypal.com",      2, "Archive/Financial"}, ¬
	¬
	-- ── BUSINESS / LEGAL (flag = 3, yellow): stays in inbox ──────────────────
	¬
	{"@docusign.com",                   3, "Archive/Business"}, ¬
	{"@docusign.net",                   3, "Archive/Business"}, ¬
	{"@eumail.docusign.net",            3, "Archive/Business"}, ¬
	{"@hellosign.com",                  3, "Archive/Business"}, ¬
	¬
	-- ── WORK (flag = 4, green): stays in inbox ───────────────────────────────
	-- Add your employer(s) and work-related senders here.
	¬
	{"@youremployer.com",               4, "Archive/Work"}, ¬
	¬
	-- ── HOUSING / REAL ESTATE (flag = 5, blue): stays in inbox ──────────────
	¬
	{"@zillow.com",                     5, "Archive/Housing/Search"}, ¬
	{"@realtor.com",                    5, "Archive/Housing/Search"}, ¬
	{"@funda.nl",                       5, "Archive/Housing/Search"}, ¬
	¬
	-- ── HEALTH & GOVERNMENT (flag = 6, purple): stays in inbox ──────────────
	-- Add your doctors, insurance, and government agencies.
	¬
	{"@medicare.gov",                   6, "Archive/Health"}, ¬
	{"@ssa.gov",                        6, "Archive/Government"} ¬
}

-- =====================================================
-- ENGINE — do not edit below this line
-- =====================================================

tell application "Mail"
	with timeout of 300 seconds

	-- Find iCloud (or first) account
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

	-- Create any missing folders
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

	-- ── LAYER 1: Process Inbox ────────────────────────────────────────────────
	set inboxMsgs to messages of inbox
	repeat with aMsg in inboxMsgs
		try
			set sndr to sender of aMsg
			set subj to subject of aMsg
			set hasAttachment to (count of mail attachments of aMsg) > 0

			-- Check subject for invoice keywords
			set isInvoice to false
			repeat with kw in invoiceKeywords
				if subj contains (kw as string) then
					set isInvoice to true
					exit repeat
				end if
			end repeat

			-- Match sender against rules (first match wins)
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
				-- Auto-sort: archive immediately, no flag
				move aMsg to mailbox matchedFolder of icloudAccount
				set autoCount to autoCount + 1
			else if matchedFlag > 0 then
				-- Known sender: color flag, stays in Inbox
				set flag index of aMsg to matchedFlag
				set flagCount to flagCount + 1
			else
				-- Unknown sender: red flag only if action is needed
				if hasAttachment or isInvoice then
					set flag index of aMsg to 1
					set flagCount to flagCount + 1
				end if
			end if
		on error
		end try
	end repeat

	-- ── LAYER 2: Route Archive root to subfolders (flags preserved) ───────────
	try
		set archiveMb to mailbox "Archive" of icloudAccount
		set archivedMsgs to messages of archiveMb
		repeat with aMsg in archivedMsgs
			try
				set sndr to sender of aMsg
				set matchedFolder to ""

				-- Match against sender rules
				repeat with rule in senderRules
					if sndr contains (item 1 of rule as string) then
						set matchedFolder to item 3 of rule
						exit repeat
					end if
				end repeat

				-- Fallback: personal domains → Archive/Personal
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

	-- Show notification if anything was sorted
	if autoCount > 0 or archiveCount > 0 then
		set msg to ""
		if autoCount > 0 then set msg to msg & autoCount & " auto-sorted"
		if autoCount > 0 and archiveCount > 0 then set msg to msg & " · "
		if archiveCount > 0 then set msg to msg & archiveCount & " archived"
		display notification msg with title "MailSorter"
	end if

	end timeout
end tell
