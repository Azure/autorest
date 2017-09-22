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

$lastAutoRestPropCmd = "New-Item -Force -ItemType directory -Path ar0; cd ar0; npm install autorest@latest; node_modules\.bin\autorest --latest"
$newAutoRestPropCmd = "New-Item -Force -ItemType directory -Path ar1; cd ar1; npm install autorest@next; node_modules\.bin\autorest --latest"
$lastAutoRestCmd = "ar0\node_modules\.bin\autorest"
$newAutoRestCmd = "ar1\node_modules\.bin\autorest"

&powershell $lastAutoRestPropCmd
&powershell $newAutoRestPropCmd

# remove last run and create folders
$null = rmdir -recurse -force -ea 0 $baseFolder 
$null = mkdir -ea 0 $baseFolder
  
$null = mkdir -ea 0 $lastRoot
$null = mkdir -ea 0 $newRoot

Write-host -fore green "Last: $lastAutoRestCmd"
Write-host -fore green "New : $newAutoRestCmd"

$procs = get-process -ea 0 autorest 
if( $procs ) {
  write-host -fore red "Ensuring all previous jobs are completed."
  $procs.Kill()
}

@(
  @("--csharp"),
  @("--azure-arm --csharp"),
  @("--azure-arm --fluent --csharp"),
  @("--java"),
  @("--azure-arm --java"),
  @("--azure-arm --fluent --java"),
  @("--ruby"),
  @("--azure-arm --ruby"),
  @("--nodejs"),
  @("--azure-arm --nodejs"),
  @("--python"),
  @("--azure-arm --python"),
  @("--go"),
  @("--azureresourceschema") ) |% {

  $gen = $_;
  $gensan = $gen -replace "-","" -replace " ","_"
 
  get-content "$psscriptroot\all-specs" |% {
    $spec = $_
    $uniquename = $spec -replace "\\","_" -replace ".json",""
    # $filename = (dir $spec ).Name
    $name = $spec -replace ".json","" -replace ".*\\",""
    # $specfile = (resolve-path $spec).Path
    $specfile = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/current/specification/$spec/readme.md"
  
    write-host -fore darkGray "Processing $name : $gen "

    $cmd = "$lastAutoRestCmd $specfile --namespace=fallbacknamespace $gen.output-folder=$lastRoot\$uniqueName\$gensan"
    Write-host -fore green "Running : $cmd"
    $output += &powershell $cmd

    $cmd = "$newAutoRestCmd $specfile --namespace=fallbacknamespace $gen.output-folder=$newRoot\$uniqueName\$gensan"
    Write-host -fore green "Running : $cmd"
    $output += &powershell $cmd
  
    if( !$notrim -and (test-path "$lastRoot\$uniqueName\") ) {
      (dir "$lastRoot\$uniqueName\" -recurse -file).FullName  |% {
        $ref = $_ 
        if( $ref ) {
          $cur = $ref -replace "\\Last\\","\New\"
          
          if( (test-path $ref ) -and (test-path $cur) ) {  
            $r = (get-content $ref |% { $_ -replace "Code generated .*", "" })
            $c = (get-content $cur |% { $_ -replace "Code generated .*", "" })
            if( $r -and $c ) {
              $v = compare-object $r $c 
              if( !$v )  {
                erase $ref
                erase $cur
              }
            }
          }
        }
      }
    }
  }
}

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
}