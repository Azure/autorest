# AutoRest extension protocol

The protocol is bidirectional, i.e. AutoRest may call the API of the extension and vice versa. 

## Implementations

* TypeScript: [autorest-extension-base](https://github.com/olydis/autorest-extension-base) (example extension: [autorest-extension-helloworld](https://github.com/olydis/autorest-extension-helloworld))
* C#: see [azure-openapi-validator](https://github.com/Azure/azure-openapi-validator/tree/master/src/dotnet)

## AutoRest ⇒ Extension

``` TypeScript
GetPluginNames(): string[]
Process(pluginName: string, sessionId: string): boolean
```

## Extension ⇒ AutoRest 

``` TypeScript
ListInputs(sessionId: string, artifactType?: string): string[]
ReadFile(sessionId: string, filename: string): string
GetValue(sessionId: string, key: string): any

WriteFile(sessionId: string, filename: string, content: string, sourceMap?: Mapping[] | RawSourceMap): void
Message(sessionId: string, message: Message): void
```

### Enum: Channel 
``` typescript

/**
 * The Channel that a message is registered with.
 */
export enum Channel {
  /** Information is considered the mildest of responses; not necesarily actionable. */
  Information = <any>"information",

  /** Warnings are considered important for best practices, but not catastrophic in nature. */
  Warning = <any>"warning",

  /** Errors are considered blocking issues that block a successful operation.  */
  Error = <any>"error",

  /** Debug messages are designed for the developer to communicate internal autorest implementation details. */
  Debug = <any>"debug",

  /** Verbose messages give the user additional clarity on the process. */
  Verbose = <any>"verbose",

  /** Catastrophic failure, likely abending the process.  */
  Fatal = <any>"fatal",

  /** Hint messages offer guidance or support without forcing action. */
  Hint = <any>"hint",

  /** File represents a file output from an extension. Details are a Artifact and are required.  */
  File = <any>"file",
}
```

### Type: Message

``` TypeScript
{
  Channel: Channel
  Key?: string[]
  Details?: any
  Text: string
  Source?: SourceLocation[]
}
```

### Type: SourceLocation

``` TypeScript
{
  document: string  // the URI of the input document (as used for `ReadFile`)
  Position: Position
}
```

### Type: Position

``` TypeScript
{
  line: number // 1-based
  column: number // 0-based
} |
{
  path: (string | number)[] // object path (e.g. `['b', 3, 'a']` for $.b[3].a)
}
```

### Type: Mapping

``` TypeScript
{
  generated: Position // position in generated document
  original: Position  // position in source document
  source: string      // the URI of the input document (as used for `ReadFile`)
  name?: string
}
```

### Type: RawSourceMap

see [An Introduction to Source Maps](http://blog.teamtreehouse.com/introduction-source-maps)

``` TypeScript
{
  file?: string
  sourceRoot?: string
  version: string
  sources: string[]
  names: string[]
  sourcesContent?: string[]
  mappings: string
}
```