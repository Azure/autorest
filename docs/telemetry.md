# Autorest Telemetry

Autorest will collect some anonymous telemetry information to help us improve.

## Disable

There is 2 options to disable the telemetry:

1. You can either disable by adding the `--disable-telemetry` flag to the cli.
2. Set the environment variable `AUTOREST_DISABLE_TELEMETRY` to any value.

## Data collected

This is a list of the data collected by autorest

Common properties added to each events:

| Name        | Description                                |
| ----------- | ------------------------------------------ |
| coreVersion | Version of autorest core that is being run |

Event and data recorded

| Name      | Description                                                                                                                          |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `CliArgs` | Event emitted on startup and contains the all the options passed in the cli with the value sanitized(Converted to `true` or `false`) |
