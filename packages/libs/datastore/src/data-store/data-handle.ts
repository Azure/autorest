import { MappedPosition, Position, RawSourceMap, SourceMapConsumer } from "source-map";
import { promises as fs } from "fs";
import { ParseToAst as parseAst, YAMLNode, parseYAMLFast, parseNode } from "../yaml";
import { getLineIndices } from "../parsing/text-utility";

export interface Data {
  status: "loaded" | "unloaded";
  name: string;
  artifactType: string;
  identity: string[];

  lineIndices?: number[];
  sourceMap: RawSourceMap | undefined;

  writeToDisk?: Promise<void>;
  writeSourceMapToDisk?: Promise<void>;
  cached?: string;
  cachedAst?: YAMLNode;
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
    if (this.item.sourceMap && !this.item.writeSourceMapToDisk) {
      this.item.writeSourceMapToDisk = fs.writeFile(`${this.item.name}.map`, JSON.stringify(this.item.sourceMap));
    }
    // clear the caches.
    this.item.status = "unloaded";
    this.item.cached = undefined;
    this.item.cachedObject = undefined;
    this.item.cachedAst = undefined;
    this.item.sourceMap = undefined;
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
    this.item.accessed = true;

    // return the cached object, or get it, then return it.
    return this.item.cachedObject || (this.item.cachedObject = parseNode<T>(await this.readYamlAst()).result);
  }

  public async readYamlAst(): Promise<YAMLNode> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;
    // return the cachedAst or get it, then return it.
    return this.item.cachedAst || (this.item.cachedAst = parseAst(await this.readData()));
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

  public async blame(position: Position): Promise<Array<MappedPosition>> {
    await this.readData();
    const sourceMap = await this.getSourceMap();
    if (!sourceMap) {
      return [];
    }
    const consumer = await new SourceMapConsumer(sourceMap);
    const mappedPosition = consumer.originalPositionFor(position);
    if (mappedPosition.line === null) {
      return [];
    }
    return [mappedPosition as any];
  }

  public async lineIndices() {
    if (!this.item.lineIndices) {
      this.item.lineIndices = getLineIndices(await this.readData());
    }

    return this.item.lineIndices;
  }

  public async getSourceMap() {
    if (!this.item.sourceMap) {
      try {
        const content = await fs.readFile(`${this.item.name}.map`, "utf8");
        this.item.sourceMap = JSON.parse(content.toString());
      } catch {
        return undefined;
      }
    }

    return this.item.sourceMap;
  }

  /**
   * @deprecated use @see isObject
   */
  public async IsObject(): Promise<boolean> {
    return this.isObject();
  }

  /**
   * @deprecated use @see blame
   */
  public async Blame(position: Position): Promise<Array<MappedPosition>> {
    return this.blame(position);
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
  public async ReadYamlAst(): Promise<YAMLNode> {
    return this.readYamlAst();
  }
}
