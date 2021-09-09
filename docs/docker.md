# Use AutoRest with docker

AutoRest provide some docker images:

| Image               | Description            | Ubuntu |
| ------------------- | ---------------------- | ------ |
| `azuresdk/autorest` | This is the base image | ✔️     |

## Usage

```bash
# Run the autorest image that fits your need(see next section for different options) and mount the current directory to access the openapi spec there.
docker run -v "${pwd}:/specs" -t <autorest-image> \
    --input-file=/specs/openapi.json
```
