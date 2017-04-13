/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { LineIndices } from "../parsing/text-utility";
import { CancellationToken } from "../ref/cancallation";
import { Mappings, Mapping, SmartPosition, Position } from "../ref/source-map";
import { EnsureIsFolderUri, ReadUri, ResolveUri, WriteString } from '../ref/uri';
import { Parse, ParseToAst as parseAst, YAMLNode, Stringify } from "../ref/yaml";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator, SourceMapConsumer } from "source-map";
import { Compile, CompilePosition } from "../source-map/source-map";
import { BlameTree } from "../source-map/blaming";
import { Lazy, LazyPromise } from '../lazy';
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

export abstract class DataStoreViewReadonly {
  public abstract Enum(): Promise<string[]>;
  public abstract Read(uri: string): Promise<DataHandleRead | null>;

  public async ReadStrict(uri: string): Promise<DataHandleRead> {
    const result = await this.Read(uri);
    if (result === null) {
      throw new Error(`Failed to read '${uri}'. Key not found.`);
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
      await WriteString(targetFileUri + ".map", JSON.stringify(await metadata.sourceMap, null, 2));
      await WriteString(targetFileUri + ".input.map", JSON.stringify(await metadata.inputSourceMap, null, 2));
    }
  }
}

export class QuickScope extends DataStoreViewReadonly {
  public constructor(private handles: DataHandleRead[]) {
    super();
  }

  public async Enum(): Promise<string[]> {
    return this.handles.map(x => x.key);
  }

  public async Read(key: string): Promise<DataHandleRead | null> {
    const data = this.handles.filter(x => x.key === key)[0];
    return data || null;
  }
}

export abstract class DataStoreView extends DataStoreViewReadonly {
  public abstract get BaseUri(): string;

  public abstract Write(key: string): Promise<DataHandleWrite>;

  public CreateScope(name: string): DataStoreView {
    return new DataStoreViewScope(name, this);
  }

  public AsReadonly(): DataStoreViewReadonly {
    return this;
  }
}

class DataStoreViewScope extends DataStoreView {
  constructor(private name: string, private slave: DataStoreView) {
    super();
  }

  public get BaseUri(): string {
    return ResolveUri(this.slave.BaseUri, `${this.name}/`);
  }

  public Write(uri: string): Promise<DataHandleWrite> {
    uri = ResolveUri(this.BaseUri, uri);
    return this.slave.Write(uri);
  }

  public Read(uri: string): Promise<DataHandleRead> {
    uri = ResolveUri(this.BaseUri, uri);
    if (!uri.startsWith(this.BaseUri)) {
      throw new Error(`Cannot access '${uri}' because it is out of scope.`);
    }
    return this.slave.Read(uri);
  }

  public async Enum(): Promise<string[]> {
    const parentResult = await this.slave.Enum();
    return From(parentResult)
      .Select(key => ResolveUri(this.slave.BaseUri, key))
      .Where(key => key.startsWith(this.BaseUri))
      .Select(key => key.substr(this.BaseUri.length))
      .ToArray();
  }
}

class DataStoreViewReadThrough extends DataStoreViewReadonly {
  private uris: string[] = [];

  constructor(private slave: DataStore, private customUriFilter: (uri: string) => boolean = uri => /^http/.test(uri)) {
    super();
  }

  public async Read(uri: string): Promise<DataHandleRead> {
    // validation before hitting the file system or web
    if (!this.customUriFilter(uri)) {
      throw new Error(`Provided URI '${uri}' violated the filter`);
    }

    // special URI handlers
    // - GitHub
    if (uri.startsWith("https://github")) {
      uri = uri.replace(/^https:\/\/(github.com)(.*)blob\/(.*)/ig, "https://raw.githubusercontent.com$2$3");
    }

    // prope cache
    const existingData = await this.slave.Read(uri);
    if (existingData !== null) {
      this.uris.push(uri);
      return existingData;
    }

    // populate cache
    const data = await ReadUri(uri);
    const writeHandle = await this.slave.Write(uri);
    const readHandle = await writeHandle.WriteData(data);
    this.uris.push(uri);
    return readHandle;
  }

  public async Enum(): Promise<string[]> {
    return this.slave.Enum();
  }
}

class DataStoreViewReadThroughFS extends DataStoreViewReadonly {
  private uris: string[] = [];

  constructor(private slave: DataStore, private fs: IFileSystem) {
    super();
  }

  public async Read(uri: string): Promise<DataHandleRead | null> {
    // special URI handlers
    // - GitHub
    if (uri.startsWith("https://github")) {
      uri = uri.replace(/^https:\/\/(github.com)(.*)blob\/(.*)/ig, "https://raw.githubusercontent.com$2$3");
    }

    // prope cache
    const existingData = await this.slave.Read(uri);
    if (existingData !== null) {
      this.uris.push(uri);
      return existingData;
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
    const writeHandle = await this.slave.Write(uri);
    const readHandle = await writeHandle.WriteData(data);
    this.uris.push(uri);
    return readHandle;
  }

  public async Enum(): Promise<string[]> {
    return this.slave.Enum();
  }
}

export class DataStore extends DataStoreView {
  public static readonly BaseUri = "mem://";
  public readonly BaseUri = DataStore.BaseUri;
  private store: Store = {};

  public constructor(private cancellationToken: CancellationToken = CancellationToken.None) {
    super();
  }

  private ThrowIfCancelled(): void {
    if (this.cancellationToken.isCancellationRequested) {
      throw new OperationCanceledException();
    }
  }

  public GetReadThroughScope(customUriFilter?: (uri: string) => boolean): DataStoreViewReadonly {
    return new DataStoreViewReadThrough(this, customUriFilter);
  }

  public GetReadThroughScopeFileSystem(fs: IFileSystem): DataStoreViewReadonly {
    return new DataStoreViewReadThroughFS(this, fs);
  }

  /****************
   * Data access
   ***************/

  public async Write(uri: string): Promise<DataHandleWrite> {
    uri = ResolveUri(this.BaseUri, uri);
    this.ThrowIfCancelled();
    return new DataHandleWrite(uri, async (data, sourceMapFactory) => {
      this.ThrowIfCancelled();
      if (this.store[uri]) {
        throw new Error(`can only write '${uri}' once`);
      }
      const storeEntry: Data = {
        data: data,
        metadata: <Metadata><Metadata | null>{}
      };
      this.store[uri] = storeEntry;

      // metadata
      const result = await this.ReadStrict(uri);
      storeEntry.metadata.sourceMap = new Lazy(() => {
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
      storeEntry.metadata.sourceMapEachMappingByLine = new Lazy<sourceMap.MappingItem[][]>(() => {
        const result: sourceMap.MappingItem[][] = [];

        const sourceMapConsumer = new SourceMapConsumer(storeEntry.metadata.sourceMap.Value);

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
      storeEntry.metadata.inputSourceMap = new Lazy(() => this.CreateInputSourceMapFor(uri));
      storeEntry.metadata.yamlAst = new Lazy<YAMLNode>(() => parseAst(data));
      storeEntry.metadata.lineIndices = new Lazy<number[]>(() => LineIndices(data));
      return result;
    });
  }

  public ReadStrictSync(absoluteUri: string): DataHandleRead {
    return new DataHandleRead(absoluteUri, this.store[absoluteUri]);
  }

  public async Read(uri: string): Promise<DataHandleRead | null> {
    uri = ResolveUri(this.BaseUri, uri);
    const data = this.store[uri];
    if (!data) {
      return null;
    }
    return new DataHandleRead(uri, data);
  }

  public async Enum(): Promise<string[]> {
    return Object.getOwnPropertyNames(this.store);
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
      const inputPositions = blameTree.BlameInputs();
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

export class DataHandleWrite {
  constructor(public readonly key: string, private write: (rawData: string, metadataFactory: (readHandle: DataHandleRead) => RawSourceMap) => Promise<DataHandleRead>) {
  }

  public async WriteDataWithSourceMap(data: string, sourceMapFactory: (readHandle: DataHandleRead) => RawSourceMap): Promise<DataHandleRead> {
    return await this.write(data, sourceMapFactory);
  }

  public async WriteData(data: string, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return await this.WriteDataWithSourceMap(data, readHandle => {
      const sourceMapGenerator = new SourceMapGenerator({ file: this.key });
      Compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public WriteObject<T>(obj: T, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return this.WriteData(Stringify(obj), mappings, mappingSources);
  }
}

export class DataHandleRead {
  constructor(public readonly key: string, private read: Data) {
  }

  public ReadData(): string {
    return this.read.data;
  }

  public ReadMetadata(): Metadata {
    return this.read.metadata;
  }

  public ReadObject<T>(): T {
    return Parse<T>(this.ReadData());
  }

  public ReadYamlAst(): YAMLNode {
    return this.ReadMetadata().yamlAst.Value;
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