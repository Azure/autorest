/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { ConfigurationView } from '../autorest-core';
import { LineIndices } from "../parsing/text-utility";
import { CancellationToken } from "../ref/cancellation";
import { Mappings, Mapping, SmartPosition, Position } from "../ref/source-map";
import { EnsureIsFolderUri, ReadUri, ResolveUri, ToRawDataUrl, WriteString } from "../ref/uri";
import { FastStringify, ParseNode, ParseToAst as parseAst, YAMLNode } from "../ref/yaml";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator, SourceMapConsumer } from "source-map";
import { Compile, CompilePosition } from "../source-map/source-map";
import { BlameTree } from "../source-map/blaming";
import { Lazy } from "../lazy";
import { IFileSystem } from "../file-system";
import { OperationCanceledException } from "../exception";

/********************************************
 * Data model section (not exposed)
 ********************************************/

export interface Metadata {
  inputSourceMap: Lazy<RawSourceMap>;
  sourceMap: Lazy<RawSourceMap>;
  sourceMapEachMappingByLine: Lazy<sourceMap.MappingItem[][]>;
  yamlAst: Lazy<YAMLNode>;
  lineIndices: Lazy<number[]>;
}

export interface Data {
  data: string;
  metadata: Metadata;
}

type Store = { [uri: string]: Data };


/********************************************
 * Central data controller
 * - one stop for creating data
 * - ensures WRITE ONCE model
 ********************************************/

export abstract class DataSource {
  public abstract Enum(): Promise<string[]>;
  public abstract Read(uri: string): Promise<DataHandle | null>;

  public async ReadStrict(uri: string): Promise<DataHandle> {
    const result = await this.Read(uri);
    if (result === null) {
      throw new Error(`Could not to read '${uri}'.`);
    }
    return result;
  }

  public async Dump(targetDirUri: string): Promise<void> {
    targetDirUri = EnsureIsFolderUri(targetDirUri);
    const keys = await this.Enum();
    for (const key of keys) {
      const dataHandle = await this.ReadStrict(key);
      const data = dataHandle.ReadData();
      const metadata = dataHandle.ReadMetadata();
      const targetFileUri = ResolveUri(
        targetDirUri,
        key.replace(":", "")); // make key (URI) a descriptive relative path
      await WriteString(targetFileUri, data);
      await WriteString(targetFileUri + ".map", JSON.stringify(metadata.sourceMap.Value, null, 2));
      await WriteString(targetFileUri + ".input.map", JSON.stringify(metadata.inputSourceMap.Value, null, 2));
    }
  }
}

export class QuickDataSource extends DataSource {
  public constructor(private handles: DataHandle[]) {
    super();
  }

  public async Enum(): Promise<string[]> {
    return this.handles.map(x => x.key);
  }

  public async Read(key: string): Promise<DataHandle | null> {
    const data = this.handles.filter(x => x.key === key)[0];
    return data || null;
  }
}

class ReadThroughDataSource extends DataSource {
  private uris: string[] = [];
  private cache: { [uri: string]: Promise<DataHandle | null> } = {};

  constructor(private store: DataStore, private fs: IFileSystem) {
    super();
  }

  public async Read(uri: string): Promise<DataHandle | null> {
    uri = ToRawDataUrl(uri);

    // sync cache (inner stuff is racey!)
    if (!this.cache[uri]) {
      this.cache[uri] = (async () => {
        // probe data store
        try {
          const existingData = await this.store.Read(uri);
          this.uris.push(uri);
          return existingData;
        } catch (e) {
        }

        // populate cache
        let data: string | null = null;
        try {
          data = await this.fs.ReadFile(uri) || await ReadUri(uri);
        } finally {
          if (!data) {
            return null;
          }
        }
        const readHandle = await this.store.WriteData(uri, data);

        this.uris.push(uri);
        return readHandle;
      })();
    }

    return await this.cache[uri];
  }

  public async Enum(): Promise<string[]> {
    return this.uris;
  }
}

export class DataStore {
  public static readonly BaseUri = "mem://";
  public readonly BaseUri = DataStore.BaseUri;
  private store: Store = {};

  public constructor(private cancellationToken: CancellationToken = CancellationToken.None) {
  }

  private ThrowIfCancelled(): void {
    if (this.cancellationToken.isCancellationRequested) {
      throw new OperationCanceledException();
    }
  }

  public GetReadThroughScope(fs: IFileSystem): DataSource {
    return new ReadThroughDataSource(this, fs);
  }

  /****************
   * Data access
   ***************/

  private uid = 0;

  private async WriteDataInternal(uri: string, data: string, metadata: Metadata): Promise<DataHandle> {
    this.ThrowIfCancelled();
    if (this.store[uri]) {
      throw new Error(`can only write '${uri}' once`);
    }
    this.store[uri] = {
      data: data,
      metadata: metadata
    };

    return this.Read(uri);
  }

  public async WriteData(description: string, data: string, sourceMapFactory?: (self: DataHandle) => RawSourceMap): Promise<DataHandle> {
    const uri = this.createUri(description);

    // metadata
    const metadata: Metadata = <any>{};
    const result = await this.WriteDataInternal(uri, data, metadata);
    metadata.sourceMap = new Lazy(() => {
      if (!sourceMapFactory) {
        return new SourceMapGenerator().toJSON();
      }
      const sourceMap = sourceMapFactory(result);

      // validate
      const inputFiles = sourceMap.sources.concat(sourceMap.file);
      for (const inputFile of inputFiles) {
        if (!this.store[inputFile]) {
          throw new Error(`Source map of '${uri}' references '${inputFile}' which does not exist`);
        }
      }

      return sourceMap;
    });
    metadata.sourceMapEachMappingByLine = new Lazy<sourceMap.MappingItem[][]>(() => {
      const result: sourceMap.MappingItem[][] = [];

      const sourceMapConsumer = new SourceMapConsumer(metadata.sourceMap.Value);

      // const singleResult = sourceMapConsumer.originalPositionFor(position);
      // does NOT support multiple sources :(
      // `singleResult` has null-properties if there is no original

      // get coinciding sources
      sourceMapConsumer.eachMapping(mapping => {
        while (result.length <= mapping.generatedLine) {
          result.push([]);
        }
        result[mapping.generatedLine].push(mapping);
      });

      return result;
    });
    metadata.inputSourceMap = new Lazy(() => this.CreateInputSourceMapFor(uri));
    metadata.yamlAst = new Lazy<YAMLNode>(() => parseAst(data));
    metadata.lineIndices = new Lazy<number[]>(() => LineIndices(data));
    return result;
  }

  private createUri(description: string): string {
    return ResolveUri(this.BaseUri, `${this.uid++}?${encodeURIComponent(description)}`);
  }

  public get DataSink(): DataSink {
    return new DataSink(
      (description, data, sourceMapFactory) => this.WriteData(description, data, sourceMapFactory),
      async (description, input) => {
        const uri = this.createUri(description);
        this.store[uri] = this.store[input.key];
        return this.Read(uri);
      }
    );
  }

  public ReadStrictSync(absoluteUri: string): DataHandle {
    const entry = this.store[absoluteUri];
    if (entry === undefined) {
      throw new Error(`Object '${absoluteUri}' does not exist.`);
    }
    return new DataHandle(absoluteUri, entry);
  }

  public async Read(uri: string): Promise<DataHandle> {
    uri = ResolveUri(this.BaseUri, uri);
    const data = this.store[uri];
    if (!data) {
      throw new Error(`Could not to read '${uri}'.`);
    }
    return new DataHandle(uri, data);
  }

  public Blame(absoluteUri: string, position: SmartPosition): BlameTree {
    const data = this.ReadStrictSync(absoluteUri);
    const resolvedPosition = CompilePosition(position, data);
    return BlameTree.Create(this, {
      source: absoluteUri,
      column: resolvedPosition.column,
      line: resolvedPosition.line,
      name: `blameRoot (${JSON.stringify(position)})`
    });
  }

  private CreateInputSourceMapFor(absoluteUri: string): RawSourceMap {
    const data = this.ReadStrictSync(absoluteUri);

    // retrieve all target positions
    const targetPositions: SmartPosition[] = [];
    const metadata = data.ReadMetadata();
    const sourceMapConsumer = new SourceMapConsumer(metadata.sourceMap.Value);
    sourceMapConsumer.eachMapping(m => targetPositions.push(<Position>{ column: m.generatedColumn, line: m.generatedLine }));

    // collect blame
    const mappings: Mapping[] = [];
    for (const targetPosition of targetPositions) {
      const blameTree = this.Blame(absoluteUri, targetPosition);
      const inputPositions = blameTree.BlameLeafs();
      for (const inputPosition of inputPositions) {
        mappings.push({
          name: inputPosition.name,
          source: inputPosition.source,
          generated: blameTree.node,
          original: inputPosition
        })
      }
    }
    const sourceMapGenerator = new SourceMapGenerator({ file: absoluteUri });
    Compile(mappings, sourceMapGenerator);
    return sourceMapGenerator.toJSON();
  }
}


/********************************************
 * Data handles
 * - provide well-defined access to specific data
 * - provide convenience methods
 ********************************************/

export class DataSink {
  constructor(
    private write: (description: string, rawData: string, metadataFactory: (readHandle: DataHandle) => RawSourceMap) => Promise<DataHandle>,
    private forward: (description: string, input: DataHandle) => Promise<DataHandle>) {
  }

  public async WriteDataWithSourceMap(description: string, data: string, sourceMapFactory: (readHandle: DataHandle) => RawSourceMap): Promise<DataHandle> {
    return await this.write(description, data, sourceMapFactory);
  }

  public async WriteData(description: string, data: string, mappings: Mappings = [], mappingSources: DataHandle[] = []): Promise<DataHandle> {
    return await this.WriteDataWithSourceMap(description, data, readHandle => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      Compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public WriteObject<T>(description: string, obj: T, mappings: Mappings = [], mappingSources: DataHandle[] = []): Promise<DataHandle> {
    return this.WriteData(description, FastStringify(obj), mappings, mappingSources);
  }

  public Forward(description: string, input: DataHandle): Promise<DataHandle> {
    return this.forward(description, input);
  }
}

export class DataHandle {
  constructor(public readonly key: string, private read: Data) {
  }

  public ReadData(): string {
    return this.read.data;
  }

  public ReadMetadata(): Metadata {
    return this.read.metadata;
  }

  public ReadObject<T>(): T {
    return ParseNode<T>(this.ReadYamlAst());
  }

  public ReadYamlAst(): YAMLNode {
    return this.ReadMetadata().yamlAst.Value;
  }

  public get Description(): string {
    return decodeURIComponent(this.key.split('?').reverse()[0]);
  }

  public IsObject(): boolean {
    try {
      this.ReadObject();
      return true;
    } catch (e) {
      return false;
    }
  }

  public Blame(position: sourceMap.Position): sourceMap.MappedPosition[] {
    const metadata = this.ReadMetadata();
    const sameLineResults = (metadata.sourceMapEachMappingByLine.Value[position.line] || [])
      .filter(mapping => mapping.generatedColumn <= position.column);
    const maxColumn = sameLineResults.reduce((c, m) => Math.max(c, m.generatedColumn), 0);
    const columnDelta = position.column - maxColumn;
    return sameLineResults.filter(m => m.generatedColumn === maxColumn).map(m => {
      return {
        column: m.originalColumn + columnDelta,
        line: m.originalLine,
        name: m.name,
        source: m.source
      };
    });
  }
}