$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
. $PSScriptRoot/autorest.ps1


function write-hostcolor { Param ( $color,  [parameter(ValueFromRemainingArguments=$true)] $content ) write-host -fore $color $content }
function comment { Param ( [parameter(ValueFromRemainingArguments=$true)] $content ) write-host -fore darkgray $content }
function action { Param ( [parameter(ValueFromRemainingArguments=$true)] $content ) write-host -fore green $content }
function warn { Param ( [parameter(ValueFromRemainingArguments=$true)] $content ) write-host -fore yellow $content }

function err { Param ( [parameter(ValueFromRemainingArguments=$true)] $content ) write-host -fore red $content }

new-alias '//'  comment
new-alias '/#'  comment
new-alias '=>' action
new-alias '/$' warn
new-alias '/!' err

new-alias '==>' write-hostcolor

#autorest-reset
#autorest-info

$readmes = (get-childitem Samples/readme.md -recurse).Fullname

$readmes | % {

  $sample = $_ -replace '\\', '/'

  # write-host -fore cyan "Sample: $sample "
  if ( $sample.ToLower().endsWith('samples/readme.md')) {
    # write-host -fore cyan "Skipping: $sample "
    continue;
  }

  $folder = resolve-path "$sample/.."
  pushd $folder
  # write-host -fore cyan "Folder: $folder "
  try {
    /# Running AutoRest
    $result = autorest $sample
    /# Done with AutoRest.
    $outputFolder = resolve-path -ea 0 "$folder/shell"
    /# creating output folder
    $shh = mkdir -ea 0 $outputFolder

    /# writing $outputFolder/code.txt
    write-to "$outputFolder/code.txt" "$($result.ExitCode)"
    /# writing $outputFolder/stdout.txt
    write-to "$outputFolder/stdout.txt" "$($result.Output)"
    /# writing $outputFolder/stderr.txt
    write-to "$outputFolder/stderr.txt" "$($result.Error)"

    /# checking exit code $($result.ExitCode)
    # HACK.
    if ( $result.ExitCode -eq 0 ) {
      /# only supporting successful runs right now.



      $files = get-childitem -recurse $folder

      /# replace source files with SRC
      $files |? {  $_.extension -in ('.cs', '.go', '.java', '.js' , '.ts', '.php', '.py', '.rb') } | % {
        $file = $_.FullName

        /# "Tweaking $file"

        if ( -not ('directory' -in ($_.Attributes)) ) {
          write-to $file @("SRC")
        }
      }

      /# "Tweaking .map and .txt"

      $basefolder = $root -replace '\\', '/'
      $files |? { $_.extension -in ('.map', '.txt' ) } | % {
        $file = $_.FullName
        /# "Tweaking (2) $file"
        $content = read-from $file

        /# "3"
        $content = $content -replace 'mem:\/\/\/[^: ]*?', 'mem'

        if( -not( $_.extension -eq '.map' )  ) {
          /# "A"
          $content = $content -replace "\(node:\d+\)", "(node)"
          /# "B"
          $content = $content -replace '\s\''?[^\s]+[\/\\]autorest-core(\\|'')?(?=(\b|\\n))', " autorest-core"
          /# "C"
          # $content = $content -replace '\sat .*', "at ..."
          /# "D"
          $content = $content -replace '(at \.\.\.\s*)+', "at ..."  # minify exception stack traces
          /# "E"
          $content = $content -replace '.*AutoRest code generation utility.*`n', ""  # remove header message
          /# "F"
          $content = $content -replace ".*DeprecationWarning.*`n", "(node) DeprecationWarning (trimmed)"  # remove header message
          /# "G"
          $content = $content -replace ".*UnhandledPromiseRejectionWarning.*:`n", "(node) UnhandledPromiseRejectionWarning:"  # remove header message
          /# "H"
          $content = $content -replace ".*\(C\) \d* Microsoft Corporation.*`n", ""  # remove header message
          /# "I"
          $content = $content -replace ".* AutoRest extension '.*`n", ""  # remove extension loading messages
          /# "J"
          $content = $content -replace ".* Loading AutoRest.*`n", ""  # remove core loading messages
          /# "k"
          $content = $content -replace ".* -> .*`n", ""  # remove bin install messages (npm 5.6.0+)
          /# "L"
          $content = $content -replace "Recording package path.*`n", ""   # dotnet-2.0.0 installation message
          /# "M"
          /# Sorting?
          if ( ($file.endsWith('stdout.txt')) -or ($file.endsWith('stderr.txt')) ) {
            $content = $content.split("`n") | Sort-Object
          }
          /# Done Sorting?
        }
        /# Saving content
        write-to $file $content
      }

      /# yaml tweaking
      $files |? {  $_.extension -in ('.yaml' ) } | % {
        $file = $_.FullName
        $content = read-from $file

        $content = $content -replace '.*autorest[a-zA-Z0-9]*.src.*', ""  # source file names
        $content = $content -replace '^version:.*autorest-core["'']?''', ""  # autorest-core path as reported by bootstrapper again!
        $content = $content -replace 'file\:\/\/\/.*Custom transformations.*', ""  # fix path in file

        write-to $file $content
      }
    }
  } finally {
    /# write-host -fore cyan "Popd "
    popd
  }
}
