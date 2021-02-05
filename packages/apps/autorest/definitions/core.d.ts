// Dear @future_garrett:
//   Currently, the construction of this file is hand-constructed, and should really be automated in the future.
//   I would have done it today, but ... frankly, I don't see what the payoff is for me, when it's not my problem.
//
//   Sincerly yours,
//     @fearthecowboy.

declare module "autorest-core" {
  import * as events from "events";

  export interface Position {
    line: number;
    column: number;
  }
  export interface PositionEnhancements {
    path?: JsonPath;
    length?: number;
    valueOffset?: number;
    valueLength?: number;
  }

  export type JsonPathComponent = string | number;
  export type JsonPath = Array<JsonPathComponent>;

  /**
   * The Channel that a message is registered with.
   */
  export enum Channel {
    /** Information is considered the mildest of responses; not necesarily actionable. */
    Information,

    /** Warnings are considered important for best practices, but not catastrophic in nature. */
    Warning,

    /** Errors are considered blocking issues that block a successful operation.  */
    Error,

    /** Debug messages are designed for the developer to communicate internal autorest implementation details. */
    Debug,

    /** Verbose messages give the user additional clarity on the process. */
    Verbose,

    /** Catastrophic failure, likely abending the process.  */
    Fatal,

    /** Hint messages offer guidance or support without forcing action. */
    Hint,

    /** File represents a file output from an extension. Details are a Artifact and are required.  */
    File,

    /** content represents an update/creation of a configuration file. The final uri will be in the same folder as the primary config file. */
    Configuration,
  }

  export type EnhancedPosition = Position & PositionEnhancements;

  export interface SourceLocation {
    document: string;
    Position: EnhancedPosition;
  }
  export interface Range {
    document: string;
    start: Position;
    end: Position;
  }
  export interface Message {
    Channel: Channel;
    Key?: Iterable<string>;
    Details?: any;
    Text: string;
    Source?: Array<SourceLocation>;
    Range?: Iterable<Range>;
    Plugin?: string;
    FormattedMessage?: string;
  }

  export type SmartPosition = Position | { path: JsonPath };

  export interface Mapping {
    generated: SmartPosition;
    original: SmartPosition;
    source: string;
    name?: string;
  }

  interface RawSourceMap {
    version: number;
    sources: string[];
    names: string[];
    sourceRoot?: string;
    sourcesContent?: string[];
    mappings: string;
    file: string;
  }

  export interface Artifact {
    uri: string;
    type: string;
    content: string;
  }

  export interface ArtifactMessage extends Message {
    Details: Artifact & {
      sourceMap?: Array<Mapping> | RawSourceMap;
    };
  }


  /**
   * The results from calling the 'generate' method via the {@link AutoRestLanguageService/generate}
   *
   */
  export interface GenerationResults {
    /** the array of messages produced from the run. */

    messages: Array<string>;
    /** the collection of outputted files.
     *
     * Member keys are the file names
     * Member values are the file contents
     *
     * To Access the files:
     * for( const filename in generated.files ) {
     *   const content = generated.files[filename];
     *   /// ...
     * }
     */
    files: Map<string, string>;
  }

  export interface IFileSystem {
    EnumerateFileUris(folderUri: string): Promise<Array<string>>;
    ReadFile(uri: string): Promise<string>;
  }

  class EventEmitter extends events.EventEmitter {
  }

  export interface IEvent<TSender extends events.EventEmitter, TArgs> {
    Subscribe(fn: (sender: TSender, args: TArgs) => void): () => void;
    Unsubscribe(fn: (sender: TSender, args: TArgs) => void): void;
    Dispatch(args: TArgs): void;
  }

  export interface MessageEmitter extends EventEmitter {
    /**
     * Event: Signals when a File is generated
     */
    GeneratedFile: IEvent<MessageEmitter, Artifact>;
    /**
     * Event: Signals when a Folder is supposed to be cleared
     */
    ClearFolder: IEvent<MessageEmitter, string>;
    /**
     * Event: Signals when a message is generated
     */
    Message: IEvent<MessageEmitter, Message>;
  }

  export interface Directive {
    from?: Array<string> | string;
    where?: Array<string> | string;
    reason?: string;
    suppress?: Array<string> | string;
    set?: Array<string> | string;
    transform?: Array<string> | string;
    test?: Array<string> | string;
  }

  export interface DirectiveView {
    readonly from: Iterable<string>;
    readonly where: Iterable<string>;
    readonly reason: string | null;
    readonly suppress: Iterable<string>;
    readonly transform: Iterable<string>;
    readonly test: Iterable<string>;
  }

  export interface AutoRestConfigurationImpl {
    __info?: string | null;
    'allow-no-input'?: boolean;
    'input-file'?: Array<string> | string;
    'base-folder'?: string;
    'directive'?: Array<Directive> | Directive;
    'declare-directive'?: {
      [name: string]: string;
    };
    'output-artifact'?: Array<string> | string;
    'message-format'?: 'json' | 'yaml' | 'regular';
    'use-extension'?: {
      [extensionName: string]: string;
    };
    'require'?: Array<string> | string;
    'try-require'?: Array<string> | string;
    'help'?: any;
    'vscode'?: any;
    'override-info'?: any;
    'title'?: any;
    'description'?: any;
    'debug'?: boolean;
    'verbose'?: boolean;
    'output-file'?: string;
    'output-folder'?: string;
    'client-side-validation'?: boolean;
    'fluent'?: boolean;
    'azure-arm'?: boolean;
    'namespace'?: string;
    'license-header'?: string;
    'add-credentials'?: boolean;
    'package-name'?: string;
    'package-version'?: string;
    'sync-methods'?: 'all' | 'essential' | 'none';
    'payload-flattening-threshold'?: number;
    'openapi-type'?: string;
  }

  export interface ConfigurationView {
    configurationFiles: {
      [key: string]: any;
    };
    fileSystem: IFileSystem;
    messageEmitter: MessageEmitter;
    configFileFolderUri: string;
    [name: string]: any;
    readonly Keys: Array<string>;
    readonly UseExtensions: Array<{
      name: string;
      source: string;
      fullyQualified: string;
    }>;
    IncludedConfigurationFiles(fileSystem: IFileSystem, ignoreFiles: Set<string>): Promise<Array<string>>;
    readonly Directives: Array<DirectiveView>;
    readonly config.inputFileUris: Array<string>;
    readonly OutputFolderUri: string;
    IsOutputArtifactRequested(artifact: string): boolean;
    GetEntry(key: keyof AutoRestConfigurationImpl): any;
    readonly Raw: AutoRestConfigurationImpl;
    readonly DebugMode: boolean;
    readonly VerboseMode: boolean;
    readonly HelpRequested: boolean;
    GetNestedConfiguration(pluginName: string): Iterable<ConfigurationView>;
    GetNestedConfigurationImmediate(...scope: Array<any>): ConfigurationView;
    Message(m: Message): void;
  }

  /**
     * An instance of the AutoRest generator.
     *
     * Note: to create an instance of autore
     */
  export interface AutoRest extends EventEmitter {
    configFileOrFolderUri?: string | undefined;
    /**
     * Event: Signals when a Process() finishes.
     */
    Finished: IEvent<AutoRest, boolean | Error>;
    /**
     * Event: Signals when a File is generated
     */
    GeneratedFile: IEvent<AutoRest, Artifact>;
    /**
     * Event: Signals when a Folder is supposed to be cleared
     */
    ClearFolder: IEvent<AutoRest, string>;
    /**
     * Event: Signals when a message is generated
     */
    Message: IEvent<AutoRest, Message>;
    readonly view: Promise<ConfigurationView>;
    RegenerateView(includeDefault?: boolean): Promise<ConfigurationView>;
    Invalidate(): void;
    AddConfiguration(configuration: any): void;
    ResetConfiguration(): Promise<void>;
    /**
     * Called to start processing of the files.
     */
    Process(): {
      finish: Promise<boolean | Error>;
      cancel(): void;
    };
  }
}
