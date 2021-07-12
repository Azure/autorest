import { RawSourceMap, SourceMapGenerator } from "source-map";
import { fastStringify } from "../yaml";
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
    mappings?: MappingParam,
  ): Promise<DataHandle> {
    return this.writeDataWithSourceMap(description, data, artifact, identity, async (readHandle) => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      if (mappings) {
        await compileMapping(mappings.mappings, sourceMapGenerator, mappings.mappingSources.concat(readHandle));
      }
      return sourceMapGenerator.toJSON();
    });
  }

  public writeObject<T>(
    description: string,
    obj: T,
    identity: Array<string>,
    artifact?: string,
    mappings?: MappingParam,
  ): Promise<DataHandle> {
    return this.writeData(description, fastStringify(obj), identity, artifact, mappings);
  }
}

export interface MappingParam {
  /**
   * List of mappings from original to generated
   */
  mappings: Mapping[];

  /**
   * Data handle of the source mapping.
   */
  mappingSources: DataHandle[];
}
