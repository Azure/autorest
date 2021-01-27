function Get-ArtifactBaseDownloadUrl() {
    $url = "$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI$env:SYSTEM_TEAMPROJECTID/_apis/build/builds/$env:BUILD_BUILDID/artifacts?artifactName=packages&api-version=5.1"
    Write-Host "Getting artifact info at: '$url'"

    $buildPipeline= Invoke-RestMethod -Uri $url -Headers @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" } -Method Get
    $ArtifactDownloadURL= $buildPipeline.resource.downloadUrl
    return $ArtifactDownloadURL
}

function Get-DownloadUrl([string] $baseDownloadUrl, [string] $filename) {
    return $ArtifactDownloadURL  -replace "format=zip","format=file&subPath=%2Fautorest-modelerfour-$(artver).tgz";
}

function Create-TinyUrlForArtifact([string] $baseDownloadUrl, [string] $filename, [string]$outVarName) {
    $downloadUrl = Get-DownloadUrl -baseDownloadUrl $baseDownloadUrl -filename $filename
    Write-Host "Raw Artifact Url: '$downloadUrl'"
    $downurl = (iwr "http://tinyurl.com/api-create.php?url=$( [System.Web.HttpUtility]::UrlEncode($downloadUrl))" ).Content
    Write-Host "Tiny Url: '$tinyUrl'"
    Write-Host "##vso[task.setvariable variable=$outVarName]$downurl"
}

function Get-PackageVersion([string] $packageRoot) {
    return (Get-Content $packageRoot/package.json) -join "`n" | ConvertFrom-Json | Select -ExpandProperty "version"
}

function Run() {
    $root = $env:Build_SourcesDirectory
    $baseDownloadUrl = Get-ArtifactBaseDownloadUrl
    Write-Host "Base download url is $baseDownloadUrl";

    $coreVersion = Get-PackageVersion -packageRoot $root/packages/extensions/core
    $m4Version = Get-PackageVersion -packageRoot $root/packages/extensions/modelerfour

    Create-TinyUrlForArtifact -baseDownloadUrl $baseDownloadUrl -filename "%2Fautorest-modelerfour-$coreVersion.tgz" -outVarName "AUTOREST_MODELERFOUR_DOWNLOAD_URL";
    Create-TinyUrlForArtifact -baseDownloadUrl $baseDownloadUrl -filename "%2Fautorest-core-$m4Version.tgz" -outVarName "AUTOREST_CORE_DOWNLOAD_URL";
}

Run