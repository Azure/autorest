<#
    This script attempts to find the tools required to build Autorest, and 
    if necessary sets the required environment variables and PATH settings
    (in the current process)
    
    When finding a tool, it scans the PATH, then can look recursively in folders
    for the tools.
    
    When it finds a tool, it will remember it by sticking an entry into the 
    registry. 
    
    -reset will nuke the remembered tools.
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

function Find-OrAdd ( $cmd , $folders = @("${env:ProgramFiles(x86)}","${env:ProgramFiles}"), $hint = $null ) { 
    if( !($exe = which $cmd) ) {
        $exe = find-exe $cmd -folders $folders 
        if( $exe) {
            write-host "Adding '$($exe.Directory)' to PATH".
            # $env:PATH="$env:PATH;$($exe.Directory)"
            $env:PATH="$($exe.Directory);$env:PATH"
        } else {    
            write-host -fore red "Unable to find '$cmd' in path/search folders"
            if( $hint ) {
            write-host -fore yellow "HINT: $hint"
            }
            $script:failing = $true
            
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

find-orAdd "dotnet.exe" -hint "See: https://www.microsoft.com/net/core#windows"
find-orAdd "msbuild.exe" -hint "Install Visual studio 2015"

find-orAdd "javac.exe" -hint "Download and install JAVA JDK"

find-orAdd "node.exe" -hint "See: https://nodejs.org"
find-orAdd "gulp.cmd" -hint "maybe use 'npm install -g gulp'"

find-orAdd "ruby.exe" (@() +  ((dir -ea 0 c:\ruby*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -hint "see http://rubyinstaller.org/downloads/"

find-orAdd "gradle.bat" ( @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -hint "see http://gradle.org/gradle-download/"

find-orAdd "python.exe" (@() +  ((dir -ea 0 c:\python*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools")) -hint "https://www.python.org/downloads/"
find-orAdd "tox.exe" (@() +  ((dir -ea 0 c:\python*).fullname) + @( "${env:ProgramFiles(x86)}","${env:ProgramFiles}","c:\tools"))   -hint "maybe use 'pip install tox'"


#

# make sure JAVA_HOME is set
if( (!$env:JAVA_HOME) -or (!(test-path  -PathType Container $env:JAVA_HOME )) ) {
    $javac = which javac.exe
    if( $javac ) {
        $env:JAVA_HOME = (get-item ("$javac\..\.."))
        write-host "Setting JAVA_HOME to $ENV:JAVA_HOME".
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
    }
}

if( !$failing  ) {
    write-host -fore green "`n`nTools/Environment are OK"
} else {
    write-host -fore red "`n`nTools/Environment are not OK"
}
