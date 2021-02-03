/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { EnumerateFiles, ResolveUri, ReadUri, WriteString } from '@azure-tools/uri';
// import { From } from "linq-es2015";
import { items, keys } from '@azure-tools/linq';

import * as Constants from './constants';

export interface IFileSystem {
  EnumerateFileUris(folderUri: string): Promise<Array<string>>;
  ReadFile(uri: string): Promise<string>;
}

export class MemoryFileSystem implements IFileSystem {
  public static readonly DefaultVirtualRootUri = 'file:///';
  private filesByUri: Map<string, string>;

  public constructor(files: Map<string, string>) {
    this.filesByUri = new Map<string, string>(
      items(files).select(
        each => [
          ResolveUri(MemoryFileSystem.DefaultVirtualRootUri, each.key),
          each.value
        ] as [string, string])
    );
    /*
        this.filesByUri = new Map<string, string>(
          From(files.entries()).Select(entry => [
            ResolveUri(MemoryFileSystem.DefaultVirtualRootUri, entry[0]),
            entry[1]
          ] as [string, string]));
          */
  }
  public readonly Outputs: Map<string, string> = new Map<string, string>();

  async ReadFile(uri: string): Promise<string> {
    if (!this.filesByUri.has(uri)) {
      throw new Error(`File ${uri} is not in the MemoryFileSystem`);
    }
    return <string>this.filesByUri.get(uri);
  }

  async EnumerateFileUris(folderUri: string = MemoryFileSystem.DefaultVirtualRootUri): Promise<Array<string>> {
    // return await [...From(this.filesByUri.keys()).Where(uri => {
    return keys(this.filesByUri).where(uri => {
      // in folder?
      if (!uri.startsWith(folderUri)) {
        return false;
      }

      // not in subfolder?
      // return uri.substr(folderUri.length).indexOf("/") === -1;
      return uri.substr(folderUri.length).indexOf('/') === -1;
    }).toArray();
    //})];
  }

  async WriteFile(uri: string, content: string): Promise<void> {
    this.Outputs.set(uri, content);
  }
}

export class RealFileSystem implements IFileSystem {
  public constructor() {
  }

  EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return EnumerateFiles(folderUri, [
      Constants.DefaultConfiguration
    ]);
  }
  async ReadFile(uri: string): Promise<string> {
    return ReadUri(uri);
  }
  async WriteFile(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }
}

// handles:
// - GitHub URI adjustment
// - GitHub auth
export class EnhancedFileSystem implements IFileSystem {
  public constructor(private githubAuthToken?: string) {
  }

  EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return EnumerateFiles(folderUri, [
      Constants.DefaultConfiguration
    ]);
  }
  async ReadFile(uri: string): Promise<string> {
    const headers: { [key: string]: string } = {};

    // check for GitHub OAuth token
    if (
      this.githubAuthToken &&
        (uri.startsWith('https://raw.githubusercontent.com') ||
        uri.startsWith('https://github.com'))
    ) {
      console.log(`Used GitHub authentication token to request '${uri}'.`);
      headers.authorization = `Bearer ${this.githubAuthToken}`;
    }

    return ReadUri(uri, headers);
  }
  async WriteFile(uri: string, content: string): Promise<void> {
    return WriteString(uri, content);
  }
}