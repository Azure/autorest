import { Artifact } from "../artifact";
import { EventEmitter, IEvent } from "../events";
import { CancellationToken, CancellationTokenSource } from "vscode-jsonrpc";
import { DataStore } from "@azure-tools/datastore";

export class MessageEmitter extends EventEmitter {
  /**
   * Event: Signals when a File is generated
   */
  @EventEmitter.Event public GeneratedFile!: IEvent<MessageEmitter, Artifact>;
  /**
   * Event: Signals when a Folder is supposed to be cleared
   */
  @EventEmitter.Event public ClearFolder!: IEvent<MessageEmitter, string>;
  private cancellationTokenSource = new CancellationTokenSource();

  constructor() {
    super();
    this.DataStore = new DataStore();
  }
  /* @internal */ public DataStore: DataStore;
  /* @internal */ public get messageEmitter() {
    return this;
  }
  /* @internal */ public get CancellationTokenSource(): CancellationTokenSource {
    return this.cancellationTokenSource;
  }
  /* @internal */ public get CancellationToken(): CancellationToken {
    return this.cancellationTokenSource.token;
  }
}
