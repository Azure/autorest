$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
. $PSScriptRoot/autorest.ps1

#autorest-reset
#autorest-info

$readmes = (get-childitem Samples/readme.md -recurse).Fullname

$readmes | % {
  $sample = $_ -replace '\\', '/'
  if ( $sample.ToLower().endsWith('samples/readme.md')) {
    continue;
  }
  $folder = resolve-path "$sample/.."
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
      if ( -not ('directory' -in ($_.Attributes)) ) {
        write-to $_ @("SRC")
      }
    }

    $basefolder = $root -replace '\\', '/'
    $files |? { $_.extension -in ('.map', '.txt' ) } | % {
      $file = $_.FullName
      $content = read-from $file

      $content = $content -replace "\(node:\d+\)", "(node)"
      # $content = $content -replace  "\\bfile:\\/+$basefolder", "/"
      $content = $content -replace '\s\''?[^\s]+[\/\\]autorest-core(\\|'')?(?=(\b|\\n))', " autorest-core"
      $content = $content -replace '\sat .*', "at ..."
      $content = $content -replace 'mem:\/\/\/[^: ]*', 'mem'
      $content = $content -replace '(at \.\.\.\s*)+', "at ...\n"  # minify exception stack traces
      $content = $content -replace '.*AutoRest code generation utility.*\n', ""  # remove header message
      $content = $content -replace '.*DeprecationWarning.*\n', "(node) DeprecationWarning (trimmed)"  # remove header message
      $content = $content -replace '.*UnhandledPromiseRejectionWarning.*:n', "(node) UnhandledPromiseRejectionWarning:"  # remove header message
      $content = $content -replace '.*\(C\) \d* Microsoft Corporation.*\n', ""  # remove header message
      $content = $content -replace '.* AutoRest extension ''.*\n', ""  # remove extension loading messages
      $content = $content -replace '.* Loading AutoRest core.*\n', ""  # remove core loading messages
      $content = $content -replace '.* -> .*\n', ""  # remove bin install messages (npm 5.6.0+)
      $content = $content -replace 'Recording package path.*\n', ""   # dotnet-2.0.0 installation message
      if ( ($file.endsWith('stdout.txt')) -or ($file.endsWith('stderr.txt')) ) {
        $content = $content.split("`n") | sort
      }

      write-to $file $content
    }

    $files |? {  $_.extension -in ('.yaml' ) } | % {
      $file = $_
      $content = read-from $file

      $content = $content -replace '.*autorest[a-zA-Z0-9]*.src.*', ""  # source file names
      $content = $content -replace '^version:.*autorest-core["'']?''', ""  # autorest-core path as reported by bootstrapper again!
      $content = $content -replace 'file\:\/\/\/.*Custom transformations.*', ""  # fix path in file

      write-to $file $content
    }

  }
}
