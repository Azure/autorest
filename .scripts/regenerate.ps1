$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
. $PSScriptRoot/autorest.ps1

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
    $result = autorest $sample
    $outputFolder = resolve-path -ea 0 "$folder/shell"
    $shh = mkdir -ea 0 $outputFolder

    write-to "$outputFolder/code.txt" "$($result.ExitCode)"
    write-to "$outputFolder/stdout.txt" "$($result.Output)"
    write-to "$outputFolder/stderr.txt" "$($result.Error)"

    # HACK.
    if ( $result.ExitCode -eq 0 ) {
      # only supporting successful runs right now.



      $files = get-childitem -recurse $folder

      # replace source files with SRC
      $files |? {  $_.extension -in ('.cs', '.go', '.java', '.js' , '.ts', '.php', '.py', '.rb') } | % {
        $file = $_.FullName

        # write-host -fore cyan "Tweaking $file"

        if ( -not ('directory' -in ($_.Attributes)) ) {
          write-to $file @("SRC")
        }
      }

      # write-host -fore cyan "Tweaking .map and .txt"

      $basefolder = $root -replace '\\', '/'
      $files |? { $_.extension -in ('.map', '.txt' ) } | % {
        $file = $_.FullName
        # write-host -fore cyan "Tweaking $file"
        $content = read-from $file

        # write-host -fore cyan "3"
        $content = $content -replace 'mem:\/\/\/[^: ]*?', 'mem'

        if( -not( $_.extension -eq '.map' )  ) {
          $content = $content -replace "\(node:\d+\)", "(node)"
          $content = $content -replace '\s\''?[^\s]+[\/\\]autorest-core(\\|'')?(?=(\b|\\n))', " autorest-core"
          # $content = $content -replace '\sat .*', "at ..."
          $content = $content -replace '(at \.\.\.\s*)+', "at ..."  # minify exception stack traces
          $content = $content -replace '.*AutoRest code generation utility.*`n', ""  # remove header message
          $content = $content -replace ".*DeprecationWarning.*`n", "(node) DeprecationWarning (trimmed)"  # remove header message
          $content = $content -replace ".*UnhandledPromiseRejectionWarning.*:`n", "(node) UnhandledPromiseRejectionWarning:"  # remove header message
          $content = $content -replace ".*\(C\) \d* Microsoft Corporation.*`n", ""  # remove header message
          $content = $content -replace ".* AutoRest extension '.*`n", ""  # remove extension loading messages
          $content = $content -replace ".* Loading AutoRest.*`n", ""  # remove core loading messages
          $content = $content -replace ".* -> .*`n", ""  # remove bin install messages (npm 5.6.0+)
          $content = $content -replace "Recording package path.*`n", ""   # dotnet-2.0.0 installation message
          if ( ($file.endsWith('stdout.txt')) -or ($file.endsWith('stderr.txt')) ) {
            $content = $content.split("`n") | sort
          }
        }
        write-to $file $content
      }


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
    # write-host -fore cyan "Popd "
    popd
  }
}
