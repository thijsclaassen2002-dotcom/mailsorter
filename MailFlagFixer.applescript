-- =====================================================
-- MailFlagFixer — Generic Edition v1.0
-- Run once to fix flag colors on all archived mail.
-- Maps Archive subfolder names to their correct flag color.
-- =====================================================
-- Edit the folderFlagMap below to match your folder structure
-- and desired flag colors before running.
-- =====================================================

-- =====================================================
-- CONFIGURATION
-- =====================================================

-- {folder_path, flag_color}
-- flag_color: 0=none, 1=red, 2=orange, 3=yellow, 4=green, 5=blue, 6=purple
set folderFlagMap to {¬
	{"Archive/Financial",                        2}, ¬
	{"Archive/Financial/Mortgage",               2}, ¬
	{"Archive/Business",                         3}, ¬
	{"Archive/Work",                             4}, ¬
	{"Archive/Housing",                          5}, ¬
	{"Archive/Housing/Search",                   5}, ¬
	{"Archive/Health",                           6}, ¬
	{"Archive/Government",                       6}, ¬
	{"Archive/Personal",                         0}, ¬
	{"Archive/LinkedIn",                         0}, ¬
	{"Archive/Deliveries",                       0}, ¬
	{"Archive/Transport",                        0}, ¬
	{"Archive/Newsletters",                      0}, ¬
	{"Archive/Newsletters/Fashion & Shopping",   0}, ¬
	{"Archive/Newsletters/Tech & AI",            0}, ¬
	{"Archive/Newsletters/Events & Going Out",   0}, ¬
	{"Archive/Newsletters/Food & Sports",        0} ¬
}

-- =====================================================
-- ENGINE
-- =====================================================

tell application "Mail"
	with timeout of 3600 seconds

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

	set totalFixed to 0

	repeat with mapItem in folderFlagMap
		set folderPath to item 1 of mapItem
		set targetFlag to item 2 of mapItem
		try
			set mb to mailbox folderPath of icloudAccount
			set msgs to messages of mb
			repeat with aMsg in msgs
				try
					if (flag index of aMsg) is not targetFlag then
						set flag index of aMsg to targetFlag
						set totalFixed to totalFixed + 1
					end if
				on error
				end try
			end repeat
		on error
		end try
	end repeat

	display dialog "Done! " & totalFixed & " flag(s) corrected across all Archive folders." & return & return & "All archived mail now shows its correct category color." buttons {"OK"} default button "OK" with title "MailFlagFixer"

	end timeout
end tell
