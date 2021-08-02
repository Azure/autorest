import { SourceMapData } from "./source-map-data";

export interface PathMapping {
  /**
   * JsonPath of the target
   */
  generated: string;

  /**
   * JsonPath of the original source.
   */
  original: string;

  /**
   * Source file.
   */
  source: string;
}

export interface OriginalPosition {
  path: string;
  source: string;
}

export interface PathPosition {
  path: string;
}

/**
 * Sourcemap based on json paths.
 */
export class PathSourceMap {
  private data: PathSourceMapData;

  public constructor(filename: string, mappings: PathMapping[]) {
    const map = new Map<string, OriginalPosition>();
    for (const mapping of mappings) {
      map.set(mapping.generated, { path: mapping.original, source: mapping.source });
    }

    this.data = new PathSourceMapData(filename, map);
  }
  public async getOriginalLocation(position: PathPosition): Promise<OriginalPosition | undefined> {
    const mappings = await this.data.get();
    const mapping = mappings.get(position.path);
    if (!mapping) {
      return undefined;
    }

    return mapping;
  }
}

export class PathSourceMapData extends SourceMapData<Map<string, OriginalPosition>> {
  protected serialize(value: Map<string, OriginalPosition>): string {
    return JSON.stringify([...value]);
  }

  protected parse(content: string): Map<string, OriginalPosition> {
    return new Map(JSON.parse(content));
  }
}
