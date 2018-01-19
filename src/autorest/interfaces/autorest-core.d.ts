/// <reference path="./source-maps.d.ts" />
declare module 'autorest-core/lib/artifact' {
	export interface Artifact {
    uri: string;
    type: string;
    content: string;
}

}
declare module 'autorest-core/lib/ref/safe-eval' {
	export const safeEval: <T>(expression: string, context?: any) => T;

}
declare module 'autorest-core/lib/ref/jsonpath' {
	import * as jsonpath from "jsonpath";
export type JsonPathComponent = jsonpath.PathComponent;
export type JsonPath = JsonPathComponent[];
export function parse(jsonPath: string): JsonPath;
export function stringify(jsonPath: JsonPath): string;
export function paths<T>(obj: T, jsonQuery: string): JsonPath[];
export function nodes<T>(obj: T, jsonQuery: string): {
    path: JsonPath;
    value: any;
}[];
export function IsPrefix(prefix: JsonPath, path: JsonPath): boolean;
export function CreateObject(jsonPath: JsonPath, leafObject: any): any;
export function matches(jsonQuery: string, jsonPath: JsonPath): boolean;
export function parseJsonPointer(jsonPointer: string): JsonPath;

}
declare module 'autorest-core/lib/constants' {
	export const MagicString: string;
export const DefaultConfiguration: string;

}
declare module 'autorest-core/lib/ref/array' {
	export function pushAll<T>(target: T[], source: T[]): void;

}
declare module 'autorest-core/lib/ref/source-map' {
	export { Position } from "source-map";
import { Position } from "source-map";
export { RawSourceMap } from "source-map";
import { JsonPath } from 'autorest-core/lib/ref/jsonpath';
export interface PositionEnhancements {
    path?: JsonPath;
    length?: number;
    valueOffset?: number;
    valueLength?: number;
}
export type EnhancedPosition = Position & PositionEnhancements;
export type SmartPosition = Position | {
    path: JsonPath;
};
export interface Mapping {
    generated: SmartPosition;
    original: SmartPosition;
    source: string;
    name?: string;
}
export type Mappings = Array<Mapping>;

}
declare module 'autorest-core/lib/message' {
	import { EnhancedPosition, Position } from 'autorest-core/lib/ref/source-map';
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
}
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

}
declare module 'autorest-core/lib/ref/async' {
	/// <reference types="node" />
export function mkdir(path: string | Buffer): Promise<void>;
export const exists: (path: string | Buffer) => Promise<boolean>;
export function readdir(path: string): Promise<Array<string>>;
export function close(fd: number): Promise<void>;
export function readFile(path: string, options?: {
    encoding?: string | null;
    flag?: string;
}): Promise<string | Buffer>;
export function writeFile(filename: string, content: string): Promise<void>;

}
declare module 'autorest-core/lib/ref/uri' {
	export function IsUri(uri: string): boolean;
/**
 * Loads a UTF8 string from given URI.
 */
export function ReadUri(uri: string, headers?: {
    [key: string]: string;
}): Promise<string>;
export function ExistsUri(uri: string): Promise<boolean>;
/**
 * Create a 'file:///' URI from given absolute path.
 * Examples:
 * - "C:\swagger\storage.yaml" -> "file:///C:/swagger/storage.yaml"
 * - "/input/swagger.yaml" -> "file:///input/swagger.yaml"
 */
export function CreateFileOrFolderUri(absolutePath: string): string;
export function CreateFileUri(absolutePath: string): string;
export function CreateFolderUri(absolutePath: string): string;
export function EnsureIsFolderUri(uri: string): string;
export function EnsureIsFileUri(uri: string): string;
export function GetFilename(uri: string): string;
export function GetFilenameWithoutExtension(uri: string): string;
export function ToRawDataUrl(uri: string): string;
/**
 * The singularity of all resolving.
 * With URI as our one data type of truth, this method maps an absolute or relative path or URI to a URI using given base URI.
 * @param baseUri   Absolute base URI
 * @param pathOrUri Relative/absolute path/URI
 * @returns Absolute URI
 */
export function ResolveUri(baseUri: string, pathOrUri: string): string;
export function ParentFolderUri(uri: string): string | null;
export function MakeRelativeUri(baseUri: string, absoluteUri: string): string;
export function EnumerateFiles(folderUri: string, probeFiles?: string[]): Promise<string[]>;
/**
 * Writes string to local file system.
 * @param fileUri  Target file uri.
 * @param data     String to write (encoding: UTF8).
 */
export function WriteString(fileUri: string, data: string): Promise<void>;
export function ClearFolder(folderUri: string): Promise<void>;
export function FileUriToPath(fileUri: string): string;
export function GetExtension(name: string): string;

}
declare module 'autorest-core/lib/exception' {
	export class Exception extends Error {
    exitCode: number;
    constructor(message: string, exitCode?: number);
}
export class OperationCanceledException extends Exception {
    exitCode: number;
    constructor(message?: string, exitCode?: number);
}
export class OutstandingTaskAlreadyCompletedException extends Exception {
    constructor();
}
export class OperationAbortedException extends Exception {
    constructor();
}

}
declare module 'autorest-core/lib/lazy' {
	export class Lazy<T> {
    private factory;
    private promise;
    constructor(factory: () => T);
    readonly Value: T;
}
export class LazyPromise<T> implements PromiseLike<T> {
    private factory;
    private promise;
    constructor(factory: () => Promise<T>);
    private readonly Value;
    readonly hasValue: boolean;
    then<TResult1, TResult2>(onfulfilled: (value: T) => TResult1 | PromiseLike<TResult1>, onrejected: (reason: any) => TResult2 | PromiseLike<TResult2>): PromiseLike<TResult1 | TResult2>;
}

}
declare module 'autorest-core/lib/outstanding-task-awaiter' {
	export class OutstandingTaskAwaiter {
    private locked;
    private outstandingTasks;
    Wait(): Promise<void>;
    Await<T>(task: Promise<T>): Promise<T>;
}

}
declare module 'autorest-core/lib/events' {
	/// <reference types="node" />
import * as events from "events";
export interface IEvent<TSender extends events.EventEmitter, TArgs> {
    Subscribe(fn: (sender: TSender, args: TArgs) => void): () => void;
    Unsubscribe(fn: (sender: TSender, args: TArgs) => void): void;
    Dispatch(args: TArgs): void;
}
export class EventDispatcher<TSender extends EventEmitter, TArgs> implements IEvent<TSender, TArgs> {
    private _instance;
    private _name;
    private _subscriptions;
    constructor(instance: TSender, name: string);
    UnsubscribeAll(): void;
    Subscribe(fn: (sender: TSender, args: TArgs) => void): () => void;
    Unsubscribe(fn: (sender: TSender, args: TArgs) => void): void;
    Dispatch(args: TArgs): void;
}
export class EventEmitter extends events.EventEmitter {
    private _subscriptions;
    constructor();
    protected static Event<TSender extends EventEmitter, TArgs>(target: TSender, propertyKey: string): void;
    protected _init(t: EventEmitter): void;
}

}
declare module 'autorest-core/lib/ref/cancellation' {
	export { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";

}
declare module 'autorest-core/lib/ref/jsonrpc' {
	export * from "vscode-jsonrpc";

}
declare module 'autorest-core/lib/ref/commonmark' {
	export { Node, Parser } from "commonmark";

}
declare module 'autorest-core/lib/file-system' {
	export interface IFileSystem {
    EnumerateFileUris(folderUri: string): Promise<Array<string>>;
    ReadFile(uri: string): Promise<string>;
}
export class MemoryFileSystem implements IFileSystem {
    static readonly DefaultVirtualRootUri: string;
    private filesByUri;
    constructor(files: Map<string, string>);
    readonly Outputs: Map<string, string>;
    ReadFile(uri: string): Promise<string>;
    EnumerateFileUris(folderUri?: string): Promise<Array<string>>;
    WriteFile(uri: string, content: string): Promise<void>;
}
export class RealFileSystem implements IFileSystem {
    constructor();
    EnumerateFileUris(folderUri: string): Promise<string[]>;
    ReadFile(uri: string): Promise<string>;
    WriteFile(uri: string, content: string): Promise<void>;
}
export class EnhancedFileSystem implements IFileSystem {
    private githubAuthToken;
    constructor(githubAuthToken?: string | undefined);
    EnumerateFileUris(folderUri: string): Promise<string[]>;
    ReadFile(uri: string): Promise<string>;
    WriteFile(uri: string, content: string): Promise<void>;
}

}
declare module 'autorest-core/lib/document-type' {
	export enum DocumentType {
    OpenAPI2,
    OpenAPI3,
    LiterateConfiguration,
    Unknown,
}
export enum DocumentFormat {
    Markdown,
    Yaml,
    Json,
    Unknown,
}
export const DocumentExtension: {
    "yaml": DocumentFormat;
    "yml": DocumentFormat;
    "json": DocumentFormat;
    "md": DocumentFormat;
    "markdown": DocumentFormat;
};
export const DocumentPatterns: {
    yaml: string[];
    json: string[];
    markdown: string[];
    all: string[];
};

}
declare module 'autorest-core/main' {
	export { IFileSystem } from 'autorest-core/lib/file-system';
export { Message, Channel } from 'autorest-core/lib/message';
export { Artifact } from 'autorest-core/lib/artifact';
export { AutoRest, ConfigurationView, IdentifyDocument, IsConfigurationExtension, IsConfigurationDocument, IsOpenApiExtension, LiterateToJson, IsOpenApiDocument } from 'autorest-core/lib/autorest-core';
export { DocumentFormat, DocumentExtension, DocumentPatterns, DocumentType } from 'autorest-core/lib/document-type';

}
declare module 'autorest-core/help' {
	export interface Help {
    categoryFriendlyName: string;
    activationScope?: string;
    description?: string;
    settings: SettingHelp[];
}
export interface SettingHelp {
    required?: boolean;
    key: string;
    type?: string;
    description: string;
}

}
declare module 'autorest-core/lib/autorest-core' {
	import { IEvent, EventEmitter } from 'autorest-core/lib/events';
import { ConfigurationView } from 'autorest-core/lib/configuration';
export { ConfigurationView } from 'autorest-core/lib/configuration';
import { Message } from 'autorest-core/lib/message';
import { Artifact } from 'autorest-core/lib/artifact';
import { DocumentType } from 'autorest-core/lib/document-type';
/**
 * An instance of the AutoRest generator.
 *
 * Note: to create an instance of autore
 */
export class AutoRest extends EventEmitter {
    private fileSystem;
    configFileOrFolderUri: string | undefined;
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
    private _configurations;
    private _view;
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
        cancel: () => void;
    };
}
/** Determines the document type based on the content of the document
 *
 * @returns Promise<DocumentType> one of:
 *  -  DocumentType.LiterateConfiguration - contains the magic string '\n> see https://aka.ms/autorest'
 *  -  DocumentType.OpenAPI2 - $.swagger === "2.0"
 *  -  DocumentType.OpenAPI3 - $.openapi === "3.0.0"
 *  -  DocumentType.Unknown - content does not match a known document type
 *
 * @see {@link DocumentType}
 */
export function IdentifyDocument(content: string): Promise<DocumentType>;
/**
 * Processes a document (yaml, markdown or JSON) and returns the document as a JSON-encoded document text
 * @param content - the document content
 *
 * @returns the content as a JSON string (not a JSON DOM)
 */
export function LiterateToJson(content: string): Promise<string>;
/**
 * Checks to see if the document is a literate configuation document.
 *
 * @param content the document content to check
 */
export function IsConfigurationDocument(content: string): Promise<boolean>;
/**
  *  Given a document's content, does this represent a openapi document of some sort?
  *
  * @param content - the document content to evaluate
  */
export function IsOpenApiDocument(content: string): Promise<boolean>;
/**
 * Shuts down any active autorest extension processes.
 */
export function Shutdown(): Promise<void>;
/**
 * Checks if the file extension is a known file extension for a literate configuration document.
 * @param extension the extension to check (no leading dot)
 */
export function IsConfigurationExtension(extension: string): Promise<boolean>;
/**
 * Checks if the file extension is a known file extension for a OpenAPI document (yaml/json/literate markdown).
 * @param extension the extension to check (no leading dot)
 */
export function IsOpenApiExtension(extension: string): Promise<boolean>;

}
declare module 'autorest-core/lib/configuration' {
	import { Artifact } from 'autorest-core/lib/artifact';
import { EventEmitter, IEvent } from 'autorest-core/lib/events';
import { IFileSystem } from 'autorest-core/lib/file-system';
import { Message } from 'autorest-core/lib/message';
export interface AutoRestConfigurationImpl {
    __info?: string | null;
    "allow-no-input"?: boolean;
    "input-file"?: string[] | string;
    "base-folder"?: string;
    "directive"?: Directive[] | Directive;
    "declare-directive"?: {
        [name: string]: string;
    };
    "output-artifact"?: string[] | string;
    "message-format"?: "json" | "yaml" | "regular";
    "use-extension"?: {
        [extensionName: string]: string;
    };
    "require"?: string[] | string;
    "try-require"?: string[] | string;
    "help"?: any;
    "vscode"?: any;
    "override-info"?: any;
    "title"?: any;
    "description"?: any;
    "debug"?: boolean;
    "verbose"?: boolean;
    "output-file"?: string;
    "output-folder"?: string;
    "client-side-validation"?: boolean;
    "fluent"?: boolean;
    "azure-arm"?: boolean;
    "namespace"?: string;
    "license-header"?: string;
    "add-credentials"?: boolean;
    "package-name"?: string;
    "package-version"?: string;
    "sync-methods"?: "all" | "essential" | "none";
    "payload-flattening-threshold"?: number;
    "openapi-type"?: string;
}
export function MergeConfigurations(...configs: AutoRestConfigurationImpl[]): AutoRestConfigurationImpl;
export interface Directive {
    from?: string[] | string;
    where?: string[] | string;
    reason?: string;
    suppress?: string[] | string;
    set?: string[] | string;
    transform?: string[] | string;
    test?: string[] | string;
}
export class DirectiveView {
    private directive;
    constructor(directive: Directive);
    readonly from: Iterable<string>;
    readonly where: Iterable<string>;
    readonly reason: string | null;
    readonly suppress: Iterable<string>;
    readonly transform: Iterable<string>;
    readonly test: Iterable<string>;
}
export class MessageEmitter extends EventEmitter {
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
    private cancellationTokenSource;
    constructor();
}
export class ConfigurationView {
    messageEmitter: MessageEmitter;
    configFileFolderUri: string;
    [name: string]: any;
    private suppressor;
    readonly Keys: Array<string>;
    Dump(title?: string): void;
    private config;
    private rawConfig;
    private ResolveAsFolder(path);
    private ResolveAsPath(path);
    private readonly BaseFolderUri;
    readonly UseExtensions: Array<{
        name: string;
        source: string;
        fullyQualified: string;
    }>;
    IncludedConfigurationFiles(fileSystem: IFileSystem, ignoreFiles: Set<string>): Promise<string[]>;
    readonly Directives: DirectiveView[];
    readonly InputFileUris: string[];
    readonly OutputFolderUri: string;
    IsOutputArtifactRequested(artifact: string): boolean;
    GetEntry(key: keyof AutoRestConfigurationImpl): any;
    readonly Raw: AutoRestConfigurationImpl;
    readonly DebugMode: boolean;
    readonly VerboseMode: boolean;
    readonly HelpRequested: boolean;
    GetNestedConfiguration(pluginName: string): Iterable<ConfigurationView>;
    GetNestedConfigurationImmediate(...scope: any[]): ConfigurationView;
    Message(m: Message): void;
}
export class Configuration {
    private fileSystem;
    private configFileOrFolderUri;
    constructor(fileSystem?: IFileSystem, configFileOrFolderUri?: string | undefined);
    private ParseCodeBlocks(configFile, contextConfig, scope);
    private static extensionManager;
    private DesugarRawConfig(configs);
    private DesugarRawConfigs(configs);
    static shutdown(): Promise<void>;
    CreateView(messageEmitter: MessageEmitter, includeDefault: boolean, ...configs: Array<any>): Promise<ConfigurationView>;
    static DetectConfigurationFile(fileSystem: IFileSystem, configFileOrFolderUri: string | null, messageEmitter?: MessageEmitter, walkUpFolders?: boolean): Promise<string | null>;
    static DetectConfigurationFiles(fileSystem: IFileSystem, configFileOrFolderUri: string | null, messageEmitter?: MessageEmitter, walkUpFolders?: boolean): Promise<Array<string>>;
}

}
declare module 'autorest-core/language-service/language-service' {
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

}
declare module 'autorest-core/lib/sleep' {
	export function Delay(delayMS: number): Promise<void>;

}
interface OpenApi2Definition {
}
interface OpenApi3Definition {
}
