Write-Output ">>>>>>>>> Generating CSharp clients"
powershell -File ..\AutoRest\AutoRest\Generators\CSharp\CSharp.Tests\RegenerateExpectedClasses.ps1
Write-Output ">>>>>>>>> Generating Azure CSharp clients"
powershell -File ..\AutoRest\AutoRest\Generators\CSharp\Azure.CSharp.Tests\RegenerateExpectedClasses.ps1
Write-Output ">>>>>>>>> Generating Node.js clients"
powershell -File ..\AutoRest\AutoRest\Generators\NodeJS\NodeJS.Tests\RegenerateExpectedClasses.ps1
Write-Output ">>>>>>>>> Generating Azure Node.js clients"
powershell -File ..\AutoRest\AutoRest\Generators\NodeJS\Azure.NodeJS.Tests\RegenerateExpectedClasses.ps1