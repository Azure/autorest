import { Position, RawSourceMap, MappedPosition, SourceMapConsumer } from "source-map";
import { SourceMapData } from "./source-map-data";

/**
 * Sourcemap based on json paths.
 */
export class PositionSourceMap {
  private data: PositionSourceMapData;

  public constructor(filename: string, mappings: RawSourceMap) {
    this.data = new PositionSourceMapData(`${filename}.map`, mappings);
  }

  public async getOriginalLocation(position: Position): Promise<MappedPosition | undefined> {
    const sourceMap = await this.data.get();
    const consumer = await new SourceMapConsumer(sourceMap);
    const mappedPosition = consumer.originalPositionFor(position);
    if (mappedPosition.line === null) {
      return undefined;
    }
    return mappedPosition as MappedPosition;
  }

  public unload(): Promise<void> {
    return this.data.unload();
  }
}

export class PositionSourceMapData extends SourceMapData<RawSourceMap> {
  protected serialize(value: RawSourceMap): string {
    return JSON.stringify(value);
  }

  protected parse(content: string): RawSourceMap {
    return JSON.parse(content);
  }
}
