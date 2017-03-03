/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from "path";
import { Mappings, Mapping, SmartPosition, Position } from "../approved-imports/sourceMap";
import { readUri } from "../approved-imports/uri";
import { writeString } from "../approved-imports/writefs";
import { parse, parseToAst as parseAst, YAMLNode, stringify } from "../approved-imports/yaml";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator, SourceMapConsumer } from "source-map";
import { compile, compilePosition } from "../source-map/sourceMap";
import { BlameTree } from "../source-map/blaming";

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
  inputSourceMap: Promise<RawSourceMap>;
  sourceMap: Promise<RawSourceMap>;
  yamlAst: Promise<YAMLNode>;
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
  abstract read(key: string): Promise<DataHandleRead | null>;
  abstract enum(): Promise<Iterable<string>>;

  public async dump(targetDir: string): Promise<void> {
    const keys = await this.enum();
    for (const key of keys) {
      const dataHandle = await this.read(key);
      if (dataHandle !== null) {
        const data = await dataHandle.readData();
        const metadata = await dataHandle.readMetadata();
        const targetFile = path.join(targetDir, key);
        await writeString(targetFile, data);
        await writeString(targetFile + ".map", JSON.stringify(await metadata.sourceMap, null, 2));
        await writeString(targetFile + ".input.map", JSON.stringify(await metadata.inputSourceMap, null, 2));
      }
    }
  }
}

export abstract class DataStoreView extends DataStoreViewReadonly {
  abstract write(key: string): Promise<DataHandleWrite>;

  public createScope(name: string): DataStoreView {
    return new DataStoreViewScope(name, this);
  }

  public asFileScope(): DataStoreFileView {
    return new DataStoreFileView(this);
  }

  public asFileScopeReadThrough(customUriFilter?: (uri: string) => boolean): DataStoreViewReadonly {
    return new DataStoreViewReadThrough(this.asFileScope(), customUriFilter);
  }

  public asReadonly(): DataStoreViewReadonly {
    return this;
  }
}

class DataStoreViewScope extends DataStoreView {
  constructor(private name: string, private slave: DataStoreView) {
    super();
  }

  private get prefix(): string {
    return `${this.name}/`;
  }

  public write(key: string): Promise<DataHandleWrite> {
    return this.slave.write(this.prefix + key);
  }

  public read(key: string): Promise<DataHandleRead> {
    return this.slave.read(this.prefix + key);
  }

  public async enum(): Promise<Iterable<string>> {
    const parentResult = await this.slave.enum();
    return From(parentResult)
      .Where(key => key.startsWith(this.prefix))
      .Select(key => key.substr(this.prefix.length));
  }
}

class DataStoreViewReadThrough extends DataStoreViewReadonly {
  constructor(private slave: DataStoreFileView, private customUriFilter: (uri: string) => boolean = uri => /^http/.test(uri)) {
    super();
  }

  public async read(uri: string): Promise<DataHandleRead> {
    // prope cache
    const existingData = await this.slave.read(uri);
    if (existingData !== null) {
      return existingData;
    }

    // validation before hitting the file system or web
    if (!this.customUriFilter(uri)) {
      throw new Error(`Provided URI '${uri}' violated the filter`);
    }

    // populate cache
    const data = await readUri(uri);
    const writeHandle = await this.slave.write(uri);
    const readHandle = await writeHandle.writeData(data);
    return readHandle;
  }

  public async enum(): Promise<Iterable<string>> {
    return this.slave.enum();
  }
}

export class DataStoreFileView extends DataStoreView {
  private static isUri(uri: string): boolean {
    return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
  }

  private static encodeUri(uri: string): string {
    return encodeURIComponent(uri);
  }

  private static decodeUri(encodedUri: string): string {
    return decodeURIComponent(encodedUri);
  }

  constructor(private slave: DataStoreView) {
    super();
  }

  public async read(uri: string): Promise<DataHandleRead | null> {
    if (!DataStoreFileView.isUri(uri)) {
      throw new Error(`Provided URI '${uri}' is invalid`);
    }

    const key = DataStoreFileView.encodeUri(uri);
    return await this.slave.read(key);
  }

  public async write(uri: string): Promise<DataHandleWrite> {
    if (!DataStoreFileView.isUri(uri)) {
      throw new Error(`Provided URI '${uri}' is invalid`);
    }

    const key = DataStoreFileView.encodeUri(uri);
    return await this.slave.write(key);
  }

  public async enum(): Promise<Iterable<string>> {
    const slaveResult = await this.slave.enum();
    return From(slaveResult).Select(DataStoreFileView.decodeUri);
  }
}

export class DataStore extends DataStoreView {
  private store: Store = {};

  private async validate(key: string): Promise<void> {
    const data = this.store[key];

    // sourceMap
    const sourceMap = await data.metadata.sourceMap;
    const inputFiles = sourceMap.sources.concat(sourceMap.file);
    for (const inputFile of inputFiles) {
      if (!this.store[inputFile]) {
        throw new Error(`Source map of '${key}' references '${inputFile}' which does not exist`);
      }
    }
  }

  public async write(key: string): Promise<DataHandleWrite> {
    return new DataHandleWrite(key, async (data, metadataFactory) => {
      if (this.store[key]) {
        throw new Error(`can only write '${key}' once`);
      }
      const storeEntry: Data = {
        data: data,
        metadata: <Metadata><Metadata | null>null
      };
      this.store[key] = storeEntry;
      storeEntry.metadata = await metadataFactory(new DataHandleRead(key, Promise.resolve(storeEntry)));
      storeEntry.metadata.inputSourceMap = this.createInputSourceMapFor(key);
      await this.validate(key);
      return await this.read(key);
    });
  }

  public async read(key: string): Promise<DataHandleRead | null> {
    const data = this.store[key];
    if (!data) {
      return null;
    }
    return new DataHandleRead(key, Promise.resolve(data));
  }

  public async enum(): Promise<Iterable<string>> {
    return Object.getOwnPropertyNames(this.store);
  }

  public async blame(key: string, position: SmartPosition): Promise<BlameTree> {
    const data = await this.read(key);
    if (data === null) {
      throw new Error(`Data with key '${key}' not found`);
    }
    const resolvedPosition = await compilePosition(position, data);
    return BlameTree.create(this, {
      source: key,
      column: resolvedPosition.column,
      line: resolvedPosition.line,
      name: `blameRoot (${JSON.stringify(position)})`
    });
  }

  private async createInputSourceMapFor(key: string): Promise<RawSourceMap> {
    const data = await this.read(key);
    if (data === null) {
      throw new Error(`Data with key '${key}' not found`);
    }

    // retrieve all target positions
    const targetPositions: SmartPosition[] = [];
    const metadata = await data.readMetadata();
    const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);
    sourceMapConsumer.eachMapping(m => targetPositions.push(<Position>{ column: m.generatedColumn, line: m.generatedLine }));

    // collect blame
    const mappings: Mapping[] = [];
    for (const targetPosition of targetPositions) {
      const blameTree = await this.blame(key, targetPosition);
      const inputPositions = blameTree.blameInputs();
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
    await compile(mappings, sourceMapGenerator);
    return sourceMapGenerator.toJSON();
  }
}


/********************************************
 * Data handles
 * - provide well-defined access to specific data
 * - provide convenience methods
 ********************************************/

export class DataHandleWrite {
  constructor(public readonly key: string, private write: (rawData: string, metadataFactory: (readHandle: DataHandleRead) => Promise<Metadata>) => Promise<DataHandleRead>) {
  }

  public async writeDataWithSourceMap(data: string, sourceMapFactory: (readHandle: DataHandleRead) => Promise<RawSourceMap>): Promise<DataHandleRead> {
    return await this.write(data, async readHandle => {
      return {
        sourceMap: sourceMapFactory(readHandle), // defer initializing source map as it depends on read handle
        yamlAst: new Promise<YAMLNode>((res, rej) => {
          res(parseAst(data));
        })
      };
    });
  }

  public async writeData(data: string, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return await this.writeDataWithSourceMap(data, async readHandle => {
      const sourceMapGenerator = new SourceMapGenerator({ file: this.key });
      await compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public writeObject<T>(obj: T, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    return this.writeData(stringify(obj), mappings, mappingSources);
  }
}

/* @internal */
export class DataHandleRead {
  constructor(public readonly key: string, private read: Promise<Data>) {
  }

  public async readData(): Promise<string> {
    const data = await this.read;
    return data.data;
  }

  public async readMetadata(): Promise<Metadata> {
    const data = await this.read;
    return data.metadata;
  }

  public async readObject<T>(): Promise<T> {
    const data = await this.readData();
    return parse<T>(data);
  }

  public async blame(position: sourceMap.Position): Promise<sourceMap.MappedPosition[]> {
    const metadata = await this.readMetadata();
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