-- =====================================================
-- MailSorter_OneTime — Generic Edition v1.0
-- Run once to sort everything currently in your Inbox.
-- Uses the same rules as MailSorter.applescript.
-- =====================================================
-- IMPORTANT: Copy your senderRules, archiveFolders,
-- invoiceKeywords, and personalDomains from
-- MailSorter.applescript into this file before running.
-- =====================================================


-- =====================================================
-- CONFIGURATION — paste your config from MailSorter.applescript
-- =====================================================

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

set invoiceKeywords to {"invoice", "payment due", "overdue", "reminder", "statement", "factuur", "betaling", "rekening", "nota", "herinnering"}

set personalDomains to {"@gmail.com", "@icloud.com", "@outlook.com", "@hotmail.com", "@proton.me", "@yahoo.com", "@me.com"}

set senderRules to {¬
	{"@linkedin.com",                   0, "Archive/LinkedIn"}, ¬
	{"@lnkd.in",                        0, "Archive/LinkedIn"}, ¬
	{"@postnl.nl",                      0, "Archive/Deliveries"}, ¬
	{"@dhl.com",                        0, "Archive/Deliveries"}, ¬
	{"@dpd.nl",                         0, "Archive/Deliveries"}, ¬
	{"@ups.com",                        0, "Archive/Deliveries"}, ¬
	{"@fedex.com",                      0, "Archive/Deliveries"}, ¬
	{"@amazon.com",                     0, "Archive/Deliveries"}, ¬
	{"@bpost.be",                       0, "Archive/Deliveries"}, ¬
	{"@github.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@vercel.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@supabase.com",                   0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@openai.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@anthropic.com",                  0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@windsurf.ai",                    0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@resend.com",                     0, "Archive/Newsletters/Tech & AI"}, ¬
	{"@zalando.com",                    0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@zalando.nl",                     0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@uniqlo.com",                     0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@shopifyemail.com",               0, "Archive/Newsletters/Fashion & Shopping"}, ¬
	{"@ticketswap.com",                 0, "Archive/Newsletters/Events & Going Out"}, ¬
	{"@eventbrite.com",                 0, "Archive/Newsletters/Events & Going Out"}, ¬
	{"@paylogic.com",                   0, "Archive/Newsletters/Events & Going Out"}, ¬
	{"@strava.com",                     0, "Archive/Newsletters/Food & Sports"}, ¬
	{"@toogoodtogo.com",                0, "Archive/Newsletters/Food & Sports"}, ¬
	{"@airbnb.com",                     0, "Archive/Transport"}, ¬
	{"@easyjet.com",                    0, "Archive/Transport"}, ¬
	{"@ryanair.com",                    0, "Archive/Transport"}, ¬
	{"@socialdeal.nl",                  0, "Archive/Newsletters"}, ¬
	{"@indeedemail.com",                0, "Archive/Newsletters"}, ¬
	{"@yourbank.com",                   2, "Archive/Financial"}, ¬
	{"@paypal.com",                     2, "Archive/Financial"}, ¬
	{"@klarna.com",                     2, "Archive/Financial"}, ¬
	{"@communications.paypal.com",      2, "Archive/Financial"}, ¬
	{"@docusign.com",                   3, "Archive/Business"}, ¬
	{"@docusign.net",                   3, "Archive/Business"}, ¬
	{"@eumail.docusign.net",            3, "Archive/Business"}, ¬
	{"@hellosign.com",                  3, "Archive/Business"}, ¬
	{"@youremployer.com",               4, "Archive/Work"}, ¬
	{"@zillow.com",                     5, "Archive/Housing/Search"}, ¬
	{"@realtor.com",                    5, "Archive/Housing/Search"}, ¬
	{"@funda.nl",                       5, "Archive/Housing/Search"}, ¬
	{"@medicare.gov",                   6, "Archive/Health"}, ¬
	{"@ssa.gov",                        6, "Archive/Government"} ¬
}

-- =====================================================
-- ENGINE — do not edit below this line
-- =====================================================

tell application "Mail"
	with timeout of 1800 seconds

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

	set inboxMsgs to messages of inbox
	set total to count of inboxMsgs
	set movedCount to 0
	set flaggedCount to 0

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
				set movedCount to movedCount + 1
			else if matchedFlag > 0 then
				set flag index of aMsg to matchedFlag
				set flaggedCount to flaggedCount + 1
			else
				if hasAttachment or isInvoice then
					set flag index of aMsg to 1
					set flaggedCount to flaggedCount + 1
				end if
			end if
		on error
		end try
	end repeat

	display dialog "Done!" & return & return & "Moved to archive:  " & movedCount & return & "Flagged in inbox:   " & flaggedCount & return & return & "Total processed: " & total buttons {"OK"} default button "OK" with title "MailSorter One-Time"

	end timeout
end tell
