import { serialize } from "../../../codegen/dist";
import { JsonPath, stringify } from "../json-path/json-path";
import { SourceMapData } from "./source-map-data";

export interface PathMapping {
  /**
   * JsonPath of the target
   */
  generated: JsonPath;

  /**
   * JsonPath of the original source.
   */
  original: JsonPath;

  /**
   * Source file.
   */
  source: string;
}

export interface PathMappedPosition {
  path: JsonPath;
  source: string;
}

export interface PathPosition {
  path: string | JsonPath;
}

/**
 * Sourcemap based on json paths.
 */
export class PathSourceMap {
  private data: PathSourceMapData;

  public constructor(filename: string, mappings: PathMapping[]) {
    const map = new Map<string, PathMappedPosition>();
    for (const mapping of mappings) {
      map.set(serialize(mapping.generated), { path: mapping.original, source: mapping.source });
    }

    this.data = new PathSourceMapData(`${filename}.pathmap`, map);
  }

  public async getOriginalLocation(position: PathPosition): Promise<PathMappedPosition | undefined> {
    const mappings = await this.data.get();
    const path = typeof position.path === "string" ? position.path : stringify(position.path);
    const mapping = mappings.get(path);
    if (!mapping) {
      return undefined;
    }

    return mapping;
  }

  public unload(): Promise<void> {
    return this.data.unload();
  }
}

export class PathSourceMapData extends SourceMapData<Map<string, PathMappedPosition>> {
  protected serialize(value: Map<string, PathMappedPosition>): string {
    return JSON.stringify([...value]);
  }

  protected parse(content: string): Map<string, PathMappedPosition> {
    return new Map(JSON.parse(content));
  }
}
