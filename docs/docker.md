# Use AutoRest with docker

AutoRest provide some docker images:

| Image                                             | Description                                                         | Ubuntu             |
| ------------------------------------------------- | ------------------------------------------------------------------- | ------------------ |
| `azsdkengsys.azurecr.io/azuresdk/autorest`        | Base image with node installed                                      | :heavy_check_mark: |
| `azsdkengsys.azurecr.io/azuresdk/autorest-python` | Base image + python 3 For building python sdk                       | :heavy_check_mark: |
| `azsdkengsys.azurecr.io/azuresdk/autorest-dotnet` | Base image + dotnet. For building csharp sdk                        | :heavy_check_mark: |
| `azsdkengsys.azurecr.io/azuresdk/autorest-java`   | Base image + java. For building java sdk                            | :heavy_check_mark: |
| `azsdkengsys.azurecr.io/azuresdk/autorest-all`    | Base image with all the languages for building any of the sdk above | :heavy_check_mark: |

## Usage

```bash
# Run the autorest image that fits your need(see next section for different options) and mount the current directory to access the openapi spec there.
docker run -v "${pwd}:/specs" -t <autorest-image> \
    --input-file=/specs/openapi.json
```
