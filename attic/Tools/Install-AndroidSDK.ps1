<# 
    This script can install additional Android SDK packages 
    (assuming that you installed at least something)
    Gleefully borrowed from the VS 2015 installer.
    
    Usage:
    
    # Install the SDK for Android level 23:
    # AS ADMIN!!
    
    .\Install-AndroidSDK.ps1  -RequestedAndroidPackages android-23 -apilevel 23
#>
param
(
    [String[]]$RequestedAndroidPackages, 
    [String]$Operation, 
    [String]$LogFileName,
    [String]$APILevel
)

function add-content( $path, $text  ) {
    write-host "LOG: $text"
    Microsoft.PowerShell.Management\add-content $path $text 
}

function Set-InstallResult ($Succeeded, $details,$ReturnCode ) {
    write-host $Succeeded $details $ReturnCode  
}

<#
Download and install Android SDK
#>
Function Invoke-InteractiveProcess([String]$FilePath, [string[]]$ArgumentList)
{
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $FilePath
    $startInfo.Arguments = $ArgumentList
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.CreateNoWindow = $true
    $process = [System.Diagnostics.Process]::Start($startInfo)

    return $process
} 


# Android helper functions
Function Get-AndroidHomeFromRegistry
{

    # if ([Environment]::Is64BitOperatingSystem)
    # powershell v1 doesn't have is 64 bit flag.
    if ([environment]::GetEnvironmentVariable("ProgramFiles(x86)"))
    {
        $androidRegistryKey = "HKLM:\SOFTWARE\Wow6432Node\Android SDK Tools"
    }
    else
    {
        $androidRegistryKey = "HKLM:\SOFTWARE\Android SDK Tools"
    }

    if (Test-Path $androidRegistryKey)
    {
        $path = (Get-ItemProperty $androidRegistryKey Path).Path

        if (-not (Test-Path $path))
        {
            $path = $null
        }
    }

    return $path
}


Function Format-PackageList($packages)
{
    "$([Environment]::Newline)  $($packages -join "$([Environment]::Newline)  ")$([Environment]::Newline)"
}

Function Get-AVDConfiguration([String]$FilePath)
{
    $result = @{}

    if (Test-Path $FilePath)
    {
        ForEach ($pair in (Get-Content $FilePath) -split "`n")
        {
            $pair = $pair -split "="

            if ($pair.Count -eq 2)
            {
                $result[$pair[0]] = $pair[1]
            }
        }
    }

    return $result
}

Function Set-AVDConfiguration([String]$FilePath, [Hashtable]$configHashtable)
{
    Remove-Item $FilePath

    ForEach ($key in $configHashtable.Keys | Sort-Object)
    {
        $keyValuePair = "$key=$($configHashtable[$key])"
        Add-Content $FilePath $keyValuePair
    }
}

Function Create-AVD([String]$Name, [String]$DeviceDefinition, [Hashtable]$ConfigurationOptions)
{
    if (-not $Name)
    {
        return
    }

    add-content $logFile "Creating AVD $Name"

    $processArgs = @("create avd",
                     "-n $Name",
                     "-t $currentApiLevel",
                     "-b default/armeabi-v7a")

    if ($DeviceDefinition)
    {
        $processArgs += "-d `"$DeviceDefinition`""
    }

    # Create the AVD
    $process = Invoke-InteractiveProcess `
                    -FilePath "$androidHome\tools\android.bat" `
                    -ArgumentList $processArgs

    while (-not $process.StandardOutput.EndOfStream)
    {
        # Answer 'no' to: Do you wish to create a custom hardware profile [no]
        $firstChar = $process.StandardOutput.Peek()
        if ($firstChar -eq 68)
        {
            $process.StandardInput.WriteLine("no")
        }

        $line = $process.StandardOutput.ReadLine()

        add-content $logFile "$line$([Environment]::NewLine)"
    }

    # needs to kill adb process here because if SecondaryInstaller is launched via ARP, adb
	# server will be launched and prevent ARP from installing other things.
        # need to have -erroraction silentlycontinue, otherwise we'll get an error when adb doesn't exist
    $processAdb = Get-Process adb -erroraction silentlycontinue 
	if ($processAdb)
	{
       $processAdb.Kill()
	}
    if (!$process.HasExited)
    {
	   $process.CloseMainWindow()
    }
    $process.Dispose()

    $avdConfigFile = "$env:HOMEPATH\.android\avd\$defaultAVDName.avd\config.ini"

    if (Test-Path $avdConfigFile)
    {
        $configHashtable = Get-AVDConfiguration $avdConfigFile

        foreach ($key in $ConfigurationOptions.Keys)
        {
            $configHashtable[$key] = $ConfigurationOptions[$key]
        }

        Set-AVDConfiguration $avdConfigFile $configHashtable

        add-content $logFile "Updating AVD $Name to the following hardware config:$([Environment]::NewLine)"

        Get-Content $avdConfigFile | Microsoft.PowerShell.Management\add-content $logFile

        add-content $logFile "$([Environment]::NewLine)"
    }
}

Function Get-DeviceDefinitionNames()
{
    return (& $androidBatch list devices) `
        | Select-String `
            -AllMatches `
            -Pattern 'id: (?<id>\d+) or "(?<deviceName>[\s-_A-Za-z0-9\.]+)"' `
        | Select-Object -ExpandProperty Matches `
        | Foreach-Object {$_.Groups['deviceName'].Value}
}

Function Get-PreferredAVDDeviceDefinition()
{
    $nexusDevices = Get-DeviceDefinitionNames | Where-Object { $_.Contains("Nexus")}

    $deviceDefinition = ""
    $preferredDeviceDefinition = "Galaxy Nexus"

    if ($nexusDevices.Length -gt 0)
    {
        if ($nexusDevices -contains $preferredDeviceDefinition)
        {
            $deviceDefinition = $preferredDeviceDefinition
        }
        else
        {
            $deviceDefinition = $nexusDevices[0]
        }
    }

    return $deviceDefinition
}

Function Get-FileNameWithTimeStamp([String]$OldFileName)
{
	[string]$strippedFileName = [System.IO.Path]::GetFileNameWithoutExtension($OldFileName);
	[string]$extension = [System.IO.Path]::GetExtension($OldFileName);
	[string]$newFileName = $strippedFileName + [DateTime]::Now.ToString("yyyyMMdd-HHmmss") + $extension;
	[string]$newFilePath = [System.IO.Path]::Combine($Env:temp, $newFileName);

	return $newFilePath
}

# OUTPUT: [String[]]A list of packages installed previously.
# Operation:
#     Go to HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\Setup\VS\SecondaryInstaller\AndroidSDKSelector
#     Extract the list of key names.
Function Get-InstalledPackagesFromRegistry()
{
    [String[]]$installedPackagesResult = @()

    $androidPackageSelectorRootRegistryKey = "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\Setup\VS\SecondaryInstaller\AndroidSDKSelector"

    if (Test-Path $androidPackageSelectorRootRegistryKey)
    {
        $installedPackagesItems = Get-ChildItem $androidPackageSelectorRootRegistryKey -ErrorAction SilentlyContinue

        $installedPackagesResult = $installedPackagesItems | Select-Object -ExpandProperty PSChildName
    }
    
    return $installedPackagesResult
}

# INPUT: TargetPackages - a list of packages the user wants to install.
# INPUT: TargetOperation - the current operation.
# OUTPUT: A list of packages the script should install.
# Operation:
#     If the TargetOperation is Repair and no TargetPackages is passed in return a list of alreadyInstalledPackages.
#     Else
#         Return a list of TargetPackages that are not already been installed.
Function Get-DesiredPackages([String[]]$TargetPackages, [String]$TargetOperation)
{
    $alreadyInstalledPackages = Get-InstalledPackagesFromRegistry

    add-content $logFile "Here are list of packages already installed on this system: $alreadyInstalledPackages"

    if ($TargetOperation -eq "Repair")
    {
		# if the user pass in specific packages, then we should repair those.
		if ($TargetPackages)
		{
			add-content $logFile "Repair the following: $TargetPackages"
			return $TargetPackages
		}

		add-content $logFile "Repair the following: $alreadyInstalledPackages"

        return $alreadyInstalledPackages
    }

    $packagesDontNeedToBeInstalled = $TargetPackages | Where { $alreadyInstalledPackages -contains $_ }
    add-content $logFile "Skipping followings because they were installed previously: $packagesDontNeedToBeInstalled"
    $packagesNeedToBeInstalled = $TargetPackages | Where { $alreadyInstalledPackages -notcontains $_ }
    Add-Content $logFile "Install the followings: $packagesNeedToBeInstalled"

	return $packagesNeedToBeInstalled
}

# INPUT: TargetPackages - a list of packages that were installed successfully.
# INPUT: TargetOperation - the current operation.
# Operation:
#     If the TargetOperation is Repair, no opt.
#     Else
#         Write a list of intalled packages to the registry.
Function Set-InstalledPackages([String[]]$InstalledPackages, [String]$TargetOperation)
{
	if ($TargetOperation -eq "Repair")
    {
        add-content $logFile "Repair operation, no registry is set."
    }
    else
    {
        add-content $logFile "Recording the list of installed package. (This step will not remove previously installed items)"

        foreach($p in $InstalledPackages)
        {            
            $androidPackageSelectorRegistryKey = "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\Setup\VS\SecondaryInstaller\AndroidSDKSelector\$p"

            add-content $logFile "Recorded Installed item: $androidPackageSelectorRegistryKey"

            if (-not (Test-Path $androidPackageSelectorRegistryKey))
            {
                $newRegistryItem = New-Item -Force -Path $androidPackageSelectorRegistryKey -ErrorAction SilentlyContinue
            }
        }
    }
}

# INPUT:
# [String[]]$RequestedAndroidPackages, 
# [String]$Operation, 
# [String]$LogFileName,
# [Int]$APILevel

# Get Start Time
$startDTM = (Get-Date)

$logFile = Get-FileNameWithTimeStamp $LogFileName
if ([IO.File]::Exists($logFile))
{
    Remove-Item $logFile
}

add-content $logFile "AndroidSDKInstall: -RequestedAndroidPackages $RequestedAndroidPackages -Operation $Operation -LogFilename $LogFileName -APILevel $APILevel"
add-content $logFile "Android SDK Install starting ..."

$androidHome = Get-AndroidHomeFromRegistry

# if androidHome doesn't exist then we don't have to select products.
if (!$androidHome)
{
    add-content $logFile "No Android SDK detected."

    Set-InstallResult -Succeeded $true
    exit
}

add-content $logFile "AndroidHome:"
add-content $logFile $androidHome

$androidBatch = Join-Path $androidHome "tools\android.bat"

$packageListingOutputRaw = & $androidBatch list sdk --all --extended
$anyAVDsFound = (& $androidBatch list avd) -match "Name: "

$packageRegex = 'id: \d+ or "(?<packageName>[-_A-Za-z0-9\.]+)"'
$availablePackages = [regex]::Matches($packageListingOutputRaw, $packageRegex) | ForEach { $_.Groups["packageName"].Value }

add-content $logFile "Android packages available:"
add-content $logFile "$(Format-PackageList $availablePackages)"

Add-Content $logFile "Requested Packages: $RequestedAndroidPackages"

$desiredPackages = Get-DesiredPackages $RequestedAndroidPackages $Operation

$currentApiLevel = $APILevel

$packagesToInstall = $desiredPackages | Where { $availablePackages -contains $_ }
$packagesNotFound = $desiredPackages | Where { $availablePackages -notcontains $_ }

if ($packagesToInstall)
{
    add-content $logFile "Installing packages:"
    add-content $logFile "$(Format-PackageList $packagesToInstall)"

    $process = Invoke-InteractiveProcess `
                    -FilePath "$androidHome\tools\android.bat" `
                    -ArgumentList @("update sdk",
                                    "-u",
                                    "-a",
                                    "--filter $($packagesToInstall -join ",")")

    $newLine = ''
    while (-not $process.StandardOutput.EndOfStream)
    {
        # we need to read one char at a time, and when we encounter newline, then we pipe it out as output.
        $rawVal = $process.StandardOutput.Read()

        if ($rawVal -eq -1)
        {
            break;
        }

        $oneChar = [char]$rawVal

        # check for new line.
        if ($rawVal -eq 10)
        {
            add-content $logFile "$newLine$([Environment]::NewLine)"
            $newLine = ''
        }
        else
        {          
            $newLine = $newLine + $oneChar

            if ($newLine -match 'Done. \d+ packages installed.')
            {
                break
            }

            # if it match the sentenses
            if ($newLine.StartsWith("Do you accept the license", "InvariantCultureIgnoreCase"))
            {
                $process.StandardInput.WriteLine("y")

                # read the remainder of the line.
                $remainder = $process.StandardOutput.ReadLine();
                add-content $logFile "$newLine$remainder"
                $newLine = ''
            }
            if ($newLine.StartsWith("A folder failed to be moved.", "InvariantCultureIgnoreCase"))
            {
                $process.StandardInput.WriteLine("n")
                
                # read the remaider of the line.
                $remainder = $process.StandardOutput.ReadLine();
                add-content $logFile "$newLine$remainder"
                $newLine = ''

                Set-InstallResult -Succeeded $false -Details The process cannot access the file because another process has locked a portion of the file. -ReturnCode 33
                exit
            }
        }
    }

    # needs to kill adb process here because if SecondaryInstaller is launched via ARP, adb
	# server will be launched and prevent ARP from installing other things.
        # need to have -erroraction silentlycontinue, otherwise we'll get an error when adb doesn't exist
    $processAdb = Get-Process adb -erroraction silentlycontinue 
    if ($processAdb)
    {
        $processAdb.Kill()
    }
    if (!$process.HasExited)
    {
	    $process.CloseMainWindow()
    }
    $process.Dispose()
}

# If there aren't any AVDs present on the system create one.
if (-not $anyAVDsFound)
{
    $deviceDefinition = Get-PreferredAVDDeviceDefinition

    if ($deviceDefinition -and $currentApiLevel)
    {
        $defaultAVDName = "AVD_$($deviceDefinition -replace ' ', '')_ToolsForApacheCordova"

        Create-AVD `
            -Name $defaultAVDName `
            -DeviceDefinition $deviceDefinition `
            -ConfigurationOptions @{"hw.keyboard"  = "yes"; 
                                    "hw.ramSize"  = "768"; 
                                    "vm.heapSize" = "64"}
    }
}

if ($packagesNotFound)
{
    add-content $logFile "WARNING: The following package(s) were not found:"
    add-content $logFile "$(Format-PackageList $packagesNotFound)"

    # return code ERROR_BAD_NETPATH 53
    Set-InstallResult -Succeeded $false -Details "The following package(s) were not downloaded: $packagesNotFound . Please check your internet connection and try again." -ReturnCode 53
    exit
}

Set-InstalledPackages $packagesToInstall $Operation

add-content $logFile "Android SDK Install is successful."

# Get End Time
$endDTM = (Get-Date)
add-content $logFile "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"

Set-InstallResult -Succeeded $true
