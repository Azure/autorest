/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as path from "path";
import { read } from "./input";
import { dumpString } from "./dump";
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

export class DataStore {
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

  public async create(key: string): Promise<DataHandleWrite> {
    return new DataHandleWrite(key, async data => {
      if (this.store[key]) {
        throw new Error(`can only write '${key}' once`);
      }
      this.store[key] = data;
      this.validate(key);
      return new DataHandleRead(key, Promise.resolve(data));
    });
  }

  public async readThrough(key: string, uri: string): Promise<DataHandleRead> {
    const data = await read(uri);
    const writeHandle = await this.create(key);
    const readHandle = await writeHandle.writeData(data);
    return readHandle;
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