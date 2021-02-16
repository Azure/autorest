# Writing an AutoRest Extension

This document aims to provide a concise explanation for how one would write,
test, and publish an extension for AutoRest v3.

## Developing an Extension

### Extension Packaging

AutoRest extensions are delivered via Node.js' `npm` ecosystem.  No matter which
language you use to write your AutoRest extension, you must create a
`package.json` file which provides the necessary metadata to AutoRest and
enables it to be shipped via `npm`.

The most important part of the `package.json` file will be the `scripts` section
because the `install` and `start` commands will be used by AutoRest to set up
and run your extension.  Here's a boilerplate `package.json` example that you
can use as a starting point:

#### Example `package.json`

```json
{
  "name": "@autorest/example-generator",
  "version": "0.1.0",
  "description": "An AutoRest generator extension.",
  "scripts": {
    "start": "<command to run your generator>",
    "install": "<command to build your generator>"
  },
  "systemRequirements": {
    "myCompiler": {
      "version": ">=3.2.1",
      "environmentVariable": "AUTOREST_MY_COMPILER_PATH"
    }
  }
}
```

NOTE: the package name _does not_ need to contain `@autorest`.

Consult the [`package.json`
documentation](https://docs.npmjs.com/files/package.json) for information on
more fields that you use to can supply additional information.

#### Extension system requirements

Autorest can automatically check for command line executable to be availaible in the path to ensure the start command succeed.

Schema:
```json
{
  "systemRequirements": {
    "<exe-name>": {
      "version": "<version-requirement [optional]>",
      "environmentVariable": "<environment variable name [optional]>",
    }
  }
}
```

| Field                 | Optional? | Description                                                                                                                                    | Example                    |
| --------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| `exe-name`            | Required  | This is the name of the executable that should be available in the path.                                                                       | `python`                   |
| `version`             | Optional  | This is the version requirement for the executable. It is only supported for [known commands](#known-commands)                                 | `>=3.6`                    |
| `environmentVariable` | Optional  | This is a name of an environment variable where the extension could expect the user to configure the path to the exe to use for this extension | `AUTOREST_PYTHON_EXE_PATH` |


##### Known commands

This is a list of known commands that will be able to retrieve the version of.
- `dotnet`
- `java`
- `python`: Python(only python 3+) will automatically look for `py`, `python3` and `python` for a compatible version.

##### Programtic usage.

You can consume the `@azure-tools/extension` package to use any of the `resolveXYZRequirement` to get the same results and/or get the path to the command.

```ts
import {resolvePythonRequirement} from "@azure-tools/extensions"

const resolution = await resolvePythonRequirement({version: ">=3.6"});
if(resolution.error) {
  console.error("Error", resolution)
} else {
  console.log("Command for python 3.6 is:", resolution.command)
}
```

### RPC Channel

AutoRest uses [JSON-RPC](https://www.jsonrpc.org/specification) to communicate
with AutoRest extensions that are loaded into the pipeline.  When AutoRest
starts your extension process via the `start` script of your `package.json`, it
will expect to communicate via JSON-RPC over the standard input and output
(`stdin`/`stdout`) streams of your process.  Messages sent by AutoRest will be
read by the extension from `stdin` and messages sent to AutoRest should be
written to `stdout`.

All AutoRest messages have positional parameters which are specified by
supplying an [array of
values](https://www.jsonrpc.org/specification#parameter_structures) to the
`params` field of the message.

#### Typical RPC Flow

Here's the general process of how AutoRest will communicate with your extension:

1. AutoRest will run through the pipeline, and once it reaches the phase for your extension, it will run `npm run start` which invokes the command in your `package.json` as described above.
2. AutoRest will attach to `stdio` and `stdout` of your process to establish the RPC channel
3. AutoRest will send the `GetPluginNames` request which should be responded to with the plugin name(s) your extension provides (typically a name like `python` or whatever language you are providing a generator for)
4. AutoRest will send a `Process` message to your extension for the plugin it wants to launch, providing a `sessionId` to be used for all future messages.  **Do not** respond to this message yet!  AutoRest uses the response to determine when the extension has finished processing files.
5. Your extension *may* send a `ListFiles` request to find the file(s) it needs to process (you can skip this step if you will just be asking for `@autorest/modelerfour`'s `code-model-v4.yaml`).
6. Your extension will send a `ReadFile` request to read the specific file it wants to process (ask for `code-model-v4.yaml` if writing an AutoRest v3 language generator).
7. Your extension will build its output files based on the code model and then send `WriteFile` notifications for each file that should be written to the output folder.  You can send as many `WriteFile` notifications you like at any time, no need to wait for a response.
8. Once your extension is finished writing output files, it should send a response to the `Process` request and then exit with a code of `0`.


### Extension Messages

The following messages will be sent from AutoRest to the extension via `stdin`:

#### `GetPluginNames` Request

The `GetPluginNames` message is sent to the extension to request the list of
plugin names that the extension provides.

##### Parameters

This message does not have any parameters.

##### Example

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "GetPluginNames"
}
```

##### Response

The extension should return an array of plugin names, typically an array
containing a single string, the name of the plugin that you register in the
`pipeline` configuration of your extension's `README.md` file.

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": ["my-extension-name"]
}
```


#### `Process` Request

The `Process` message is sent to the extension to initiate processing of its
inputs.

##### Parameters

- `pluginName` - A string representing the name of the plugin to launch, typically the one you registered in your extension configuration.
- `sessionId` - A string representing the unique ID of the AutoRest session.  This should be sent back to AutoRest as a parameter in requests or notifications.

##### Example

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "Process",
  "params": ["plugin-name", "unique-session-id"]
}
```

##### Response

The extension should send a plain response **only** when processing of files is complete to signal to AutoRest that the extension is finished:

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": true
}
```

### AutoRest Messages

The following messages can be sent by the extension to AutoRest by writing to
`stdout`:

#### `ListInputs` Request

The `ListInputs` message requests the list of inputs that can be read using the
`ReadFile` request.

##### Parameters

- `sessionId` - The sessionId that was provided in the `Process` request
- `artifactType` - (Optional) The artifact type to look for (typically you'd pass `code-model-v4` to get `modelerfour` output)

##### Example

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "ListInputs",
  "params": ["unique-session-id", "code-model-v4"]
}
```

##### Response

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": ["code-model-v4.yaml"]
}
```

#### `ReadFile` Request

The `ReadFile` message requests the contents of a particular input file.

##### Parameters

- `sessionId` - The sessionId that was provided in the `Process` request
- `filename` - The name of the file to read from AutoRest

##### Example

```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "ReadFile",
  "params": ["unique-session-id", "code-model-v4.yaml"]
}
```

##### Response

```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "result": "contents of code-model-v4.yaml"
}
```

#### `GetValue` Request

The `GetValue` message requests the value for a particular AutoRest configuration setting.

##### Parameters

- `sessionId` - The sessionId that was provided in the `Process` request
- `key` - The key of the configuration value to read. Can be hierarchical, i.e. "my-extension.config-field"

##### Returns

Returns a value of an essential JSON type like a string, boolean, or number.

##### Example

```json
{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "GetValue",
  "params": ["unique-session-id", "my-extension.config-field"]
}
```

##### Response

```json
{
  "jsonrpc": "2.0",
  "id": 5,
  "result": 42
}
```

#### `WriteFile` Notification

The `WriteFile` message notifies AutoRest to write out a file with the given name and contents.

##### Parameters

- `sessionId` - The sessionId that was provided in the `Process` request
- `filename` - The filename of the output file.
- `content` - The string content of the output file.

##### Example

```json
{
  "jsonrpc": "2.0",
  "method": "WriteFile",
  "params": ["unique-session-id", "output.py", "contents of output.py]
}
```

##### Response

There is no response to this notification.

#### `Message` Notification

The `Message` message notifies AutoRest to write out a message to the execution log.

##### Parameters

- `sessionId` - The sessionId that was provided in the `Process` request
- `message` - The message object having the structure described below


##### `Message` object structure

The `Message` object is a JSON object with the following fields:

- `Channel` - The 'channel' to which the message will be logged.  It must be one of the following strings:
  - `information` - For informational purposes, not actionable
  - `hint` - For informational purposes, not actionable
  - `warning` - Considered important but not fatal
  - `debug` - Used to log internal AutoRest and generator information
  - `verbose` - Used to give additional information to the user about the executing run
  - `error` - Errors that prevent successful operation
  - `fatal` - Fatal errors that may end the process immediately
- `Text` - The textual message to display to the user
- `Key` - (Optional) An array of strings which give context to where the message originated
- `Details` - (Optional) Additional details about the error, can be of any JSON type
- `Source` - (Optional) The location in the input file where the message was raised

##### Example

```json
{
  "jsonrpc": "2.0",
  "method": "Message",
  "params": ["unique-session-id", { "Channel": "debug", "Text": "This is a test message!" }]
}
```

##### Response

There is no response to this notification.
