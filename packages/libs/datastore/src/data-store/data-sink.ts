import { RawSourceMap, SourceMapGenerator } from "source-map";
import { fastStringify } from "@azure-tools/yaml";
import { compileMapping, Mapping } from "../source-map/source-map";

import { DataHandle } from "./data-handle";
import { PathMapping } from "../source-map/path-source-map";

export interface DataSinkOptions {
  generateSourceMap?: boolean;
}

export class DataSink {
  constructor(
    private options: DataSinkOptions,
    private write: (
      description: string,
      rawData: string,
      artifact: string | undefined,
      identity: Array<string>,
      mappings?: PathMapping[],
      metadataFactory?: (readHandle: DataHandle) => Promise<RawSourceMap>,
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
    return this.write(description, data, artifact, identity, undefined, sourceMapFactory);
  }

  public async writeData(
    description: string,
    data: string,
    identity: string[],
    artifact?: string,
    mappings?: MappingParam,
  ): Promise<DataHandle> {
    return this.write(description, data, artifact, identity, mappings?.mappings);
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
  mappings: PathMapping[];

  /**
   * Data handle of the source mapping.
   */
  mappingSources: DataHandle[];
}
