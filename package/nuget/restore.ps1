cmd /c rmdir /s /q bin obj node_modules
cmd /c rmdir /s /q "$ENV:HOME\.nuget\packages\.tools\autorest\"
cmd /c rmdir /s /q "$ENV:HOME\.nuget\packages\autorest\"
erase package-lock.json

dotnet restore
npm install
./get-node.ps1