Add-Type -Name Threader -Namespace "" -Member @"
 [Flags]
 public enum ThreadAccess : int
 {
   Terminate = (0x0001),
   SuspendResume = (0x0002),
   GetContext = (0x0008),
   SetContext = (0x0010),
   SetInformation = (0x0020),
   GetInformation = (0x0040),
   SetThreadToken = (0x0080),
   Impersonate = (0x0100),
   DirectImpersonation = (0x0200)
 }
 [Flags]
 public enum ProcessAccess : uint
 {
   Terminate = 0x00000001,
   CreateThread = 0x00000002,
   VMOperation = 0x00000008,
   VMRead = 0x00000010,
   VMWrite = 0x00000020,
   DupHandle = 0x00000040,
   SetInformation = 0x00000200,
   QueryInformation = 0x00000400,
   SuspendResume = 0x00000800,
   Synchronize = 0x00100000,
   All = 0x001F0FFF
 }
 
 [DllImport("ntdll.dll", EntryPoint = "NtSuspendProcess", SetLastError = true)]
 public static extern uint SuspendProcess(IntPtr processHandle);
 
 [DllImport("ntdll.dll", EntryPoint = "NtResumeProcess", SetLastError = true)]
 public static extern uint ResumeProcess(IntPtr processHandle);
 
 [DllImport("kernel32.dll")]
 public static extern IntPtr OpenProcess(ProcessAccess dwDesiredAccess, bool bInheritHandle, uint dwProcessId);
 
 [DllImport("kernel32.dll")]
 public static extern IntPtr OpenThread(ThreadAccess dwDesiredAccess, bool bInheritHandle, uint dwThreadId);
 
 [DllImport("kernel32.dll", SetLastError=true)]
 public static extern bool CloseHandle(IntPtr hObject);
 
 [DllImport("kernel32.dll")]
 public static extern uint SuspendThread(IntPtr hThread);
 
 [DllImport("kernel32.dll")]
 public static extern int ResumeThread(IntPtr hThread);
"@
 
 
 
function Suspend-Process {
param(
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
[System.Diagnostics.Process]
$Process
)
process {
  
  if(($pProc = [Threader]::OpenProcess("SuspendResume", $false, $Process.Id)) -ne [IntPtr]::Zero) {
   Write-Verbose "Suspending Process: $pProc"
   $result = [Threader]::SuspendProcess($pProc)
   if($result -ne 0) {
     Write-Error "Failed to Suspend: $result"
     ## TODO: GetLastError()
   }
   [Threader]::CloseHandle($pProc)
  } else {
   Write-Error "Unable to open Process $($Process.Id), are you running elevated?"
   ## TODO: Check if they're elevated and otherwise GetLastError()
  }
}
}
function Resume-Process {
param(
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
[System.Diagnostics.Process]
$Process
)
process {
  if(($pProc = [Threader]::OpenProcess("SuspendResume", $false, $Process.Id)) -ne [IntPtr]::Zero) {
   Write-Verbose "Resuming Process: $pProc"
   $result = [Threader]::ResumeProcess($pProc)
   if($result -ne 0) {
     Write-Error "Failed to Suspend: $result"
     ## TODO: GetLastError()
   }
   [Threader]::CloseHandle($pProc)
  } else {
   Write-Error "Unable to open Process $($Process.Id), are you running elevated?"
   ## TODO: Check if they're elevated and otherwise GetLastError()
  }
}
}
 
 
function Suspend-Thread {
param(
[Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
[System.Diagnostics.ProcessThread[]]
[Alias("Threads")]
$Thread
)
process {
  if(($pThread = [Threader]::OpenThread("SuspendResume", $false, $Thread.Id)) -ne [IntPtr]::Zero) {
   Write-Verbose "Suspending Thread: $pThread"
   [Threader]::SuspendThread($pThread)
   [Threader]::CloseHandle($pThread)
  } else {
   Write-Error "Unable to open Thread $($Thread.Id), are you running elevated?"
   ## TODO: Check if they're elevated and otherwise GetLastError()
  }
}
}
function Resume-Thread {
param(
[Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
[System.Diagnostics.ProcessThread[]]
[Alias("Threads")]
$Thread
)
process {
  if(($pThread = [Threader]::OpenThread("SuspendResume", $false, $Thread.Id)) -ne [IntPtr]::Zero) {
   Write-Verbose "Resuming Thread: $pThread"
   [Threader]::ResumeThread($pThread)
   [Threader]::CloseHandle($pThread)
  } else {
   Write-Error "Unable to open Thread $($Thread.Id), are you running elevated?"
   ## TODO: Check if they're elevated and otherwise GetLastError()
  }
}
}

function clean-expected { 
    write-host -fore darkgreen "Cleaning"
    if( $csharp -or $rebuild ) {
        erase -recurse -force -ea 0 src/generator/AutoRest.CSharp.Azure.Tests/Expected 
        erase -recurse -force -ea 0 src/generator/AutoRest.CSharp.Tests/Expected 
    }
    if( $csfluent -or $rebuild ) {
        erase -recurse -force -ea 0 src/generator/AutoRest.CSharp.Azure.Fluent.Tests/Expected 
    }
    if( $node -or $rebuild ) {
        erase -recurse -force -ea 0 src/generator/AutoRest.NodeJS.Tests/Expected
        erase -recurse -force -ea 0 src/generator/AutoRest.NodeJS.Azure.Tests/Expected
    }
    if( $ruby -or $rebuild ) {
        erase -recurse -force -ea 0 src/generator/AutoRest.Ruby.Tests/RspecTests/Generated/
        erase -recurse -force -ea 0 src/generator/AutoRest.Ruby.Azure.Tests/RspecTests/generated
    }
    if( $ars -or $rebuild) {
        erase -recurse -force -ea 0 src/generator/AutoRest.AzureResourceSchema.Tests/Expected
    }
    if( $python -or $rebuild) {
        erase -recurse -force -ea 0 src/generator/AutoRest.Python.Tests/Expected/
        erase -recurse -force -ea 0 src/generator/AutoRest.Python.Azure.Tests/Expected/
    }
    if( $samples -or $rebuild) {
        erase -recurse -force -ea 0 Samples/*
    }
}

function reset-expected {
    clean-expected 
    write-host -fore darkgreen "Resetting"
    if( $csharp -or $rebuild) {
        git checkout src/generator/AutoRest.CSharp.Azure.Tests/Expected 
        git checkout src/generator/AutoRest.CSharp.Tests/Expected 
    }
    if( $csfluent -or $rebuild) {
        git checkout src/generator/AutoRest.CSharp.Azure.Fluent.Tests/Expected 
    }
    if( $node -or $rebuild) {
        git checkout src/generator/AutoRest.NodeJS.Tests/Expected
        git checkout src/generator/AutoRest.NodeJS.Azure.Tests/Expected
    }
    if( $ruby -or $rebuild) { 
        git checkout src/generator/AutoRest.Ruby.Tests/RspecTests
        git checkout src/generator/AutoRest.Ruby.Azure.Tests/RspecTests
     }
    if( $python -or $rebuild) {
        git checkout src/generator/AutoRest.Python.Tests/Expected/
        git checkout src/generator/AutoRest.Python.Azure.Tests/Expected/
    }
    if( $ars -or $rebuild) {
        git checkout src/generator/AutoRest.AzureResourceSchema.Tests/Expected
    }
    if( $samples -or $rebuild) {
        git checkout Samples/
    }    
}

function regen-expected {
    clean-expected
    write-host -fore darkgreen "Regenerating..."
    if( $csharp ) {
        gulp regenerate:expected:cs 
        if( $lastexitcode -ne 0 ) { return }
        gulp regenerate:expected:csazure 
        if( $lastexitcode -ne 0 ) { return }
    }
    if( $csfluent ) {
        # don't regenerate fluent right now.
        git checkout src/generator/AutoRest.CSharp.Azure.Fluent.Tests/Expected
        
        # gulp regenerate:expected:csazurefluent
        # if( $lastexitcode -ne 0 ) { return }
    }    
    if( $node ) {
        gulp regenerate:expected:node 
        if( $lastexitcode -ne 0 ) { return }
        gulp regenerate:expected:nodeazure 
        if( $lastexitcode -ne 0 ) { return }
    }
    if( $ruby ) {
        gulp regenerate:expected:ruby 
        if( $lastexitcode -ne 0 ) { return }
        gulp regenerate:expected:rubyazure 
        if( $lastexitcode -ne 0 ) { return } 
    }
    if( $ars ) {
      pushd src\generator\AutoRest.AzureResourceSchema.Tests\
      .\regenerate-expected.ps1
      popd
    }
    if( $python ) {
        gulp regenerate:expected:python 
        if( $lastexitcode -ne 0 ) { return }
        gulp regenerate:expected:pythonazure 
        if( $lastexitcode -ne 0 ) { return }
    }
    if( $samples ) {
        # don't regen samples right now
        git checkout Samples/
    }    
}


function Regen
{
  param( [switch]$reset, [switch]$rebuild, [switch]$csharp,[switch]$node,[switch]$ruby,[switch]$python,[switch]$ars, [switch]$csfluent, [switch]$samples ) 

  # reset the host foreground color
  $HOST.UI.RawUI.ForegroundColor = 15

  if( !($csharp -or $node -or $ruby -or $python -or $ars -or $samples -or $csfluent ) ) {
      $csharp = $true
      $csfluent = $true
      $samples = $true
      $node = $true
      $ruby = $true
      $python = $true
      $ars = $true
  }

  try { 
    get-process devenv | suspend-process

    if( $reset -or $rebuild ) {
        reset-expected
    }

    if( $rebuild ) {
        write-host -fore darkgreen "Rebuilding Autorest."
        gulp build
        if( $lastExitCode -ne 0  ) { return }
    }
    $rebuild = $null

    if( -not $reset ) {
        regen-expected 
    }
  }
  finally {
    get-process devenv | resume-process
  }

}