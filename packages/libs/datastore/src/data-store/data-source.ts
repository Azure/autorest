import { DataHandle } from "./data-handle";
import { PipeState } from "./misc";

export abstract class DataSource {
  public pipeState: PipeState;
  public abstract enum(): Promise<Array<string>>;
  public abstract read(uri: string): Promise<DataHandle | null>;

  constructor() {
    this.pipeState = {};
  }

  get skip(): boolean {
    return !!this.pipeState.skipping;
  }
  get cachable(): boolean {
    return !this.pipeState.excludeFromCache;
  }
  set cachable(value: boolean) {
    this.pipeState.excludeFromCache = !value;
  }

  public async readStrict(uri: string): Promise<DataHandle> {
    const result = await this.Read(uri);
    if (result === null) {
      throw new Error(`Could not read '${uri}'.`);
    }
    return result;
  }

  /**
   * @deprecated use @see readStrict
   */
  public async ReadStrict(uri: string): Promise<DataHandle> {
    return this.readStrict(uri);
  }

  /**
   *
   * @deprecated use @see enum() instead
   */
  public async Enum(): Promise<Array<string>> {
    return this.enum();
  }

  /**
   *
   * @deprecated use @see read() instead
   */
  public async Read(key: string): Promise<DataHandle | null> {
    return this.read(key);
  }
}
