import { SmartPosition, Position } from './ref/source-map';
import { DataStore, Metadata } from './data-store/data-store';
import { IEnumerable, From } from './ref/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./events";
import { IFileSystem } from "./file-system";
import { Configuration } from "./configuration";
import { DocumentType } from "./document-type";

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

  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open.
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(private configuration: Configuration) {
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

  /**
   * This should be called to notify AutoRest that a file has changed.
   *
   * @param path the path of the files that has changed
   */
  public FileChanged(path: string) {

  }

  /**
   * Called to start processing of the files.
   */
  public Start(): void {

  }

  /**
   * Called to stop the processing.
   */
  public Stop(): void {

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
