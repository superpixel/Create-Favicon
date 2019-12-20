(*
	Create Favicon
	Version 1.0 - December 20, 2019
*)



on run
	if my checkToolRequirements() is true then
		try
			set picked_files to choose file of type {"png"} with prompt "Choose multiple PNG files to convert to a Favicon:" with multiple selections allowed
		on error
			return
		end try
		my processFiles(picked_files)
	end if
end run

on open dropped_files
	if my checkToolRequirements() is true then
		my processFiles(dropped_files)
	end if
end open

on checkToolRequirements()
	try
		do shell script "/usr/local/bin/convert -version"
	on error --err_msg number err_num
		beep
		set requirement_warning to display alert "ImageMagick could not be found." message Â
			"It is assumed that ImageMagick is installed via Homebrew." & space & Â
			"If necessary, get Homebrew first and then install ImageMagick." buttons Â
			{"Get Homebrew", "Install ImageMagick", "Quit"} default button "Quit"
		if button returned of requirement_warning is equal to "Get Homebrew" then
			open location "https://brew.sh"
			return false
		else if button returned of requirement_warning is equal to "Install ImageMagick" then
			tell application id "com.apple.terminal"
				activate
				do script "/usr/local/bin/brew install imagemagick"
			end tell
			return false
		else
			return false
		end if
	end try
	return true
end checkToolRequirements

on processFiles(the_files)
	-- Define output path
	set output_path to quoted form of (POSIX path of (path to desktop folder from user domain) & my saveFileName())
	-- Define input files
	set input_files to ""
	repeat with i from 1 to number of items in the_files
		set this_file to item i of the_files
		set input_files to input_files & (quoted form of POSIX path of this_file) & space
	end repeat
	-- Process the files
	try
		set process_result to do shell script "/usr/local/bin/convert" & space & input_files & output_path
	on error err_msg -- number err_num
		beep
		display alert "Could not convert to Favicon." message err_msg buttons {"OK"} default button "OK"
		
		return
	end try
end processFiles

on saveFileName()
	tell application id "com.apple.Finder"
		set standard_exists to exists file "favicon.ico" in (path to desktop folder from user domain)
	end tell
	if standard_exists is true then
		return ((random number from 10000 to 99999) & "-" & "favicon.ico" as text)
	else
		return "favicon.ico"
	end if
end saveFileName
