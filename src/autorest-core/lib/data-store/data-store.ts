/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { JsonPath } from '../ref/jsonpath';
import { CancellationToken } from "../ref/cancallation";
import { Mappings, Mapping, SmartPosition, Position } from "../ref/source-map";
import { ReadUri, ResolveUri, WriteString } from "../ref/uri";
import { Parse, ParseToAst as parseAst, YAMLNode, Stringify } from "../ref/yaml";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator, SourceMapConsumer } from "source-map";
import { Compile, CompilePosition } from "../source-map/source-map";
import { BlameTree } from "../source-map/blaming";
import { Lazy } from "../lazy";
import { IFileSystem } from "../file-system";

export const helloworld = "hi"; // TODO: wat?

/* @internal */
export module KnownScopes {
  export const Input = "input";
  export const Configuration = "config";
}

/********************************************
 * Data model section (not exposed)
 ********************************************/

export interface Metadata {
  inputSourceMap: Lazy<RawSourceMap>;
  sourceMap: Lazy<RawSourceMap>;
  yamlAst: Lazy<YAMLNode>;
}

interface Data {
  data: string;
  metadata: Metadata;
}

type Store = { [key: string]: Data };


/********************************************
 * Central data controller
 * - one stop for creating data
 * - ensures WRITE ONCE model
 ********************************************/

export abstract class DataStoreViewReadonly {
  abstract Enum(): Promise<string[]>;
  abstract Enum(prefix: string): Promise<string[]>;
  abstract Read(key: string): Promise<DataHandleRead | null>;

  public async ReadStrict(key: string): Promise<DataHandleRead> {
    const result = await this.Read(key);
    if (result === null) {
      throw new Error(`Failed to read '${key}'. Key not found.`);
    }
    return result;
  }

  public async Dump(targetDirUri: string): Promise<void> {
    const keys = await this.Enum();
    for (const key of keys) {
      const dataHandle = await this.ReadStrict(key);
      const data = await dataHandle.ReadData();
      const metadata = await dataHandle.ReadMetadata();
      const targetFileUri = ResolveUri(
        targetDirUri.replace(/\/$/g, "") + "/",
        key.replace(/%3A/g, "")); // bug: ResolveUri (or rather its internals) unescape "%3A" to ":"
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
  abstract Write(key: string): Promise<DataHandleWrite>;

  public CreateScope(name: string): DataStoreView {
    return new DataStoreViewScope(name, this);
  }

  public AsFileScope(): DataStoreFileView {
    return new DataStoreFileView(this);
  }

  public AsFileScopeReadThrough(customUriFilter?: (uri: string) => boolean): DataStoreViewReadonly {
    return new DataStoreViewReadThrough(this.AsFileScope(), customUriFilter);
  }

  public AsFileScopeReadThroughFileSystem(fs: IFileSystem): DataStoreViewReadonly {
    return new DataStoreViewReadThroughFS(this.AsFileScope(), fs);
  }

  public AsReadonly(): DataStoreViewReadonly {
    return this;
  }
}

class DataStoreViewScope extends DataStoreView {
  constructor(private name: string, private slave: DataStoreView) {
    super();
  }

  private get Prefix(): string {
    return `${this.name}/`;
  }

  public Write(key: string): Promise<DataHandleWrite> {
    return this.slave.Write(this.Prefix + key);
  }

  public Read(key: string): Promise<DataHandleRead> {
    return this.slave.Read(this.Prefix + key);
  }

  public async Enum(): Promise<string[]> {
    const parentResult = await this.slave.Enum();
    return From(parentResult)
      .Where(key => key.startsWith(this.Prefix))
      .Select(key => key.substr(this.Prefix.length))
      .ToArray();
  }
}

class DataStoreViewReadThrough extends DataStoreViewReadonly {
  constructor(private slave: DataStoreFileView, private customUriFilter: (uri: string) => boolean = uri => /^http/.test(uri)) {
    super();
  }

  public async Read(uri: string): Promise<DataHandleRead> {
    // validation before hitting the file system or web
    if (!this.customUriFilter(uri)) {
      throw new Error(`Provided URI '${uri}' violated the filter`);
    }

    // special URI handlers
    // - GitHub
    if (uri.startsWith('https://github')) {
      uri = uri.replace(/^https:\/\/(github.com)(.*)blob\/(.*)/ig, 'https://raw.githubusercontent.com$2$3');
    }

    // prope cache
    const existingData = await this.slave.Read(uri);
    if (existingData !== null) {
      return existingData;
    }

    // populate cache
    const data = await ReadUri(uri);
    const writeHandle = await this.slave.Write(uri);
    const readHandle = await writeHandle.WriteData(data);
    return readHandle;
  }

  public async Enum(): Promise<string[]> {
    return this.slave.Enum();
  }
}

class DataStoreViewReadThroughFS extends DataStoreViewReadonly {
  constructor(private slave: DataStoreFileView, private fs: IFileSystem) {
    super();
  }

  public async Read(uri: string): Promise<DataHandleRead> {
    // special URI handlers
    // - GitHub
    if (uri.startsWith('https://github')) {
      uri = uri.replace(/^https:\/\/(github.com)(.*)blob\/(.*)/ig, 'https://raw.githubusercontent.com$2$3');
    }

    // prope cache
    const existingData = await this.slave.Read(uri);
    if (existingData !== null) {
      return existingData;
    }

    // populate cache
    let data: string | null = null;
    try {
      data = await this.fs.ReadFile(uri);
    } finally {
      if (!data) {
        throw new Error(`FileSystem unable to read file ${uri}.`)
      }
    }
    const writeHandle = await this.slave.Write(uri);
    const readHandle = await writeHandle.WriteData(data);
    return readHandle;
  }

  public async Enum(): Promise<string[]> {
    return this.slave.Enum();
  }
}

export class DataStoreFileView extends DataStoreView {
  private static isUri(uri: string): boolean {
    return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
  }

  private static EncodeUri(uri: string): string {
    return encodeURIComponent(uri);
  }

  private static DecodeUri(encodedUri: string): string {
    return decodeURIComponent(encodedUri);
  }

  constructor(private slave: DataStoreView) {
    super();
  }

  public async Read(uri: string): Promise<DataHandleRead | null> {
    if (!DataStoreFileView.isUri(uri)) {
      throw new Error(`Provided URI '${uri}' is invalid`);
    }

    const key = DataStoreFileView.EncodeUri(uri);
    return await this.slave.Read(key);
  }

  public async Write(uri: string): Promise<DataHandleWrite> {
    if (!DataStoreFileView.isUri(uri)) {
      throw new Error(`Provided URI '${uri}' is invalid`);
    }

    const key = DataStoreFileView.EncodeUri(uri);
    return await this.slave.Write(key);
  }

  public async Enum(): Promise<string[]> {
    const slaveResult = await this.slave.Enum();
    return From(slaveResult).Select(DataStoreFileView.DecodeUri).ToArray();
  }
}

export class DataStore extends DataStoreView {
  private store: Store = {};

  public constructor(private cancellationToken: CancellationToken = CancellationToken.None) {
    super();
  }

  private ThrowIfCancelled(): void {
    if (this.cancellationToken.isCancellationRequested) {
      throw new Error("cancelled");
    }
  }

  /****************
   * Data access
   ***************/

  public async Write(key: string): Promise<DataHandleWrite> {
    this.ThrowIfCancelled();
    return new DataHandleWrite(key, async (data, sourceMapFactory) => {
      this.ThrowIfCancelled();
      if (this.store[key]) {
        throw new Error(`can only write '${key}' once`);
      }
      const storeEntry: Data = {
        data: data,
        metadata: <Metadata><Metadata | null>{}
      };
      this.store[key] = storeEntry;

      // metadata
      const result = await this.ReadStrict(key);
      storeEntry.metadata.sourceMap = new Lazy(async () => {
        const sourceMap = await sourceMapFactory(result);

        // validate
        const inputFiles = sourceMap.sources.concat(sourceMap.file);
        for (const inputFile of inputFiles) {
          if (!this.store[inputFile]) {
            throw new Error(`Source map of '${key}' references '${inputFile}' which does not exist`);
          }
        }

        return sourceMap;
      });
      storeEntry.metadata.inputSourceMap = new Lazy(() => this.CreateInputSourceMapFor(key));
      storeEntry.metadata.yamlAst = new Lazy<YAMLNode>(async () => parseAst(data));
      return result;
    });
  }

  public async Read(key: string): Promise<DataHandleRead | null> {
    const data = this.store[key];
    if (!data) {
      return null;
    }
    return new DataHandleRead(key, Promise.resolve(data));
  }

  public async Enum(): Promise<string[]> {
    return Object.getOwnPropertyNames(this.store);
  }

  public async Blame(key: string, position: SmartPosition): Promise<BlameTree> {
    const data = await this.ReadStrict(key);
    const resolvedPosition = await CompilePosition(position, data);
    return BlameTree.Create(this, {
      source: key,
      column: resolvedPosition.column,
      line: resolvedPosition.line,
      name: `blameRoot (${JSON.stringify(position)})`
    });
  }

  private async CreateInputSourceMapFor(key: string): Promise<RawSourceMap> {
    const data = await this.ReadStrict(key);

    // retrieve all target positions
    const targetPositions: SmartPosition[] = [];
    const metadata = await data.ReadMetadata();
    const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);
    sourceMapConsumer.eachMapping(m => targetPositions.push(<Position>{ column: m.generatedColumn, line: m.generatedLine }));

    // collect blame
    const mappings: Mapping[] = [];
    for (const targetPosition of targetPositions) {
      const blameTree = await this.Blame(key, targetPosition);
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
    const sourceMapGenerator = new SourceMapGenerator({ file: key });
    await Compile(mappings, sourceMapGenerator);
    return sourceMapGenerator.toJSON();
  }
}


/********************************************
 * Data handles
 * - provide well-defined access to specific data
 * - provide convenience methods
 ********************************************/

export class DataHandleWrite {
  constructor(public readonly key: string, private write: (rawData: string, metadataFactory: (readHandle: DataHandleRead) => Promise<RawSourceMap>) => Promise<DataHandleRead>) {
  }

  public async WriteDataWithSourceMap(data: string, sourceMapFactory: (readHandle: DataHandleRead) => Promise<RawSourceMap>): Promise<DataHandleRead> {
    return await this.write(data, sourceMapFactory);
  }

  public async WriteData(data: string, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return await this.WriteDataWithSourceMap(data, async readHandle => {
      const sourceMapGenerator = new SourceMapGenerator({ file: this.key });
      await Compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public WriteObject<T>(obj: T, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return this.WriteData(Stringify(obj), mappings, mappingSources);
  }
}

/* @internal */
export class DataHandleRead {
  constructor(public readonly key: string, private read: Promise<Data>) {
  }

  public async ReadData(): Promise<string> {
    const data = await this.read;
    return data.data;
  }

  public async ReadMetadata(): Promise<Metadata> {
    const data = await this.read;
    return data.metadata;
  }

  public async ReadObject<T>(): Promise<T> {
    const data = await this.ReadData();
    return Parse<T>(data);
  }

  public async ReadYamlAst(): Promise<YAMLNode> {
    const data = await this.ReadMetadata();
    return await data.yamlAst;
  }

  public async Blame(position: sourceMap.Position): Promise<(sourceMap.MappedPosition & { path?: JsonPath })[]> {
    const metadata = await this.ReadMetadata();
    const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);

    // const singleResult = sourceMapConsumer.originalPositionFor(position);
    // does NOT support multiple sources :(
    // `singleResult` has null-properties if there is no original

    // get coinciding sources
    const sameLineResults: sourceMap.MappingItem[] = [];
    sourceMapConsumer.eachMapping(mapping => {
      if (mapping.generatedLine === position.line && mapping.generatedColumn <= position.column) {
        sameLineResults.push(mapping);
      }
    });
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