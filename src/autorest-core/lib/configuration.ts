/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import {
  DataHandleRead,
  DataHandleWrite,
  DataStore,
  DataStoreFileView,
  DataStoreViewReadonly
} from './data-store/data-store';

import { EventEmitter, IEvent } from './events';
import { CodeBlock, Parse as ParseLiterateYaml, ParseCodeBlocks } from './parsing/literate-yaml';
import { EnsureIsFolderUri, ResolveUri } from './ref/uri';
import { From, Enumerable as IEnumerable } from "./ref/linq";
import { IFileSystem } from "./file-system"
import * as Constants from './constants';
import { Message } from "./message";
import { Artifact } from "./artifact";
import { CancellationTokenSource, CancellationToken } from "./ref/cancallation";

export interface AutoRestConfigurationSwitches {
  [key: string]: string | null;
}

export interface AutoRestConfigurationSpecials {
  infoSectionOverride?: any; // from composite swagger file, no equivalent (yet) in config file; IF DOING THAT: also make sure source maps are pulling it! (see "composite swagger" method)
  codeGenerator?: string;
  azureValidator?: boolean;
  header?: string | null;
  namespace?: string;
  payloadFlatteningThreshold?: number;
  syncMethods?: "all" | "essential" | "none";
  addCredentials?: boolean;
  rubyPackageName?: string;
}

export interface AutoRestConfigurationImpl {
  [key: string]: any;
  __info?: string | null;
  __specials?: AutoRestConfigurationSpecials;
  "input-file": string[] | string;
  "output-folder"?: string;
  "base-folder"?: string;
  "directive"?: Directive[] | Directive;
}

// protected static CreateDefaultConfiguration(): AutoRestConfigurationImpl {
//   return {
//     "input-file": []
//   };
// }

/*
function key(target: string) {
  return (target, propertyKey) => {

    @key("base-folder") baseFolder: string;
    @key("output-folder") outputFolder: string;

  };
};
*/

function ValuesOf(objs: Iterable<any>, fieldName: string): IEnumerable<any> {
  return From(objs).Select(o => o[fieldName]).Where(o => o !== undefined);
}

function SingleValue<T>(objs: Iterable<any>, fieldName: string): T | null {
  return ValuesOf(objs, fieldName).LastOrDefault();
}

function MultipleValues<T>(objs: Iterable<any>, fieldName: string): Iterable<T> {
  return [...(function* () {
    for (const each of ValuesOf(objs, fieldName)) {
      if (typeof each === "string") {
        yield <T><any>each;
      } else if (each[Symbol.iterator]) {
        yield* each;
      } else {
        yield each;
      }
    }
  })()];
}

export interface Directive {
  from?: string[] | string;
  where?: string[] | string;
  reason?: string;

  // one of:
  supress?: string[] | string;
  set?: string[] | string;
  transform?: string[] | string;
}

export class DirectiveView {
  constructor(private directive: Directive) {
  }

  public get from(): Iterable<string> {
    return MultipleValues<string>([this.directive], "from");
  }

  public get where(): Iterable<string> {
    return MultipleValues<string>([this.directive], "where");
  }

  public get reason(): string | null {
    return this.directive.reason || null;
  }

  public get suppress(): Iterable<string> {
    return MultipleValues<string>([this.directive], "suppress");
  }

  public get set(): Iterable<string> {
    return MultipleValues<string>([this.directive], "set");
  }

  public get transform(): Iterable<string> {
    return MultipleValues<string>([this.directive], "transform");
  }
}

export class ConfigurationView extends EventEmitter {

  /* @internal */ constructor(
    /* @internal */
    private configFileFolderUri: string,
    ...configs: Array<AutoRestConfigurationImpl>
  ) {
    super();
    this.DataStore = new DataStore(this.CancellationToken);
    // TODO: fix configuration loading, note that there was no point in passing that DataStore used 
    // for loading in here as all connection to the sources is lost when passing `Array<AutoRestConfigurationImpl>` instead of `DataHandleRead`s...
    // theoretically the `ValuesOf` approach and such won't support blaming (who to blame if $.directives[3] sucks? which code block was it from)
    // long term, we simply gotta write a `Merge` method that adheres to the rules we need in here.
    this.config = configs;
    this.Debug.Dispatch({ Text: `Creating ConfigurationView : ${configs.length} sections.` });
  }

  /* @internal */
  public readonly DataStore: DataStore;

  private cancellationTokenSource = new CancellationTokenSource();
  /* @internal */
  public get CancellationTokenSource(): CancellationTokenSource { return this.cancellationTokenSource; }
  /* @internal */
  public get CancellationToken(): CancellationToken { return this.cancellationTokenSource.token; }

  @EventEmitter.Event public GeneratedFile: IEvent<ConfigurationView, Artifact>;

  @EventEmitter.Event public Information: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Warning: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Error: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Debug: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Verbose: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Fatal: IEvent<ConfigurationView, Message>;

  private config: Array<AutoRestConfigurationImpl>;

  private ResolveAsFolder(path: string): string {
    return EnsureIsFolderUri(ResolveUri(this.configFileFolderUri, path));
  }

  private ResolveAsPath(path: string): string {
    return ResolveUri(this.baseFolderUri, path);
  }

  private get baseFolderUri(): string {
    return this.ResolveAsFolder(SingleValue<string>(this.config, "base-folder") || "");
  }

  // public methods

  public get directives(): Iterable<DirectiveView> {
    return From(MultipleValues<Directive>(this.config, "directive"))
      .Select(each => new DirectiveView(each));
  }

  public get inputFileUris(): Iterable<string> {
    return From<string>(MultipleValues<string>(this.config, "input-file"))
      .Select(each => this.ResolveAsPath(each));
  }

  public get outputFolderUri(): string {
    return this.ResolveAsFolder(SingleValue<string>(this.config, "output-folder") || "generated");
  }

  public get __specials(): AutoRestConfigurationSpecials {
    return ValuesOf(this.config, "__specials").FirstOrDefault() || {};
  }

  public pluginSection(pluginName: string): any {
    return SingleValue<any>(this.config, pluginName);
  }

  public get disableValidation(): boolean {
    return SingleValue<boolean>(this.config, "disable-validation") || false;
  }

  public get azureArm(): boolean {
    return SingleValue<boolean>(this.config, "azure-arm") || false;
  }

  // TODO: stuff like generator specific settings (= YAML merging root with generator's section)
}


export class Configuration {
  public async CreateView(...configs: Array<any>): Promise<ConfigurationView> {
    const workingScope: DataStore = new DataStore();
    const configFileUri = this.fileSystem && this.uriToConfigFileOrWorkingFolder
      ? await Configuration.DetectConfigurationFile(this.fileSystem, this.uriToConfigFileOrWorkingFolder)
      : null;

    const defaults = require("../resources/default-configuration.json");

    if (configFileUri === null) {
      return new ConfigurationView("file:///", defaults, ...configs);
    } else {
      const inputView = workingScope.CreateScope("input").AsFileScopeReadThroughFileSystem(this.fileSystem as IFileSystem);

      // load config
      const hConfig = await ParseCodeBlocks(
        null,
        await inputView.ReadStrict(configFileUri),
        workingScope.CreateScope("config"));

      const blocks = await Promise.all(From<CodeBlock>(hConfig).Select(async each => {
        const block = await each.data.ReadObject<AutoRestConfigurationImpl>();
        block.__info = each.info;
        return block;
      }));

      return new ConfigurationView(ResolveUri(configFileUri, "."), defaults, ...configs, ...blocks);
    }
  }

  public constructor(
    private fileSystem?: IFileSystem,
    private uriToConfigFileOrWorkingFolder?: string
  ) {
    this.FileChanged();
  }

  public FileChanged() {
  }

  public static async DetectConfigurationFile(fileSystem: IFileSystem, uriToConfigFileOrWorkingFolder: string | null): Promise<string | null> {
    if (!uriToConfigFileOrWorkingFolder || !uriToConfigFileOrWorkingFolder.endsWith("/")) {
      return uriToConfigFileOrWorkingFolder;
    }

    // search for a config file, walking up the folder tree
    while (uriToConfigFileOrWorkingFolder !== null) {
      // scan the filesystem items for the configuration.
      const configFiles = new Map<string, string>();

      for await (const name of fileSystem.EnumerateFileUris(uriToConfigFileOrWorkingFolder)) {
        const content = await fileSystem.ReadFile(name);
        if (content.indexOf(Constants.MagicString) > -1) {
          configFiles.set(name, content);
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
      uriToConfigFileOrWorkingFolder = ResolveUri(uriToConfigFileOrWorkingFolder, "..");
    }

    return null
  }

  // public async HasConfiguration(): Promise<boolean> {
  //   return await this.DetectConfigurationFile() !== null;
  // }
}
