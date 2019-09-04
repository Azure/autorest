$ErrorActionPreference = "Stop"
$root = resolve-path $PSScriptRoot/..
[Int]$TimeoutMilliseconds = 1800000 #30min

function Invoke-Executable {
  param( [String]$sExeFile)

  # Setting process invocation parameters.
  $oPsi = New-Object -TypeName System.Diagnostics.ProcessStartInfo
  $oPsi.CreateNoWindow = $true
  $oPsi.UseShellExecute = $false
  $oPsi.RedirectStandardOutput = $true
  $oPsi.RedirectStandardError = $true
  $oPsi.FileName = $sExeFile
  if ($args.Count -gt 0) {
    $oPsi.Arguments = $args | % {$_}
  }

  # Creating process object.
  $oProcess = New-Object -TypeName System.Diagnostics.Process
  $oProcess.StartInfo = $oPsi

  # Creating string builders to store stdout and stderr.
  $oStdOutBuilder = New-Object -TypeName System.Text.StringBuilder
  $oStdErrBuilder = New-Object -TypeName System.Text.StringBuilder

  # Adding event handers for stdout and stderr.
  $oStdOutEvent = Register-ObjectEvent -InputObject $oProcess -EventName 'OutputDataReceived' -MessageData $oStdOutBuilder -Action {
    if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
      $Event.MessageData.AppendLine($EventArgs.Data)
    }
  }

  $oStdErrEvent = Register-ObjectEvent -InputObject $oProcess -EventName 'ErrorDataReceived' -MessageData $oStdErrBuilder -Action {
    if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
      $Event.MessageData.AppendLine($EventArgs.Data)
    }
  }
try {
  # Starting process.
  [Void]$oProcess.Start()
  $oProcess.BeginOutputReadLine()
  $oProcess.BeginErrorReadLine()
  while( (-not ($oProcess.WaitForExit(1000)) ) -and (-not ($oProcess.HasExited) ))  {
    
    write-host -NoNewline '.'
  }

} finally {
  write-host -NoNewline '!'
  # Unregistering events to retrieve process output.
  Unregister-Event -SourceIdentifier $oStdOutEvent.Name
  write-host -NoNewline '#'
  Unregister-Event -SourceIdentifier $oStdErrEvent.Name
  write-host -NoNewline '$' 
}
  $oResult = New-Object -TypeName PSObject -Property ([Ordered]@{
      "ExeFile"  = $sExeFile;
      "Args"     = $oPsi.Arguments -join " ";
      "ExitCode" = $oProcess.ExitCode;
      "Output"   = $oStdOutBuilder.ToString().Trim();
      "Error"    = $oStdErrBuilder.ToString().Trim()
    })
    write-host -NoNewline '?'
  return $oResult
}


function write-to($filename, $content) {
  $text =  [system.String]::Join( "`n", $content)
  return [System.IO.File]::WriteAllText($filename, $text, (New-Object System.Text.UTF8Encoding($false)));
  # write-host -fore cyan "WRITING $filename"
}

function read-from($filename) {
  $result = [System.IO.File]::ReadAllText( $filename, (New-Object System.Text.UTF8Encoding($false)) );
  return $result -replace "`r",""
}

function autorest() {
  write-host -fore gray "> autorest --version=${root}/core --no-upgrade-check $args"
  # write-host -fore cyan INVOKING (get-command node).Source ${root}/autorest/dist/app.js --version=${root}/core --no-upgrade-check $args
  $r = Invoke-Executable (get-command node).Source ${root}/autorest/dist/app.js --version=${root}/core --no-upgrade-check $args
  # write-host -fore yellow "> done ... $args"

  if ( $r.ExitCode -ne 0  ) {
    write-host -fore red $r.Output
    write-host -fore red $r.Error
    return write-error "[FAILED]"
  }
  return $r
}

function autorest-reset() {
  return autorest --allow-no-input --verbose --debug
}

function autorest-info() {
  $r = autorest --info --verbose --debug
}
