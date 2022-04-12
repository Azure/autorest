/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { createHash } from "crypto";
import { promises as fs } from "fs";
import { tmpdir } from "os";
import { join } from "path";
import { resolveUri } from "@azure-tools/uri";
import { RawSourceMap } from "source-map";
import { IFileSystem } from "../file-system/file-system";
import {
  PathMapping,
  PathPosition,
  PathSourceMap,
  Position,
  PositionSourceMap,
  IdentityPathMappings,
} from "../source-map";
import { BlameTree } from "../source-map/blaming";

import { Data, DataHandle } from "./data-handle";
import { DataSink } from "./data-sink";
import { DataSource } from "./data-source";
import { ReadThroughDataSource } from "./read-through-data-source";

const md5 = (content: any) => (content ? createHash("md5").update(JSON.stringify(content)).digest("hex") : null);

const FALLBACK_DEFAULT_OUTPUT_ARTIFACT = "";

/********************************************
 * Data model section (not exposed)
 ********************************************/

interface Store {
  [uri: string]: DataHandle;
}

export interface DataStoreOptions {
  /**
   * Enable auto unloading data to release memory.
   */
  autoUnloadData?: boolean;
}

export class DataStore {
  public static readonly BaseUri = "mem://";
  public readonly BaseUri = DataStore.BaseUri;
  private store: Store = {};
  private cacheFolder?: string;

  public constructor(private options: DataStoreOptions = {}) {}

  private async getCacheFolder() {
    if (!this.cacheFolder) {
      this.cacheFolder = await fs.mkdtemp(join(tmpdir(), "autorest-"));
    }
    return this.cacheFolder;
  }

  public getReadThroughScope(fs: IFileSystem): DataSource {
    return new ReadThroughDataSource(this, fs);
  }

  /****************
   * Data access
   ***************/

  private uid = 0;

  public async writeData(
    description: string,
    data: string,
    artifactType: string,
    identity: Array<string>,
    mappings?: PathMapping[] | IdentityPathMappings,
    sourceMapFactory?: (self: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    const uri = this.createUri(description);
    if (this.store[uri]) {
      throw new Error(`can only write '${uri}' once`);
    }

    // make a sanitized name
    let filename = uri.replace(/[^\w.()]+/g, "-");
    if (filename.length > 64) {
      filename = `${md5(filename)}-${filename.slice(-64)}`;
    }
    const name = join(await this.getCacheFolder(), filename);

    const item: Data = {
      status: "loaded",
      name,
      cached: data,
      artifactType,
      identity,
      pathSourceMap: undefined,
      positionSourceMap: undefined,
    };
    const handle = (this.store[uri] = new DataHandle(uri, item, this.options.autoUnloadData));
    if (sourceMapFactory) {
      item.positionSourceMap = new PositionSourceMap(name, await sourceMapFactory(handle));
    }
    if (mappings) {
      item.pathSourceMap = mappings instanceof IdentityPathMappings ? mappings : new PathSourceMap(name, mappings);
    }

    return handle;
  }

  private createUri(description: string): string {
    return resolveUri(this.BaseUri, `${this.uid++}?${encodeURIComponent(description)}`);
  }

  public getDataSink(defaultArtifact: string = FALLBACK_DEFAULT_OUTPUT_ARTIFACT): DataSink {
    return new DataSink(
      (description, data, artifact, identity, mappings, sourceMapFactory) =>
        this.writeData(description, data, artifact || defaultArtifact, identity, mappings, sourceMapFactory),
      async (description, input) => {
        const uri = this.createUri(description);
        this.store[uri] = this.store[input.key];
        return this.read(uri);
      },
    );
  }

  public readStrictSync(absoluteUri: string): DataHandle {
    const entry = this.store[absoluteUri];
    if (entry === undefined) {
      throw new Error(`Object '${absoluteUri}' does not exist.`);
    }
    return entry;
  }

  public async read(uri: string): Promise<DataHandle> {
    uri = resolveUri(this.BaseUri, uri);
    const data = this.store[uri];
    if (!data) {
      throw new Error(`Could not read '${uri}'.`);
    }
    return data;
  }

  public async blame(absoluteUri: string, position: Position | PathPosition): Promise<BlameTree> {
    return await BlameTree.create(this, {
      source: absoluteUri,
      ...position,
    });
  }

  /**
   * @deprecated use @see getReadThroughScope
   */
  public GetReadThroughScope(fs: IFileSystem): DataSource {
    return this.getReadThroughScope(fs);
  }

  /**
   * @deprecated use @see writeData
   */
  public async WriteData(
    description: string,
    data: string,
    artifact: string,
    identity: Array<string>,
    sourceMapFactory?: (self: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    return this.writeData(description, data, artifact, identity, undefined, sourceMapFactory);
  }

  /**
   * @deprecated use @see readStrictSync
   */
  public ReadStrictSync(absoluteUri: string): DataHandle {
    return this.readStrictSync(absoluteUri);
  }

  /**
   * @deprecated use @see read
   */
  public async Read(uri: string): Promise<DataHandle> {
    return this.read(uri);
  }

  /**
   * @deprecated use @see blame
   */
  public async Blame(absoluteUri: string, position: Position | PathPosition): Promise<BlameTree> {
    return this.blame(absoluteUri, position);
  }
}
