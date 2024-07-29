#Requires -Version 7
# Disable annoying stuff in Windows 10 with group policies
# by Christian Blechert <christian@serverless.industries>
# 2021-07-18

$ErrorActionPreference = "Stop"

# Install required powershell modules
if (-not (Get-Command "Set-PolicyFileEntry" -errorAction SilentlyContinue))
{
    Write-Host "[*] PolicyFileEditor cmdlet not found, install it..."
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    Install-Module -Name PolicyFileEditor -RequiredVersion 3.0.0 -Scope CurrentUser
}
else
{
    Write-Host "[i] PolicyFileEditor cmdlet already installed"
}

# Policy File
$UserDir = "$env:windir\system32\GroupPolicy\Machine\registry.pol"
Write-Host "[i] Policy File: $UserDir"

# Windows Advertising ID
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.UserProfiles::DisableAdvertisingId
Write-Host "[*] Disable Windows Advertising ID"
@(
    New-Object psobject -Property @{ ValueName='DisabledByGroupPolicy'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\AdvertisingInfo"

# Input personalization
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Globalization::ImplicitDataCollectionOff_2
Write-Host "[*] Disable data collection for input personalization"
@(
    New-Object psobject -Property @{ ValueName='RestrictImplicitTextCollection'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='RestrictImplicitInkCollection'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "SOFTWARE\Policies\Microsoft\InputPersonalization"

# Online tips
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ControlPanel::AllowOnlineTips
Write-Host "[*] Disable online tips"
@(
    New-Object psobject -Property @{ ValueName='AllowOnlineTips'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

# cloud content
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.CloudContent::DisableSoftLanding
Write-Host "[*] Disable cloud content"
@(
    New-Object psobject -Property @{ ValueName='DisableCloudOptimizedContent'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableSoftLanding'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableWindowsConsumerFeatures'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\CloudContent"

# Data Collection and Preview Builds
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.DataCollection::AllowCommercialDataPipeline
Write-Host "[*] Disable telemetry and feedback"
@(
    New-Object psobject -Property @{ ValueName='AllowTelemetry'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableEnterpriseAuthProxy'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='TelemetryProxyServer'; Data = '127.0.0.1:64523'; Type = 'String' }
    New-Object psobject -Property @{ ValueName='DisableTelemetryOptInChangeNotification'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableTelemetryOptInSettingsUx'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DoNotShowFeedbackNotifications'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\DataCollection"

Write-Host "[*] Disable MS Edge data collection"
@(
    New-Object psobject -Property @{ ValueName='MicrosoftEdgeDataOptIn'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection"

Write-Host "[*] Disable Windows Preview builds"
@(
    New-Object psobject -Property @{ ValueName='EnableConfigFlighting'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='EnableExperimentation'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowBuildPreview'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\PreviewBuilds"

# Microsoft Account
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.MicrosoftAccount::MicrosoftAccount_DisableUserAuth
Write-Host "[*] Disable Microsoft accounts"
@(
    New-Object psobject -Property @{ ValueName='DisableUserAuth'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\MicrosoftAccount"

# Microsoft Edge
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.MicrosoftEdge::AllowFlash
Write-Host "[*] Configure the new MS Edge (Chromium)"
@(
    New-Object psobject -Property @{ ValueName='FlashPlayerEnabled'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\MicrosoftEdge\Addons"

@(
    New-Object psobject -Property @{ ValueName='AllowWebContentOnNewTabPage'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\MicrosoftEdge\ServiceUI"

@(
    New-Object psobject -Property @{ ValueName='ConfigureOpenMicrosoftEdgeWith'; Data = 2; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\MicrosoftEdge\Internet Settings"

# Windows Feeds
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.Feeds::EnableFeeds
Write-Host "[*] Disable Windows feeds"
@(
    New-Object psobject -Property @{ ValueName='EnableFeeds'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Windows Feeds"

# Windows Search
# https://admx.help/?Category=Windows_10_2016&Policy=FullArmor.Policies.3B9EA2B5_A1D1_4CD5_9EDE_75B22990BC21::AllowCloudSearch
Write-Host "[*] Disable cortana, web search and cloud functions in windows search"
@(
    New-Object psobject -Property @{ ValueName='AllowCloudSearch'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortanaAboveLock'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortana'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortanaInAAD'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowSearchToUseLocation'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableWebSearch'; Data = 1; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='ConnectedSearchUseWeb'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Windows Search"

@(
    New-Object psobject -Property @{ ValueName='DisableSearchBoxSuggestions'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Explorer"

# Sync
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.SettingSync::DisableSettingSync
Write-Host "[*] Disable data synchronization"
@(
    New-Object psobject -Property @{ ValueName='DisableSettingSync'; Data = 2; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='DisableSettingSyncUserOverride'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\SettingSync"

# Logon options
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsLogon2::DisplayLastLogonInfoDescription
if (Test-Path -Path "C:\configs\enable-logoninfo.txt" -PathType Leaf)
{
    Write-Host "[*] Enable info dialog about last logon"
    @(
        New-Object psobject -Property @{ ValueName='DisplayLastLogonInfo'; Data = 1; Type = 'DWord' }
    ) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\Windows\CurrentVersion\Policies\System"
}
else
{
    Write-Host "[i] 'Show logoninfo' is disabled. Create a empty 'C:\configs\enable-logoninfo.txt' to enable."
    @(
        New-Object psobject -Property @{ ValueName='DisplayLastLogonInfo' }
    ) | Remove-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\Windows\CurrentVersion\Policies\System"
}

# Windows Updates
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsUpdate::AutoUpdateCfg
# https://docs.microsoft.com/de-de/windows/deployment/update/waas-wu-settings#configuring-automatic-updates-by-editing-the-registry
Write-Host "[*] Disable automatic updates, show notifications on new updates"
@(
    # auto updates
    New-Object psobject -Property @{ ValueName='NoAutoUpdate'; Data = 0; Type = 'DWord' }
    # download and install
    New-Object psobject -Property @{ ValueName='AUOptions'; Data = 4; Type = 'DWord' }
    # every day
    New-Object psobject -Property @{ ValueName='ScheduledInstallDay'; Data = 0; Type = 'DWord' }
    # install at 4 am
    New-Object psobject -Property @{ ValueName='ScheduledInstallTime'; Data = 4; Type = 'DWord' }
    # no automatic reboot
    New-Object psobject -Property @{ ValueName='NoAutoRebootWithLoggedOnUsers'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"

# https://www.pcmag.com/how-to/stop-your-computer-from-randomly-waking-up-from-sleep-mode
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsUpdate::AUPowerManagement_Title
Write-Host "[*] Disable wake up system for windows updates"
@(
    # no wake up for updates
    New-Object psobject -Property @{ ValueName='AUPowerManagement'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\WindowsUpdate"

# Disable Windows 11 Upgrade
Write-Host "[*] Disable Upgrade to Windows 11"
@(
    # enforce specific target version
    New-Object psobject -Property @{ ValueName='TargetReleaseVersion'; Data = 1; Type = 'DWord' }
    # Windows Release
    New-Object psobject -Property @{ ValueName='ProductVersion'; Data = "Windows 10"; Type = 'String' }
    # Windows 10 Release
    New-Object psobject -Property @{ ValueName='TargetReleaseVersionInfo'; Data = "22H2"; Type = 'String' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\WindowsUpdate"

# Error Reporting
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsErrorReporting::WerDisable_2
Write-Host "[*] Disable error reporting"
@(
    New-Object psobject -Property @{ ValueName='Disabled'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"

@(
    New-Object psobject -Property @{ ValueName='DoReport'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\PCHealth\ErrorReporting"

@(
    New-Object psobject -Property @{ ValueName='Disabled'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Windows Error Reporting"

# Customer Experience Reporting
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetCommunicationManagement::CEIPEnable
Write-Host "[*] Disable consumer experience reporting"
@(
    New-Object psobject -Property @{ ValueName='CEIPEnable'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\SQMClient\Windows"

@(
    New-Object psobject -Property @{ ValueName='DisableCustomerImprovementProgram'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Internet Explorer\SQM"

# Application Telemetry
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.ApplicationCompatibility::AppCompatTurnOffApplicationImpactTelemetry
Write-Host "[*] Disable application telemetry"
@(
    New-Object psobject -Property @{ ValueName='AITEnable'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\AppCompat"

# Wifi
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WlanSvc::WiFiSense
Write-Host "[*] Disable auto connect to suggested hotspots"
@(
    # "Connect to suggested open hotspots," "Connect to networks shared by my contacts," and "Enable paid services"
    New-Object psobject -Property @{ ValueName='AutoConnectAllowedOEM'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\wcmsvc\wifinetworkmanager\config"

# Disable alternative windows update sources
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.DeliveryOptimization::DownloadMode
Write-Host "[*] Disable P2P Windows Update features"
@(
    # Bypass P2P and use BITS service
    New-Object psobject -Property @{ ValueName='DODownloadMode'; Data = 100; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"

# Disable OneDrive
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.OneDrive::PreventOnedriveFileSync
Write-Host "[*] Disable OneDrive"
@(
    # Bypass P2P and use BITS service
    New-Object psobject -Property @{ ValueName='DisableFileSyncNGSC'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\OneDrive"

# Disable PowerShell Telemetry
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_telemetry?view=powershell-7.4
Write-Host "[*] Disable PowerShell Telemetry"
if ($null -eq $env:POWERSHELL_TELEMETRY_OPTOUT)
{
    $env:POWERSHELL_TELEMETRY_OPTOUT = "true"
    [Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "true", "Machine")
}

# True reboot/shutdown
if (Test-Path -Path "C:\configs\enable-trueshutdown-icon.txt" -PathType Leaf)
{
    Write-Host "[*] Create shortcut for true reboot/shutdown on desktop"

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\True Reboot.lnk")
    $Shortcut.TargetPath = "shutdown"
    $Shortcut.Arguments = "/r /f /t 0"
    $Shortcut.IconLocation = "C:\Windows\System32\shell32.dll, 41"
    $Shortcut.Save()

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\True Shutdown.lnk")
    $Shortcut.TargetPath = "shutdown"
    $Shortcut.Arguments = "/s /f /t 0"
    $Shortcut.IconLocation = "C:\Windows\System32\shell32.dll, 41"
    $Shortcut.Save()
}
else
{
    Write-Host "[i] True shutdown/reboot icons are disabled. Create a empty 'C:\configs\enable-trueshutdown-icon.txt' to enable."
    Remove-Item -Force -ErrorAction SilentlyContinue -Path "C:\Users\Public\Desktop\True Reboot.lnk"
    Remove-Item -Force -ErrorAction SilentlyContinue -Path "C:\Users\Public\Desktop\True Shutdown.lnk"
}

# uninstall bloatware software
function Remove-AppxPackageAndWait {
    param([string]$Name)

    $pkginfos = Get-AppxPackage -AllUsers -Name "*$($Name)*"
    foreach($pkginfo in $pkginfos)
    {
        Write-Host "[*] Uninstall package '$($pkginfo.PackageFullName)' on all accounts"
        $pkginfo | Remove-AppxPackage -AllUsers
    }
}

function Remove-AppXProvisionedPackageAndWait {
    param([string]$Name)

    $pkginfos = Get-AppXProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$($Name)*" }
    foreach($pkginfo in $pkginfos)
    {
        Write-Host "[*] Uninstall '$($pkginfo.PackageName)' on system-level"
        Remove-AppxProvisionedPackage -Online -AllUsers -PackageName "$($pkginfo.PackageName)"
    }
}

$packages = @(
    '3dbuilder',
    '3dviewer',
    'bingfinance',
    'bingnews',
    'bingsports',
    'bingweather',
    'disney',
    'feedbackhub',
    'getstarted',
    'netflix',
    'officehub',
    'oneconnect',
    'onenote',
    'people',
    'print3d',
    'skypeapp',
    'solitairecollection',
    'soundrecorder',
    'tuneinradio',
    'twitter',
    'windowsalarms',
    'windowscamera',
    'windowscommunicationsapps',
    'windowsmaps',
    'windowsphone',
    'xbox',
    'zunemusic',
    'zunevideo',
    'xing',
    'king.com'
)

if (Test-Path -Path "C:\configs\enable-uninstallpackages.txt" -PathType Leaf)
{
    if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AppXSvc').Start -ne 2) {
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AppXSvc' -Name 'Start' -Value '2'
        Write-Host "[*] Enable AppXSvc Service"
        Write-Host "[!] You have to restart the computer to make uninstalling packages work!"
    }
    else
    {
        Import-Module -usewindowspowershell AppX
        $ErrorActionPreference = "Continue"

        foreach($package in $packages)
        {
            Remove-AppXProvisionedPackageAndWait -Name $package
            Remove-AppxPackageAndWait -Name $package
        }

        $ErrorActionPreference = "Stop"
    }
}
else
{
    Write-Host "[i] Uninstalling packages is disabled. Check packages list carefully and create a empty 'C:\configs\enable-uninstallpackages.txt' to enable."
}

# refresh and generate report
Write-Host "[*] Apply changes..."
gpupdate.exe /force

Write-Host "[*] Generate report in C:\Temp\GPReport.html"
Remove-Item -Force -ErrorAction SilentlyContinue -Path \Temp\GPReport.html
gpresult.exe /H \Temp\GPReport.html
