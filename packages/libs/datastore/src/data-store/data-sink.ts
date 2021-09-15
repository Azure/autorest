import { fastStringify } from "@azure-tools/yaml";
import { SourceMapGenerator, RawSourceMap } from "source-map";
import { addMappingsToSourceMap, Mapping } from "../source-map";
import { IdentityPathMappings, PathMapping } from "../source-map/path-source-map";
import { DataHandle } from "./data-handle";

export class DataSink {
  constructor(
    private write: (
      description: string,
      rawData: string,
      artifact: string | undefined,
      identity: Array<string>,
      mappings?: PathMapping[] | IdentityPathMappings,
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
    if (!mappings) {
      return this.write(description, data, artifact, identity);
    }
    if ("pathMappings" in mappings) {
      return this.write(description, data, artifact, identity, mappings?.pathMappings);
    }
    return this.write(description, data, artifact, identity, undefined, async (readHandle) => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      if (mappings) {
        await addMappingsToSourceMap(mappings.positionMappings, sourceMapGenerator);
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

export type MappingParam = PathMappingParam | PositionMappingParam;

export interface PathMappingParam {
  /**
   * List of mappings from original to generated using path
   */
  pathMappings: PathMapping[] | IdentityPathMappings;
}

export interface PositionMappingParam {
  /**
   * List of mappings from original to generated using positions
   */
  positionMappings: Mapping[];
}
