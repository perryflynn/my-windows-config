# my-windows-config
Disable Cortana, forced updates and other annoying stuff

## Install

```ps1
new-item -itemtype directory -force -path \configs
Invoke-WebRequest -Uri "https://github.com/perryflynn/my-windows-config/raw/main/set-policies.ps1" -OutFile "\configs\set-policies.ps1"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
\configs\set-policies.ps1
```

## Example output

**PS C:\WINDOWS\system32>** `\configs\set-policies.ps1`

```
[i] PolicyFileEditor cmdlet already installed
[i] Policy File: C:\WINDOWS\system32\GroupPolicy\Machine\registry.pol
[*] Disable Windows Advertising ID
[*] Disable data collection for input personalization
[*] Disable online tips
[i] Skip start menu layout stuff as there is no startlayout.xml present.
[*] Disable cloud content
[*] Disable telemetry and feedback
[*] Disable MS Edge data collection
[*] Disable Windows Preview builds
[*] Disable Microsoft accounts
[*] COnfigure the new MS Edge (Chromium)
[*] Disable Windows feeds
[*] Disable cortana and cloud functions in windows search
[*] Disable data synchronization
[*] Enable info dialog about last logon
[*] Disable automatic updates, show notifications on new updates
[*] Disable error reporting
[*] Disable consumer experience reporting
[*] Disable application telemetry
[*] Apply changes...
Updating policy...

Computer Policy update has completed successfully.
User Policy update has completed successfully.

[*] Generate report in C:\Temp\GPReport.html
```
