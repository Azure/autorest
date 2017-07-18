<#
.SYNOPSIS
    Downloads build tools and a particular version of Node.js
    for purposes of later building a package.
.PARAMETER Version
    The version of Node.js to download.
#>
$progressPreference = 'silentlyContinue'  
$Version = "8.1.4"
$DistRootUri = "https://nodejs.org/dist/v$Version"
$LayoutRoot = "$PSScriptRoot\"
if (!(Test-Path $LayoutRoot)) { $null = mkdir $LayoutRoot }

function Expand-ZIPFile($file, $destination) {
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace((Resolve-Path $file).Path)
    foreach ($item in $zip.items()) {
        $shell.Namespace((Resolve-Path $destination).Path).copyhere($item)
    }
}

if (!(Test-Path $PSScriptRoot\obj)) { $null = mkdir $PSScriptRoot\obj }

$unzipTool = "$PSScriptRoot\obj\7z\7za.exe"
if (!(Test-Path $unzipTool)) {
    $zipToolArchive = "$PSScriptRoot\obj\7za920.zip"
    if (!(Test-Path $zipToolArchive)) {
        Invoke-WebRequest -Uri http://7-zip.org/a/7za920.zip -OutFile $zipToolArchive
    }
    
    if (!(Test-Path $PSScriptRoot\obj\7z)) { $null = mkdir $PSScriptRoot\obj\7z }
    Expand-ZIPFile -file $zipToolArchive -destination $PSScriptRoot\obj\7z
}

Function Get-NetworkFile {
Param(
    [uri]$Uri,
    [string]$OutDir
)
    if (!(Test-Path $OutDir)) { 
        $null = mkdir $OutDir
    }
    
    $OutFile = Join-Path $OutDir $Uri.Segments[$Uri.Segments.Length - 1]
    if (!(Test-Path $OutFile)) {
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    }
    
    $OutFile
}

Function Get-NixNode($os, $arch, $osBrand) {
    $tgzPath = Get-NetworkFile -Uri $DistRootUri/node-v$Version-$os-$arch.tar.gz -OutDir "$PSScriptRoot\obj"
    $tarName = [IO.Path]::GetFileNameWithoutExtension($tgzPath)
    $tarPath = Join-Path $PSScriptRoot\obj $tarName
    $null = & $unzipTool -y -o"$PSScriptRoot\obj" e $tgzPath $tarName
    $null = & $unzipTool -y -o"$PSScriptRoot\obj" e $tarPath "node-v$Version-$os-$arch\bin\node"
    
    if (!$osBrand) { $osBrand = $os }
    $targetDir = "$LayoutRoot\tools\$osBrand-$arch"
    if (!(Test-Path $targetDir)) {
        $null = mkdir $targetDir
    }

    Copy-Item $PSScriptRoot\obj\node $targetDir
    Remove-Item $PSScriptRoot\obj\node
}

Function Get-WinNode($arch) {
    $nodePath = Get-NetworkFile -Uri https://nodejs.org/dist/v$Version/win-$arch/node.exe -OutDir "$PSScriptRoot\obj\win-$arch-$Version"
    $targetDir = "$LayoutRoot\tools\win-$arch"
    if (!(Test-Path $targetDir)) {
        $null = mkdir $targetDir
    }

    Copy-Item $nodePath $targetDir
}

Get-NixNode 'linux' x64
Get-NixNode 'linux' x86
Get-NixNode 'darwin' x64 -osBrand 'osx'
Get-WinNode x86
Get-WinNode x64

npm install 