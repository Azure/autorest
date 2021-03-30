import { Delay, Lazy, LazyPromise } from "@azure-tools/tasks";
import { MappedPosition, MappingItem, Position, RawSourceMap } from "source-map";
import { promises as fs } from "fs";
import { ParseToAst as parseAst, YAMLNode, parseYaml, ParseNode } from "../yaml";

export interface Metadata {
  lineIndices: Lazy<Array<number>>;

  inputSourceMap: LazyPromise<RawSourceMap>;
  sourceMap: LazyPromise<RawSourceMap>;
  sourceMapEachMappingByLine: LazyPromise<Array<Array<MappingItem>>>;
}

export interface Data {
  name: string;
  artifactType: string;
  metadata: Metadata;
  identity: Array<string>;

  writeToDisk?: Promise<void>;
  cached?: string;
  cachedAst?: YAMLNode;
  cachedObject?: any;
  accessed?: boolean;
}

export class DataHandle {
  /**
   * @param autoUnload If the data unhandle should automatically unload files after they are not used for a while.
   */
  constructor(public readonly key: string, private item: Data, private autoUnload = true) {
    // start the clock once this has been created.
    // this ensures that the data cache will be flushed if not
    // used in a reasonable amount of time
    this.onTimer();
  }

  public async serialize() {
    this.item.name;
    return JSON.stringify({
      key: this.description,
      artifactType: this.item.artifactType,
      identity: this.item.identity,
      name: this.item.name,
      content: await this.ReadData(true),
    });
  }

  private onTimer() {
    this.checkIfNeedToUnload().catch((e) => {
      // eslint-disable-next-line no-console
      console.error("Error while verifing DataHandle cache status", e);
    });
  }

  private async checkIfNeedToUnload() {
    if (!this.autoUnload) {
      return;
    }

    await Delay(3000);
    if (this.item.accessed) {
      // it's been cached. start the timer!
      this.onTimer();
      // clear the accessed flag before we go.
      this.item.accessed = false;
      return;
    }
    // wasn't actually used since the delay. let's dump it.
    // console.log(`flushing ${this.item.name}`);
    // wait to make sure it's finished writing to disk tho'
    // await this.item.writingToDisk;
    if (!this.item.writeToDisk) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      this.item.writeToDisk = fs.writeFile(this.item.name, this.item.cached!);
    }
    // clear the caches.
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

        // start the timer again.
        this.onTimer();
      }
    }

    return this.item.cached;
  }

  public async readObjectFast<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;

    return this.item.cachedObject || (this.item.cachedObject = parseYaml(await this.readData()));
  }

  public async readObject<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;

    // return the cached object, or get it, then return it.
    return this.item.cachedObject || (this.item.cachedObject = ParseNode<T>(await this.readYamlAst()));
  }

  public async readYamlAst(): Promise<YAMLNode> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;
    // return the cachedAst or get it, then return it.
    return this.item.cachedAst || (this.item.cachedAst = parseAst(await this.readData()));
  }

  public get metadata(): Metadata {
    return this.item.metadata;
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
    const metadata = this.metadata;
    const sameLineResults = ((await metadata.sourceMapEachMappingByLine)[position.line] || []).filter(
      (mapping) => mapping.generatedColumn <= position.column,
    );
    const maxColumn = sameLineResults.reduce((c, m) => Math.max(c, m.generatedColumn), 0);
    const columnDelta = position.column - maxColumn;
    return sameLineResults
      .filter((m) => m.generatedColumn === maxColumn)
      .map((m) => {
        return {
          column: m.originalColumn + columnDelta,
          line: m.originalLine,
          name: m.name,
          source: m.source,
        };
      });
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
