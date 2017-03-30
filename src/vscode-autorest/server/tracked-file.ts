import { ResolveUri, CreateFileUri, NormalizeUri, FileUriToPath } from '../lib/ref/uri';
import { IConnection, Diagnostic, DiagnosticSeverity } from 'vscode-languageserver';
import { EventEmitter, IEvent, IFileSystem, AutoRest } from "autorest";
import * as crypto from 'crypto'
import * as a from '../lib/ref/async'

// Create a connection for the server. The connection uses Node's IPC as a transport
export const connection: IConnection = (<any>global).connection
const md5 = (content: string) => content ? crypto.createHash('md5').update(content).digest("hex") : null;

export class File extends EventEmitter {
  private _content: string | null;
  private _checksum: string | null;
  public IsActive: boolean = false;
  private diagnostics = new Map<string, Diagnostic>();
  private queuedToSend: NodeJS.Timer | null = null;

  @EventEmitter.Event public Changed: IEvent<File, boolean>;
  @EventEmitter.Event public DiagnosticsToSend: IEvent<File, Map<string, Diagnostic>>;

  public ClearDiagnostics() {
    this.diagnostics.clear();
  }

  public PushDiagnostic(diagnostic: Diagnostic) {
    let hash = md5(JSON.stringify(diagnostic))
    if (!this.diagnostics.has(hash)) {
      this.diagnostics.set(hash, diagnostic);
    }
    this.FlushDiagnostics();
  }

  public FlushDiagnostics(force?: boolean) {
    if (force) {
      if (this.queuedToSend) {
        clearTimeout(this.queuedToSend);
      }
      this.queuedToSend = null;
      this.DiagnosticsToSend.Dispatch(this.diagnostics);
      return;
    }

    /*
    // Strategy #1 - queue up, but wait no longer than 15 milliseconds before sending it out.
    if (!this.queuedToSend) {
      this.queuedToSend = setTimeout(() => {
        this.queuedToSend = null;
        this.DiagnosticsToSend.Dispatch(this.diagnostics);
      }, 15);
    }
  */

    // Strategy #2 - queue up, but reset the timeout to wait until at least 25 milliseconds has passed 
    if (this.queuedToSend) {
      clearTimeout(this.queuedToSend);
      this.queuedToSend = setTimeout(() => {
        this.queuedToSend = null;
        this.DiagnosticsToSend.Dispatch(this.diagnostics);
      }, 25)
    }

  }

  private async getContent(): Promise<string | null> {
    if (this._content) {
      return this._content;
    }

    try {
      // connection.console.log(`Reading content for ${this.fullPath} `)
      // acquire the content and set the checksum.
      this.SetContent(await a.readFile(FileUriToPath(this.fullPath), 'utf8'));
    } catch (exception) {
      connection.console.error(`Exception reading content for ${this.fullPath} `)
      // failed! well, set the content to null. it'll try again later. 
      this.SetContent(null);
    }
    return this._content;
  }
  public get content(): Promise<string | null> {
    return this.getContent();
  };

  public SetContent(text: string | null) {
    const ck = md5(text);
    if (ck == this._checksum) {
      // no change!
      return;
    }
    this._content = text;
    this._checksum = ck;
    this.Changed.Dispatch(text == null);
  };

  public get checksum(): Promise<string> {
    return (async () => this._checksum ? this._checksum : (this._checksum = md5(await this.content)))();
  }

  constructor(public readonly fullPath: string) {
    super();
  }
}
