/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import {
  DataHandleRead,
  DataHandleWrite,
  DataStore,
  DataStoreFileView,
  DataStoreView,
  DataStoreViewReadonly
} from './data-store/data-store';

import { EventEmitter, IEvent } from './events';
import { CodeBlock, Parse as ParseLiterateYaml, ParseCodeBlocks } from './parsing/literate-yaml';
import { ResolveUri } from "./ref/uri";
import { From, Enumerable as IEnumerable } from "./ref/linq";
import { IFileSystem } from "./file-system"
import * as Constants from './constants';
import { Message } from "./message";

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

export class ConfigurationView extends EventEmitter {

  /* @internal */ constructor(
    public workingScope: DataStore,
    private configurationFileUri: string,
    ...configs: Array<AutoRestConfigurationImpl>
  ) {
    super();
    this.config = configs;
    this.Debug.Dispatch({ Text: `Creating ConfigurationView : ${configs.length} sections.` })
  }

  @EventEmitter.Event public Information: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Warning: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Error: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Debug: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Verbose: IEvent<ConfigurationView, Message>;
  @EventEmitter.Event public Fatal: IEvent<ConfigurationView, Message>;

  private config: Array<AutoRestConfigurationImpl>

  private ValuesOf(fieldName: string): IEnumerable<any> {
    return From<AutoRestConfigurationImpl>(this.config).Select(config => config[fieldName]);
  }

  private SingleValue<T>(fieldName: string): T | null {
    return this.ValuesOf(fieldName).FirstOrDefault();
  }

  private *MultipleValues<T>(fieldName: string): Iterable<T> {
    for (const each of this.ValuesOf(fieldName)) {
      if (each != undefined && each != null) {
        if (typeof each == 'string') {
          yield <T><any>each;
        } else if (each[Symbol.iterator]) {
          yield* each;
        } else {
          yield each;
        }
      }
    }
  }

  private ResolveAsFolder(path: string): string {
    return ResolveUri(this.configFileFolderUri, path).replace(/\/$/g, "") + "/";
  }

  private ResolveAsPath(path: string): string {
    return ResolveUri(this.baseFolderUri, path);
  }

  private get configFileFolderUri(): string {
    return ResolveUri(this.configurationFileUri, ".");
  }

  private get baseFolderUri(): string {
    return this.ResolveAsFolder(this.SingleValue<string>("base-folder") || "");
  }

  // public methods 

  public get inputFileUris(): Iterable<string> {
    return From<string>(this.MultipleValues<string>("input-file"))
      .Select(each => this.ResolveAsPath(each));
  }

  public get outputFolderUri(): string {
    return this.ResolveAsFolder(this.SingleValue<string>("output-folder") || "generated")
  }

  public get __specials(): AutoRestConfigurationSpecials {
    return this.ValuesOf("__specials").FirstOrDefault() || {};
  }

  // TODO: stuff like generator specific settings (= YAML merging root with generator's section)
}


export abstract class Configuration {
  abstract Acquire(data: DataStoreView): Promise<{ inputView: DataStoreViewReadonly, uri: string }>;
  abstract HasConfiguration(): Promise<boolean>;

  public async CreateView(...configs: Array<any>): Promise<ConfigurationView> {
    let workingScope: DataStore = new DataStore()
    const configResult = await this.Acquire(workingScope);
    const defaults = require("../resources/default-configuration.json");

    // load config
    const hConfig = await ParseCodeBlocks(
      await configResult.inputView.ReadStrict(configResult.uri),
      workingScope.CreateScope("config"));

    const blocks = await Promise.all(From<CodeBlock>(hConfig).Select(async each => {
      const block = await each.data.ReadObject<AutoRestConfigurationImpl>();
      block.__info = each.info;
      return block;
    }));

    return new ConfigurationView(workingScope, configResult.uri, defaults, ...configs, ...blocks);
  }
}

export class ConstantConfiguration extends Configuration {
  public constructor(
    private configurationUri: string,
    private configuration: AutoRestConfigurationImpl
  ) {
    super();
  }

  public async Acquire(data: DataStoreView): Promise<{ inputView: DataStoreViewReadonly, uri: string }> {
    const inputView = data.CreateScope("input").AsFileScope();
    await inputView.Write(this.configurationUri);
    return {
      inputView: inputView,
      uri: this.configurationUri
    };
  }

  public async HasConfiguration(): Promise<boolean> {
    return true;
  }
}

export class FileSystemConfiguration extends Configuration {
  private cachedConfigurationFileName: string | null | undefined;

  public constructor(
    private fileSystem: IFileSystem,
    private configurationFileName?: string
  ) {
    super();
    this.FileChanged();
  }

  public FileChanged() {
    this.cachedConfigurationFileName = undefined;
  }

  private async DetectConfigurationFile(): Promise<string | null> {
    if (this.cachedConfigurationFileName !== undefined) {
      return this.cachedConfigurationFileName;
    }

    // scan the filesystem items for the configuration.
    const configFiles = new Map<string, string>();

    for await (const name of this.fileSystem.EnumerateFiles()) {
      const content = await this.fileSystem.ReadFile(name);
      if (content.indexOf(Constants.MagicString) > -1) {
        configFiles.set(name, content);
      }
    }

    if (configFiles.size === 0) {
      return null;
    }

    // it's the readme.md or the shortest filename.
    let found =
      From<string>(configFiles.keys()).FirstOrDefault(each => each.toLowerCase() === Constants.DefaultConfiguratiion) ||
      From<string>(configFiles.keys()).OrderBy(each => each.length).First();

    return this.cachedConfigurationFileName = ResolveUri(this.fileSystem.RootUri, found);
  }

  public async Acquire(data: DataStoreView): Promise<{ inputView: DataStoreViewReadonly, uri: string }> {
    const inputView = data.CreateScope("input").AsFileScopeReadThroughFileSystem(this.fileSystem);
    const result = await this.DetectConfigurationFile();
    if (result === null) {
      throw new Error(`No configuation file found in the filesystem '${this.fileSystem.RootUri}'`);
    }
    return {
      inputView: inputView,
      uri: result
    };
  }

  public async HasConfiguration(): Promise<boolean> {
    return await this.DetectConfigurationFile() !== null;
  }

  public Add(path: string, value: any) {

  }

  public Remove(path: string) {

  }
}
