import { Stringify } from './ref/yaml';
import { RunPipeline } from './pipeline/pipeline';
import { SmartPosition, Position } from './ref/source-map';
import { DataStore, Metadata } from './data-store/data-store';
import { IEnumerable, From } from './ref/linq';
import { IEvent, EventDispatcher, EventEmitter } from "./events";
import { IFileSystem } from "./file-system";
import { Configuration, ConfigurationView } from './configuration';
import { DocumentType } from "./document-type";
export { ConfigurationView } from './configuration';
import { Message } from './message';
import * as Constants from './constants';
import { Artifact } from './artifact';

export class AutoRest extends EventEmitter {
  private _configurations = new Array<any>();
  private _view: ConfigurationView | undefined;
  public get view(): Promise<ConfigurationView> {
    return new Promise<ConfigurationView>(async (r, j) => {
      if (!this._view) {
        this._view = await new Configuration(this.fileSystem, this.configFileUri).CreateView(...this._configurations);

        // subscribe to the events for the current configuration view
        this._view.GeneratedFile.Subscribe((cfg, file) => this.GeneratedFile.Dispatch(file));
        this._view.Debug.Subscribe((cfg, message) => this.Debug.Dispatch(message));
        this._view.Verbose.Subscribe((cfg, message) => this.Verbose.Dispatch(message));
        this._view.Fatal.Subscribe((cfg, message) => this.Fatal.Dispatch(message));
        this._view.Information.Subscribe((cfg, message) => this.Information.Dispatch(message));
        this._view.Error.Subscribe((cfg, message) => this.Error.Dispatch(message));
        this._view.Warning.Subscribe((cfg, message) => this.Warning.Dispatch(message));
      }
      r(this._view);
    });
  }
  /**
   * 
   * @param rootUri The rootUri of the workspace. Is null if no workspace is open.
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   */
  public constructor(private fileSystem?: IFileSystem, private configFileUri?: string) {
    super();
  }

  /**
   *  Given a file's content, does this represent a swagger file of some sort?
   *
   * @param content - the file content to evaluate
   */
  public async IsSwaggerFile(documentType: DocumentType, content: string): Promise<boolean> {
    // this checks to see if the document is a 
    return true;
  }

  public async IsConfigurationFile(content: string): Promise<boolean> {
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
    this._view = undefined;
  }

  public async AddConfiguration(configuratuion: any): Promise<void> {
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
  public Process(): { finish: Promise<boolean>, cancel: () => void } {
    let earlyCancel = false;
    let cancel: () => void = () => earlyCancel = true;
    const processInternal = async () => {
      const view = await this.view;

      // expose cancallation token
      cancel = () => view.CancellationTokenSource.cancel();
      if (earlyCancel) {
        this.Finished.Dispatch(false);
        return;
      }

      try {
        // TODO: implement RunPipeline here. (i.e.: actually BUILD a pipeline instead of using the hard coded one...)
        this.Debug.Dispatch({ Text: `Starting Process() Run Pipeline.` })
        await RunPipeline(await this.view);

        // finished cleanly
        this.Finished.Dispatch(true);
        return true;
      }
      catch (e) {
        console.error(e);
        // finished not cleanly
        this.Debug.Dispatch({ Text: `Process() Cancelled due to exception : ${e}` })
        this.Finished.Dispatch(false);
        return false;
      }
      finally {
        this.Invalidate();
      }
    };
    return {
      cancel: () => cancel(),
      finish: processInternal()
    }
  }

  @EventEmitter.Event public Finished: IEvent<AutoRest, boolean>;

  @EventEmitter.Event public GeneratedFile: IEvent<AutoRest, Artifact>;

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
