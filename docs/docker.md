# Use autorest with docker

Autorest provide some docker images.

## Usage

```bash
# Run the autorest image that fits your need(see next section for different options) and mount the current directory to access the openapi spec there.
docker run -v "${pwd}:/specs" -t <autorest-image> \
    --input-file=/specs/openapi.json
```
