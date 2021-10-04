import { JsonPointerTokens, serializeJsonPointer } from "@azure-tools/json";
import { SourceMapData } from "./source-map-data";

/**
 * PathSourceMap where the path between the source and generated documeent are a 1:1 mapping.
 * To use when a plugin doesn't change the structure.
 */
export class IdentityPathMappings {
  public constructor(public source: string) {}
}

export interface PathMapping {
  /**
   * JsonPath of the target
   */
  generated: JsonPointerTokens;

  /**
   * JsonPath of the original source.
   */
  original: JsonPointerTokens;

  /**
   * Source file.
   */
  source: string;
}

export interface PathMappedPosition {
  path: JsonPointerTokens;
  source: string;
}

export interface PathPosition {
  path: JsonPointerTokens;
}

/**
 * Sourcemap based on json paths.
 */
export class PathSourceMap {
  private data: PathSourceMapData;

  public constructor(filename: string, mappings: PathMapping[]) {
    const map = new Map<string, PathMappedPosition>();
    for (const mapping of mappings) {
      map.set(serializeJsonPointer(mapping.generated), { path: mapping.original, source: mapping.source });
    }

    this.data = new PathSourceMapData(`${filename}.pathmap`, map);
  }

  public async getOriginalLocation(position: PathPosition): Promise<PathMappedPosition | undefined> {
    const mappings = await this.data.get();
    const path = typeof position.path === "string" ? position.path : serializeJsonPointer(position.path);
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
