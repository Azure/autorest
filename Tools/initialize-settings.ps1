<#
    This script attempts to find the tools required to build Autorest, and 
    if necessary sets the required environment variables and PATH settings
    (in the current process)
    
    When finding a tool, it scans the PATH, then can look recursively in folders
    for the tools.
    
    When it finds a tool, it will remember it by sticking an entry into the 
    registry. 
    
    -reset will nuke the remembered tools.

    UPDATE: Original script (verify-settings.ps1) modified to do the following:
            
            * Check if the required tools are installed on developer machine
            
            * If a tool cannot be found, it is installed
                - Check specific scriptblock for tool to see installation process
            
            * Developer machine is restarted to ensure successful installation
                - NOTE: A few steps are required after restart; check end of script for details
#>

param ( 
    [Switch] $reset # will nuke the remembered tools.
    )

if( $reset ) {
    rmdir -recurse -force -ea 0 "HKCU:\Software\KnownTools"
}

function exists($file) {
    return ($file -and (test-path -PathType Leaf  $file ))
}

function Read-PEHeader ($exe) {
    if( exists $exe ) {
        try {
            [byte[]]$data = New-Object -TypeName System.Byte[] -ArgumentList 4096
            $stream = New-Object -TypeName System.IO.FileStream -ArgumentList ($exe, 'Open', 'Read')
            $stream.Read($data, 0, 4096) | Out-Null
        } finally {
            $stream.Close();
        }
        return $data;
    }
}

function Get-Architecture ($exe) {
   $data = Read-PEHeader $exe
   if( $data -and ([System.BitConverter]::ToInt16($data,0) -eq 23117 )) {
        [int32]$MACHINE_OFFSET = 4
        [int32]$PE_POINTER_OFFSET = 60
        [int32]$PE_HEADER_ADDR = [System.BitConverter]::ToInt32($data, $PE_POINTER_OFFSET)
        
        switch ([System.BitConverter]::ToUInt16($data, $PE_HEADER_ADDR + $MACHINE_OFFSET)) {
            0      { return 'Native' }
            0x014c { return 'x86' }
            0x0200 { return 'Itanium' }
            0x8664 { return 'x64' }
        }
    } 
    return 'Unknown'
}

function Any {
    [CmdletBinding()]
    param( [Parameter(Mandatory = $True)] $Condition, [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $Item )
    begin { $isMatch = $False }
    process { if (& $Condition $Item) { $isMatch = $true } }
    end { $isMatch }
}

function All {
    [CmdletBinding()]
    param( [Parameter(Mandatory = $True)] $Condition, [Parameter(Mandatory = $True, ValueFromPipeline = $True)] $Item )
    begin { $isMatch = $true }
    process { if (-not ($isMatch -and (& $Condition $Item)) ) {$isMatch = $false} }
    end { $isMatch }
}

function Includes { param( [string] $i, [string[]] $all ) $all | All { $i -match $_ } }
function Excludes { param( [string] $i, [string[]] $all )  $all | All { -not ($i -match $_) } }

function Validate (
    [string] $exe,
    [string] $arch,
    [string[]] $include,
    [string[]] $exclude,
    [string] $minimumVersion ) {
    
    if(exists $exe ) {
        $file = dir $exe
        
        if( -not (Includes $file $include) ) {
            return $false
        }
        
        if( -not (Excludes $file $exclude) ) {
            return $false
        }

        if( $arch -and $arch -ne (Get-Architecture $file) ) {
            return $false
        }
        
        if( $minimumVersion -and (([system.version]$minimumVersion) -gt $file.VersionInfo.FileVersion ) ) {
            return $false
        }    
        
        return $file
    }
    return $false
}

function which( 
    [string]$cmd,  
    [string]$arch,
    [string[]] $include = @(),
    [string[]] $exclude= @('arm','_x86','x86_', 'shared'),
    [string] $minimumVersion = $null) {
    
    if( $env:path ) {
        foreach( $dir in $env:path.Split(";")) {
            foreach( $ext in (";.ps1;"+$env:pathext).split(";")) {
                if( $dir -and (resolve-path $dir -ea 0 ) ) {
                    $p = join-path $dir "$cmd$ext"
                    if( exists $p ) { 
                        if( Validate -exe $p $arch $include $exclude $minimumVersion ) {
                            return (dir $p)
                        }
                    }
                }
            }
        }
    }
}

function find-exe ( 
        [string] $exe,
        [string] $arch,
        [string[]] $folders = @("${env:ProgramFiles(x86)}","${env:ProgramFiles}"),
        [string[]] $include = @(),
        [string[]] $exclude= @('arm','_x86','x86_','shared'),
        [string] $minimumVersion = $null
    ) {

    # find exe on path
    $result = which $exe $arch $include $exclude $minimumVersion 
    if( $result )  {
        return $result
    }

    # not in path. check registry
    $kt = "HKCU:\Software\KnownTools"
    if( $arch ) {
        $kt += "\$arch"
    }

    if( $minimumVersion ) {
        $kt += "\$minimumVersion"
        try { $minimumVersion = [system.version]$minimumVersion }  catch {
            try {
                $minimumVersion = [system.version]($minimumVersion + ".0")
            } catch {
                write-error "Bad Version $minimumVersion"
                return;
            }
        }
    }

    if( $result = Validate -exe ((Get-ItemProperty -Path "$kt\$exe" -Name Path -ea 0).Path) $arch $include $exclude $minimumVersion) {
        return $result
    } 

    if( -not $result -or -not (exists $result )) { 
        write-host -fore yellow "Searching for $exe"
        $result = ($folders |% {cmd "/c dir /s/b `"$_\$exe`" 2>nul"  | dir }) `
            |% { Validate -exe $_ $arch $include $exclude $minimumVersion } `
            |? { $_ -ne $false } `
            | Sort-Object -Descending { $_.VersionInfo.FileVersion  } `
            | Select-Object -first 1 
        
        if( $result ) { 
            $result = $result.FullName 
            $null = mkdir -Path "$kt\$exe" -Force
            $null = New-ItemProperty -Path "$kt\$exe" -Name Path -Value $result -force 
        } 
    } 
    if( $result ) {
        return (dir $result)
    }
}

$failing = $false

function Find-OrAdd ( $cmd , $folders = @("${env:ProgramFiles(x86)}","${env:ProgramFiles}"), [scriptblock] $installFunction = $null ) { 
    if( !($exe = which $cmd) ) {
        $exe = find-exe $cmd -folders $folders 
        if( $exe) {
            write-host "Adding '$($exe.Directory)' to PATH".
            # $env:PATH="$env:PATH;$($exe.Directory)"
            $env:PATH="$($exe.Directory);$env:PATH"
        } else {    
            write-host -fore red "Unable to find '$cmd' in path/search folders"
            
            # Install the proper file(s)
            invoke-command -scriptblock $installFunction    
        }
    }
}

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

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
	param([string]$zipfile, [string]$outpath)
	[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$dotnetInstall = {
    # Check to see if .NET 4.5+ is already installed on the machine
    # From https://msdn.microsoft.com/en-us/library/hh925568: "If the Full subkey is not present, then you do not have the .NET Framework 4.5 or later installed"
    $measure = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4' -recurse | Get-ItemProperty -name Version,Release -EA 0 | Where { $_.PSChildName -match 'Full'} | Measure

    # If we found the Full subkey, then the count of $measure will be greater than zero
    if ( $measure.count -gt 0) 
    {
        write-host -fore yellow -back black "Found .NET 4.5 or later on machine"
    }
    else
    {
        $url = "https://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe"
        $webClient = New-Object System.Net.WebClient
        $destination = "$($env:ProgramFiles)\dotnet.exe"

        # Download the file and save as "dotnet.exe"
        $webClient.DownloadFile($url, $destination)

        $arguments = "/q"

        write-host -fore yellow -back black "Installing .NET 4.5"

        # Install .NET 4.5
        Start-Process -FilePath $destination -ArgumentList $arguments -Wait
    }
}

$msbuildInstall = {
    $url = "http://go.microsoft.com/fwlink/?LinkID=626924&clcid=0x409/vs_community_ENU.exe"
    $webClient = New-Object System.Net.WebClient
    $destination = "$($env:ProgramFiles)\msbuild.exe"

    # Download the file and save as "msbuild.exe"
    $webClient.DownloadFile($url, $destination)

    $arguments = "/q /norestart"

    write-host -fore yellow -back black "Installing Visual Studio 2015 (Community edition)"

    # Install Visual Studio 2015 (Community edition)
    # NOTE: This installation of VS already includes Update 3
    Start-Process -FilePath $destination -ArgumentList $arguments -Wait
}

$javacInstall = {
    write-host -fore yellow -back black "Installing Java JDK 8"
    choco install jdk8 -Confirm:$true

    # Also install the Android SDK
    write-host -fore yellow -back black "Installing Android SDK"
    choco install android-sdk -Confirm:$true
}

$nodeInstall = {
    write-host -fore yellow -back black "Installing Node.js"
    
    # In order to avoid error with Node, we need to install Node 4.x instead of current version
    choco install nodejs -version 4.1.2 -Confirm:$true
}

$rubyInstall = {
    write-host -fore yellow -back black "Installing Ruby"
    choco install ruby -Confirm:$true
}

$gradleInstall = {
    write-host -fore yellow -back black "Installing Gradle"
    choco install gradle -Confirm:$true
}

$pythonInstall = {
    write-host -fore yellow -back black "Installing Python"
    choco install python -Confirm:$true
    choco install python2 -Confirm:$true

    # Download and run ez_setup.py
    $url = "https://bootstrap.pypa.io/ez_setup.py"
    $webClient = New-Object System.Net.WebClient
    $destination = "$($env:ProgramFiles)\ez_setup.py"

    $webClient.DownloadFile($url, $destination)

    Start-Process -FilePath $destination -Wait

    # Add the path of the Python scripts to the PATH environment variable
    # This will allow the tox command to become recognized
    $userPath = [Environment]::GetEnvironmentVariables("User").PATH
    cmd.exe /c setx PATH "$($env:ProgramData)\chocolatey\lib\python3\tools\Scripts;$userPath"
}

$toxInstall = {
    write-host -fore yellow -back black "Installing tox"
    # pip install tox
    easy_install tox
}

$coreclrInstall = {
    # NOTE: Visual Studio Update 3 must be installed before .NET Core can be installed
    $url = "https://go.microsoft.com/fwlink/?LinkId=817245"
    $webClient = New-Object System.Net.WebClient
    $destination = "$($env:ProgramFiles)\coreclr.exe"

    # Download the file and save as "coreclr.exe"
    $webClient.DownloadFile($url, $destination)

    $arguments = "/q"

    write-host -fore yellow -back black "Installing .NET Core 1.0"
    Start-Process -FilePath $destination -ArgumentList $arguments -Wait
}

$goInstall = {
    write-host -fore yellow -back black "Installing Go"
    choco install golang -Confirm:$true
}

$glideInstall = {
    write-host -fore yellow -back black "Installing Glide"
    $url = "https://github.com/Masterminds/glide/releases/download/v0.11.1/glide-v0.11.1-windows-amd64.zip"
    $webClient = New-Object System.Net.WebClient
    $destination = "$($env:ProgramFiles)\glide-amd64.zip"
    $unzipPath = "$($env:ProgramFiles)\glide"
    $webClient.DownloadFile($url, $destination)
    # Unzip glide to the final destination
    Unzip $destination $unzipPath
    
    # Add glide to the path
    $userPath = [Environment]::GetEnvironmentVariables("User").PATH
    cmd.exe /c setx PATH "$($unzipPath)\windows-amd64\;$userPath"
}


# Install chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

find-orAdd "dotnet.exe" -installFunction $dotnetInstall

find-orAdd "javac.exe" -installFunction $javacInstall

find-orAdd "node.exe" -installFunction $nodeInstall -folders @("${env:appdata}","${env:ProgramFiles(x86)}","${env:ProgramFiles}")

find-orAdd "ruby.exe" (@() +  ((dir -ea 0 c:\ruby*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -installFunction $rubyInstall

find-orAdd "gradle.bat" ( @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -installFunction $gradleInstall

find-orAdd "python.exe" (@() +  ((dir -ea 0 c:\python*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -installFunction $pythonInstall
find-orAdd "tox.exe" (@() +  ((dir -ea 0 c:\python*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools"))   -installFunction $toxInstall

find-orAdd "msbuild.exe" -installFunction $msbuildInstall

find-orAdd "coreclr.exe" -installFunction $coreclrInstall

find-orAdd "go.exe" -installFunction $goInstall
find-orAdd "glide.exe" -installFunction $glideInstall

# make sure JAVA_HOME is set
if( (!$env:JAVA_HOME) -or (!(test-path  -PathType Container $env:JAVA_HOME )) ) {
    $javac = which javac.exe
    if( $javac ) {
        $env:JAVA_HOME = (get-item ("$javac\..\.."))
        cmd.exe /c setx -m JAVA_HOME "$($env:JAVA_HOME)"
        write-host -fore yellow -back black "Setting JAVA_HOME to $ENV:JAVA_HOME".
    } else {
        write-host -fore red "Environment variable JAVA_HOME not set correctly."
        $failing = $true
    }
}

# use this to add the missing SDK
# .\Install-AndroidSDK.ps1  -RequestedAndroidPackages android-23 -apilevel 23

if( (!$env:ANDROID_HOME) -or (!(test-path  -PathType Container $env:ANDROID_HOME )) ) {
    $android = Get-AndroidHomeFromRegistry
    if (! $android ) {
        write-host -fore red "Environment variable ANDROID_HOME not set correctly."
        $failing = $true
    } else {
        $env:ANDROID_HOME= $android
        cmd.exe /c setx -m ANDROID_HOME "$android"
        write-host -fore yellow -back black "Setting ANDROID_HOME TO $env:ANDROID_HOME"
    }
}

if( !$failing  ) {
    write-host -fore green "`n`nTools/Environment are OK"
} else {
    write-host -fore red "`n`nTools/Environment are not OK"
}

Restart-Computer

# After restart:

# 1) Run the following commands to finish Android SDK setup:
# > (echo y | android update sdk -u -a -t build-tools-23.0.1) && (echo y | android update sdk -u -a -t android-23) && (echo y | android update sdk -u -a -t extra-android-m2repository)
# > Copy-Item "$($env:LOCALAPPDATA)\Android" "C:\Program Files (x86)\Android" -recurse

# 2) Run the following command from the project root:
# > gem install bundler && npm install && npm install gulp && npm install gulp -g && npm update