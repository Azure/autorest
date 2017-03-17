/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ResolveUri } from "./approved-imports/uri";
import { IFileSystem } from "./file-system"

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

export class Configuration {
  private constructor(
    private fileSystem: IFileSystem,
    private config?: AutoRestConfigurationImpl
  ) {
  }

  public static async Create(fileSystem: IFileSystem, config?: AutoRestConfigurationImpl): Promise<Configuration> {
    let result = new Configuration(fileSystem);
    if (config) {
      // passed a configuration template, no scanning required
    } else {
      // scan the filesystem items for the configuration.

      // having found the configuation, parse and load it.

      // add that to the result object.
    }
    return result;
  }
  private configurationFileUri: string


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
