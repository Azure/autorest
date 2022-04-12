import { DataHandle } from "./data-handle";
import { DataSource } from "./data-source";
import { PipeState } from "./misc";

export class QuickDataSource extends DataSource {
  public constructor(private handles: Array<DataHandle>, pipeState?: PipeState) {
    super();
    this.pipeState = pipeState || {};
  }

  public async enum(): Promise<Array<string>> {
    return this.pipeState.skipping ? new Array<string>() : this.handles.map((x) => x.key);
  }

  public async read(key: string): Promise<DataHandle | null> {
    if (this.pipeState.skipping) {
      return null;
    }
    const data = this.handles.filter((x) => x.key === key)[0];
    return data || null;
  }
}
