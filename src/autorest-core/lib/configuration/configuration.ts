/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { resolveUri } from "../approved-imports/uri";

export interface AutoRestConfigurationSwitches {
  [key: string]: string | null;
}

export interface AutoRestConfiguration {
  "input-file": string[] | string;
  "base-folder"?: string;
}

export class AutoRestConfigurationManager {
  public constructor(
    private config: AutoRestConfiguration,
    private configurationFileUri: string) {
  }

  private get baseFolderUri(): string {
    const configFileFolderUri = resolveUri(this.configurationFileUri, ".").toString();
    const baseFolder = this.config["base-folder"] || "";
    const baseFolderUri = resolveUri(configFileFolderUri, baseFolder);
    return baseFolderUri.replace(/\/$/g, "") + "/";
  }

  private resolveUri(path: string): string {
    return resolveUri(this.baseFolderUri, path);
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

  // TODO: stuff like generator specific settings (= YAML merging root with generator's section)
}
