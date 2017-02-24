/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from "path";
import { readUri } from "./input";
import { dumpString } from "./dump";
import { From } from "linq-es2015";
import { RawSourceMap, SourceMapGenerator } from "source-map";
import { Mappings, compile } from "../source-map/sourceMap";
import { parse } from "../parsing/yaml";


/********************************************
 * Data model section (not exposed)
 ********************************************/

interface Data {
  data: string;
  metadata: {
    sourceMap: RawSourceMap;
  };
}

type Store = { [key: string]: Data };


/********************************************
 * Central data controller
 * - one stop for creating data
 * - ensures WRITE ONCE model
 ********************************************/

abstract class DataViewReadonly {
  abstract read(key: string): Promise<DataHandleRead | null>;
  abstract enum(): Promise<Iterable<string>>;
}

abstract class DataView extends DataViewReadonly {
  abstract write(key: string): Promise<DataHandleWrite>;

  public createScope(name: string): DataView {
    return new DataViewScope(name, this);
  }

  public createReadThroughScope(name: string, customUriFilter?: (uri: string) => boolean): DataViewReadonly {
    return new DataViewReadThrough(this.createScope(name), customUriFilter);
  }

  public asReadonly(): DataViewReadonly {
    return this;
  }
}

class DataViewScope extends DataView {
  constructor(private name: string, private slave: DataView) {
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

class DataViewReadThrough extends DataViewReadonly {
  private static isUri(uri: string): boolean {
    return /^([a-z0-9+.-]+):(?:\/\/(?:((?:[a-z0-9-._~!$&'()*+,;=:]|%[0-9A-F]{2})*)@)?((?:[a-z0-9-._~!$&'()*+,;=]|%[0-9A-F]{2})*)(?::(\d*))?(\/(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?|(\/?(?:[a-z0-9-._~!$&'()*+,;=:@]|%[0-9A-F]{2})+(?:[a-z0-9-._~!$&'()*+,;=:@/]|%[0-9A-F]{2})*)?)(?:\?((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?(?:#((?:[a-z0-9-._~!$&'()*+,;=:/?@]|%[0-9A-F]{2})*))?$/i.test(uri);
  }

  private static encodeUri(uri: string): string {
    return encodeURIComponent(uri);
  }

  private static decodeUri(encodedUri: string): string {
    return decodeURIComponent(encodedUri);
  }

  constructor(private slave: DataView, private customUriFilter: (uri: string) => boolean = uri => /^http/.test(uri)) {
    super();
  }

  public async read(uri: string): Promise<DataHandleRead> {
    // validation
    if (!DataViewReadThrough.isUri(uri)) {
      throw `Provided URI '${uri}' is invalid`;
    }
    if (!this.customUriFilter(uri)) {
      throw `Provided URI '${uri}' violated the filter`;
    }

    const key = DataViewReadThrough.encodeUri(uri);

    // prope cache
    const existingData = await this.slave.read(key);
    if (existingData !== null) {
      return existingData;
    }

    // populate cache
    const data = await readUri(uri);
    const writeHandle = await this.slave.write(key);
    const readHandle = await writeHandle.writeData(data);
    return readHandle;
  }

  public async enum(): Promise<Iterable<string>> {
    const slaveResult = await this.slave.enum();
    return From(slaveResult).Select(DataViewReadThrough.decodeUri);
  }
}

export class DataStore extends DataView {
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

  public async dump(targetDir: string): Promise<void> {
    // tslint:disable-next-line:forin
    for (const key in this.store) {
      const data = this.store[key];
      const targetFile = path.join(targetDir, key);
      await dumpString(targetFile, data.data);
      await dumpString(targetFile + ".map", JSON.stringify(data.metadata.sourceMap, null, 2));
    }
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

  public async readObject<T>(): Promise<T> {
    const data = await this.readData();
    return parse<T>(data);
  }
}