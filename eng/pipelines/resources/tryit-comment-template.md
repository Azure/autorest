You may test this build by running `autorest --reset` and then either:

<hr>
Add the following CLI flags

| Pacakge               | Flag                                          | Description                   |
| --------------------- | --------------------------------------------- | ----------------------------- |
| @autorest/core        | `--version:{{AUTOREST_CORE_DOWNLOAD_URL}}`    | For changes to autorest core. |
| @autorest/modelerfour | `--use:{{AUTOREST_MODELERFOUR_DOWNLOAD_URL}}` | For changes to modelerfour.   |

Or with all

```bash
autorest --version:{{AUTOREST_CORE_DOWNLOAD_URL}} --use:{{AUTOREST_MODELERFOUR_DOWNLOAD_URL}}
```

<hr>
or use the following in your autorest configuration:

```yaml
# For changes to autorest core
version: "{{AUTOREST_CORE_DOWNLOAD_URL}}"

# For changes to modelerfour
use-extension:
  "@autorest/modelerfour": "{{AUTOREST_MODELERFOUR_DOWNLOAD_URL}}"
```

<hr>
If this build is good for you, give this comment a thumbs up. (👍)
And you should run `autorest --reset` again once you're finished testing to remove it.
