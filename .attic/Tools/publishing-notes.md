# Notes regarding publishing versions

AutoRest is versioned in four files:


``` text
./VERSION
./src/autorest-core/package.json
./src/autorest/package.json
./src/common/common.proj
./package/nuget/dotnet-autorest.csproj
./package/nuget/package.json 

```

Update the version in those locations.

## Process 
1. Ensure the version is set correctly in the four locations, and commit to github if neccessary.
2. Run the job in CI to publish the build
3. Update the version to the next version in the four files and push to github (this ensures that followup builds are higher version, and when `-preview` is added, that it is a preview for the next version.

