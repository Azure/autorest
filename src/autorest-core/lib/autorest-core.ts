import { Stringify } from './ref/yaml';
import { RunPipeline } from './pipeline/pipeline';
import { SmartPosition, Position } from './ref/source-map';
import { DataStore, Metadata } from './data-store/data-store';
import { IEnumerable, From } from './ref/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./events";
import { IFileSystem } from "./file-system";
import { Configuration, ConfigurationView, MessageEmitter } from './configuration';
import { DocumentType } from "./document-type";
export { ConfigurationView } from './configuration';
import { Message, Channel } from './message';
import * as Constants from './constants';
import { Artifact } from './artifact';
import { Exception, OperationCanceledException } from './exception';

export class AutoRest extends EventEmitter {
  private _configurations = new Array<any>();
  private _view: ConfigurationView | undefined;
  public get view(): Promise<ConfigurationView> {
    return (async () => {
      if (!this._view) {
        const messageEmitter = new MessageEmitter();

        // subscribe to the events for the current configuration view
        messageEmitter.GeneratedFile.Subscribe((cfg, file) => this.GeneratedFile.Dispatch(file));
        messageEmitter.Message.Subscribe((cfg, message) => this.Message.Dispatch(message));

        this._view = await new Configuration(this.fileSystem, this.configFileUri).CreateView(messageEmitter, ...this._configurations);
      }
      return this._view;
    })();
  }
  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open.
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(private fileSystem?: IFileSystem, public configFileUri?: string) {
    super();
    // this.Fatal.Subscribe((_, m) => console.error(m.Text));
  }


  /**
   *  Given a file's content, does this represent a swagger file of some sort?
   *
   * @param content - the file content to evaluate
   */
  public static async IsSwaggerFile(content: string): Promise<boolean> {
    // this checks to see if the document is a swagger document 
    try {
      // quick check to see if it's json already
      let doc = JSON.parse(content);
      return (doc && doc.swagger && doc.swagger === "2.0")
    } catch (e) {
      try {
        // maybe it's yaml or literate swagger
        let doc = JSON.parse(await AutoRest.LiterateToJson(content));
        return (doc && doc.swagger && doc.swagger === "2.0")
      } catch (e) {
        // nope
      }
    }

    return false;
  }

  public static async LiterateToJson(content: string): Promise<string> {
    let autorest = new AutoRest({
      EnumerateFileUris: async function* (folderUri: string): AsyncIterable<string> { },
      ReadFile: async (f: string): Promise<string> => f == "mem:///foo.md" ? content : ""
    });
    let result = "";
    autorest.AddConfiguration({ "input-file": "mem:///foo.md", "output-artifact": ["swagger-document"] });
    autorest.GeneratedFile.Subscribe((source, artifact) => {
      result = artifact.content;
    });
    // run autorest and wait.
    try {
      await (await autorest.Process()).finish;
      return result;
    } catch (x) {
    }
    return "";
  }

  public static async IsConfigurationFile(content: string): Promise<boolean> {
    // this checks to see if the document is an autorest markdown configuration file
    return content.indexOf(Constants.MagicString) > -1;
  }

  public static IsConfigurationExtension(extension: string): boolean {
    switch (extension) {
      case "markdown":
      case "md":
        return true;
    }
    return false;
  }

  public static IsSwaggerExtension(extension: string): boolean {
    switch (extension) {
      case "yaml":
      case "yml":
      case "markdown":
      case "md":
      case "json":
        return true;
    }
    return false;
  }

  public static async DetectConfigurationFile(fileSystem: IFileSystem, documentPath?: string): Promise<string | null> {
    return Configuration.DetectConfigurationFile(fileSystem, (documentPath || null));
  }

  public Invalidate() {
    if (this._view) {
      this._view.messageEmitter.removeAllListeners();
      this._view = undefined;
    }
  }

  public AddConfiguration(configuratuion: any): void {
    this._configurations.push(configuratuion);
    this.Invalidate();
  }

  public async ResetConfiguration(): Promise<void> {
    // clear the configuratiion array.
    this._configurations.length = 0;
    this.Invalidate();
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
  public Process(): { finish: Promise<boolean | Error>, cancel: () => void } {
    let earlyCancel = false;
    let cancel: () => void = () => earlyCancel = true;
    const processInternal = async () => {
      let view: ConfigurationView = <ConfigurationView><any>null;
      try {
        // grab the current configuration view.
        view = await this.view;

        // you can't use this again!
        this._view = undefined;

        // expose cancallation token
        cancel = () => {
          if (view) {
            view.CancellationTokenSource.cancel();
            view.messageEmitter.removeAllListeners();
          }
        }

        if (earlyCancel) {
          this.Finished.Dispatch(false);
          return false;
        }

        // TODO: implement RunPipeline here. (i.e.: actually BUILD a pipeline instead of using the hard coded one...)
        this.Message.Dispatch({ Channel: Channel.Debug, Text: `Starting Process() Run Pipeline.` });

        const result = await Promise.race([
          RunPipeline(view, <IFileSystem>this.fileSystem),
          new Promise((_, rej) => view.CancellationToken.onCancellationRequested(() => rej("Cancellation requested.")))]);

        // finished -- return status (if cancelled, returns false.)
        this.Finished.Dispatch(!view.CancellationTokenSource.token.isCancellationRequested);

        view.messageEmitter.removeAllListeners();
        return true;
      }
      catch (e) {
        if (e instanceof Error) {
          /* if (!(e instanceof OperationCanceledException)) {
            console.error(e.message);
          } */

          this.Message.Dispatch({ Channel: Channel.Debug, Text: `Process() Cancelled due to exception : ${e.message}` });
          this.Finished.Dispatch(e);

          if (view) {
            view.messageEmitter.removeAllListeners();
          }
          return e;
        }

        // console.error(e);
        this.Finished.Dispatch(false);
        if (view) {
          view.messageEmitter.removeAllListeners();
        }
        return false;
      }
    };
    return {
      cancel: () => cancel(),
      finish: processInternal()
    }
  }

  /**
   * Event: Signals when a Process() finishes.
   */
  @EventEmitter.Event public Finished: IEvent<AutoRest, boolean | Error>;

  /**
  * Event: Signals when a File is generated 
  */
  @EventEmitter.Event public GeneratedFile: IEvent<AutoRest, Artifact>;
  /**
   * Event: Signals when a message is generated
   */
  @EventEmitter.Event public Message: IEvent<AutoRest, Message>;
}
