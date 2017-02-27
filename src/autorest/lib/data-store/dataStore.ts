/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from "path";
import { readUri } from "../io/input";
import { dumpString } from "../io/dump";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator } from "source-map";
import { Mappings, compile } from "../source-map/sourceMap";
import { parse } from "../parsing/yaml";

export module KnownScopes {
  export const Input = "input";
  export const Configuration = "config";
}

/********************************************
 * Data model section (not exposed)
 ********************************************/

interface Metadata {
  sourceMap: RawSourceMap;
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
        console.log(key);
        await dumpString(targetFile, data);
        await dumpString(targetFile + ".map", JSON.stringify(metadata.sourceMap, null, 2));
      }
    }
  }
}

export abstract class DataStoreView extends DataStoreViewReadonly {
  abstract write(key: string): Promise<DataHandleWrite>;

  public createScope(name: string): DataStoreView {
    return new DataStoreViewScope(name, this);
  }

  public createFileScope(name: string): DataStoreFileView {
    return new DataStoreFileView(new DataStoreViewScope(name, this));
  }

  public createReadThroughScope(name: string, customUriFilter?: (uri: string) => boolean): DataStoreViewReadonly {
    return new DataStoreViewReadThrough(this.createFileScope(name), customUriFilter);
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
      throw `Provided URI '${uri}' violated the filter`;
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

class DataStoreFileView extends DataStoreView {
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
      throw `Provided URI '${uri}' is invalid`;
    }

    const key = DataStoreFileView.encodeUri(uri);
    return await this.slave.read(key);
  }

  public async write(uri: string): Promise<DataHandleWrite> {
    if (!DataStoreFileView.isUri(uri)) {
      throw `Provided URI '${uri}' is invalid`;
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

  private validate(key: string): void {
    const data = this.store[key];

    // sourceMap
    const inputFiles = data.metadata.sourceMap.sources.concat(data.metadata.sourceMap.file);
    for (const inputFile of inputFiles) {
      if (!this.store[inputFile]) {
        throw new Error(`Source map of '${key}' references '${inputFile}' which does not exist`);
      }
    }
  }

  public async write(key: string): Promise<DataHandleWrite> {
    return new DataHandleWrite(key, async data => {
      if (this.store[key]) {
        throw new Error(`can only write '${key}' once`);
      }
      this.store[key] = data;
      this.validate(key);
      return this.read(key);
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
}


/********************************************
 * Data handles
 * - provide well-defined access to specific data
 * - provide convenience methods
 ********************************************/

export class DataHandleWrite {
  constructor(public readonly key: string, private write: (data: Data) => Promise<DataHandleRead>) {
  }

  public async writeDataWithSourceMap(data: string, sourceMap: RawSourceMap): Promise<DataHandleRead> {
    return await this.write({
      data: data,
      metadata: {
        sourceMap: sourceMap
      }
    });
  }

  public async writeData(data: string, mappings: Mappings = [], mappingSources: DataHandleRead[] = []): Promise<DataHandleRead> {
    // compile source map
    const sourceMapGenerator = new SourceMapGenerator({ file: this.key });
    const inputFiles: { [key: string]: string } = {};
    for (const mappingSource of mappingSources) {
      inputFiles[mappingSource.key] = await mappingSource.readData();
    }
    inputFiles[this.key] = data;
    compile(mappings, sourceMapGenerator, inputFiles);

    return await this.writeDataWithSourceMap(data, sourceMapGenerator.toJSON());
  }
}

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
}