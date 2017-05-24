cmd /c rmdir /s /q "$ENV:HOME\.nuget\packages\.tools\autorest\"
cmd /c rmdir /s /q "$ENV:HOME\.nuget\packages\autorest\"

dotnet build --configuration release
dotnet publish --configuration release
copy bin/release/netcoreapp1.0/publish/* tools/
dotnet pack --configuration release 