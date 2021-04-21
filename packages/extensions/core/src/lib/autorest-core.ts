/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AutorestContextLoader, AutorestContext, MessageEmitter, AutorestLoggingSession } from "./context";
import { EventEmitter, IEvent } from "./events";
import { Exception } from "@autorest/common";
import { IFileSystem, RealFileSystem } from "@azure-tools/datastore";
import { runPipeline } from "./pipeline/pipeline";
export { AutorestContext } from "./context";
import { isConfigurationDocument } from "@autorest/configuration";
import { homedir } from "os";
import { Artifact } from "./artifact";
import { DocumentType } from "./document-type";
import { Channel, Message } from "./message";
import { StatsCollector } from "./stats";

function IsIterable(target: any) {
  return !!target && typeof target !== "string" && typeof target[Symbol.iterator] === "function";
}

function Push<T>(destination: Array<T>, source: any) {
  if (source) {
    if (IsIterable(source)) {
      destination.push(...source);
    } else {
      destination.push(source);
    }
  }
}

/**
 * An instance of the AutoRest generator.
 *
 * Note: to create an instance of autore
 */
export class AutoRest extends EventEmitter {
  /**
   * Event: Signals when a Process() finishes.
   */
  @EventEmitter.Event public Finished!: IEvent<AutoRest, boolean | Error>;
  /**
   * Event: Signals when a File is generated
   */
  @EventEmitter.Event public GeneratedFile!: IEvent<AutoRest, Artifact>;
  /**
   * Event: Signals when a Folder is supposed to be cleared
   */
  @EventEmitter.Event public ClearFolder!: IEvent<AutoRest, string>;
  /**
   * Event: Signals when a message is generated
   */
  @EventEmitter.Event public Message!: IEvent<AutoRest, Message>;

  private _configurations = new Array<any>();
  private _view: AutorestContext | undefined;
  public get view(): Promise<AutorestContext> {
    return this._view ? Promise.resolve(this._view) : this.RegenerateView(true);
  }

  /**
   * @internal
   * @param fileSystem The implementation of the filesystem to load and save files from the host application.
   * @param configFileOrFolderUri The URI of the configuration file or folder containing the configuration file. Is null if no configuration file should be looked for.
   */
  public constructor(private fileSystem: IFileSystem = new RealFileSystem(), public configFileOrFolderUri?: string) {
    super();
    // ensure the environment variable for the home folder is set.
    process.env["autorest.home"] = process.env["AUTOREST_HOME"] || process.env["autorest.home"] || homedir();
  }

  public async RegenerateView(includeDefault = false): Promise<AutorestContext> {
    this.Invalidate();
    const messageEmitter = new MessageEmitter();

    // subscribe to the events for the current configuration view
    messageEmitter.GeneratedFile.Subscribe((cfg, file) => this.GeneratedFile.Dispatch(file));
    messageEmitter.ClearFolder.Subscribe((cfg, folder) => this.ClearFolder.Dispatch(folder));
    messageEmitter.Message.Subscribe((cfg, message) => this.Message.Dispatch(message));

    const stats = new StatsCollector();
    return (this._view = await new AutorestContextLoader(this.fileSystem, stats, this.configFileOrFolderUri).createView(
      messageEmitter,
      includeDefault,
      ...this._configurations,
    ));
  }

  public Invalidate() {
    if (this._view) {
      this._view.messageEmitter.removeAllListeners();
      this._view = undefined;
    }
  }

  public AddConfiguration(configuration: any): void {
    Push(this._configurations, configuration);
    this.Invalidate();
  }

  public async ResetConfiguration(): Promise<void> {
    // clear the configuratiion array.
    this._configurations.length = 0;
    this.Invalidate();
  }

  /**
   * Called to start processing of the files.
   */
  public Process(): { finish: Promise<boolean | Error>; cancel(): void } {
    let earlyCancel = false;
    let cancel: () => void = () => (earlyCancel = true);
    const processInternal = async () => {
      let view: AutorestContext = <any>null;
      try {
        // grab the current configuration view.
        view = await this.view;

        // you can't use this again!
        this._view = undefined;

        // expose cancellation token
        cancel = () => {
          if (view) {
            view.CancellationTokenSource.cancel();
            view.messageEmitter.removeAllListeners();
          }
        };
        if (view.config.inputFileUris.length === 0) {
          if (view.GetEntry("allow-no-input")) {
            this.Finished.Dispatch(true);
            return true;
          } else {
            // if this is using perform-load we don't need to require files.
            // if it's using batch, we might not have files in the main body
            if (view.config.raw["perform-load"] !== false) {
              return new Exception("No input files provided.\n\nUse --help to get help information.");
            }
          }
        }

        if (earlyCancel) {
          this.Finished.Dispatch(false);
          return false;
        }

        await Promise.race([
          runPipeline(view, this.fileSystem),
          new Promise((_, rej) => view.CancellationToken.onCancellationRequested(() => rej("Cancellation requested."))),
        ]);

        // Wait for all logs to have been sent before shutting down.
        await AutorestLoggingSession.waitForMessages();

        // finished -- return status (if cancelled, returns false.)
        this.Finished.Dispatch(!view.CancellationTokenSource.token.isCancellationRequested);

        view.messageEmitter.removeAllListeners();
        return true;
      } catch (e) {
        const message = view?.config.debug
          ? {
              Channel: Channel.Debug,
              Text: `Process() cancelled due to exception : ${e.message ? e.message : e} / ${e.stack ? e.stack : ""}`,
            }
          : {
              Channel: Channel.Debug,
              Text: "Process() cancelled due to failure ",
            };
        if (e instanceof Exception) {
          // idea: don't throw exceptions, just visibly log them and return false
          message.Channel = Channel.Fatal;
          // eslint-disable-next-line no-ex-assign
          e = false;
        }
        this.Message.Dispatch(message);
        // Wait for all logs to have been sent before shutting down.
        await AutorestLoggingSession.waitForMessages();
        this.Finished.Dispatch(e);
        if (view) {
          view.messageEmitter.removeAllListeners();
        }
        return e;
      }
    };
    return {
      cancel: cancel,
      finish: processInternal(),
    };
  }
}

/**
 * Processes a document (yaml, markdown or JSON) and returns the document as a JSON-encoded document text
 * @param content - the document content
 *
 * @returns the content as a JSON string (not a JSON DOM)
 */
export async function LiterateToJson(content: string): Promise<string> {
  try {
    const autorest = new AutoRest({
      list: () => Promise.resolve([]),
      read: (f: string) => Promise.resolve(f == "none:///empty-file.md" ? content || "# empty file" : "# empty file"),
      EnumerateFileUris: () => Promise.resolve([]),
      ReadFile: (f: string) =>
        Promise.resolve(f == "none:///empty-file.md" ? content || "# empty file" : "# empty file"),
    });
    let result = "";
    autorest.AddConfiguration({ "input-file": "none:///empty-file.md", "output-artifact": ["swagger-document"] });
    autorest.GeneratedFile.Subscribe((source, artifact) => {
      result = artifact.content;
    });
    // run autorest and wait.

    await (await autorest.Process()).finish;
    return result;
  } catch (x) {
    return "";
  }
}

/** Determines the document type based on the content of the document
 *
 * @returns Promise<DocumentType> one of:
 *  -  DocumentType.LiterateConfiguration - contains the magic string '\n> see https://aka.ms/autorest'
 *  -  DocumentType.OpenAPI2 - $.swagger === "2.0"
 *  -  DocumentType.OpenAPI3 - $.openapi === "3.0.0"
 *  -  DocumentType.Unknown - content does not match a known document type
 *
 * @see {@link DocumentType}
 */
export async function IdentifyDocument(content: string): Promise<DocumentType> {
  if (content) {
    // check for configuration
    if (await isConfigurationDocument(content)) {
      return DocumentType.LiterateConfiguration;
    }

    // check for openapi document
    let doc: any;
    try {
      // quick check to see if it's json already
      doc = JSON.parse(content);
    } catch (e) {
      try {
        // maybe it's yaml or literate openapip
        doc = JSON.parse(await LiterateToJson(content));
      } catch (e) {
        // nope
      }
    }
    if (doc) {
      return doc.swagger && doc.swagger === "2.0"
        ? DocumentType.OpenAPI2
        : doc.openapi && doc.openapi === "3.0.0"
        ? DocumentType.OpenAPI3
        : DocumentType.Unknown;
    }
  }
  return DocumentType.Unknown;
}

/**
 *  Given a document's content, does this represent a openapi document of some sort?
 *
 * @param content - the document content to evaluate
 */
export async function IsOpenApiDocument(content: string): Promise<boolean> {
  switch (await IdentifyDocument(content)) {
    case DocumentType.OpenAPI2:
    case DocumentType.OpenAPI3:
      return true;
  }
  return false;
}

/**
 * Shuts down any active autorest extension processes.
 */
export async function Shutdown() {
  await AutorestContextLoader.shutdown();
}

/**
 * Checks if the file extension is a known file extension for a literate configuration document.
 * @param extension the extension to check (no leading dot)
 */
export async function IsConfigurationExtension(extension: string): Promise<boolean> {
  switch (extension) {
    case "markdown":
    case "md":
      return true;
    default:
      return false;
  }
}

/**
 * Checks if the file extension is a known file extension for a OpenAPI document (yaml/json/literate markdown).
 * @param extension the extension to check (no leading dot)
 */
export async function IsOpenApiExtension(extension: string): Promise<boolean> {
  switch (extension) {
    case "yaml":
    case "yml":
    case "markdown":
    case "md":
    case "json":
      return true;
    default:
      return false;
  }
}
