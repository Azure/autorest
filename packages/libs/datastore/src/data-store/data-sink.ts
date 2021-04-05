import { RawSourceMap, SourceMapGenerator } from "source-map";
import { FastStringify } from "../yaml";
import { compileMapping, Mapping } from "../source-map/source-map";

import { DataHandle } from "./data-handle";

export class DataSink {
  constructor(
    private write: (
      description: string,
      rawData: string,
      artifact: string | undefined,
      identity: Array<string>,
      metadataFactory: (readHandle: DataHandle) => Promise<RawSourceMap>,
    ) => Promise<DataHandle>,
    public forward: (description: string, input: DataHandle) => Promise<DataHandle>,
  ) {}

  public async writeDataWithSourceMap(
    description: string,
    data: string,
    artifact: string | undefined,
    identity: string[],
    sourceMapFactory: (readHandle: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    return this.write(description, data, artifact, identity, sourceMapFactory);
  }

  public async writeData(
    description: string,
    data: string,
    identity: string[],
    artifact?: string,
    mappings: Mapping[] = [],
    mappingSources: DataHandle[] = [],
  ): Promise<DataHandle> {
    return this.writeDataWithSourceMap(description, data, artifact, identity, async (readHandle) => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      await compileMapping(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public writeObject<T>(
    description: string,
    obj: T,
    identity: Array<string>,
    artifact?: string,
    mappings: Array<Mapping> = [],
    mappingSources: Array<DataHandle> = [],
  ): Promise<DataHandle> {
    return this.writeData(description, FastStringify(obj), identity, artifact, mappings, mappingSources);
  }

  /**
   * @deprecated use @see writeDataWithSourceMap
   */
  public async WriteDataWithSourceMap(
    description: string,
    data: string,
    artifact: string | undefined,
    identity: Array<string>,
    sourceMapFactory: (readHandle: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    return this.writeDataWithSourceMap(description, data, artifact, identity, sourceMapFactory);
  }

  /**
   * @deprecated use @see writeData
   */
  public async WriteData(
    description: string,
    data: string,
    identity: Array<string>,
    artifact?: string,
    mappings: Array<Mapping> = [],
    mappingSources: Array<DataHandle> = [],
  ): Promise<DataHandle> {
    return this.writeData(description, data, identity, artifact, mappings, mappingSources);
  }

  /**
   * @deprecated use @see writeObject
   */
  public WriteObject<T>(
    description: string,
    obj: T,
    identity: Array<string>,
    artifact?: string,
    mappings: Array<Mapping> = [],
    mappingSources: Array<DataHandle> = [],
  ): Promise<DataHandle> {
    return this.writeObject(description, obj, identity, artifact, mappings, mappingSources);
  }

  /**
   * @deprecated use @see forward
   */
  public Forward(description: string, input: DataHandle): Promise<DataHandle> {
    return this.forward(description, input);
  }
}
