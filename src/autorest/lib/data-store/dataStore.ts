/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as http from "http";
import { read } from "./input";
import { RawSourceMap, SourceMapGenerator } from "source-map";
import { Mappings, compile } from "../source-map/sourceMap";

interface Data {
  data: string;
  metadata: {
    sourceMap: RawSourceMap;
  };
}

type Store = { [key: string]: Data };

export class DataStore {
  private store: Store = {};

  public async create(key: string): Promise<DataHandleWrite> {
    return new DataHandleWrite(key, async data => {
      if (this.store[key]) {
        throw new Error(`can only write '${key}' once`);
      }
      this.store[key] = data;
      return new DataHandleRead(key, Promise.resolve(data));
    });
  }

  public async readThrough(key: string, uri: string): Promise<DataHandleRead> {
    const data = await read(uri);
    const writeHandle = await this.create(key);
    const readHandle = await writeHandle.writeData(data);
    return readHandle;
  }
}

export class DataHandleWrite {
  constructor(public readonly key: string, private write: (data: Data) => Promise<DataHandleRead>) {
  }

  public async writeDataWithSourceMap(data: string, sourceMap: RawSourceMap): Promise<DataHandleRead> {
    // TODO: validate sourceMap
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
}