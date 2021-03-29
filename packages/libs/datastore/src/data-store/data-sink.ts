import { RawSourceMap, SourceMapGenerator } from "source-map";
import { FastStringify } from "../yaml";
import { Compile, Mapping } from "../source-map/source-map";

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
    private forward: (description: string, input: DataHandle) => Promise<DataHandle>,
  ) {}

  public async WriteDataWithSourceMap(
    description: string,
    data: string,
    artifact: string | undefined,
    identity: Array<string>,
    sourceMapFactory: (readHandle: DataHandle) => Promise<RawSourceMap>,
  ): Promise<DataHandle> {
    return this.write(description, data, artifact, identity, sourceMapFactory);
  }

  public async WriteData(
    description: string,
    data: string,
    identity: Array<string>,
    artifact?: string,
    mappings: Array<Mapping> = [],
    mappingSources: Array<DataHandle> = [],
  ): Promise<DataHandle> {
    return this.WriteDataWithSourceMap(description, data, artifact, identity, async (readHandle) => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      await Compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public WriteObject<T>(
    description: string,
    obj: T,
    identity: Array<string>,
    artifact?: string,
    mappings: Array<Mapping> = [],
    mappingSources: Array<DataHandle> = [],
  ): Promise<DataHandle> {
    return this.WriteData(description, FastStringify(obj), identity, artifact, mappings, mappingSources);
  }

  public Forward(description: string, input: DataHandle): Promise<DataHandle> {
    return this.forward(description, input);
  }
}
