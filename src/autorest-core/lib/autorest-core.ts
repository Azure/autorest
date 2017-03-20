import { IEnumerable, From } from './ref/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./events"
import { IFileSystem } from "./file-system"
import { Configuration } from "./configuration"
import { DocumentType } from "./document-type"

export interface Message {
  Text: string;
}

export class AutoRest extends EventEmitter {
  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open. 
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(configuration: Configuration) {
    super();

  }

  /**
   * Using the fileSystem associated with this instance, this will look at the root level for *.md files 
   * and find the configuration file.
   * 
   * The "configuration file" must have the string `\n>see https://aka.ms/autorest` in the file somewhere. 
   * 
   * If there are multiple configuration files, the file with the shortest filename wins. (aka, foo.md wins over foo.bak.md )
   */
  public get HasConfiguration(): boolean {

    return false;
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

  /**
   * Event: Signals when a debug message is sent from AutoRest
   */
  @EventEmitter.Event public Debug: IEvent<AutoRest, Message>;

  @EventEmitter.Event public Success: IEvent<AutoRest, Message>;



}
