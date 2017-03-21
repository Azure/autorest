import { SmartPosition, Position } from './ref/source-map';
import { DataStore, Metadata } from './data-store/data-store';
import { IEnumerable, From } from './ref/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./events";
import { IFileSystem } from "./file-system";
import { Configuration, ConfigurationView, FileSystemConfiguration } from './configuration';
import { DocumentType } from "./document-type";
export { ConfigurationView } from './configuration';

export type Channel = {
  readonly Information: "information",
  readonly Warning: "warning",
  readonly Error: "error",
  readonly Debug: "debug",
  readonly Verbose: "verbose",
  readonly Fatal: "fatal",
};

export const Channel: Channel = {
  Information: "information",
  Warning: "warning",
  Error: "error",
  Debug: "debug",
  Verbose: "verbose",
  Fatal: "fatal",
}

export interface SourceLocation {
  Id: string;
  Position: SmartPosition;
}

export interface Range {
  document: string;
  start: Position;
  end: Position;
}

export interface Message {
  Channel: Channel;
  Key: AsyncIterable<string>;
  Details: any;
  Text: string;
  Source: Array<SourceLocation>;
  Range: AsyncIterable<Range>;
  Plugin: string;
};

export class AutoRest extends EventEmitter {
  private _configurations = new Array<any>();
  private _view: ConfigurationView | undefined;
  public get view(): Promise<ConfigurationView> {
    return new Promise<ConfigurationView>(async (r, j) => {
      if (!this._view) {
        this._view = await new FileSystemConfiguration(this.fileSystem).CreateView(...this._configurations)
      }
      r(this._view);
    })
  }
  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open.
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(private fileSystem: IFileSystem) {
    super();
  }

  /**
   *  Given a file's content, does this represent a swagger file of some sort?
   *
   * @param content - the file content to evaluate
   */
  public static async IsSwaggerFile(documentType: DocumentType, content: string): Promise<boolean> {

    return true;
  }

  private invalidate() {
    this._view = undefined;
  }

  /**
   * This should be called to notify AutoRest that a file has changed.
   *
   * @param path the path of the files that has changed
   */
  public FileChanged(path: string) {
    this.invalidate();
  }

  public async AddConfiguration(configuratuion: any): Promise<void> {
    this._configurations.push(configuratuion);
    this.invalidate();
  }

  public async ResetConfiguration(): Promise<void> {
    // clear the configuratiion array.
    this._configurations.length = 0;
    this.invalidate();
  }

  public get HasConfiguration(): Promise<boolean> {
    return new Promise(async (r, f) => {
      (await this.view);
      r(false);
    });
  }

  /**
   * Called to start processing of the files.
   */
  public Start(): void {
    try {
      // implement RunPipeline here.

      // finished cleanly
      this.Finished.Dispatch(true);
    }
    catch (e) {
      // finished not cleanly
      this.Finished.Dispatch(false);
    }
    finally {
      this.invalidate();
    }
  }

  /**
   * Called to stop the processing.
   */
  public Stop(): void {
    // or better excuse to cancel.
  }


  @EventEmitter.Event public Finished: IEvent<AutoRest, boolean>;

  @EventEmitter.Event public Information: IEvent<AutoRest, Message>;
  @EventEmitter.Event public Warning: IEvent<AutoRest, Message>;
  @EventEmitter.Event public Error: IEvent<AutoRest, Message>;
  /**
   * Event: Signals when a debug message is sent from AutoRest
   */
  @EventEmitter.Event public Debug: IEvent<AutoRest, Message>;
  @EventEmitter.Event public Verbose: IEvent<AutoRest, Message>;
  @EventEmitter.Event public Fatal: IEvent<AutoRest, Message>;


}
