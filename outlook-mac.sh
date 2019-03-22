#!/bin/bash

download_signature() {
	SIGNATURE_URL="https://www.doncastersc.vic.edu.au/doncaster-signature-final.html"
	echo "downloading signature..."
	SIGNATURE_HTML=`curl -s "$SIGNATURE_URL"`
	echo "done."
}

setup_signature() {
	echo "setting up signature..."

	SIGNATURE_HTML_ESCAPED=`echo "$SIGNATURE_HTML" | sed -e 's/"/\\\"/g'`

	osascript <<END
tell application id "com.microsoft.Outlook"
	make new signature with properties {name:"DSC Signature", content:"$SIGNATURE_HTML_ESCAPED"}
end tell
END

	if [ -f "$HOME/Library/Preferences/com.microsoft.Outlook.plist" ]; then
		defaults write "$HOME/Library/Preferences/com.microsoft.Outlook.plist" "AutomaticallyDownloadExternalContent" -int 2
		defaults write "$HOME/Library/Preferences/com.microsoft.Outlook.plist" "Send Pictures With Document" -int 0
	fi

	if [ -f "$HOME/Library/Containers/com.microsoft.Outlook/Data/Library/Preferences/com.microsoft.Outlook.plist" ]; then
		defaults write "$HOME/Library/Containers/com.microsoft.Outlook/Data/Library/Preferences/com.microsoft.Outlook.plist" "AutomaticallyDownloadExternalContent" -int 2
		defaults write "$HOME/Library/Containers/com.microsoft.Outlook/Data/Library/Preferences/com.microsoft.Outlook.plist" "Send Pictures With Document" -int 0
	fi

	echo "done."
	echo "You can close this window now."
}


download_signature
setup_signature
