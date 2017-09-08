/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Extension, ExtensionManager, LocalExtension } from "@microsoft.azure/extension";
import { ChildProcess } from "child_process";

import { join } from "path";
import { Artifact } from './artifact';
import * as Constants from './constants';
import { DataHandle, DataStore } from './data-store/data-store';
import { EventEmitter, IEvent } from './events';
import { OperationAbortedException } from './exception';
import { IFileSystem, RealFileSystem } from './file-system';
import { LazyPromise } from './lazy';
import { Channel, Message, Range, SourceLocation } from './message';
import { EvaluateGuard, ParseCodeBlocks } from './parsing/literate-yaml';
import { AutoRestExtension } from './pipeline/plugin-endpoint';
import { Suppressor } from './pipeline/suppression';
import { exists } from './ref/async';
import { CancellationToken, CancellationTokenSource } from './ref/cancellation';
import { stringify } from './ref/jsonpath';
import { From } from './ref/linq';
import { CreateFileUri, CreateFolderUri, EnsureIsFolderUri, ResolveUri } from './ref/uri';
import { BlameTree } from './source-map/blaming';
import { MergeOverwriteOrAppend, resolveRValue } from './source-map/merging';
import { TryDecodeEnhancedPositionFromName } from './source-map/source-map';

const untildify: (path: string) => string = require("untildify");

const RESOLVE_MACROS_AT_RUNTIME = true;

export interface AutoRestConfigurationImpl {
  __info?: string | null;
  "allow-no-input"?: boolean;
  "input-file"?: string[] | string;
  "base-folder"?: string;
  "directive"?: Directive[] | Directive;
  "output-artifact"?: string[] | string;
  "message-format"?: "json";
  "use-extension"?: { [extensionName: string]: string };
  "vscode"?: any; // activates VS Code specific behavior and does *NOT* influence the core's behavior (only consumed by VS Code extension)

  "override-info"?: any; // make sure source maps are pulling it! (see "composite swagger" method)
  "title"?: any;
  "description"?: any;

  "debug"?: boolean;
  "verbose"?: boolean;

  // plugin specific
  "output-file"?: string;
  "output-folder"?: string;

  // from here on: CONVENTION, not cared about by the core
  "client-side-validation"?: boolean; // C#
  "fluent"?: boolean;
  "azure-arm"?: boolean;
  "namespace"?: string;
  "license-header"?: string;
  "add-credentials"?: boolean;
  "package-name"?: string; // Ruby, Python, ...
  "package-version"?: string;
  "sync-methods"?: "all" | "essential" | "none";
  "payload-flattening-threshold"?: number;
  "openapi-type"?: string // the specification type (ARM/Data-Plane/Default)
}

export function MergeConfigurations(...configs: AutoRestConfigurationImpl[]): AutoRestConfigurationImpl {
  let result: AutoRestConfigurationImpl = {};
  for (const config of configs) {
    result = MergeConfiguration(result, config);
  }
  return result;
}

// TODO: operate on DataHandleRead and create source map!
function MergeConfiguration(higherPriority: AutoRestConfigurationImpl, lowerPriority: AutoRestConfigurationImpl): AutoRestConfigurationImpl {
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
   * Event: Signals when a Folder is supposed to be cleared
   */
  @EventEmitter.Event public ClearFolder: IEvent<MessageEmitter, string>;
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

const loadedExtensions: { [fullyQualified: string]: { extension: Extension, autorestExtension: LazyPromise<AutoRestExtension> } } = {};
export async function GetExtension(fullyQualified: string): Promise<AutoRestExtension> {
  return await loadedExtensions[fullyQualified].autorestExtension;
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
      "use": [],
    };

    this.rawConfig = MergeConfigurations(this.rawConfig, ...configs);

    // default values that are the least priority.
    // TODO: why is this here and not in default-configuration?
    this.rawConfig = MergeConfiguration(this.rawConfig, <any>{
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
  /* @internal */ public get ClearFolder(): IEvent<MessageEmitter, string> { return this.messageEmitter.ClearFolder; }

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

  public get UseExtensions(): Array<{ name: string, source: string, fullyQualified: string }> {
    const useExtensions = this.Indexer["use-extension"] || {};
    return Object.keys(useExtensions).map(name => {
      const source = useExtensions[name];
      return {
        name: name,
        source: source,
        fullyQualified: JSON.stringify([name, source])
      };
    });
  }

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
    let result = this.config as any;
    for (const keyPart of key.split(".")) {
      result = result[keyPart];
    }
    return result;
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
        yield this.GetNestedConfigurationImmediate(section === true ? {} : section);
      }
    }
  }

  public GetNestedConfigurationImmediate(...scope: any[]): ConfigurationView {
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
                    Text: `Could not find the exact path ${JSON.stringify(path)} for ${JSON.stringify(m.Text)}`
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
            this.Message({
              Channel: Channel.Warning,
              Text: `Failed to blame ${JSON.stringify(s.Position)} in '${JSON.stringify(s.document)}' (${e})`,
              Details: e
            });
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
            mx.FormattedMessage = JSON.stringify(mx.Details || mx, null, 2);
            break;
          default:
            let text = `${(mx.Channel || Channel.Information).toString().toUpperCase()}${mx.Key ? ` (${[...mx.Key].join("/")})` : ""}: ${mx.Text}`;
            for (const source of mx.Source || []) {
              if (source.Position) {
                try {
                  const friendlyName = this.DataStore.ReadStrictSync(source.document).Description;
                  text += `\n    - ${friendlyName}`;
                  if (source.Position.line !== undefined) {
                    text += `:${source.Position.line}`;
                    if (source.Position.column !== undefined) {
                      text += `:${source.Position.column}`;
                    }
                  }
                  if (source.Position.path) {
                    text += ` (${stringify(source.Position.path)})`;
                  }
                } catch (e) {
                  // no friendly name, so nothing more specific to show
                }
              }
            }
            mx.FormattedMessage = text;
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
  public constructor(
    private fileSystem?: IFileSystem,
    private configFileOrFolderUri?: string,
  ) { }

  private async ParseCodeBlocks(configFile: DataHandle, contextConfig: ConfigurationView, scope: string): Promise<AutoRestConfigurationImpl[]> {
    // load config
    const hConfig = await ParseCodeBlocks(
      contextConfig,
      configFile,
      contextConfig.DataStore.DataSink);

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

  private extensionManager: LazyPromise<ExtensionManager> = new LazyPromise<ExtensionManager>(() => ExtensionManager.Create(join(process.env["autorest.home"] || require("os").homedir(), ".autorest")));

  private async DesugarRawConfig(configs: any): Promise<any> {
    // shallow copy
    configs = Object.assign({}, configs);
    configs["use-extension"] = Object.assign({}, configs["use-extension"]);

    // use => use-extension
    let use = configs.use;
    if (typeof use === "string") {
      use = [use];
    }
    if (Array.isArray(use)) {
      const extMgr = await this.extensionManager;
      for (const useEntry of use) {
        if (typeof useEntry === "string") {
          // attempt <package>@<version> interpretation
          const separatorIndex = useEntry.lastIndexOf('@');
          const versionPart = useEntry.slice(separatorIndex + 1);
          if (separatorIndex !== -1 && require("semver-regex")().test(versionPart)) {
            const pkg = await extMgr.findPackage(useEntry.slice(0, separatorIndex), versionPart);
            configs["use-extension"][pkg.name] = versionPart;
          } else {
            const pkg = await extMgr.findPackage("foo", useEntry);
            configs["use-extension"][pkg.name] = useEntry;
          }
        }
      }
      delete configs.use;
    }

    return configs;
  }

  private async DesugarRawConfigs(configs: any[]): Promise<any[]> {
    return Promise.all(configs.map(c => this.DesugarRawConfig(c)));
  }

  public async CreateView(messageEmitter: MessageEmitter, includeDefault: boolean, ...configs: Array<any>): Promise<ConfigurationView> {
    const configFileUri = this.fileSystem && this.configFileOrFolderUri
      ? await Configuration.DetectConfigurationFile(this.fileSystem, this.configFileOrFolderUri, messageEmitter)
      : null;
    const configFileFolderUri = configFileUri ? ResolveUri(configFileUri, "./") : (this.configFileOrFolderUri || "file:///");

    const createView = () => new ConfigurationView(messageEmitter, configFileFolderUri, ...configSegments);

    const configSegments: any[] = [];
    const addSegments = async (configs: any[]): Promise<void> => { configSegments.push(...await this.DesugarRawConfigs(configs)); };

    // 1. overrides (CLI, ...)
    await addSegments(configs);
    // 2. file
    if (configFileUri !== null) {
      const inputView = messageEmitter.DataStore.GetReadThroughScope(this.fileSystem as IFileSystem);
      const blocks = await this.ParseCodeBlocks(
        await inputView.ReadStrict(configFileUri),
        createView(),
        "config");
      await addSegments(blocks);
    }
    // 3. default configuration
    if (includeDefault) {
      const inputView = messageEmitter.DataStore.GetReadThroughScope(new RealFileSystem());
      const blocks = await this.ParseCodeBlocks(
        await inputView.ReadStrict(ResolveUri(CreateFolderUri(__dirname), "../../resources/default-configuration.md")),
        createView(),
        "default-config");
      await addSegments(blocks);
    }
    // 4. resolve externals
    const extMgr = await this.extensionManager;
    const addedExtensions = new Set<string>();
    while (true) {
      const tmpView = createView();
      const additionalExtensions = tmpView.UseExtensions.filter(ext => !addedExtensions.has(ext.fullyQualified));
      if (additionalExtensions.length === 0) {
        break;
      }
      // acquire additional extensions
      for (const additionalExtension of additionalExtensions) {
        try {
          addedExtensions.add(additionalExtension.fullyQualified);

          let ext = loadedExtensions[additionalExtension.fullyQualified];

          // not yet loaded?
          if (!ext) {
            const localPath = untildify(additionalExtension.source);
            if (await exists(localPath)) {
              // local package
              messageEmitter.Message.Dispatch({
                Channel: Channel.Information,
                Text: `Loading local AutoRest extension '${additionalExtension.name}' (${localPath})`
              });

              const pack = await extMgr.findPackage(additionalExtension.name, localPath);
              const extension = new LocalExtension(pack, localPath);
              // start extension
              ext = loadedExtensions[additionalExtension.fullyQualified] = {
                extension: extension,
                autorestExtension: new LazyPromise(async () => AutoRestExtension.FromChildProcess(additionalExtension.name, await extension.start()))
              };
            }
            else {
              // remote package
              const installedExtension = await extMgr.getInstalledExtension(additionalExtension.name, additionalExtension.source);
              if (installedExtension) {
                messageEmitter.Message.Dispatch({
                  Channel: Channel.Information,
                  Text: `Loading AutoRest extension '${additionalExtension.name}' (${additionalExtension.source})`
                });
                // start extension
                ext = loadedExtensions[additionalExtension.fullyQualified] = {
                  extension: installedExtension,
                  autorestExtension: new LazyPromise(async () => AutoRestExtension.FromChildProcess(additionalExtension.name, await installedExtension.start()))
                };
              } else {
                // acquire extension
                const pack = await extMgr.findPackage(additionalExtension.name, additionalExtension.source);
                messageEmitter.Message.Dispatch({
                  Channel: Channel.Information,
                  Text: `Installing AutoRest extension '${additionalExtension.name}' (${additionalExtension.source})`
                });
                const extension = await extMgr.installPackage(pack, false, 5 * 60 * 1000, (progressInit: any) => progressInit.Message.Subscribe((s: any, m: any) => tmpView.Message({ Text: m, Channel: Channel.Verbose })));
                // start extension
                ext = loadedExtensions[additionalExtension.fullyQualified] = {
                  extension: extension,
                  autorestExtension: new LazyPromise(async () => AutoRestExtension.FromChildProcess(additionalExtension.name, await extension.start()))
                };
              }
            }
          }

          // merge config
          const inputView = messageEmitter.DataStore.GetReadThroughScope(new RealFileSystem());
          const blocks = await this.ParseCodeBlocks(
            await inputView.ReadStrict(CreateFileUri(await ext.extension.configurationPath)),
            tmpView,
            `extension-config-${additionalExtension.fullyQualified}`);
          await addSegments(blocks);
        } catch (e) {
          messageEmitter.Message.Dispatch({
            Channel: Channel.Fatal,
            Text: `Failed to install or start extension '${additionalExtension.name}' (${additionalExtension.source})`
          });
          throw e;
        }
      }
    }

    return createView().Indexer;
  }

  public static async DetectConfigurationFile(fileSystem: IFileSystem, configFileOrFolderUri: string | null, messageEmitter?: MessageEmitter, walkUpFolders: boolean = false): Promise<string | null> {
    const originalConfigFileOrFolderUri = configFileOrFolderUri;

    if (!configFileOrFolderUri || configFileOrFolderUri.endsWith(".md")) {
      return configFileOrFolderUri;
    }

    // search for a config file, walking up the folder tree
    while (configFileOrFolderUri !== null) {
      // scan the filesystem items for the configuration.
      const configFiles = new Map<string, string>();

      for (const name of await fileSystem.EnumerateFileUris(EnsureIsFolderUri(configFileOrFolderUri))) {
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
          From<string>(configFiles.keys()).FirstOrDefault(each => each.toLowerCase().endsWith("/" + Constants.DefaultConfiguration)) ||
          From<string>(configFiles.keys()).OrderBy(each => each.length).First();

        return found;
      }

      // walk up
      const newUriToConfigFileOrWorkingFolder = ResolveUri(configFileOrFolderUri, "..");
      configFileOrFolderUri = !walkUpFolders || newUriToConfigFileOrWorkingFolder === configFileOrFolderUri
        ? null
        : newUriToConfigFileOrWorkingFolder;
    }

    if (messageEmitter) {
      messageEmitter.Message.Dispatch({
        Channel: Channel.Warning,
        Text: `No configuration found at '${originalConfigFileOrFolderUri}'.`
      });
    }

    return null;
  }
}