$root = $env:BUILD_SOURCESDIRECTORY


function Get-ArtifactBaseDownloadUrl() {
    $url = "$env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI$env:SYSTEM_TEAMPROJECTID/_apis/build/builds/$env:BUILD_BUILDID/artifacts?artifactName=packages&api-version=5.1"
    Write-Host "Getting artifact info at: '$url'"

    $buildPipeline= Invoke-RestMethod -Uri $url -Headers @{ Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN" } -Method Get
    $ArtifactDownloadURL= $buildPipeline.resource.downloadUrl
    return $ArtifactDownloadURL
}

function Get-DownloadUrl([string] $baseDownloadUrl, [string] $filename) {
    return $baseDownloadUrl  -replace "format=zip","format=file&subPath=%2F$filename";
}

function Create-TinyUrlForArtifact([string] $baseDownloadUrl, [string] $filename, [string]$outVarName) {
    $downloadUrl = Get-DownloadUrl -baseDownloadUrl $baseDownloadUrl -filename $filename
    Write-Host "Raw Artifact Url: '$downloadUrl'"
    $downurl = (iwr "http://tinyurl.com/api-create.php?url=$( [System.Web.HttpUtility]::UrlEncode($downloadUrl))" ).Content
    Write-Host "Tiny Url: '$tinyUrl'"
    return $downurl;
}

function Get-PackageVersion([string] $packageRoot) {
    $version =  (Get-Content "$packageRoot/package.json") -join "`n" | ConvertFrom-Json | Select -ExpandProperty "version";
    Write-Host "Version for package at $packageRoot is $version"
    return $version;
}

function Format-Comment([string] $coreDownloadUrl, [string] $modelerfourDownloadUrl, [hashtable] $extensions = @{}) {
    $template = get-content -raw -encoding utf8 "$root/eng/pipelines/resources/tryit-comment-template.md";
    $AUTOREST_CORE_DOWNLOAD_URL = $coreDownloadUrl
    $AUTOREST_MODELERFOUR_DOWNLOAD_URL = $modelerfourDownloadUrl

    # Figure out if there are any other extensions to include in the comment
    $extensionTableRow, $cliFlags = ProcessExtensionsForComment $extensions

    # Replace placeholders in the template
    $template = $template -replace "{{AUTOREST_CORE_DOWNLOAD_URL}}", $coreDownloadUrl
    $template = $template -replace "{{AUTOREST_MODELERFOUR_DOWNLOAD_URL}}", $modelerfourDownloadUrl
    $template = $template -replace "\n<!-- CONFIG_EXTENSIONS -->", $extensionTableRow
    $template = $template -replace "<!-- CLI_FLAGS -->", $cliFlags

    return $template
}

function ProcessExtensionsForComment([hashtable] $extensions) {
    $extensionTableRow = ""
    $cliFlags= ""

    foreach ($extension in $extensions.GetEnumerator()) {
        $extensionName = $extension.Key
        $extensionDownloadUrl = $extension.Value

        $extensionTableRow += "| $extensionName | `--use:$extensionName@$extensionDownloadUrl` | For changes to $extensionName. |`n"
        $cliFlags += "  --use:$extensionName@$extensionDownloadUrl `n"
    }

    return $cliFlags, $extensionTableRow
}

function Run() {
    $baseDownloadUrl = Get-ArtifactBaseDownloadUrl
    Write-Host "Base download url is $baseDownloadUrl";

    $coreVersion = Get-PackageVersion -packageRoot $root/packages/extensions/core
    $m4Version = Get-PackageVersion -packageRoot $root/packages/extensions/modelerfour
    $openApiToTypespecVersion = Get-PackageVersion -packageRoot $root/packages/extensions/openapi-to-cadl

    $coreDownloadUrl = Create-TinyUrlForArtifact -baseDownloadUrl $baseDownloadUrl -filename "autorest-core-$coreVersion.tgz";
    $modelerfourDownloadUrl = Create-TinyUrlForArtifact -baseDownloadUrl $baseDownloadUrl -filename "autorest-modelerfour-$m4Version.tgz";
    $openApiToTypespecDownloadUrl = Create-TinyUrlForArtifact -baseDownloadUrl $baseDownloadUrl -filename "openapi-to-cadl-$coreVersion.tgz";

    $extensions = @{
        # Add more extensions as needed
        #"@autorest/extension-name" = "extension-name"
    }

    if (![string]::IsNullOrEmpty($openApiToTypespecDownloadUrl)) {
        $extensions["@autorest/openapi-to-cadl"] = $openApiToTypespecDownloadUrl
    }


    $comment = Format-Comment -coreDownloadUrl $coreDownloadUrl -modelerfourDownloadUrl $modelerfourDownloadUrl -extensions $extensions

    Write-Host "Github comment content:"
    Write-Host "-----------------------"
    Write-Host $comment
    Write-Host "-----------------------"

    $escapedComment = $comment -replace "`n", "%0D%0A"
    Write-Host "$escapedComment"
    Write-Host "======================"
    Write-Host "##vso[task.setvariable variable=TRYIT_COMMENT]$escapedComment"
}

Run