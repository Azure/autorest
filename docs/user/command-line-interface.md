# AutoRest Command Line Interface Documentation

## AutoRest

The AutoRest command line has been vastly simplified, with the preference to move things that were on the command line into a configuration file, with the ability to override the configuration file settings from the command line.

### Command-line Usage

> `autorest [config-file.md | config-file.json | config-file.yaml] [additional options]`

### Configuration file

AutoRest will use a [configuration file](./configuration.md) to control the code generation process. By default, AutoRest will look for a file called `readme.md` or it can be passed on the command line.

This is the preferred method, instead of passing all the information on the command line.

If you prefer to name your configuration file something else, you can supply the filename on the command line:

```bash
autorest my_config.md
```

#### Passing additional options on the command line.

It is possible to override settings from the configuration file on the command line by prefacing the value with double dash (`--`) and setting the value with an equals sign (`=`). Ie:

```bash
autorest --input-file=myfile.json --output-folder=./generated/code/ --namespace=foo.bar
```

### Common Command-line Options

See [flags](https://github.com/azure/autorest/blob/main/docs/generate/flags.md)

#### Authentication

AutoRest supports generating from private GitHub repositories.
There are multiple options:

1. **Using the `token` query parameter**: Pass the `token` query parameter you get when clicking "Raw" on a file of a private repo, i.e. `https://github.com/<path-on-some-private-repo>/readme.md?token=<token>`.
   When such a URI is passed to AutoRest, it will automatically reuse that token for subsequent requests (e.g. querying referenced OpenAPI definitions).
   This is a quick and easy solution if you manually want to run AutoRest against private bits from time to time.
2. **Using OAuth**: GitHub allows generating OAuth tokens under `Settings -> Personal access tokens`.
   Create one with `repo` scope.
   It can be passed to AutoRest using `--github-auth-token=<token>` or by setting the environment variable `GITHUB_AUTH_TOKEN`.
   This is the way to go for all scripts and automation.
   Needless to say, _do not put this token_ into scripts directly, use Azure KeyVault or similar.
   **Note**: If the repository is in an organization it might require the Github Token to be given explicit permission to that organization.(Next to the token Enable SSO > Click Authorize for the relevant organization)
