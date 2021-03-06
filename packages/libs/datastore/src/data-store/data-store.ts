/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OperationCanceledException } from "@azure-tools/tasks";
import { resolveUri } from "@azure-tools/uri";
import { RawSourceMap, SourceMapGenerator } from "source-map";
import { CancellationToken } from "../cancellation";
import { IFileSystem } from "../file-system/file-system";
import { BlameTree } from "../source-map/blaming";
import { CompilePosition, SmartPosition } from "../source-map/source-map";
import { promises as fs } from "fs";
import { tmpdir } from "os";
import { join } from "path";

import { createHash } from "crypto";
import { DataSource } from "./data-source";
import { ReadThroughDataSource } from "./read-through-data-source";
import { Data, DataHandle } from "./data-handle";
import { DataSink, DataSinkOptions } from "./data-sink";

const md5 = (content: any) => (content ? createHash("md5").update(JSON.stringify(content)).digest("hex") : null);

const FALLBACK_DEFAULT_OUTPUT_ARTIFACT = "";

/********************************************
 * Data model section (not exposed)
 ********************************************/

interface Store {
  [uri: string]: Data;
}

export class DataStore {
  public static readonly BaseUri = "mem://";
  public readonly BaseUri = DataStore.BaseUri;
  private store: Store = {};
  private cacheFolder?: string;

  public constructor(private cancellationToken: CancellationToken = CancellationToken.None) {}

  private async getCacheFolder() {
    if (!this.cacheFolder) {
      this.cacheFolder = await fs.mkdtemp(join(tmpdir(), "autorest-"));
    }
    return this.cacheFolder;
  }

  private throwIfCancelled(): void {
    if (this.cancellationToken.isCancellationRequested) {
      throw new OperationCanceledException();
    }
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
    sourceMapFactory?: (self: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    const uri = this.createUri(description);

    if (this.store[uri]) {
      throw new Error(`can only write '${uri}' once`);
    }

    // make a sanitized name
    let filename = uri.replace(/[^\w.()]+/g, "-");
    if (filename.length > 64) {
      filename = `${md5(filename)}-${filename.substr(filename.length - 64)}`;
    }
    const name = join(await this.getCacheFolder(), filename);

    const item: Data = {
      status: "loaded",
      name,
      cached: data,
      artifactType,
      identity,
      sourceMap: undefined,
    };
    this.store[uri] = item;

    const handle = await this.read(uri);
    if (sourceMapFactory) {
      item.sourceMap = await sourceMapFactory(handle);
    } else {
      item.sourceMap = new SourceMapGenerator().toJSON();
    }
    return handle;
  }

  private createUri(description: string): string {
    return resolveUri(this.BaseUri, `${this.uid++}?${encodeURIComponent(description)}`);
  }

  public getDataSink(
    dataSinkOptions: DataSinkOptions = { generateSourceMap: true },
    defaultArtifact: string = FALLBACK_DEFAULT_OUTPUT_ARTIFACT,
  ): DataSink {
    return new DataSink(
      dataSinkOptions,
      (description, data, artifact, identity, sourceMapFactory) =>
        this.writeData(description, data, artifact || defaultArtifact, identity, sourceMapFactory),
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
    return new DataHandle(absoluteUri, entry);
  }

  public async read(uri: string): Promise<DataHandle> {
    uri = resolveUri(this.BaseUri, uri);
    const data = this.store[uri];
    if (!data) {
      throw new Error(`Could not read '${uri}'.`);
    }
    return new DataHandle(uri, data);
  }

  public async blame(absoluteUri: string, position: SmartPosition): Promise<BlameTree> {
    const data = this.readStrictSync(absoluteUri);
    const resolvedPosition = await CompilePosition(position, data);
    return await BlameTree.create(this, {
      source: absoluteUri,
      column: resolvedPosition.column,
      line: resolvedPosition.line,
      name: `blameRoot (${JSON.stringify(position)})`,
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
    return this.writeData(description, data, artifact, identity, sourceMapFactory);
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
  public async Blame(absoluteUri: string, position: SmartPosition): Promise<BlameTree> {
    return this.blame(absoluteUri, position);
  }
}
