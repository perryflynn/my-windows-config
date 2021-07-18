# Disable annoying stuff in Windows 10 with group policies
# by Christian Blechert <christian@serverless.industries>
# 2021-07-14

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

# Start menu
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.StartMenu::LockedStartLayout
if (Test-Path -Path "C:\configs\startlayout.xml" -PathType Leaf) 
{
    Write-Host "[*] Use C:\configs\startlayout.xml as start menu layout"
    @(
        New-Object psobject -Property @{ ValueName='LockedStartLayout'; Data = 1; Type = 'DWord' }
        New-Object psobject -Property @{ ValueName='StartLayoutFile'; Data = "C:\configs\startlayout.xml"; Type = 'ExpandString' }
    ) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Explorer"
}
else 
{
    Write-Host "[i] Skip start menu layout stuff as there is no startlayout.xml present."
    @(
        New-Object psobject -Property @{ ValueName='LockedStartLayout' }
        New-Object psobject -Property @{ ValueName='StartLayoutFile' }
    ) | Remove-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Explorer"
}

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
Write-Host "[*] COnfigure the new MS Edge (Chromium)"
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
Write-Host "[*] Disable cortana and cloud functions in windows search"
@(
    New-Object psobject -Property @{ ValueName='AllowCloudSearch'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortanaAboveLock'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortana'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCortanaInAAD'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowSearchToUseLocation'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCloudSearch'; Data = 0; Type = 'DWord' }
    New-Object psobject -Property @{ ValueName='AllowCloudSearch'; Data = 0; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\Windows Search"

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
    Write-Host "[i] 'Show logoninfo' is disabled. Create a empty 'C:\config\enable-logoninfo.txt' to enable."
    @(
        New-Object psobject -Property @{ ValueName='DisplayLastLogonInfo' }
    ) | Remove-PolicyFileEntry -Path $UserDir -Key "Software\Microsoft\Windows\CurrentVersion\Policies\System"
}

# Windows Updates
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.WindowsUpdate::AutoUpdateCfg
Write-Host "[*] Disable automatic updates, show notifications on new updates"
@(
    # auto updates (yes 1 means do updates)
    New-Object psobject -Property @{ ValueName='NoAutoUpdate'; Data = 1; Type = 'DWord' }
    # download and install
    New-Object psobject -Property @{ ValueName='AUOptions'; Data = 4; Type = 'DWord' }
    # no automatic reboot
    New-Object psobject -Property @{ ValueName='NoAutoRebootWithLoggedOnUsers'; Data = 1; Type = 'DWord' }
) | Set-PolicyFileEntry -Path $UserDir -Key "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"

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

# refresh and generate report
Write-Host "[*] Apply changes..."
gpupdate.exe /force

Write-Host "[*] Generate report in C:\Temp\GPReport.html"
Remove-Item -Force \Temp\GPReport.html
gpresult.exe /H \Temp\GPReport.html
