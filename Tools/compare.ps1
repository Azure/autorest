param( $lastAutorest, $newAutoRest , [switch]$noclean , $swagger, [switch]$notrim) 

function get-fullpath( $path ) {
   $result = resolve-path $path -ea 0 -ErrorVariable e
   if( $e ) {
    return $e.TargetObject
   }
   return $result
}

$baseFolder = get-fullpath "$PSScriptRoot\..\compare-results"
$lastRoot = get-fullpath "$baseFolder\Last"
$newRoot = get-fullpath "$baseFolder\New"

if( !$noclean ) {
  # remove last run and create folders
  $null = rmdir -recurse -force -ea 0 $baseFolder 
  $null = mkdir -ea 0 $baseFolder
} else {
  $null = rmdir -recurse -force -ea 0 $lastRoot 
  $null = rmdir -recurse -force -ea 0 $newRoot 
  $lastAutoRest = (dir "$baseFolder\autorest*\tools\AutoRest.exe").FullName
}
  
$null = mkdir -ea 0 $lastRoot
$null = mkdir -ea 0 $newRoot

if( -not $lastAutorest  ) {
  # install last nightly build.
  write-host -fore green "Installing latest nightly autorest."
  $null = &"$PSScriptRoot\NuGet.exe" install autorest -source https://www.myget.org/F/autorest/api/v3/index.json -prerelease -outputdirectory $baseFolder

  # get autorest nightly exe
  $lastAutoRest = (dir "$baseFolder\autorest*\tools\AutoRest.exe").FullName
}

if( -not (resolve-path $lastAutoRest -ea 0 )) {
  return write-error "Can't find last autorest exe at $lastAutoRest"
}

if( -not $newAutoRest  ) {
  $newAutorest = (dir "$PSScriptRoot\..\src\core\AutoRest\bin\Debug\net451\win7-x64\AutoRest.exe").FullName
}

if( -not (resolve-path $newAutorest -ea 0 )) {
  return write-error "Can't find new autorest exe at $newAutoRest"
}

Write-host -fore green "Last: $lastAutorest"
Write-host -fore green "New : $newAutorest"

$procs = get-process -ea 0 autorest 
if( $procs ) {
  write-host -fore red "Ensuring all previous jobs are completed."
  $procs.Kill()
}
Get-Job | remove-job -force 

function ProcessBackgroundJobs() {
  Get-Job  -state Completed |% {  
    receive-job $_ 
    remove-job $_ 
  }
}

$scrp = { 
  param($lastexe, $newexe, $commonFolder,$uniqueName ,$spec, $gen, $modeler, $notrim)
  $output = "$lastexe `n-Namespace Test.NameSpace -OutputDirectory  ""$commonFolder\Last\$uniqueName\$gen"" -input $spec -CodeGenerator $gen -verbose -modeler $modeler`n"
  $output += &$lastexe -Namespace Test.NameSpace -OutputDirectory  "$commonFolder\Last\$uniqueName\$gen" -input $spec -CodeGenerator $gen -verbose -modeler $modeler
  # set-content -value $output -path "$commonFolder\last\$uniqueName\output-$gen.txt"
  
  write-output "$newexe `n-Namespace Test.NameSpace -OutputDirectory  ""$commonFolder\New\$uniqueName\$gen"" -input $spec -CodeGenerator $gen -verbose -modeler $modeler`n"
  $output += &$newexe -Namespace Test.NameSpace -OutputDirectory  "$commonFolder\New\$uniqueName\$gen" -input $spec -CodeGenerator $gen -verbose -modeler $modeler
  #set-content -value $output -path "$commonFolder\new\$uniqueName\output-$gen.txt"

  if( !$notrim ) {
    (dir "$commonFolder\Last\$uniqueName\" -recurse -file).FullName  |% {
      $ref = $_ 
      if( $ref ) {
        $cur = $ref -replace "\\Last\\","\New\"
        
        if( (test-path $ref ) -and (test-path $cur) ) {  
          $r = get-content $ref
          $c = get-content $cur
          if( $r -and $c ) {
            $v = compare-object $r $c 
            if( !$v )  {
              # erase $ref
              # erase $cur
            }
          }
        }
      }
    }
  }
}

# @("Azure.NodeJS", "Azure.CSharp") |% {
 @("Azure.Python" ) |% {
  $gen = $_;
 

  if( $swagger ) { 
    $name = $swagger -replace ".json","" -replace ".*\\","" -replace ".*\/",""
    $uniquename = $name -replace "\\","_" -replace "//","_" -replace ".json",""
    $specfile = $swagger
    
    $modeler = "Swagger"
    if( $name -match "composite" ) { 
      $modeler = "CompositeSwagger"
    }
    $j = Start-Job -ScriptBlock $scrp -arg $lastAutorest, $newAutorest, $baseFolder, $uniqueName, $specfile, $gen, $modeler, $notrim
    
  } else {
  

    get-content "$psscriptroot\all-specs" |% {
      $spec = $_
      $uniquename = $spec -replace "\\","_" -replace ".json",""
      # $filename = (dir $spec ).Name
      $name = $spec -replace ".json","" -replace ".*\\",""
      # $specfile = (resolve-path $spec).Path
      $specfile = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/$spec" -replace "\\","/"
      
      $modeler = "Swagger"
      if( $name -match "composite" ) { 
        $modeler = "CompositeSwagger"
      }
      write-host -fore darkGray "Processing $name : $gen "
      
      $j = Start-Job -ScriptBlock $scrp -arg $lastAutorest, $newAutorest, $baseFolder, $uniqueName, $specfile, $gen, $modeler, $notrim
      sleep -milliseconds 25

      # process output of completed jobs too
      ProcessBackgroundJobs

      # throttle to 10 background jobs at a time. 
      While((Get-Job -State 'Running').Count -ge 6) {
        sleep -milliseconds 100
        # remove any files that are perfect matches.
      }
    }
  }
}

write-host -fore green -nonewline "Finishing Up..."
While((Get-Job -State 'Running').Count -ge 1) {
  write-host -fore darkgreen -nonewline "."
  ProcessBackgroundJobs
  sleep -milliseconds 250
}

# wait for the last of the jobs to run.
Get-Job |% {  
  receive-job $_ 
  remove-job $_ 
}

<#
try {
  $app = New-Object -ComObject "Merge70.Application"
  if( $app )  { 
  
    $fc = $app.FolderComparison
    $completed = $false;

    $fc.Compare("$baseFolder\Last", "$baseFolder\New");

    write-host -nonewline "`nComparing files..."
    while ($fc.Busy)
    {
        sleep -milliseconds 250 
        write-host -nonewline "."
    }

    write-host -fore green "`nWriting report: $baseFolder\report.html "

    $fc.Report("html", 0, "$baseFolder\report.html");

    while ($fc.Busy)
    {
        sleep -milliseconds 250 
        write-host -nonewline "."
    }

    $fc.Close()
    $app.Close()

    $app = $null
    $fc = $null
  }
} catch { 
  write-host -fore red "Araxis Merge not installed (report skipped)"
}#>