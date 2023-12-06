# my-windows-config
Disable Cortana, forced updates and other annoying stuff

## Install

```ps1
new-item -itemtype directory -force -path \configs
Invoke-WebRequest -Uri "https://github.com/perryflynn/my-windows-config/raw/main/set-policies.ps1" -OutFile "\configs\set-policies.ps1"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
\configs\set-policies.ps1
```

## Feature Flags

Feature Flags can be set by just creating empty text files in `C:\configs`:

| File | Description|
|------|------------|
| `enable-logoninfo.txt` | Show infos about last successful and failed login when logging in |
| `enable-trueshutdown-icon.txt` | Place shortcuts on the Desktop for reboot and shutdown via `shutdown.exe` |
| `enable-uninstallpackages.txt` | Uninstall bloatware; **Check carefully** the `$packages` list in the script if that fits for you! |

## Example output

**PS C:\WINDOWS\system32>** `\configs\set-policies.ps1`

```
[i] PolicyFileEditor cmdlet already installed
[i] Policy File: C:\Windows\system32\GroupPolicy\Machine\registry.pol
[*] Disable Windows Advertising ID
[*] Disable data collection for input personalization
[*] Disable online tips
[*] Disable cloud content
[*] Disable telemetry and feedback
[*] Disable MS Edge data collection
[*] Disable Windows Preview builds
[*] Disable Microsoft accounts
[*] Configure the new MS Edge (Chromium)
[*] Disable Windows feeds
[*] Disable cortana, web search and cloud functions in windows search
[*] Disable data synchronization
[i] 'Show logoninfo' is disabled. Create a empty 'C:\configs\enable-logoninfo.txt' to enable.
[*] Disable automatic updates, show notifications on new updates
[*] Disable wake up system for windows updates
[*] Disable error reporting
[*] Disable consumer experience reporting
[*] Disable application telemetry
[*] Disable auto connect to suggested hotspots
[*] Disable P2P Windows Update features
[*] Disable OneDrive
[*] Create shortcut for true reboot/shutdown on desktop
[*] Uninstall package 'Microsoft.Windows.PeopleExperienceHost_10.0.19041.3636_neutral_neutral_cw5n1h2txyewy' on all accounts
[*] Uninstall package 'Microsoft.XboxGameCallableUI_1000.19041.3636.0_neutral_neutral_cw5n1h2txyewy' on all accounts
[*] Apply changes...
Updating policy...

Computer Policy update has completed successfully.
User Policy update has completed successfully.

[*] Generate report in C:\Temp\GPReport.html
```
