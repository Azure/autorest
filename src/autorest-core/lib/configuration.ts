import {
  DataHandleRead,
  DataHandleWrite,
  DataStore,
  DataStoreFileView,
  DataStoreView,
  DataStoreViewReadonly
} from './data-store/data-store';
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ResolveUri } from "./ref/uri";
import { From } from "./ref/linq";
import { IFileSystem } from "./file-system"
import * as Constants from "./constants"

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

export class ConfigurationView {
  constructor(
    private configurationFileUri: string,
    private config: AutoRestConfigurationImpl) {
  }

  private get configFileFolderUri(): string {
    return ResolveUri(this.configurationFileUri, ".").toString();
  }

  private get baseFolderUri(): string {
    const baseFolder = this.config["base-folder"] || "";
    const baseFolderUri = ResolveUri(this.configFileFolderUri, baseFolder);
    return baseFolderUri.replace(/\/$/g, "") + "/";
  }

  private resolveUri(path: string): string {
    return ResolveUri(this.baseFolderUri, path);
  }

  private inputFiles(): string[] {
    const raw = this.config["input-file"];
    return typeof raw === "string"
      ? [raw]
      : raw;
  }

  public get inputFileUris(): string[] {
    return this.inputFiles().map(inputFile => this.resolveUri(inputFile));
  }

  public get outputFolderUri(): string {
    const folder = this.config["output-folder"] || "generated";
    const outputFolderUri = ResolveUri(this.configFileFolderUri, folder);
    return outputFolderUri.replace(/\/$/g, "") + "/";
  }

  public get __specials(): AutoRestConfigurationSpecials {
    return this.config.__specials || {};
  }

  // TODO: stuff like generator specific settings (= YAML merging root with generator's section)
}


export interface Configuration {
  Acquire(data: DataStoreView): Promise<{ inputView: DataStoreViewReadonly, uri: string }>;
  HasConfiguration(): Promise<boolean>;
}

export class ConstantConfiguration implements Configuration {
  public constructor(
    private configurationUri: string,
    private configuration: AutoRestConfigurationImpl
  ) {
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

export class FileSystemConfiguration implements Configuration {
  private cachedConfigurationFileName: string | null | undefined;
  private _view: DataStore | null;
  private get view(): DataStore {
    if (!this._view) {
      this._view = new DataStore();
    }
    return this._view;
  }

  public constructor(
    private fileSystem: IFileSystem,
    private configurationFileName?: string
  ) {
    this.FileChanged();
  }


  public FileChanged() {
    this.cachedConfigurationFileName = undefined;
    this._view = null;
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
    await this.Acquire(this.view);
    return await this.DetectConfigurationFile() !== null;
  }

  public Add(path: string, value: any) {

  }

  public Remove(path: string) {

  }
}
