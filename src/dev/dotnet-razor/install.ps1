
pushd $psscriptroot 

# remove anything here. 
$null = rmdir -recurse -force -ea 0 .\obj\ 
$null = rmdir -recurse -force -ea 0 .\bin\
$null = rmdir -recurse -force -ea 0 .\install\obj\ 
$null = rmdir -recurse -force -ea 0 .\install\bin\
$null = mkdir -ea 0 ".\bin\Release"
$null = mkdir -ea 0 ".\bin\Debug" 

# remove installed copies of the tool too.
$null = rmdir -recurse -force -ea 0  "$env:USERPROFILE\.nuget\packages\dotnet-razor\"
$null = rmdir -recurse -force -ea 0  "$env:USERPROFILE\.nuget\packages\.tools\dotnet-razor\"

# build this tool
dotnet restore
dotnet pack

# trick dotnet into installing the package that we just built.
cd install
dotnet restore 
popd 