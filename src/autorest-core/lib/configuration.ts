import { BlameTree } from './source-map/blaming';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { BlameTree } from "./source-map/blaming";
import { Clone } from "./ref/yaml";
import { OperationAbortedException } from "./exception";
import { TryDecodeEnhancedPositionFromName } from "./source-map/source-map";
import { Suppressor } from "./pipeline/suppression";
import { matches, stringify } from "./ref/jsonpath";
import { MergeOverwriteOrAppend, resolveRValue, ShallowCopy } from "./source-map/merging";
import { DataHandleRead, DataStore } from "./data-store/data-store";
import { EventEmitter, IEvent } from "./events";
import { CodeBlock, EvaluateGuard, ParseCodeBlocks } from "./parsing/literate-yaml";
import { CreateFolderUri, EnsureIsFolderUri, ReadUri, ResolveUri } from "./ref/uri";
import { From } from "./ref/linq";
import { IFileSystem } from "./file-system";
import * as Constants from "./constants";
import { Channel, Message, SourceLocation, Range } from "./message";
import { Artifact } from "./artifact";
import { CancellationTokenSource, CancellationToken } from "./ref/cancallation";

const RESOLVE_MACROS_AT_RUNTIME = true;

export interface AutoRestConfigurationImpl {
  __info?: string | null;
  "input-file": string[] | string;
  "base-folder"?: string;
  "directive"?: Directive[] | Directive;
  "output-artifact"?: string[] | string;
  "message-format"?: "json";
  "vscode"?: any; // activates VS Code specific behavior and does *NOT* influence the core's behavior (only consumed by VS Code extension)

  "debug"?: boolean;
  "verbose"?: boolean;

  // plugin specific
  "output-file"?: string;
  "output-folder"?: string;

  // from here on: CONVENTION, not cared about by the core
  "client-side-validation"?: boolean; // C#
  "fluent"?: boolean;
  "azure-arm"?: boolean;
  "azure-validator"?: boolean;
  "model-validator"?: boolean;
  "semantic-validator"?: boolean;
  "override-info"?: any; // make sure source maps are pulling it! (see "composite swagger" method)
  "namespace"?: string; // TODO: the modeler cares :( because it is badly designed
  "license-header"?: string;
  "add-credentials"?: boolean;
  "package-name"?: string; // Ruby, Python, ...
  "package-version"?: string;
  "sync-methods"?: "all" | "essential" | "none";
  "payload-flattening-threshold"?: number;
}

// TODO: operate on DataHandleRead and create source map!
function MergeConfigurations(higherPriority: AutoRestConfigurationImpl, lowerPriority: AutoRestConfigurationImpl): AutoRestConfigurationImpl {
  // check guard
  if (lowerPriority.__info && !EvaluateGuard(lowerPriority.__info, higherPriority)) {
    // guard false? => skip
    return higherPriority;
  }

  // merge
  return MergeOverwriteOrAppend(higherPriority, lowerPriority);
}

function ValuesOf<T>(value: any): Iterable<T> {
  if (value === undefined) {
    return [];
  }
  if (value instanceof Array) {
    return value;
  }
  return [value];
}

export interface Directive {
  from?: string[] | string;
  where?: string[] | string;
  reason?: string;

  // one of:
  suppress?: string[] | string;
  set?: string[] | string;
  transform?: string[] | string;
  test?: string[] | string;
}

export class DirectiveView {
  constructor(private directive: Directive) {
  }

  public get from(): Iterable<string> {
    return ValuesOf<string>(this.directive["from"]);
  }

  public get where(): Iterable<string> {
    return ValuesOf<string>(this.directive["where"]);
  }

  public get reason(): string | null {
    return this.directive.reason || null;
  }

  public get suppress(): Iterable<string> {
    return ValuesOf<string>(this.directive["suppress"]);
  }

  public get set(): Iterable<string> {
    return ValuesOf<string>(this.directive["set"]);
  }

  public get transform(): Iterable<string> {
    return ValuesOf<string>(this.directive["transform"]);
  }

  public get test(): Iterable<string> {
    return ValuesOf<string>(this.directive["test"]);
  }
}

export class MessageEmitter extends EventEmitter {
  /**
  * Event: Signals when a File is generated
  */
  @EventEmitter.Event public GeneratedFile: IEvent<MessageEmitter, Artifact>;
  /**
   * Event: Signals when a message is generated
   */
  @EventEmitter.Event public Message: IEvent<MessageEmitter, Message>;
  private cancellationTokenSource = new CancellationTokenSource();

  constructor() {
    super();
    this.DataStore = new DataStore(this.CancellationToken);
  }
  /* @internal */ public DataStore: DataStore;
  /* @internal */ public get messageEmitter() { return this; }
  /* @internal */ public get CancellationTokenSource(): CancellationTokenSource { return this.cancellationTokenSource; }
  /* @internal */ public get CancellationToken(): CancellationToken { return this.cancellationTokenSource.token; }
}

function ProxifyConfigurationView(cfgView: any) {
  return new Proxy(cfgView, {
    get: (target, property) => {
      const value = (<any>target)[property];
      if (value && value instanceof Array) {
        const result = [];
        for (const each of value) {
          result.push(resolveRValue(each, "", target, null));
        }
        return result;
      }
      return resolveRValue(value, <string>property, null, cfgView);
    }
  });
}


export class ConfigurationView {
  [name: string]: any;

  private suppressor: Suppressor;

  /* @internal */ constructor(
    /* @internal */public messageEmitter: MessageEmitter,
    /* @internal */public configFileFolderUri: string,
    ...configs: Array<AutoRestConfigurationImpl> // decreasing priority
  ) {

    // TODO: fix configuration loading, note that there was no point in passing that DataStore used
    // for loading in here as all connection to the sources is lost when passing `Array<AutoRestConfigurationImpl>` instead of `DataHandleRead`s...
    // theoretically the `ValuesOf` approach and such won't support blaming (who to blame if $.directives[3] sucks? which code block was it from)
    // long term, we simply gotta write a `Merge` method that adheres to the rules we need in here.
    this.rawConfig = <any>{
      "directive": [],
      "input-file": [],
      "output-artifact": [],
    };

    for (const config of configs) {
      this.rawConfig = MergeConfigurations(this.rawConfig, config);
    }

    // default values that are the least priority.
    this.rawConfig = MergeConfigurations(this.rawConfig, <any>{
      "base-folder": ".",
      "output-folder": "generated",
      "debug": false,
      "verbose": false,
      "disable-validation": false
    });

    if (RESOLVE_MACROS_AT_RUNTIME) {
      // if RESOLVE_MACROS_AT_RUNTIME is set
      // this will insert a Proxy object in most of the uses of
      // the configuration, and will do a macro resolution when the
      // value is retrieved.

      // I have turned on this behavior by default. I'm not sure that
      // I need it at this point, but I'm leaving this code here since
      // It's possible that I do.
      this.config = ProxifyConfigurationView(this.rawConfig);
    } else {
      this.config = this.rawConfig;
    }

    this.suppressor = new Suppressor(this);
    this.Message({ Channel: Channel.Debug, Text: `Creating ConfigurationView : ${configs.length} sections.` });
  }

  public get Keys(): Array<string> {
    return Object.getOwnPropertyNames(this.config);
  }

  public Dump(title: string = "") {
    console.log(`\n${title}\n===================================`)
    for (const each of Object.getOwnPropertyNames(this.config)) {
      console.log(`${each} : ${(<any>this.config)[each]}`);
    };
  }

  /* @internal */ public get Indexer(): ConfigurationView {
    return new Proxy<ConfigurationView>(this, {
      get: (target, property) => {
        return property in target.config ? (<any>target.config)[property] : this[property];
      }
    });
  }

  /* @internal */ public get DataStore(): DataStore { return this.messageEmitter.DataStore; }
  /* @internal */ public get CancellationToken(): CancellationToken { return this.messageEmitter.CancellationToken; }
  /* @internal */ public get CancellationTokenSource(): CancellationTokenSource { return this.messageEmitter.CancellationTokenSource; }
  /* @internal */ public get GeneratedFile(): IEvent<MessageEmitter, Artifact> { return this.messageEmitter.GeneratedFile; }

  private config: AutoRestConfigurationImpl;
  private rawConfig: AutoRestConfigurationImpl;

  private ResolveAsFolder(path: string): string {
    return EnsureIsFolderUri(ResolveUri(this.BaseFolderUri, path));
  }

  private ResolveAsPath(path: string): string {
    return ResolveUri(this.BaseFolderUri, path);
  }

  private get BaseFolderUri(): string {
    return EnsureIsFolderUri(ResolveUri(this.configFileFolderUri, this.config["base-folder"] as string));
  }

  // public methods

  public get Directives(): Iterable<DirectiveView> {
    return From(ValuesOf<Directive>(this.config["directive"]))
      .Select(each => new DirectiveView(each));
  }

  public get InputFileUris(): string[] {
    return From<string>(ValuesOf<string>(this.config["input-file"]))
      .Select(each => this.ResolveAsPath(each))
      .ToArray();
  }

  public get OutputFolderUri(): string {
    return this.ResolveAsFolder(this.config["output-folder"] as string);
  }

  public IsOutputArtifactRequested(artifact: string): boolean {
    return From(ValuesOf<string>(this.config["output-artifact"])).Contains(artifact);
  }

  public GetEntry(key: keyof AutoRestConfigurationImpl): any {
    return (this.config as any)[key];
  }

  public get Raw(): AutoRestConfigurationImpl {
    return this.config;
  }

  public get DebugMode(): boolean {
    return this.config["debug"] as boolean;
  }

  public get VerboseMode(): boolean {
    return this.config["verbose"] as boolean;
  }

  public * GetNestedConfiguration(pluginName: string): Iterable<ConfigurationView> {
    for (const section of ValuesOf<any>((this.config as any)[pluginName])) {
      if (section) {
        yield this.GetPluginViewImmediate(section === true ? {} : section);
      }
    }
  }

  public GetPluginViewImmediate(...scope: any[]): ConfigurationView {
    return new ConfigurationView(this.messageEmitter, this.configFileFolderUri, ...scope, this.config).Indexer;
  }

  // message pipeline (source map resolution, filter, ...)
  public Message(m: Message): void {
    if (m.Channel === Channel.Debug && !this.DebugMode) {
      return;
    }

    if (m.Channel === Channel.Verbose && !this.VerboseMode) {
      return;
    }

    try {
      // update source locations to point to loaded Swagger
      if (m.Source) {
        const blameSources = m.Source.map(s => {
          let blameTree: BlameTree | null = null;

          try {
            while (blameTree === null) {
              try {
                blameTree = this.DataStore.Blame(s.document, s.Position);
              } catch (e) {
                const path = s.Position.path as string[];
                if (path) {
                  this.Message({
                    Channel: Channel.Warning,
                    Text: `Could not find the exact path ${JSON.stringify(path)}`
                  });
                  if (path.length === 0) {
                    throw e;
                  }
                  path.pop();
                } else {
                  throw e;
                }
              }
            }
          } catch (e) {
            // TODO: activate as soon as .NET swagger loader stuff (inline responses, inline path level parameters, ...)
            //console.log(`Failed blaming '${JSON.stringify(s.Position)}' in '${s.document}'`);
            //console.log(e);
            return [s];
          }

          return blameTree.BlameLeafs().map(r => <SourceLocation>{ document: r.source, Position: Object.assign(TryDecodeEnhancedPositionFromName(r.name) || {}, { line: r.line, column: r.column }) });
        });

        //console.log("---");
        //console.log(JSON.stringify(m.Source, null, 2));
        m.Source = From(blameSources).SelectMany(x => x).ToArray();
        //console.log(JSON.stringify(m.Source, null, 2));
        //console.log("---");
      }

      // set range (dummy)
      if (m.Source) {
        m.Range = m.Source.map(s => {
          const positionStart = s.Position;
          const positionEnd = <sourceMap.Position>{ line: s.Position.line, column: s.Position.column + (s.Position.length || 3) };

          return <Range>{
            document: s.document,
            start: positionStart,
            end: positionEnd
          };
        });
      }

      // filter
      const mx = this.suppressor.Filter(m);

      // forward
      if (mx !== null) {
        // format message
        switch (this.GetEntry("message-format")) {
          case "json":
            // TODO: WHAT THE FUDGE, check with the consumers whether this has to be like that... otherwise, consider changing the format to something less generic
            if (mx.Details) {
              mx.Details.sources = (mx.Source || []).filter(x => x.Position).map(source => {
                let text = `${source.document}:${source.Position.line}:${source.Position.column}`;
                if (source.Position.path) {
                  text += ` (${stringify(source.Position.path)})`;
                }
                return text;
              });
              if (mx.Details.length > 0) {
                mx.Details["jsonref"] = mx.Details[0];
                mx.Details["json-path"] = mx.Details[0];
              }
            }
            mx.Text = JSON.stringify(mx.Details || mx, null, 2);
            break;
          default:
            let text = `${(mx.Channel || Channel.Information).toString().toUpperCase()}${mx.Key ? ` (${[...mx.Key].join("/")})` : ""}: ${mx.Text}`;
            for (const source of mx.Source || []) {
              if (source.Position) {
                text += `\n    - ${source.document}`;
                if (source.Position.line !== undefined) {
                  text += `:${source.Position.line}`;
                  if (source.Position.column !== undefined) {
                    text += `:${source.Position.column}`;
                  }
                }
                if (source.Position.path) {
                  text += ` (${stringify(source.Position.path)})`;
                }
              }
            }
            mx.Text = text;
            break;
        }

        this.messageEmitter.Message.Dispatch(mx);
      }
    } catch (e) {
      this.messageEmitter.Message.Dispatch({ Channel: Channel.Error, Text: `${e}` });
    }
  }
}


export class Configuration {
  private async ParseCodeBlocks(configFile: DataHandleRead, contextConfig: ConfigurationView, scope: string): Promise<AutoRestConfigurationImpl[]> {
    // load config
    const hConfig = await ParseCodeBlocks(
      contextConfig,
      configFile,
      contextConfig.DataStore.CreateScope(scope));

    const blocks = hConfig.map(each => {
      const block = each.data.ReadObject<AutoRestConfigurationImpl>();
      if (typeof block !== "object") {
        contextConfig.Message({
          Channel: Channel.Error,
          Text: "Syntax error: Invalid YAML object.",
          Source: [<SourceLocation>{ document: each.data.key, Position: { line: 1, column: 0 } }]
        });
        throw new OperationAbortedException();
      }
      block.__info = each.info;
      return block;
    });
    return blocks;
  }

  public async CreateView(messageEmitter: MessageEmitter, ...configs: Array<any>): Promise<ConfigurationView> {
    const configFileUri = this.fileSystem && this.configFileOrFolderUri
      ? await Configuration.DetectConfigurationFile(this.fileSystem, this.configFileOrFolderUri)
      : null;
    const configFileFolderUri = configFileUri ? ResolveUri(configFileUri, "./") : (this.configFileOrFolderUri || "file:///");

    const configSegments: any[] = [];
    // 1. overrides (CLI, ...)
    configSegments.push(...configs);
    // 2. file
    if (configFileUri !== null) {
      const inputView = messageEmitter.DataStore.GetReadThroughScopeFileSystem(this.fileSystem as IFileSystem);
      const blocks = await this.ParseCodeBlocks(
        await inputView.ReadStrict(configFileUri),
        new ConfigurationView(messageEmitter, configFileFolderUri, ...configSegments),
        "config");
      configSegments.push(...blocks);
    }
    // 3. default configuration
    {
      const inputView = messageEmitter.DataStore.GetReadThroughScope(_ => true);
      const blocks = await this.ParseCodeBlocks(
        await inputView.ReadStrict(ResolveUri(CreateFolderUri(__dirname), "../resources/default-configuration.md")),
        new ConfigurationView(messageEmitter, configFileFolderUri, ...configSegments),
        "default-config");
      configSegments.push(...blocks);
    }

    return new ConfigurationView(messageEmitter, configFileFolderUri, ...configSegments).Indexer;
  }

  public constructor(
    private fileSystem?: IFileSystem,
    private configFileOrFolderUri?: string
  ) {
  }

  public static async DetectConfigurationFile(fileSystem: IFileSystem, configFileOrFolderUri: string | null): Promise<string | null> {
    if (!configFileOrFolderUri || configFileOrFolderUri.endsWith(".md")) {
      return configFileOrFolderUri;
    }

    // search for a config file, walking up the folder tree
    while (configFileOrFolderUri !== null) {
      // scan the filesystem items for the configuration.
      const configFiles = new Map<string, string>();

      for await (const name of fileSystem.EnumerateFileUris(EnsureIsFolderUri(configFileOrFolderUri))) {
        if (name.endsWith(".md")) {
          const content = await fileSystem.ReadFile(name);
          if (content.indexOf(Constants.MagicString) > -1) {
            configFiles.set(name, content);
          }
        }
      }

      if (configFiles.size > 0) {
        // it's the readme.md or the shortest filename.
        const found =
          From<string>(configFiles.keys()).FirstOrDefault(each => each.toLowerCase().endsWith("/" + Constants.DefaultConfiguratiion)) ||
          From<string>(configFiles.keys()).OrderBy(each => each.length).First();

        return found;
      }

      // walk up
      const newUriToConfigFileOrWorkingFolder = ResolveUri(configFileOrFolderUri, "..");
      configFileOrFolderUri = newUriToConfigFileOrWorkingFolder === configFileOrFolderUri
        ? null
        : newUriToConfigFileOrWorkingFolder;
    }

    return null;
  }
}