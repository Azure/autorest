$ErrorActionPreference = 'silentlycontinue'
write-host -fore green "Verifying requirements to build.`n"

write-host -fore cyan -NoNewline "  Rush: "

$rush = get-command rush
if ( -not $rush ) {
  write-host -fore red "NOT INSTALLED."
  write-host -fore cyan "  You must install 'rush' to continue:"
  write-host -fore yellow '  > npm install -g "@microsoft/rush"'
  write-host -fore red "`n`n`n"
  exit 1
}
write-host -fore green "INSTALLED"

write-host -fore green "`nAll requirements met.`n"

write-host -fore cyan "Common rush commands:"
write-host -fore yellow '  > rush update  ' -NoNewline
write-host -fore gray '  # installs package dependencies ' 

write-host -fore yellow '  > rush rebuild ' -NoNewline
write-host -fore gray '  # rebuilds all libraries' 

write-host -fore yellow '  > rush watch   ' -NoNewline
write-host -fore gray '  # continual build when files change' 

write-host "`n`n`n"
exit 0