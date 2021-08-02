import { MappedPosition, Position, RawSourceMap, SourceMapConsumer } from "source-map";
import { promises as fs } from "fs";
import { parseYAMLAst, YamlNode, parseYAMLFast, getYamlNodeValue } from "@azure-tools/yaml";
import { getLineIndices } from "../parsing/text-utility";
import { PathMappedPosition, PathSourceMap } from "../source-map/path-source-map";
import { PositionSourceMap } from "../source-map/position-source-map";
import { EnhancedPosition } from "../source-map";
import { stringify } from "../json-path/json-path";

export interface Data {
  status: "loaded" | "unloaded";
  name: string;
  artifactType: string;
  identity: string[];
  pathSourceMap: PathSourceMap | undefined;
  positionSourceMap: PositionSourceMap | undefined;

  lineIndices?: number[];

  writeToDisk?: Promise<void>;
  cached?: string;
  cachedAst?: YamlNode;
  cachedObject?: any;
  accessed?: boolean;
}

export class DataHandle {
  private unloadTimer: NodeJS.Timer | undefined;

  /**
   * @param autoUnload If the data unhandle should automatically unload files after they are not used for a while.
   */
  constructor(public readonly key: string, private item: Data, private autoUnload = true) {
    // start the clock once this has been created.
    // this ensures that the data cache will be flushed if not
    // used in a reasonable amount of time
    this.resetUnload();
  }

  public async serialize() {
    this.item.name;
    return JSON.stringify({
      key: this.description,
      artifactType: this.item.artifactType,
      identity: this.item.identity,
      name: this.item.name,
      content: await this.readData(true),
    });
  }

  private resetUnload() {
    if (this.unloadTimer) {
      clearTimeout(this.unloadTimer);
    }

    if (!this.autoUnload) {
      return;
    }

    setTimeout(() => {
      if (this.item.accessed) {
        this.item.accessed = false;
        this.resetUnload();
      } else {
        this.unload();
      }
    }, 3000);
  }

  private unload() {
    if (!this.item.writeToDisk) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      this.item.writeToDisk = fs.writeFile(this.item.name, this.item.cached!);
    }

    if (this.item.positionSourceMap) {
      void this.item.positionSourceMap.unload();
    }

    if (this.item.pathSourceMap) {
      void this.item.pathSourceMap.unload();
    }
    // clear the caches.
    this.item.status = "unloaded";
    this.item.cached = undefined;
    this.item.cachedObject = undefined;
    this.item.cachedAst = undefined;
  }

  public get originalDirectory() {
    const id = this.identity[0];
    return id.substring(0, id.lastIndexOf("/"));
  }

  public get originalFullPath() {
    return this.identity[0];
  }

  public get identity() {
    return this.item.identity;
  }

  public async readData(nocache = false): Promise<string> {
    if (!nocache) {
      // we're going to use the data, so let's not let it expire.
      this.item.accessed = true;
    }
    // if it's not cached, load it from disk.
    if (this.item.cached === undefined) {
      // make sure the write-to-disk is finished.
      await this.item.writeToDisk;
      if (nocache) {
        return await fs.readFile(this.item.name, "utf8");
      } else {
        this.item.cached = await fs.readFile(this.item.name, "utf8");
        this.item.status = "loaded";

        // start the timer again.
        this.resetUnload();
      }
    }

    return this.item.cached;
  }

  public async readObjectFast<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;
    return this.item.cachedObject || (this.item.cachedObject = parseYAMLFast(await this.readData()));
  }

  public async readObject<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    // this.item.accessed = true;

    // // return the cached object, or get it, then return it.
    // return this.item.cachedObject || (this.item.cachedObject = getYamlNodeValue<T>(await this.readYamlAst()).result);

    return this.readObjectFast();
  }

  public async readYamlAst(): Promise<YamlNode> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;
    // return the cachedAst or get it, then return it.
    return this.item.cachedAst || (this.item.cachedAst = parseYAMLAst(await this.readData()));
  }

  public get artifactType(): string {
    return this.item.artifactType;
  }

  public get description(): string {
    return decodeURIComponent(this.key.split("?").reverse()[0]);
  }

  public async isObject(): Promise<boolean> {
    try {
      await this.readObject();
      return true;
    } catch (e) {
      return false;
    }
  }

  public async blame(position: EnhancedPosition): Promise<Array<MappedPosition | PathMappedPosition>> {
    if (position.path) {
      if (this.item.pathSourceMap) {
        const mapping = await this.item.pathSourceMap.getOriginalLocation({ path: position.path });
        if (mapping) {
          return [mapping];
        } else {
          return [];
        }
      }
      return [];
    } else {
      if (this.item.positionSourceMap) {
        const mapping = await this.item.positionSourceMap.getOriginalLocation(position);
        if (mapping) {
          return [mapping];
        } else {
          return [];
        }
      }
    }

    return [];
  }

  public async lineIndices() {
    if (!this.item.lineIndices) {
      this.item.lineIndices = getLineIndices(await this.readData());
    }

    return this.item.lineIndices;
  }

  /**
   * @deprecated use @see isObject
   */
  public async IsObject(): Promise<boolean> {
    return this.isObject();
  }

  /**
   * @deprecated use @see description
   */
  public get Description(): string {
    return this.description;
  }
  /**
   * @deprecated use @see readData
   */
  public async ReadData(nocache = false): Promise<string> {
    return this.readData(nocache);
  }

  /**
   * @deprecated use @see readObjectFast
   */
  public async ReadObjectFast<T>(): Promise<T> {
    return this.readObjectFast();
  }

  /**
   * @deprecated use @see readObject
   */
  public async ReadObject<T>(): Promise<T> {
    return this.readObject();
  }

  /**
   * @deprecated use @see readYamlAst
   */
  public async ReadYamlAst(): Promise<YamlNode> {
    return this.readYamlAst();
  }
}

function computePositionSourceMapFromPath() {
  // async (readHandle) => {
  //   const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
  //   if (this.options.generateSourceMap) {
  //     if (mappings) {
  //       await compileMapping(mappings.mappings, sourceMapGenerator, mappings.mappingSources.concat(readHandle));
  //     }
  //   }
  //   return sourceMapGenerator.toJSON();
  // };
}
