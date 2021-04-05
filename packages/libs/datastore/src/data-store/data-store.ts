/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OperationCanceledException, Lazy, LazyPromise } from "@azure-tools/tasks";
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
import { Data, DataHandle, Metadata } from "./data-handle";
import { DataSink } from "./data-sink";
import { LineIndices } from "../parsing/text-utility";

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

  private async writeDataInternal(
    uri: string,
    data: string,
    artifactType: string,
    identity: Array<string>,
    metadata: Metadata,
  ): Promise<DataHandle> {
    this.throwIfCancelled();
    if (this.store[uri]) {
      throw new Error(`can only write '${uri}' once`);
    }

    // make a sanitized name
    let filename = uri.replace(/[^\w.()]+/g, "-");
    if (filename.length > 64) {
      filename = `${md5(filename)}-${filename.substr(filename.length - 64)}`;
    }
    const name = join(await this.getCacheFolder(), filename);

    this.store[uri] = {
      name,
      cached: data,
      artifactType,
      identity,
      metadata,
    };

    return this.read(uri);
  }

  public async writeData(
    description: string,
    data: string,
    artifact: string,
    identity: Array<string>,
    sourceMapFactory?: (self: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    const uri = this.createUri(description);

    // metadata
    const metadata: Metadata = {} as any;

    const result = await this.writeDataInternal(uri, data, artifact, identity, metadata);

    // metadata.artifactType = artifact;

    metadata.sourceMap = new LazyPromise(async () => {
      if (!sourceMapFactory) {
        return new SourceMapGenerator().toJSON();
      }
      const sourceMap = await sourceMapFactory(result);

      // validate
      const inputFiles = sourceMap.sources.concat(sourceMap.file);
      for (const inputFile of inputFiles) {
        if (!this.store[inputFile]) {
          throw new Error(`Source map of '${uri}' references '${inputFile}' which does not exist`);
        }
      }

      return sourceMap;
    });

    // metadata.inputSourceMap = new LazyPromise(() => this.createInputSourceMapFor(uri));
    metadata.lineIndices = new Lazy<Array<number>>(() => LineIndices(data));

    return result;
  }

  private createUri(description: string): string {
    return resolveUri(this.BaseUri, `${this.uid++}?${encodeURIComponent(description)}`);
  }

  public getDataSink(defaultArtifact: string = FALLBACK_DEFAULT_OUTPUT_ARTIFACT): DataSink {
    return new DataSink(
      (description, data, artifact, identity, sourceMapFactory) =>
        this.writeData(description, data, artifact || defaultArtifact, identity, sourceMapFactory),
      async (description, input) => {
        const uri = this.createUri(description);
        this.store[uri] = this.store[input.key];
        return this.Read(uri);
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

  /*  input source map not enable at this time.
  private async createInputSourceMapFor(absoluteUri: string): Promise<RawSourceMap> {
    const data = this.readStrictSync(absoluteUri);

    // retrieve all target positions
    const targetPositions: SmartPosition[] = [];
    const metadata = data.metadata;
    const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);
    sourceMapConsumer.eachMapping((m) => targetPositions.push({ column: m.generatedColumn, line: m.generatedLine }));

    // collect blame
    const mappings: Array<Mapping> = [];
    for (const targetPosition of targetPositions) {
      const blameTree = await this.blame(absoluteUri, targetPosition);
      const inputPositions = blameTree.getMappingLeafs();
      for (const inputPosition of inputPositions) {
        mappings.push({
          name: inputPosition.name,
          source: this.readStrictSync(inputPosition.source).description, // friendly name
          generated: blameTree.node,
          original: inputPosition,
        });
      }
    }
    const sourceMapGenerator = new SourceMapGenerator({ file: absoluteUri });
    await Compile(mappings, sourceMapGenerator);
    return sourceMapGenerator.toJSON();
  }
  */

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
