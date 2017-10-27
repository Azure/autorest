// ---------------------------------------------------------------------------------------------
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License. See License.txt in the project root for license information.
// ---------------------------------------------------------------------------------------------

import { FileUriToPath } from '../lib/ref/uri';
import { Diagnostic } from 'vscode-languageserver';
import { readFile } from '@microsoft.azure/async-io';

import { EventEmitter, IEvent } from "@microsoft.azure/eventing";
import * as crypto from 'crypto'

const md5 = (content: string) => content ? crypto.createHash('md5').update(content).digest("hex") : null;

export class TrackedFile extends EventEmitter {
  private _content: string | null;
  private _checksum: string | null;
  public IsActive: boolean = false;
  private diagnostics = new Map<string, Diagnostic>();
  private queuedToSend: NodeJS.Timer | null = null;

  @EventEmitter.Event public Changed: IEvent<TrackedFile, boolean>;
  @EventEmitter.Event public DiagnosticsToSend: IEvent<TrackedFile, Map<string, Diagnostic>>;

  /**
   * Resets the list of diagnostics, so that the next time they are sent back to the client, it's a fresh start.
   */
  public ClearDiagnostics() {
    this.diagnostics.clear();
  }

  /**
   * Adds to the collection of vscode Diagnostic messages that will be sent back to the client.
   * Adding a Diagnostic message will queue up the server to send the list to the client.
   * @param diagnostic the Diagnostic message to add to the collection.
   */
  public PushDiagnostic(diagnostic: Diagnostic) {
    let hash = md5(JSON.stringify(diagnostic)) || ""
    if (!this.diagnostics.has(hash)) {
      this.diagnostics.set(hash, diagnostic);
    }
    this.FlushDiagnostics();
  }

  /**
   * Sends the collection of Diagnostic messages back to the client.
   * The current implementation queues up the call to wait for at least 25msec between sending to the client.
   * 
   * @param force - forces the service to send the messages immediately.
   */
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

  /** Gets the content of a file, reading from disk if necessary. */
  private async getContent(): Promise<string | null> {
    if (this._content) {
      return this._content;
    }

    try {
      // acquire the content and set the checksum.
      this.SetContent(await readFile(FileUriToPath(this.fullPath)));
    } catch (exception) {
      // failed! well, set the content to null. it'll try again later. 
      this.SetContent(null);
    }
    return this._content;
  }

  /** 
   * Public accessor for content. 
   */
  public get content(): Promise<string | null> {
    return this.getContent();
  };

  /**
   * Sets the content (and hash) of the in-memory representation of the file
   * @param text the new content.
   */
  public SetContent(text: string | null) {
    const ck = md5(text || "");
    if (ck == this._checksum) {
      // no change!
      return;
    }
    this._content = text;
    this._checksum = ck;
    this.Changed.Dispatch(text == null);
  };

  public get checksum(): Promise<string> {
    return (async () => this._checksum ? this._checksum : (this._checksum = <string>md5((await this.content) || "")))();
  }

  constructor(public readonly fullPath: string) {
    super();
  }
}
