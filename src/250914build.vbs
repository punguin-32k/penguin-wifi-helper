Set objShell = CreateObject("WScript.Shell")
objShell.Popup "Current version is a Build version and does not represent the final release.", 10, "Notice", 64
objShell.Popup "1. Fixed Gehang downgrade reboot loop caused by deletion of fota_upi" & vbCrLf & "" & vbCrLf & "2. Added new device type support in ZTE ZXIC universal remote control removal" & vbCrLf & "" & vbCrLf & "3. Added ATweb write functionality (available under Option E)", 10, "5.1-build-250914 Update Notes:", 0
